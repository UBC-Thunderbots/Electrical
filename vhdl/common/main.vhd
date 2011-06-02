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
		FlashDrive : out boolean;
		FlashCS : out boolean;
		FlashClock : out boolean;
		FlashMOSI : out std_ulogic;
		FlashMISO : in std_ulogic;
		LEDs : out leds_t;
		Encoders : in encoders_t;
		MotorsPhases : out motors_phases_t;
		Halls : in halls_t;
		KickerMISO : in boolean;
		KickerCLK : out boolean;
		KickerCS : out boolean;
		KickerCharge : out boolean;
		KickLeft : out boolean;
		KickRight : out boolean;
		KickerPresent : in boolean);
end entity Main;

architecture Behavioural of Main is
	type enable_motors_t is array(1 to 5) of boolean;
	signal EnableWheels : boolean;
	signal EnableCharger : boolean;
	signal EnableDribbler : boolean;
	signal EnableMotors : enable_motors_t;
	signal MotorsDirection : motors_direction_t;
	signal MotorsPower : motors_power_t;
	signal BatteryVoltageHigh : battery_voltage_t;
	signal TestMode : test_mode_t;
	signal TestIndex : natural range 0 to 15;
	signal KickStrobe : boolean;
	signal KickPower : kicker_times_t;
	signal KickOffset : kicker_time_t;
	signal KickOffsetSign : boolean;
	signal BatteryVoltageLow : battery_voltage_t;
	signal CapacitorVoltage : capacitor_voltage_t;
	signal EncodersCount : encoders_count_t;
	signal EncodersStrobe : boolean;
	signal KickerTimeout : boolean;
	signal KickerActivity : boolean;
	signal KickActive : kicker_active_t;
	signal FlashCRC : std_ulogic_vector(15 downto 0);
begin
	Parbus: entity work.Parbus(Behavioural)
	port map(
		Clock => ClockHigh,
		ParbusDataIn => ParbusDataIn,
		ParbusDataOut => ParbusDataOut,
		ParbusRead => ParbusRead,
		ParbusWrite => ParbusWrite,
		EnableWheels => EnableWheels,
		EnableCharger => EnableCharger,
		EnableDribbler => EnableDribbler,
		MotorsDirection => MotorsDirection,
		MotorsPower => MotorsPower,
		BatteryVoltage => BatteryVoltageHigh,
		TestMode => TestMode,
		TestIndex => TestIndex,
		KickStrobe => KickStrobe,
		KickPower => KickPower,
		KickOffset => KickOffset,
		KickOffsetSign => KickOffsetSign,
		EncodersStrobe => EncodersStrobe,
		KickerPresent => KickerPresent,
		CapacitorVoltage => CapacitorVoltage,
		EncodersCount => EncodersCount,
		FlashCRC => FlashCRC);

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

	FlashChecksummer: entity work.FlashChecksummer(Behavioural)
	port map(
		ClockHigh => ClockHigh,
		Drive => FlashDrive,
		CS => FlashCS,
		SPIClock => FlashClock,
		MOSI => FlashMOSI,
		MISO => FlashMISO,
		CRC => FlashCRC);

	EnableMotors <= (5 => EnableDribbler, others => EnableWheels);
	GenerateMotor: for I in 1 to 5 generate
		Motor: entity work.Motor(Behavioural)
		generic map(
			PWMMax => 255)
		port map(
			PWMClock => ClockMid,
			ClockHigh => ClockHigh,
			Enable => EnableMotors(I),
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
		MISO => KickerMISO,
		CLK => KickerCLK,
		CS => KickerCS,
		Level => CapacitorVoltage);

	Kicker: entity work.Kicker(Behavioural)
	port map(
		ClockHigh => ClockHigh,
		ClockLow => ClockLow,
		Strobe => KickStrobe,
		Power => KickPower,
		Offset => KickOffset,
		OffsetSign => KickOffsetSign,
		Active => KickActive);

	KickLeft <= KickActive(1);
	KickRight <= KickActive(2);

	BoostController: entity work.BoostController(Behavioural)
	port map(
		ClockLow => ClockLow,
		Enable => EnableCharger,
		CapacitorVoltage => CapacitorVoltage,
		BatteryVoltage => BatteryVoltageLow,
		Charge => KickerCharge,
		Timeout => KickerTimeout,
		Activity => KickerActivity);

	process(TestMode, Halls, Encoders, KickerActivity, KickerTimeout) is
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
				LEDs <= (0 => KickerActivity, 1 => KickerTimeout, others => false);
		end case;
	end process;
end architecture Behavioural;
