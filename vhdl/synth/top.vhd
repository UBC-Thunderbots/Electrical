library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.clock.all;
use work.pavr_constants.all;
use work.pintypes.all;
use work.types.all;

entity Top is
	port(
		OscillatorPin : in std_ulogic;
		OscillatorEnablePin : out std_ulogic := '1';

		LogicPowerPin : out std_ulogic := '1';
		HVPowerPin : out std_ulogic := '0';
		LaserPowerPin : out std_ulogic := '0';

		InterlockOverridePin : in std_ulogic;

		ADCCSPin : out std_ulogic := '1';
		ADCClockPin : out std_ulogic := '0';
		ADCMOSIPin : out std_ulogic := '0';
		ADCMISOPin : in std_ulogic;

		FlashCSPin : out std_ulogic := '1';
		FlashClockPin : out std_ulogic := '0';
		FlashMOSIPin : out std_ulogic := '0';
		FlashMISODebugPin : inout std_ulogic;

		MRFResetPin : out std_ulogic := '0';
		MRFWakePin : out std_ulogic := '0';
		MRFInterruptPin : in std_ulogic;
		MRFCSPin : out std_ulogic := '1';
		MRFClockPin : out std_ulogic := '0';
		MRFMOSIPin : out std_ulogic := '0';
		MRFMISOPin : in std_ulogic;

		SDPresentPin : in std_ulogic;
		SDCSPin : out std_ulogic := '1';
		SDClockPin : out std_ulogic := '0';
		SDMOSIPin : out std_ulogic := '0';
		SDMISOPin : in std_ulogic;

		ChickerPresentPin : in std_ulogic;
		ChickerRelayPin : out std_ulogic := '1';
		ChickerChargePin : out std_ulogic := '1';
		ChickerKickPin : out std_ulogic := '1';
		ChickerChipPin : out std_ulogic := '1';

		ChargedLEDPin : out std_ulogic := '0';
		RadioLEDPin : out std_ulogic := '0';
		TestLEDsPin : out std_ulogic_vector(2 downto 0) := (others => '0');

		BreakoutPresentPin : in std_ulogic;

		LPSDrivesPin : out std_ulogic_vector(3 downto 0) := (others => '0');

		EncodersPin : in encoders_pin_t;

		MotorsPhasesEPin : out motors_phases_pin_t := (others => (others => '0'));
		MotorsPhasesLPin : out motors_phases_pin_t := (others => (others => '0'));

		HallsPin : in halls_pin_t);
end entity Top;

