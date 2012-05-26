library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.clock.all;
use work.pintypes.all;
use work.types.all;

entity Top is
	port(
		OscillatorPin : in std_ulogic_vector(1 downto 0);
		OscillatorEnablePin : out std_ulogic := '1';

		LogicPowerPin : out std_ulogic := '1';
		HVPowerPin : out std_ulogic := '0';

		ADCCSPin : out std_ulogic := '1';
		ADCClockPin : out std_ulogic := '0';
		ADCMOSIPin : out std_ulogic := '0';
		ADCMISOPin : in std_ulogic;

		FlashCSPin : out std_ulogic := '1';
		ChickerCSPin : out std_ulogic := '1';
		ChickerChargePin : out std_ulogic := '1';
		ChickerKickPin : out std_ulogic := '1';
		ChickerChipPin : out std_ulogic := '1';
		ChickerSparePin : out std_ulogic := '0';
		MRFCSPin : out std_ulogic := '1';
		MRFResetPin : out std_ulogic;
		MRFWakePin : out std_ulogic;
		MRFInterruptPin : in std_ulogic;
		FlashMRFChickerClockPin : out std_ulogic := '0';
		FlashMRFChickerMOSIPin : out std_ulogic := '0';
		FlashMRFChickerMISOPin : in std_ulogic;

		BreakbeamDrivePin : out std_ulogic;

		LPSResetPin : out std_ulogic;
		LPSClockPin : out std_ulogic;

		ChargedLEDPin : out std_ulogic := '0';
		RadioLEDPin : out std_ulogic := '0';
		TestLEDsPin : out std_ulogic_vector(2 downto 0) := (others => '0');

		EncodersPin : in encoders_pin_t;

		MotorsPhasesPPin : out motors_phases_pin_t := (others => (others => '1'));
		MotorsPhasesNPin : out motors_phases_pin_t := (others => (others => '0'));

		HallsPin : in halls_pin_t;

		VirtualGroundPin : out std_ulogic_vector(0 to 1));
end entity Top;

architecture Behavioural of Top is
	type pwm_duty_cycles_t is array(1 to 5) of natural range 0 to 255;
	signal ClockFailed : boolean;
	signal Clock1MHz : std_ulogic;
	signal Clock1MHzInv : std_ulogic;
	signal Clock8MHz : std_ulogic;
	signal HallsLatched : halls_t;
	signal MotorsEnable : boolean := false;
	signal PWMDutyCycle : pwm_duty_cycles_t;
	signal MotorsPhases : motors_phases_t;

	signal ChickerClock : boolean;
	signal ChickerMISO : boolean;
	signal ChickerCS : boolean;
	signal CapacitorVoltage : capacitor_voltage_t;
	signal LatchedCapacitorVoltage : unsigned(11 downto 0);
	signal CapacitorVoltageOutputNybble : natural range 0 to 2 := 0;
	signal ChickerEnable : boolean;
	signal ChickerCharge : boolean;
	signal ChickerTimeout : boolean;
	signal ChickerActivity : boolean;
	signal ChickerDone : boolean;

	signal NavreResetShifter : std_ulogic_vector(15 downto 0) := X"FFFF";
	signal NavreProgramMemoryClockEnable : std_ulogic;
	signal NavreProgramMemoryAddress : unsigned(10 downto 0);
	signal NavreProgramMemoryData : std_ulogic_vector(15 downto 0) := X"0000";
	signal NavreDataMemoryWriteEnable : std_ulogic;
	signal NavreDataMemoryAddress : unsigned(12 downto 0);
	signal NavreDataMemoryDI : std_ulogic_vector(7 downto 0) := X"00";
	signal NavreDataMemoryDO : std_ulogic_vector(7 downto 0);
	signal NavreIOReadEnable : std_ulogic;
	signal NavreIOWriteEnable : std_ulogic;
	signal NavreIOAddress : unsigned(5 downto 0);
	signal NavreIODO : std_ulogic_vector(7 downto 0);
	signal NavreIODI : std_ulogic_vector(7 downto 0) := X"00";

	component navre
	generic(
		pmem_width : natural;
		dmem_width : natural);
	port(
		clk : in std_ulogic;
		rst : in std_ulogic;
		pmem_ce : out std_ulogic;
		pmem_a : out std_ulogic_vector(pmem_width - 1 downto 0);
		pmem_d : in std_ulogic_vector(15 downto 0);
		dmem_we : out std_ulogic;
		dmem_a : out std_ulogic_vector(dmem_width - 1 downto 0);
		dmem_di : in std_ulogic_vector(7 downto 0);
		dmem_do : out std_ulogic_vector(7 downto 0);
		io_re : out std_ulogic;
		io_we : out std_ulogic;
		io_a : out std_ulogic_vector(5 downto 0);
		io_do : out std_ulogic_vector(7 downto 0);
		io_di : in std_ulogic_vector(7 downto 0);
		dbg_pc : out std_ulogic_vector(pmem_width - 1 downto 0));
	end component navre;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clock1MHz => Clock1MHz,
		Clock8MHz => Clock8MHz,
		Failed => ClockFailed);

