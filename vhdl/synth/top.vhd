library gaisler;
library grlib;
library ieee;
library techmap;
library unisim;
use gaisler.leon3;
use gaisler.misc;
use grlib.amba;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use techmap.gencomp;
use unisim.vcomponents.all;
use work.pintypes.all;
use work.types.all;

entity Top is
	port(
		OscillatorPin : in std_ulogic;
		OscillatorEnablePin : buffer std_ulogic := '1';

		LogicPowerPin : buffer std_ulogic;
		HVPowerPin : buffer std_ulogic;
		LaserPowerPin : buffer std_ulogic;

		InterlockOverridePin : in std_ulogic;

		ADCCSPin : buffer std_ulogic;
		ADCClockPin : out std_ulogic;
		ADCMOSIPin : buffer std_ulogic;
		ADCMISOPin : in std_ulogic;

		FlashCSPin : buffer std_ulogic;
		FlashClockPin : out std_ulogic;
		FlashMOSIPin : inout std_ulogic;
		FlashMISODebugPin : inout std_ulogic;

		MRFResetPin : buffer std_ulogic;
		MRFWakePin : buffer std_ulogic;
		MRFInterruptPin : in std_ulogic;
		MRFCSPin : buffer std_ulogic;
		MRFClockPin : out std_ulogic;
		MRFMOSIPin : buffer std_ulogic;
		MRFMISOPin : in std_ulogic;

		SDPresentPin : in std_ulogic;
		SDCSPin : buffer std_ulogic;
		SDClockPin : out std_ulogic;
		SDMOSIPin : buffer std_ulogic;
		SDMISOPin : in std_ulogic;

		ChickerPresentPin : in std_ulogic;
		ChickerRelayPin : buffer std_ulogic := '1';
		ChickerChargePin : buffer std_ulogic;
		ChickerKickPin : buffer std_ulogic;
		ChickerChipPin : buffer std_ulogic;

		ChargedLEDPin : buffer std_ulogic;
		RadioLEDPin : buffer std_ulogic;
		TestLEDsPin : buffer std_ulogic_vector(2 downto 0);

		BreakoutPresentPin : in std_ulogic;

		LPSDrivesPin : buffer std_ulogic_vector(3 downto 0) := (others => '0');

		EncodersPin : in encoders_pin_t;

		MotorsPhasesEPin : buffer motors_phases_pin_t;
		MotorsPhasesLPin : buffer motors_phases_pin_t;

		HallsPin : in halls_pin_t);
end entity Top;

architecture Main of Top is
	signal Clock250kHz, Clock1MHz, Clock1MHzI, Clock4MHz, Clock4MHzI, Clock8MHz, Clock8MHzI, Clock48MHz, Clock48MHzI : std_ulogic;
	signal CE1MHz48 : boolean;

	signal AMBAResetRequest : boolean;
	signal AMBAReset : std_ulogic;
	signal CPUDebugOut : gaisler.leon3.l3_debug_out_type;
	signal CPUError : boolean;

	-- AHB masters are:
	-- (0) LEON3
	-- (1) MRF SPI transceiver
	-- (2) SD host controller
	constant AHBMasterCount : natural := 3;

	-- AHB slaves are:
	-- (0) BIOS ROM
	-- (1) Data RAM
	-- (2) SPI memory controller
	-- (3) APB bridge
	constant AHBSlaveCount : natural := 4;

	-- APB slaves are:
	-- (0) SysCtl module
	-- (1) Debug serial port
	-- (2) MRF SPI transceiver
	-- (3) Motor 0
	-- (4) Motor 1
	-- (5) Motor 2
	-- (6) Motor 3
	-- (7) Motor 4
	-- (8) Chicker
	-- (9) SD host controller
	constant APBSlaveCount : natural := 10;

	signal AHBMasterInputs : grlib.amba.ahb_mst_in_type;
	signal AHBMasterOutputs : grlib.amba.ahb_mst_out_vector;
	signal AHBSlaveInputs : grlib.amba.ahb_slv_in_type;
	signal AHBSlaveOutputs : grlib.amba.ahb_slv_out_vector;
	signal APBSlaveInputs : grlib.amba.apb_slv_in_type;
	signal APBSlaveOutputs : grlib.amba.apb_slv_out_vector;

	signal FlashCS : boolean;
	signal FlashClockOE : boolean;
	signal FlashMOSI : std_ulogic;
	signal FlashMOSIOE : boolean;
	signal FlashMISO : std_ulogic;
	signal FlashMISOOE : boolean;
	signal DebugPortEnabled : boolean;
	signal DebugPortOutput : std_ulogic;

	signal Interlock : boolean;

	signal MRFClockOE : boolean;

	signal ADCClockOE : boolean;
	signal ADCLevels : mcp3008s_t;

	type halls_t is array(0 to 4) of hall_t;
	type encoders_t is array(0 to 4) of encoder_t;
	type motors_drive_phases_t is array(0 to 4) of motor_drive_phases_t;
	signal Halls : halls_t;
	signal Encoders : encoders_t;
	signal MotorsDrive : motors_drive_phases_t;

	signal ChickerPresent : boolean;

	signal SDClockOE : boolean;