architecture Main of Top is
	constant DMA_READ_CHANNEL_SD : natural := 0;
	constant DMA_READ_CHANNEL_MRF : natural := 1;
	constant DMA_WRITE_CHANNEL_MRF : natural := 2;
	constant DMA_WRITE_CHANNEL_3 : natural := 3;

	signal Clocks : clocks_t;

	signal SystemReset : boolean;

	signal CPUInputs : work.types.cpu_inputs_t;
	signal CPUOutputs : work.types.cpu_outputs_t;

	signal DMAReadRequests : dmar_requests_t := (others => (Consumed => false));
	signal DMAReadResponses : dmar_responses_t;
	signal DMAWriteRequests : dmaw_requests_t := (others => (Write => false, Data => X"00"));
	signal DMAWriteResponses : dmaw_responses_t;

	signal DMAWrite : boolean;
	signal DMAAddress : natural range 0 to pavr_dm_len - 1;
	signal DMADataWrite : std_ulogic_vector(7 downto 0);
	signal DMADataRead : std_ulogic_vector(7 downto 0);

	signal Halls : halls_t := (others => (others => false));

	signal MotorsDrive : motors_drive_phases_t := (others => (others => FLOAT));

	signal Encoders : encoders_t := (others => (others => false));

	signal ChickerPresent : boolean := false;
	signal StartKick : boolean := false;
	signal StartChip : boolean := false;
	signal ChargePulse : boolean := false;
	constant CapacitorDangerousThreshold : natural := natural(30.0 / (220000.0 + 2200.0) * 2200.0 / 3.3 * 1023.0);
	constant CapacitorStopDischargeThreshold : natural := natural(20.0 / (220000.0 + 2200.0) * 2200.0 / 3.3 * 1023.0);
	signal DischargePulse : boolean := false;

	signal DeviceID : std_ulogic_vector(56 downto 0);

	signal LFSR : std_ulogic_vector(31 downto 0) := (others => '1');

	signal DebugOut : std_ulogic := '1';
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator => OscillatorPin,
		Clocks => Clocks);

	-- Assert system reset for 16 cycles of the slowest clock after startup, then release.
	process(Clocks.Clock4MHz) is
		variable ResetShifter : std_ulogic_vector(15 downto 0) := X"FFFF";
	begin
		if rising_edge(Clocks.Clock4MHz) then
			ResetShifter := '0' & ResetShifter(15 downto 1);
		end if;
		SystemReset <= to_boolean(ResetShifter(0));
	end process;

	CPU : entity work.CPUWrapper(Arch)
	port map(
		Clocks => Clocks,
		Reset => SystemReset,
		Inputs => CPUInputs,
		Outputs => CPUOutputs,
		DMAWrite => DMAWrite,
		DMAAddress => DMAAddress,
		DMADataWrite => DMADataWrite,
		DMADataRead => DMADataRead);

	LaserDiff : entity work.DeltaLaser(Arch)
	port map(
		Clock => Clocks,
		Input => CPUInputs.MCP3008(7),
		Difference => CPUInputs.LaserDiff,
		to_stdulogic(Laser) => LaserPowerPin);

	CPUInputs.InterlockOverride <= InterlockOverridePin = '1';

	DMA : entity work.DMAController(Arch)
	port map(
		Clock => Clocks.Clock40MHz,
		Reset => SystemReset,
		CPUInputs => CPUInputs.DMA,
		CPUOutputs => CPUOutputs.DMA,
		ReadRequests => DMAReadRequests,
		ReadResponses => DMAReadResponses,
		WriteRequests => DMAWriteRequests,
		WriteResponses => DMAWriteResponses,
		DMAWrite => DMAWrite,
		DMAAddress => DMAAddress,
		DMADataWrite => DMADataWrite,
		DMADataRead => DMADataRead);

	process(CPUOutputs.TestLEDsSoftware, CPUOutputs.TestLEDsValue, Halls, Encoders) is
	begin
		if CPUOutputs.TestLEDsSoftware then
			TestLEDsPin <= CPUOutputs.TestLEDsValue(2 downto 0);
		else
			case CPUOutputs.TestLEDsValue is
				when "00000" | "00001" | "00010" | "00011" | "00100" =>
					for Index in 0 to 2 loop
						TestLEDsPin(Index) <= to_stdulogic(Halls(to_integer(unsigned(CPUOutputs.TestLEDsValue)))(Index));
					end loop;

				when "00101" | "00110" | "00111" | "01000" =>
					for Index in 0 to 1 loop
						TestLEDsPin(Index) <= to_stdulogic(Encoders(to_integer(unsigned(CPUOutputs.TestLEDsValue)) - 5)(Index));
					end loop;
					TestLEDsPin(2) <= '0';

				when others =>
					TestLEDsPin <= "---";
			end case;
		end if;
	end process;

	RadioLEDPin <= '1' when CPUOutputs.RadioLED else '0';
	LogicPowerPin <= '1' when CPUOutputs.PowerLogic else '0';
	HVPowerPin <= '1' when CPUOutputs.PowerMotors else '0';
	LPSDrivesPin <= CPUOutputs.LPSDrives;

	CPUInputs.BreakoutPresent <= to_boolean(BreakoutPresentPin);

	process(Clocks.Clock8MHz) is
	begin
		if rising_edge(Clocks.Clock8MHz) then
			for Index in 0 to 4 loop
				for Pin in 0 to 2 loop
					Halls(Index)(Pin) <= to_boolean(HallsPin(Index)(Pin));
				end loop;
			end loop;
		end if;
	end process;

	Motors : for Index in 0 to 4 generate
		Motor : entity work.Motor(Arch)
		generic map(
			PWMMax => 255,
			PWMPhase => Index * 51)
		port map(
			Clock => Clocks.Clock8MHz,
			Control => CPUOutputs.MotorsControl(Index),
			Hall => Halls(Index),
			HallStuckHigh => CPUInputs.HallsStuckHigh(Index),
			HallStuckLow => CPUInputs.HallsStuckLow(Index),
			Drive => MotorsDrive(Index));

		Phases : for Phase in 0 to 2 generate
			MotorsPhasesEPin(Index)(Phase) <= '1' when MotorsDrive(Index)(Phase) /= FLOAT else '0';
			MotorsPhasesLPin(Index)(Phase) <= '1' when MotorsDrive(Index)(Phase) = HIGH else '0';
		end generate;
	end generate;

	GenerateEncoders : for Index in 0 to 3 generate
		process(Clocks.Clock40MHz) is
		begin
			if rising_edge(Clocks.Clock40MHz) then
				for Channel in 0 to 1 loop
					Encoders(Index)(Channel) <= to_boolean(EncodersPin(Index)(Channel));
				end loop;
			end if;
		end process;

		Encoder : entity work.GrayCounter(Arch)
		port map(
			Clock => Clocks.Clock40MHz,
			Input => Encoders(Index),
			Clear => CPUOutputs.EncodersClear(Index),
			Value => CPUInputs.EncodersCount(Index));

		EncoderFail : entity work.EncoderFail(Arch)
		port map(
			Clock => Clocks.Clock4MHz,
			Encoder => Encoders(Index),
			Hall => Halls(Index),
			Fail => CPUInputs.EncodersFail(Index));
	end generate;

	DribblerSpeed : entity work.HallSpeed(Arch)
	port map(
		Clock => Clocks.Clock40MHz,
		Reset => CPUOutputs.DribblerSpeedClear,
		Hall => Halls(4),
		Count => CPUInputs.DribblerSpeed);

	MCP3008 : entity work.MCP3008(Arch)
	port map(
		Clocks => Clocks,
		MOSI => ADCMOSIPin,
		MISO => ADCMISOPin,
		CLK => ADCClockPin,
		CS => ADCCSPin,
		Levels => CPUInputs.MCP3008);

	CPUInputs.ChickerPresent <= to_boolean(not ChickerPresentPin);

	ChargedLEDPin <= to_stdulogic(CPUInputs.MCP3008(0).Value > CapacitorDangerousThreshold);

	StartKickDC : entity work.DownClock(Arch)
	port map(
		HighClock => Clocks.Clock40MHz,
		LowClock => Clocks.Clock4MHz,
		StrobeIn => CPUOutputs.StartKick,
		StrobeOut => StartKick);

	StartChipDC : entity work.DownClock(Arch)
	port map(
		HighClock => Clocks.Clock40MHz,
		LowClock => Clocks.Clock4MHz,
		StrobeIn => CPUOutputs.StartChip,
		StrobeOut => StartChip);

	BoostController : entity work.BoostController(Arch)
	generic map(
		ClockFrequency => 4000000.0)
	port map(
		Clock => Clocks.Clock4MHz,
		Enable => CPUOutputs.Charge,
		CapacitorVoltage => CPUInputs.MCP3008(0).Value,
		BatteryVoltage => CPUInputs.MCP3008(1).Value,
		Charge => ChargePulse,
		Timeout => CPUInputs.ChargeTimeout,
		Done => CPUInputs.ChargeDone);
	ChickerChargePin <= to_stdulogic(ChargePulse);

	process(Clocks.Clock4MHz) is
		variable Counter : natural range 0 to 65535;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			CPUInputs.KickActive <= CPUInputs.KickActive or StartKick;
			CPUInputs.ChipActive <= CPUInputs.ChipActive or StartChip;
			if StartKick or StartChip then
				Counter := CPUOutputs.KickPeriod;
			elsif Counter = 0 then
				CPUInputs.KickActive <= false;
				CPUInputs.ChipActive <= false;
			else
				Counter := Counter - 1;
			end if;
		end if;
	end process;
	process(Clocks.Clock4MHz, CPUOutputs.Discharge, CPUInputs.MCP3008) is
		subtype count_t is natural range 0 to 19999;
		variable Count : count_t := 0;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			Count := (Count + 1) mod (count_t'high + 1);
		end if;
		DischargePulse <= (Count < 1200) and CPUOutputs.Discharge and (CPUInputs.MCP3008(0).Value > CapacitorStopDischargeThreshold);
	end process;
	ChickerChipPin <= to_stdulogic(CPUInputs.ChipActive or DischargePulse);
	ChickerKickPin <= to_stdulogic(CPUInputs.KickActive or DischargePulse);

	FlashCSPin <= CPUOutputs.FlashCS;
	FlashSPI : entity work.SPI(Arch)
	port map(
		HostClock => Clocks.Clock40MHz,
		BusClock => Clocks.Clock40MHz,
		BusClockI => Clocks.Clock40MHzI,
		WriteData => CPUOutputs.FlashDataWrite,
		ReadData => CPUInputs.FlashDataRead,
		Strobe => CPUOutputs.FlashStrobe,
		Busy => CPUInputs.FlashBusy,
		ClockPin => FlashClockPin,
		MOSIPin => FlashMOSIPin,
		MISOPin => FlashMISODebugPin);

	MRFWakePin <= CPUOutputs.MRFWake;
	MRFResetPin <= CPUOutputs.MRFReset;
	CPUInputs.MRFInterrupt <= MRFInterruptPin;
	MRF : entity work.MRF(Arch)
	port map(
		HostClock => Clocks.Clock40MHz,
		BusClock => Clocks.Clock8MHz,
		BusClockI => Clocks.Clock8MHzI,
		WriteData => CPUOutputs.MRFDataWrite,
		ReadData => CPUInputs.MRFDataRead,
		Address => CPUOutputs.MRFAddress,
		StrobeAddress => CPUOutputs.MRFStrobeAddress,
		StrobeShortRead => CPUOutputs.MRFStrobeShortRead,
		StrobeLongRead => CPUOutputs.MRFStrobeLongRead,
		StrobeShortWrite => CPUOutputs.MRFStrobeShortWrite,
		StrobeLongWrite => CPUOutputs.MRFStrobeLongWrite,
		Busy => CPUInputs.MRFBusy,
		CSPin => MRFCSPin,
		ClockPin => MRFClockPin,
		MOSIPin => MRFMOSIPin,
		MISOPin => MRFMISOPin,
		DMAReadRequest => DMAReadRequests(DMA_READ_CHANNEL_MRF),
		DMAReadResponse => DMAReadResponses(DMA_READ_CHANNEL_MRF),
		DMAWriteRequest => DMAWriteRequests(DMA_WRITE_CHANNEL_MRF),
		DMAWriteResponse => DMAWriteResponses(DMA_WRITE_CHANNEL_MRF));

	CPUInputs.SDPresent <= to_boolean(SDPresentPin);
	SDCSPin <= CPUOutputs.SDCS;
	SD : entity work.SD(Arch)
	port map(
		HostClock => Clocks.Clock40MHz,
		BusClock => Clocks.Clock4MHz,
		BusClockI => Clocks.Clock4MHzI,
		PIOWriteData => CPUOutputs.SDDataWrite,
		PIOReadData => CPUInputs.SDDataRead,
		PIOStrobe => CPUOutputs.SDStrobe,
		Busy => CPUInputs.SDBusy,
		DRTCRCError => CPUInputs.SDDRTCRCError,
		DRTWriteError => CPUInputs.SDDRTWriteError,
		DRTUnknownError => CPUInputs.SDDRTUnknownError,
		ClockPin => SDClockPin,
		MOSIPin => SDMOSIPin,
		MISOPin => SDMISOPin,
		DMAReadRequest => DMAReadRequests(DMA_READ_CHANNEL_SD),
		DMAReadResponse => DMAReadResponses(DMA_READ_CHANNEL_SD));
	
	DNAPort : entity work.DeviceDNA
	port map(
		Clocks => Clocks,
		Value => DeviceID);
	CPUInputs.DeviceID <= DeviceID(55 downto 0);
	CPUInputs.DeviceIDReady <= to_boolean(DeviceID(56));

	process(Clocks.Clock40MHz) is
	begin
		if rising_edge(Clocks.Clock40MHz) then
			if CPUOutputs.LFSRTick then
				LFSR <= (LFSR(19) XOR LFSR(24) XOR LFSR(26) XOR LFSR(31)) & LFSR(31 downto 1);
			end if;
		end if;
	end process;
	CPUInputs.LFSRBit <= LFSR(0);

	DebugPort : entity work.AsyncSerialTransmitter(Arch)
	generic map(
		BusClockDivider => 4)
	port map(
		HostClock => Clocks.Clock40MHz,
		BusClock => Clocks.Clock4MHz,
		Data => CPUOutputs.DebugData,
		Strobe => CPUOutputs.DebugStrobe,
		Busy => CPUInputs.DebugBusy,
		Output => DebugOut);
	FlashMISODebugPin <= DebugOut when CPUOutputs.DebugEnabled else 'Z';

	ICAPWrapper : entity work.ICAPWrapper(Arch)
	port map(
		HostClock => Clocks.Clock40MHz,
		ICAPClock => Clocks.Clock4MHz,
		Data => CPUOutputs.ICAPData,
		Strobe => CPUOutputs.ICAPStrobe,
		Busy => CPUInputs.ICAPBusy);
end architecture Main;