--	LogicPowerPin <= '1';
--	HVPowerPin <= '0';
--	ADCCSPin <= '1';
--	ADCClockPin <= '0';
--	ADCMOSIPin <= '0';
--	FlashCSPin <= '1';
--	ChickerCSPin <= '1';
--	ChickerChargePin <= '1';
--	ChickerKickPin <= '1';
--	ChickerChipPin <= '1';
--	ChickerSparePin <= '0';
	MRFCSPin <= '1';
	MRFResetPin <= '0';
	MRFWakePin <= '0';
--	FlashMRFChickerClockPin <= '0';
--	FlashMRFChickerMOSIPin <= '0';
	BreakbeamDrivePin <= '1';
	LPSResetPin <= '0';
	LPSClockPin <= '0';
--	MotorsPhasesPPin <= (others => "111");
--	MotorsPhasesNPin <= (others => "000");
	VirtualGroundPin <= (others => '0');

--	ChargedLEDPin <= '1' when ClockFailed else '0';

	process(Clock8MHz) is
	begin
		if rising_edge(Clock8MHz) then
			for MotorIndex in 1 to 5 loop
				for SensorIndex in 0 to 2 loop
					HallsLatched(MotorIndex)(SensorIndex) <= HallsPin(MotorIndex)(SensorIndex) = '1';
				end loop;
			end loop;
		end if;
	end process;

	TopLevel1 : if false generate
		process(Clock1MHz) is
			variable Subseconds : natural range 0 to 999999 := 0;
			variable Seconds : natural range 0 to 7 := 0;
			type StateType is (BOOT, HV_ENABLED, MOTORS_ENABLED, PWM_ENABLED);
			variable State : StateType := BOOT;
		begin
			if rising_edge(Clock1MHz) then
				if Subseconds = 999999 then
					if Seconds = 7 then
						case State is
							when BOOT =>
								HVPowerPin <= '1';
								RadioLEDPin <= '1';
								State := HV_ENABLED;
							when HV_ENABLED =>
								MotorsEnable <= true;
								State := MOTORS_ENABLED;
							when MOTORS_ENABLED =>
								PWMDutyCycle(1) <= 20;
								PWMDutyCycle(2) <= 20;
								PWMDutyCycle(3) <= 20;
								PWMDutyCycle(4) <= 20;
								PWMDutyCycle(5) <= 80;
								State := PWM_ENABLED;
							when PWM_ENABLED =>
								null;
						end case;
					end if;
					Seconds := (Seconds + 1) mod 8;
				end if;
				if Subseconds = 999999 then Subseconds := 0; else Subseconds := Subseconds + 1; end if;
			end if;
			TestLEDsPin <= std_ulogic_vector(to_unsigned(Seconds, 3));
		end process;

		Motors : for MotorIndex in 1 to 5 generate
			Motor : entity work.Motor(Behavioural)
			generic map(
				PWMMax => 255,
				PWMPhase => 0)
			port map(
				ClockMid => Clock8MHz,
				ClockHigh => Clock8MHz,
				Enable => MotorsEnable,
				Power => PWMDutyCycle(MotorIndex),
				Direction => false,
				Hall => HallsLatched(MotorIndex),
				EncodersStrobe => false,
				HallStuck => open,
				HallCommutated => open,
				Phases => MotorsPhases(MotorIndex));

			Phases : for PhaseIndex in 0 to 2 generate
				MotorsPhasesPPin(MotorIndex)(PhaseIndex) <= '0' when MotorsPhases(MotorIndex)(PhaseIndex) = HIGH else '1';
				MotorsPhasesNPin(MotorIndex)(PhaseIndex) <= '1' when MotorsPhases(MotorIndex)(PhaseIndex) = LOW else '0';
			end generate;
		end generate;
	end generate;

	TopLevel2 : if false generate
		Halls : for I in 0 to 2 generate
			TestLEDsPin(I) <= '1' when HallsLatched(1)(I) else '0';
		end generate;
	end generate;

	TopLevel3 : if false generate
		MRFWakePin <= '0';
		MRFResetPin <= '1';

		process(Clock1MHz) is
			type state_t is (IDLE, CS_ASSERTED, CLK_RAISED, DONE);
			variable State : state_t := IDLE;
			-- Reset value of ACKTMOUT (0x12) should be 0b00111001 (0x39)
			variable DataOut : std_ulogic_vector(15 downto 0) := X"2400";
			variable DataIn : std_ulogic_vector(15 downto 0) := X"0000";
			variable Count : natural range 0 to 15 := 15;
		begin
			if rising_edge(Clock1MHz) then
				case State is
					when IDLE =>
						MRFCSPin <= '0';
						State := CS_ASSERTED;
					when CS_ASSERTED =>
						FlashMRFChickerClockPin <= '1';
						State := CLK_RAISED;
						DataIn := DataIn(14 downto 0) & FlashMRFChickerMISOPin;
					when CLK_RAISED =>
						FlashMRFChickerClockPin <= '0';
						State := CS_ASSERTED;
						DataOut := DataOut(14 downto 0) & '0';
						if Count = 0 then
							TestLEDsPin(2) <= DataIn(4);
							TestLEDsPin(1) <= DataIn(3);
							TestLEDsPin(0) <= DataIn(2);
							RadioLEDPin <= DataIn(1);
							ChargedLEDPin <= DataIn(0);
							State := DONE;
						end if;
						Count := Count - 1;
					when DONE =>
						MRFCSPin <= '1';
				end case;
			end if;
			FlashMRFChickerMOSIPin <= DataOut(15);
		end process;
	end generate;

	TopLevel4 : if false generate
		process(Clock1MHz) is
			type state_t is (IDLE, ACTIVE);
			variable State : state_t := IDLE;
			variable CSOut : std_ulogic_vector(17 downto 0) := "100000000000000000";
			variable DataOut : std_ulogic_vector(17 downto 0) := "111011000000000000";
			variable DataIn : std_ulogic_vector(9 downto 0);
			variable Snapshot : std_ulogic_vector(9 downto 0);
		begin
			if rising_edge(Clock1MHz) then
				if CSOut(17) = '1' then
					Snapshot := DataIn;
				end if;
				DataIn := DataIn(8 downto 0) & ADCMISOPin;
			end if;
			if falling_edge(Clock1MHz) then
				CSOut := CSOut(16 downto 0) & CSOut(17);
				DataOut := DataOut(16 downto 0) & DataOut(17);
			end if;
			ADCCSPin <= CSOut(17);
			ADCMOSIPin <= DataOut(17);
			TestLEDsPin(2) <= Snapshot(9);
			TestLEDsPin(1) <= Snapshot(8);
			TestLEDsPIn(0) <= Snapshot(7);
			RadioLEDPin <= Snapshot(6);
			ChargedLEDPin <= Snapshot(5);
		end process;
		Clock1MHzInv <= not Clock1MHz;
		ADCClockODDR : ODDR2
		port map(
			D0 => '1',
			D1 => '0',
			C0 => Clock1MHz,
			C1 => Clock1MHzInv,
			CE => '1',
			R => '0',
			S => '0',
			Q => ADCClockPin);
	end generate;

	TopLevel5 : if false generate
		NavreInstance : navre
		generic map(
			pmem_width => 11,
			dmem_width => 13)
		port map(
			clk => Clock1MHz,
			rst => NavreResetShifter(0),
			pmem_ce => NavreProgramMemoryClockEnable,
			unsigned(pmem_a) => NavreProgramMemoryAddress,
			pmem_d => NavreProgramMemoryData,
			dmem_we => NavreDataMemoryWriteEnable,
			unsigned(dmem_a) => NavreDataMemoryAddress,
			dmem_di => NavreDataMemoryDI,
			dmem_do => NavreDataMemoryDO,
			io_re => NavreIOReadEnable,
			io_we => NavreIOWriteEnable,
			unsigned(io_a) => NavreIOAddress,
			io_do => NavreIODO,
			io_di => NavreIODI,
			dbg_pc => open);

		process(Clock1MHz) is
			type program_memory_type is array(0 to 2047) of std_ulogic_vector(15 downto 0);
			variable ProgramMemory : program_memory_type := (
				X"B000",
				X"B002",
				X"9200",
				X"0000",
				X"9010",
				X"0000",
				X"B810",
				X"CFF8",
				others => X"0000");

			type data_memory_type is array(0 to 65535) of std_ulogic_vector(7 downto 0);
			variable DataMemory : data_memory_type;

