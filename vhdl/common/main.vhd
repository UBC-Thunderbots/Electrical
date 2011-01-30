library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity Main is
	port(
		ClockLow : in std_ulogic;
		ClockMid : in std_ulogic;
		ClockHigh : in std_ulogic;
		ParbusDataIn : in std_ulogic_vector(7 downto 0);
		ParbusDataOut : out std_ulogic_vector(7 downto 0);
		ParbusRead : in boolean;
		ParbusWrite : in boolean;
		LEDs : out leds_t;
		Encoders : in encoders_t;
		MotorsPhases : out motors_phases_t;
		Halls : in halls_t;
		ChickerMISO : in boolean;
		ChickerCLK : out boolean;
		ChickerCS : out boolean;
		ChickerCharge : out boolean;
		Kick : out boolean;
		Chip : out boolean;
		ChickerPresent : in boolean);
end entity Main;

architecture Behavioural of Main is
	signal EnableMotors : boolean;
	signal EnableCharger : boolean;
	signal MotorsDirection : motors_direction_t;
	signal MotorsPower : motors_power_t;
	signal BatteryVoltageHigh : battery_voltage_t;
	signal TestMode : test_mode_t;
	signal TestIndex : natural range 0 to 15;
	signal ChickStrobe : boolean;
	signal ChickPower : chicker_power_t;
	signal BatteryVoltageLow : battery_voltage_t;
	signal CapacitorVoltage : capacitor_voltage_t;
	signal EncodersCount : encoders_count_t;
	signal EncodersStrobe : boolean;
	signal ChickerFault : boolean;
	signal ChickerActivity : boolean;
	signal ChickActive : boolean;
begin
	Parbus: entity work.Parbus(Behavioural)
	port map(
		Clock => ClockHigh,
		ParbusDataIn => ParbusDataIn,
		ParbusDataOut => ParbusDataOut,
		ParbusRead => ParbusRead,
		ParbusWrite => ParbusWrite,
		EnableMotors => EnableMotors,
		EnableCharger => EnableCharger,
		MotorsDirection => MotorsDirection,
		MotorsPower => MotorsPower,
		BatteryVoltage => BatteryVoltageHigh,
		TestMode => TestMode,
		TestIndex => TestIndex,
		ChickStrobe => ChickStrobe,
		ChickPower => ChickPower,
		EncodersStrobe => EncodersStrobe,
		ChickerPresent => ChickerPresent,
		CapacitorVoltage => CapacitorVoltage,
		EncodersCount => EncodersCount);

	-- Parbus registers its output on ClockHigh.
	-- BoostConverter runs entirely on ClockLow.
	-- Cross the timing domain into a second register.
	-- Without this, timing closure fails as BoostConverter is too slow.
	process(ClockLow) is
	begin
		if rising_edge(ClockLow) then
			BatteryVoltageLow <= BatteryVoltageHigh;
		end if;
	end process;

	GenerateMotor: for I in 1 to 5 generate
		Motor: entity work.Motor(Behavioural)
		generic map(
			PWMMax => 255)
		port map(
			PWMClock => ClockMid,
			ClockHigh => ClockHigh,
			Enable => EnableMotors,
			Power => MotorsPower(I),
			Direction => MotorsDirection(I),
			Hall => Halls(I),
			AllLow => open,
			AllHigh => open,
			Phases => MotorsPhases(I));
	end generate;

	GenerateGrayCounter: for I in 1 to 4 generate
		GrayCounter: entity work.GrayCounter(Behavioural)
		port map(
			Clock => ClockHigh,
			Input => Encoders(I),
			Strobe => EncodersStrobe,
			Value => EncodersCount(I));
	end generate;

	ADC: entity work.ADC(Behavioural)
	port map(
		Clock => ClockLow,
		MISO => ChickerMISO,
		CLK => ChickerCLK,
		CS => ChickerCS,
		Level => CapacitorVoltage);

	Chicker: entity work.Chicker(Behavioural)
	port map(
		ClockHigh => ClockHigh,
		ClockLow => ClockLow,
		Strobe => ChickStrobe,
		Power => ChickPower,
		Active => ChickActive);

	Kick <= ChickActive;

	BoostController: entity work.BoostController(Behavioural)
	port map(
		Clock => ClockLow,
		Enable => EnableCharger,
		CapacitorVoltage => CapacitorVoltage,
		BatteryVoltage => BatteryVoltageLow,
		Charge => ChickerCharge,
		Fault => ChickerFault,
		Activity => ChickerActivity);

	process(TestMode, Halls, Encoders, ChickerActivity, ChickerFault) is
	begin
		case TestMode is
			when NONE =>
				LEDs <= (others => false);

			when LAMPTEST =>
				LEDs <= (others => true);

			when HALL =>
				for I in 0 to 2 loop
					LEDs(I) <= Halls(TestIndex)(I);
				end loop;
				LEDs(3) <= false;

			when ENCODER_LINES =>
				LEDs <= (0 => Encoders(TestIndex)(0), 1 => Encoders(TestIndex)(1), others => false);

			when ENCODER_COUNT =>
				for I in 0 to 3 loop
					LEDs(I) <= to_unsigned(EncodersCount(TestIndex), 4)(I) = '1';
				end loop;

			when BOOSTCONVERTER =>
				LEDs <= (0 => ChickerActivity, 1 => ChickerFault, others => false);
		end case;
	end process;
end architecture Behavioural;