begin
	-- Generate system clocks.
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator => OscillatorPin,
		Clock250kHz => Clock250kHz,
		Clock1MHz => Clock1MHz,
		Clock1MHzI => Clock1MHzI,
		Clock4MHz => Clock4MHz,
		Clock4MHzI => Clock4MHzI,
		Clock8MHz => Clock8MHz,
		Clock8MHzI => Clock8MHzI,
		Clock48MHz => Clock48MHz,
		Clock48MHzI => Clock48MHzI,
		CE1MHz48 => CE1MHz48);

	-- Assert system reset for 16 cycles of the slowest clock after startup, then release.
	process(Clock250kHz, AMBAResetRequest) is
		variable ResetShifter : std_ulogic_vector(15 downto 0) := X"0000";
	begin
		if rising_edge(Clock250kHz) then
			if AMBAResetRequest then
				ResetShifter := X"0000";
			else
				ResetShifter := '1' & ResetShifter(15 downto 1);
			end if;
		end if;
		if AMBAResetRequest then
			AMBAReset <= '0';
		else
			AMBAReset <= ResetShifter(0);
		end if;
	end process;

	-- Instantiate an AHB arbiter, decoder, and other bus management logic.
	AHBController : grlib.amba.ahbctrl
	generic map(
		defmast => 0, -- Default master index
		split => 0, -- Disable split transactions
		rrobin => 0, -- Use fixed master priorities
		timeout => 0, -- Disable bus timeout detection
		ioaddr => 16#A00#, -- I/O space starts at 0xA0000000
		iomask => 16#F00#, -- Upper 4 bits of ioaddr must match to be in I/O space
		cfgaddr => 16#FF0#, -- Configuration space starts at offset 0xFF000 into AHB I/O space
		cfgmask => 16#F00#, -- Upper 4 bits of cfgaddr must match to be in configuration space
		nahbm => AHBMasterCount,
		nahbs => AHBSlaveCount,
		ioen => 1, -- Enable I/O space
		disirq => 1, -- Disable IRQ routing
		fixbrst => 1, -- Enable fixed-length bursts
		debug => 0, -- Print nothing to console
		fpnpen => 1, -- Fully decode plug-and-play records
		icheck => 0, -- Enable bus index sanity checking in simulation
		devid => 0, -- Device ID to show in configuration area
		enbusmon => 0, -- Disable bus monitor
		assertwarn => 0, -- Disable assertions for warnings
		asserterr => 0, -- Disable assertions for errors
		mprio => 0, -- No special priority configuration for masters
		mcheck => 0, -- Disable overlapping address space checking in simulation
		ccheck => 0, -- Disable configuration space sanity checking in simulation
		acdm => 0, -- Disable AMBA-compliant >32-bit byte lane handling (enable GRLIB optimization)
		ahbtrace => 0, -- Disable AHB tracing in simulation
		hwdebug => 0, -- Disable AHB debug registers in configuration space
		fourgslv => 0) -- Disable single four-gigabyte slave
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		msti => AHBMasterInputs,
		msto => AHBMasterOutputs,
		slvi => AHBSlaveInputs,
		slvo => AHBSlaveOutputs);

	-- Instantiate a LEON3 CPU.
	LEON3 : gaisler.leon3.leon3s
	generic map(
		hindex => 0, -- AHB master index
		fabtech => techmap.gencomp.spartan6, -- Spartan 6 instantiated primitives
		memtech => techmap.gencomp.spartan6, -- Spartan 6 instantiated primitives for RAM
		nwindows => 8, -- 8 register windows
		dsu => 0, -- No debug support unit
		fpu => 0, -- No FPU
		v8 => 1, -- 16x16 multiplier
		cp => 0, -- No coprocessor interface
		mac => 0, -- No multiply/accumulate instructions
		pclow => 2, -- Omit bottom 2 bits of program counter
		notag => 0, -- Enable tagged arithmetic and CASA instructions
		nwp => 0, -- No watchpoints
		icen => 1, -- Enable instruction cache
		irepl => 0, -- LRU instruction cache replacement policy
		isets => 1, -- One way associative instruction cache
		isetsize => 32, -- Each instruction cache set is 32 kilobytes
		isetlock => 0, -- Disable instruction cache line locking
		dcen => 0, -- Disable data cache
		ilram => 0, -- Disable local instruction RAM
		dlram => 0, -- Disable scratchpad data RAM
		mmuen => 0, -- Disable MMU
		lddel => 1, -- One cycle load delay (better performance, lower clock frequency)
		disas => 0, -- Do not disassemble instructions in simulation
		tbuf => 0, -- Disable trace buffer
		pwd => 0, -- Disable power down capability
		svt => 1, -- Enable single vector trapping
		rstaddr => 16#20000#, -- Reset starts running at address 0x20000000
		smp => 0, -- Disable multiprocessor support
		cached => 0, -- No fixed cacheability mask
		scantest => 0, -- Disable scan test support
		bp => 1) -- Enable branch prediction
	port map(
		clk => Clock48MHz,
		rstn => AMBAReset,
		ahbi => AHBMasterInputs,
		ahbo => AHBMasterOutputs(0),
		ahbsi => AHBSlaveInputs,
		ahbso => AHBSlaveOutputs,
		irqi => (irl => (others => '0'), rst => '0', run => '0', rstvec => (others => '0'), iact => '0', index => (others => '0'), hrdrst => '0'),
		dbgi => gaisler.leon3.dbgi_none,
		dbgo => CPUDebugOut);
	CPUError <= not to_boolean(CPUDebugOut.Error);

	-- Instantiate the BIOS ROM.
	CPUROM : entity work.AHBROM(RTL)
	generic map(
		hindex => 0, -- AHB slave index
		haddr => 16#200#, -- ROM starts at 0x20000000
		hmask => 16#F00#) -- Upper 4 bits of haddr must match
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		ahbsi => AHBSlaveInputs,
		ahbso => AHBSlaveOutputs(0));

	-- Instantiate the data RAM.
	CPURAM : gaisler.misc.ahbram
	generic map(
		hindex => 1, -- AHB slave index
		haddr => 16#400#, -- System RAM starts at 0x40000000
		hmask => 16#F00#, -- Upper 4 bits of haddr must match
		tech => techmap.gencomp.spartan6,
		kbytes => 16)
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		ahbsi => AHBSlaveInputs,
		ahbso => AHBSlaveOutputs(1));

	-- Instantiate the SPI memory controller.
	SPIFlash : entity work.SPIFlash(RTL)
	generic map(
		hindex => 2, -- AHB slave index
		hmaddr => 16#600#, -- Flash starts at 0x60000000
		hmmask => 16#F00#, -- Upper 4 bits of hmaddr must match
		hiaddr => 16#000#, -- Control registers start at offset 0x00000 from AHB I/O
		himask => 16#FFF#) -- All 12 bits of hiaddr must match
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		ahbsi => AHBSlaveInputs,
		ahbso => AHBSlaveOutputs(2),
		CS => FlashCS,
		ClockOE => FlashClockOE,
		MOSIIn => FlashMOSIPin,
		MOSIOut => FlashMOSI,
		MOSIOE => FlashMOSIOE,
		MISOIn => FlashMISODebugPin,
		MISOOut => FlashMISO,
		MISOOE => FlashMISOOE);

	-- Instantiate the APB bridge.
	APBBridge : amba.apbctrl
	generic map(
		hindex => 3, -- AHB slave index
		haddr => 16#C00#, -- APB starts at 0xC0000000
		hmask => 16#F00#, -- Upper 4 bits of haddr must match
		nslaves => APBSlaveCount,
		debug => 0, -- Disable debug information in simulation
		icheck => 0, -- Disable bus index sanity checking in simulation
		enbusmon => 0, -- Disable bus monitor
		mcheck => 0, -- Disable overlapping address space checking in simulation
		ccheck => 0) -- Disable configuration space sanity checking in simulation
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		ahbi => AHBSlaveInputs,
		ahbo => AHBSlaveOutputs(3),
		apbi => APBSlaveInputs,
		apbo => APBSlaveOutputs);

	-- Instantiate the system control module.
	SysCtl : entity work.SysCtl(RTL)
	generic map(
		pindex => 0, -- APB slave index
		paddr => 16#000#, -- Control registers start at offset 0x00000 from APB
		pmask => 16#FFF#) -- All 12 bits of paddr must match
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		apbi => APBSlaveInputs,
		apbo => APBSlaveOutputs(0),
		Clock250kHz => Clock250kHz,
		Clock1MHz => Clock1MHz,
		LogicPower => LogicPowerPin,
		HVPower => HVPowerPin,
		HWInterlockOverride => InterlockOverridePin,
		Interlock => Interlock,
		BreakoutPresent => BreakoutPresentPin,
		RadioLED => RadioLEDPin,
		TestLEDs => TestLEDsPin,
		BatteryVoltage => ADCLevels(1),
		ThermistorVoltage => ADCLevels(5),
		to_stdulogic(LaserDrive) => LaserPowerPin,
		LaserReceiverVoltage => ADCLevels(7),
		AMBAResetRequest => AMBAResetRequest,
		CPUError => CPUError);

	-- Instantiate the debug port.
	DebugPort : entity work.AsyncSerialTransmitter(RTL)
	generic map(
		pindex => 1, -- APB slave index
		paddr => 16#001#, -- Control registers start at offset 0x00100 from APB
		pmask => 16#FFF#) -- All 12 bits of paddr must match
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		apbi => APBSlaveInputs,
		apbo => APBSlaveOutputs(1),
		BusClock => Clock250kHz,
		Enabled => DebugPortEnabled,
		Output => DebugPortOutput);

	-- Arbitrate access to the Flash/debug pins.
	FlashCSPin <= '0' when FlashCS else '1';
	FlashClockODDR2 : ODDR2
	generic map(
		DDR_ALIGNMENT => "NONE",
		INIT => '0',
		SRTYPE => "SYNC")
	port map(
		D0 => to_stdulogic(FlashClockOE),
		D1 => '0',
		C0 => Clock48MHz,
		C1 => Clock48MHzI,
		CE => '1',
		R => '0',
		S => '0',
		Q => FlashClockPin);
	FlashMOSIPin <= FlashMOSI when FlashMOSIOE else 'Z';
	FlashMISODebugPin <= DebugPortOutput when DebugPortEnabled else FlashMISO when FlashMISOOE else 'Z';

	-- Instantiate the MRF SPI transceiver
	MRF : entity work.MRF(RTL)
	generic map(
		hindex => 1, -- AHB master index
		pindex => 2, -- APB slave index
		paddr => 16#002#, -- Control registers start at offset 0x00200 from APB
		pmask => 16#FFF#) -- All 12 bits of paddr must match
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		ahbmi => AHBMasterInputs,
		ahbmo => AHBMasterOutputs(1),
		apbi => APBSlaveInputs,
		apbo => APBSlaveOutputs(2),
		BusClock => Clock8MHz,
		CSPin => MRFCSPin,
		ClockOE => MRFClockOE,
		MOSIPin => MRFMOSIPin,
		MISOPin => MRFMISOPin,
		ResetPin => MRFResetPin,
		WakePin => MRFWakePin,
		InterruptPin => MRFInterruptPin);
	MRFClockODDR2 : ODDR2
	generic map(
		DDR_ALIGNMENT => "NONE",
		INIT => '0',
		SRTYPE => "SYNC")
	port map(
		D0 => to_stdulogic(MRFClockOE),
		D1 => '0',
		C0 => Clock8MHz,
		C1 => Clock8MHzI,
		CE => '1',
		R => '0',
		S => '0',
		Q => MRFClockPin);

	-- Instantiate the motors
	Motors : for I in 0 to 4 generate
		Motor : entity work.Motor(RTL)
		generic map(
			pindex => 3 + I, -- APB slave index
			paddr => 16#003# + I, -- Control registers start at offset 0x00{3,4,5,6,7}00 from APB
			pmask => 16#FFF#, -- All 12 bits of paddr must match
			PWMMax => 255,
			PWMPhase => 255 * I / 5,
			EncoderPresent => I /= 4)
		port map(
			rst => AMBAReset,
			clk => Clock48MHz,
			apbi => APBSlaveInputs,
			apbo => APBSlaveOutputs(3 + I),
			PWMClock => Clock8MHz,
			Interlock => Interlock,
			Hall => Halls(I),
			Encoder => Encoders(I),
			Drive => MotorsDrive(I));
	end generate;
	process(Clock48MHz) is
	begin
		if rising_edge(Clock48MHz) then
			for I in 0 to 4 loop
				for J in 0 to 2 loop
					Halls(I)(J) <= to_boolean(HallsPin(I)(J));
				end loop;
			end loop;
			for I in 0 to 3 loop
				for J in 0 to 1 loop
					Encoders(I)(J) <= to_boolean(EncodersPin(I)(J));
				end loop;
			end loop;
			for I in 0 to 4 loop
				for J in 0 to 2 loop
					case MotorsDrive(I)(J) is
						when FLOAT =>
							MotorsPhasesEPin(I)(J) <= '0';
							MotorsPhasesLPin(I)(J) <= '0';
						when LOW =>
							MotorsPhasesEPin(I)(J) <= '1';
							MotorsPhasesLPin(I)(J) <= '0';
						when HIGH =>
							MotorsPhasesEPin(I)(J) <= '1';
							MotorsPhasesLPin(I)(J) <= '1';
					end case;
				end loop;
			end loop;
		end if;
	end process;

	-- Instantiate the ADC
	ADC : entity work.MCP3008(RTL)
	port map(
		rst => AMBAReset,
		BusClock => Clock1MHz,
		CSPin => ADCCSPin,
		ClockOE => ADCClockOE,
		MOSIPin => ADCMOSIPin,
		MISOPin => ADCMISOPin,
		Levels => ADCLevels);
	ADCClockODDR2 : ODDR2
	generic map(
		DDR_ALIGNMENT => "NONE",
		INIT => '0',
		SRTYPE => "SYNC")
	port map(
		D0 => to_stdulogic(ADCClockOE),
		D1 => '0',
		C0 => Clock1MHz,
		C1 => Clock1MHzI,
		CE => '1',
		R => '0',
		S => '0',
		Q => ADCClockPin);

	-- Instantiate the chicker
	Chicker : entity work.Chicker(RTL)
	generic map(
		pindex => 8, -- APB slave index
		paddr => 16#008#, -- Control registers start at offset 0x00800 from APB
		pmask => 16#FFF#) -- All 12 bits of paddr must match
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		apbi => APBSlaveInputs,
		apbo => APBSlaveOutputs(8),
		DischargeCE => CE1MHz48,
		Present => ChickerPresent,
		BatteryVoltage => ADCLevels(1),
		CapacitorVoltage => ADCLevels(0),
		ChargerClock => Clock4MHz,
		Interlock => Interlock,
		to_stdulogic(ChargedLED) => ChargedLEDPin,
		to_stdulogic(ChargePin) => ChickerChargePin,
		to_stdulogic(KickPin) => ChickerKickPin,
		to_stdulogic(ChipPin) => ChickerChipPin);
	ChickerPresent <= not to_boolean(ChickerPresentPin);

	-- Instantiate the SD host controller
	SD : entity work.SD(RTL)
	generic map(
		hindex => 2, -- AHB master index
		pindex => 9, -- APB slave index
		paddr => 16#009#, -- Control registers start at offset 0x00900 from APB
		pmask => 16#FFF#) -- All 12 bits of paddr must match
	port map(
		rst => AMBAReset,
		clk => Clock48MHz,
		ahbmi => AHBMasterInputs,
		ahbmo => AHBMasterOutputs(2),
		apbi => APBSlaveInputs,
		apbo => APBSlaveOutputs(9),
		BusClock => Clock4MHz,
		PresentPin => SDPresentPin,
		CSPin => SDCSPin,
		ClockOE => SDClockOE,
		MOSIPin => SDMOSIPin,
		MISOPin => SDMISOPin);
	SDClockODDR2 : ODDR2
	generic map(
		DDR_ALIGNMENT => "NONE",
		INIT => '0',
		SRTYPE => "SYNC")
	port map(
		D0 => to_stdulogic(SDClockOE),
		D1 => '0',
		C0 => Clock4MHz,
		C1 => Clock4MHzI,
		CE => '1',
		R => '0',
		S => '0',
		Q => SDClockPin);
end architecture Main;