--			variable ProgramMemory : program_memory_type := (
--				X"E000", -- LDI r16, 0x00
--				X"B900", -- OUT 0x00, r16
--				X"9503", -- INC r16
--				X"B001", -- IN r0, 0x01
--				X"2000", -- AND r0, r0
--				X"F3E9", -- BREQ .-6
--				X"CFFA", -- RJMP .-12
--				others => X"0000");
--			variable ProgramMemory : program_memory_type := (
--				-- LDI r16, 0x00
--				0 => "1110000000000000",
--
--				-- LDI r17, 0x00
--				1 => "1110000000010000",
--
--				-- LDI r18, 0x00
--				2 => "1110000000100000",
--
--				-- OUT 0x00, r18
--				3 => "1011100100100000",
--
--				-- INC r16
--				4 => "1001010100000011",
--
--				-- BRNE -2 => PC will be 5 + 1 - 2 = 4
--				5 => "1111011111110001",
--
--				-- INC r17
--				6 => "1001010100010011",
--
--				-- BRNE -4 => PC will be 7 + 1 - 4 = 4
--				7 => "1111011111100001",
--
--				-- INC r18
--				8 => "1001010100100011",
--
--				-- RJMP -7 => PC will be 9 + 1 - 7 = 3
--				9 => "1100111111111001",
--
--				others => X"0000");
			variable TSC : unsigned(31 downto 0) := X"00000000";
			variable TSCLatched : std_ulogic_vector(31 downto 0);
		begin
			if rising_edge(Clock1MHz) then
				NavreResetShifter <= '0' & NavreResetShifter(15 downto 1);

				if NavreProgramMemoryClockEnable = '1' then
					NavreProgramMemoryData <= ProgramMemory(to_integer(NavreProgramMemoryAddress));
				end if;

				NavreDataMemoryDI <= DataMemory(to_integer(NavreDataMemoryAddress));
				if NavreDataMemoryWriteEnable = '1' then
					DataMemory(to_integer(NavreDataMemoryAddress)) := NavreDataMemoryDO;
				end if;

				NavreIODI <= X"00";
				if NavreIOReadEnable = '1' then
					case to_integer(NavreIOAddress) is
						when 0 =>
							TSCLatched := std_ulogic_vector(TSC);
							NavreIODI <= TSCLatched(7 downto 0);
						when 1 =>
							NavreIODI <= TSCLatched(15 downto 8);
						when 2 =>
							NavreIODI <= TSCLatched(23 downto 16);
						when 3 =>
							NavreIODI <= TSCLatched(31 downto 24);
						when others =>
							null;
					end case;
				end if;

				if NavreIOWriteEnable = '1' then
					case to_integer(NavreIOAddress) is
						when 0 =>
							TestLEDsPin(2) <= NavreIODO(4);
							TestLEDsPin(1) <= NavreIODO(3);
							TestLEDsPin(0) <= NavreIODO(2);
							RadioLEDPin <= NavreIODO(1);
							ChargedLEDPin <= NavreIODO(0);
						when others =>
							null;
					end case;
				end if;

				TSC := TSC + 1;

