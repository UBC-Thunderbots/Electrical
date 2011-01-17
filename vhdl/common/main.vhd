library ieee;
use ieee.std_logic_1164.all;
use work.types;

entity Main is
	port(
		ClockLow : in std_ulogic;
		ClockMid : in std_ulogic;
		ClockHigh : in std_ulogic;
		Reset : in boolean;
		ParbusDataIn : in std_ulogic_vector(7 downto 0);
		ParbusDataOut : out std_ulogic_vector(7 downto 0);
		ParbusRead : in boolean;
		ParbusWrite : in boolean;
		LEDs : out types.leds_t;
		Encoders : in types.encoders_t;
		MotorsPhases : out types.motors_phases_t;
		Halls : in types.halls_t;
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
	signal MotorsDirection : types.motors_direction_t;
	signal MotorsPower : types.motors_power_t;
	signal BatteryVoltageHigh : types.battery_voltage_t;
	signal TestMode : types.test_mode_t;
	signal TestIndex : natural range 0 to 15;
	signal BatteryVoltageLow : types.battery_voltage_t;
	signal CapacitorVoltage : types.capacitor_voltage_t;
	signal EncodersCount : types.encoders_count_t;
	signal ChickerFault : boolean;
	signal ChickerActivity : boolean;
begin
	Parbus: entity Parbus(Behavioural)
	port map(
		Clock => ClockHigh,
		Reset => Reset,
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
		Motor: entity Motor(Behavioural)
		generic map(
			PWMMax => 255)
		port map(
			PWMClock => ClockMid,
			ClockHigh => ClockHigh,
			Reset => Reset,
			Enable => EnableMotors,
			Power => MotorsPower(I),
			Direction => MotorsDirection(I),
			Hall => Halls(I),
			AllLow => open,
			AllHigh => open,
			Phases => MotorsPhases(I));
	end generate;

	GenerateGrayCounter: for I in 1 to 4 generate
		GrayCounter: entity GrayCounter(Behavioural)
		port map(
			Clock => ClockHigh,
			Reset => Reset,
			Input => Encoders(I),
			Value => EncodersCount(I));
	end generate;

	ADC: entity ADC(Behavioural)
	port map(
		Clock => ClockLow,
		Reset => Reset,
		MISO => ChickerMISO,
		CLK => ChickerCLK,
		CS => ChickerCS,
		Level => CapacitorVoltage);

	BoostController: entity BoostController(Behavioural)
	port map(
		Clock => ClockLow,
		Reset => Reset,
		Enable => EnableCharger,
		CapacitorVoltage => CapacitorVoltage,
		BatteryVoltage => BatteryVoltageLow,
		Charge => ChickerCharge,
		Fault => ChickerFault,
		Activity => ChickerActivity);

	process(ClockMid) is
	begin
		if rising_edge(ClockMid) then
			case TestMode is
				when types.NONE =>
					LEDs <= (others => false);

				when types.HALL =>
					for I in 0 to 2 loop
						LEDs(I) <= Halls(TestIndex)(I);
					end loop;
					LEDs(3) <= false;

				when types.ENCODER =>
					LEDs <= (0 => Encoders(TestIndex)(0), 1 => Encoders(TestIndex)(1), others => false);

				when types.BOOSTCONVERTER =>
					LEDs <= (0 => ChickerActivity, 1 => ChickerFault, others => false);
			end case;
		end if;
	end process;
end architecture Behavioural;