--				if NavreIOWriteEnable = '1' then
--					if NavreIOAddress = 0 then
--						Output := NavreIODO;
--						TestLEDsPin(2) <= NavreIODO(3);
--						TestLEDsPin(1) <= NavreIODO(2);
--						TestLEDsPin(0) <= NavreIODO(1);
--						RadioLEDPin <= NavreIODO(0);
--						ChargedLEDPin <= NavreIODO(0);
--					end if;
--				end if;
--				NavreIODI <= X"00";
--				if NavreIOReadEnable = '1' and NavreIOAddress = 1 and Notify then
--					NavreIODI <= X"FF";
--					Notify := false;
--				elsif NotifyCounter = 999999 then
--					Notify := true;
--				end if;
--				if NotifyCounter = 999999 then
--					NotifyCounter := 0;
--				else
--					NotifyCounter := NotifyCounter + 1;
--				end if;
			end if;
--			if NotifyCounter > 499999 then
--				ChargedLEDPin <= '0';
--				TestLEDsPin(2) <= Output(3);
--				TestLEDsPin(1) <= Output(2);
--				TestLEDsPin(0) <= Output(1);
--				RadioLEDPin <= Output(0);
--			else
--				ChargedLEDPin <= '1';
--				TestLEDsPin(2) <= Output(7);
--				TestLEDsPin(1) <= Output(6);
--				TestLEDsPin(0) <= Output(5);
--				RadioLEDPin <= Output(4);
--			end if;
		end process;
	end generate;

	TopLevel6 : if false generate
		ADCInstance : entity work.ADC(Behavioural)
		port map(
			Clock => Clock1MHz,
			MISO => ChickerMISO,
			CLK => ChickerClock,
			CS => ChickerCS,
			Level => CapacitorVoltage);
		ChickerMISO <= FlashMRFChickerMISOPin = '1';
		FlashMRFChickerClockPin <= '0' when ChickerClock else '1';
		ChickerCSPin <= '0' when ChickerCS else '1';

		process(Clock1MHz) is
			variable Subseconds : natural range 0 to 999999 := 0;
		begin
			if rising_edge(Clock1MHz) then
				if Subseconds = 999999 then
					Subseconds := 0;
					if CapacitorVoltageOutputNybble = 2 then
						LatchedCapacitorVoltage <= to_unsigned(CapacitorVoltage, 12);
						CapacitorVoltageOutputNybble <= 0;
					else
						CapacitorVoltageOutputNybble <= CapacitorVoltageOutputNybble + 1;
					end if;
				else
					Subseconds := Subseconds + 1;
				end if;
			end if;
		end process;

		BoostControllerInstance : entity work.BoostController(Behavioural)
		port map(
			ClockLow => Clock1MHz,
			Enable => ChickerEnable,
			CapacitorVoltage => CapacitorVoltage,
			BatteryVoltage => 951,
			Charge => ChickerCharge,
			Timeout => ChickerTimeout,
			Activity => ChickerActivity,
			Done => ChickerDone);
		process(Clock1MHz) is
			variable Ticks : natural range 0 to 999999 := 0;
		begin
			if rising_edge(Clock1MHz) then
				if Ticks /= 999999 then
					Ticks := Ticks + 1;
				end if;
			end if;
			if Ticks > 299999 and Ticks /= 999999 then
				ChickerSparePin <= '1';
			else
				ChickerSparePin <= '0';
			end if;
			if Ticks > 499999 and Ticks /= 999999 then
				ChickerEnable <= true;
			else
				ChickerEnable <= false;
			end if;
		end process;
		ChargedLEDPin <= '1' when ChickerCharge else '0';
		RadioLEDPin <= '1' when ChickerTimeout else '0';
		TestLEDsPin(2) <= '1' when ChickerActivity else '0';
		TestLEDsPIn(1) <= '1' when ChickerDone else '0';
		ChickerChargePin <= '0' when ChickerCharge else '1';
	end generate;

	TopLevel7 : if true generate
		process(Clock1MHz) is
			variable Microseconds : natural range 0 to 1999999 := 0;
		begin
			if rising_edge(Clock1MHz) then
				if Microseconds /= 1999999 then
					Microseconds := Microseconds + 1;
				end if;
			end if;

			if 499999 < Microseconds and Microseconds /= 1999999 then
				ChickerSparePin <= '1';
			else
				ChickerSparePin <= '0';
			end if;

			if 999999 < Microseconds and Microseconds < 999999 + 6000 then
				RadioLEDPin <= '1';
				ChickerKickPin <= '0';
			else
				RadioLEDPin <= '0';
				ChickerKickPin <= '1';
			end if;
		end process;
	end generate;
end architecture Behavioural;
