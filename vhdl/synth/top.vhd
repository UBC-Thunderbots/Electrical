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
		MRFResetPin : out std_ulogic := '0';
		MRFWakePin : out std_ulogic := '0';
		MRFInterruptPin : in std_ulogic;
		FlashMRFChickerClockPin : out std_ulogic := '0';
		FlashMRFChickerMOSIPin : out std_ulogic := '0';
		FlashMRFChickerMISOPin : in std_ulogic;

		BreakbeamDrivePin : out std_ulogic := '0';

		LPSResetPin : out std_ulogic := '0';
		LPSClockPin : out std_ulogic := '0';

		ChargedLEDPin : out std_ulogic := '0';
		RadioLEDPin : out std_ulogic := '0';
		TestLEDsPin : out std_ulogic_vector(2 downto 0) := (others => '0');

		EncodersPin : in encoders_pin_t;

		MotorsPhasesPPin : out motors_phases_pin_t := (others => (others => '1'));
		MotorsPhasesNPin : out motors_phases_pin_t := (others => (others => '0'));

		HallsPin : in halls_pin_t;

		VirtualGroundPin : out std_ulogic_vector(0 to 1) := (others => '0'));
end entity Top;

architecture TestStaticLEDs of Top is
begin
	ChargedLEDPin <= '1';
	RadioLEDPin <= '1';
	TestLEDsPin <= (others => '1');
end architecture TestStaticLEDs;

architecture TestBasicClock of Top is
begin
	process(OscillatorPin(0)) is
		variable Ticks : natural range 0 to 7999999 := 0;
		variable Seconds : unsigned(4 downto 0) := to_unsigned(0, 5);
	begin
		if rising_edge(OscillatorPin(0)) then
			if Ticks = 7999999 then
				Ticks := 0;
				Seconds := Seconds + 1;
			else
				Ticks := Ticks + 1;
			end if;
		end if;

		ChargedLEDPin <= Seconds(0);
		RadioLEDPin <= Seconds(1);
		TestLEDsPin(2 downto 0) <= std_ulogic_vector(Seconds(4 downto 2));
	end process;
end architecture TestBasicClock;

architecture TestFullClock of Top is
	signal Clocks : clocks_t;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	process(Clocks.Clock40MHz) is
		subtype ticks_t is natural range 0 to 3999999;
		variable Ticks : ticks_t := 0;
		variable Seconds : unsigned(4 downto 0) := to_unsigned(0, 5);
	begin
		if rising_edge(Clocks.Clock40MHz) then
			if Ticks = ticks_t'high then
				Ticks := 0;
				Seconds := Seconds + 1;
			else
				Ticks := Ticks + 1;
			end if;
		end if;

		ChargedLEDPin <= Seconds(0);
		RadioLEDPin <= Seconds(1);
		TestLEDsPin(2 downto 0) <= std_ulogic_vector(Seconds(4 downto 2));
	end process;
end architecture TestFullClock;

architecture TestMRFBasic of Top is
	signal Clocks : clocks_t;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	MRFWakePin <= '0';
	MRFResetPin <= '1';

	process(Clocks.Clock4MHz) is
		subtype ticks_t is natural range 0 to 3;
		variable Ticks : ticks_t := 0;
		type state_t is (IDLE, CS_ASSERTED, CLK_RAISED, DONE);
		variable State : state_t := IDLE;
		-- Reset value of ACKTMOUT (0x12) should be 0b00111001 (0x39)
		variable DataOut : std_ulogic_vector(15 downto 0) := X"2400";
		variable DataIn : std_ulogic_vector(15 downto 0) := X"0000";
		variable Count : natural range 0 to 15 := 15;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if Ticks = ticks_t'high then
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
			Ticks := (Ticks + 1) mod (ticks_t'high + 1);
		end if;
		FlashMRFChickerMOSIPin <= DataOut(15);
	end process;
end architecture TestMRFBasic;

architecture TestADC of Top is
	signal Clocks : clocks_t;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	process(Clocks.Clock4MHz) is
		subtype ticks_t is natural range 0 to 3;
		variable Ticks : ticks_t := 0;
		type state_t is (IDLE, ACTIVE);
		variable State : state_t := IDLE;
		variable CSOut : std_ulogic_vector(17 downto 0) := "100000000000000000";
		variable DataOut : std_ulogic_vector(17 downto 0) := "111011000000000000";
		variable DataIn : std_ulogic_vector(9 downto 0);
		variable Snapshot : std_ulogic_vector(9 downto 0);
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if Ticks = 0 then
				if CSOut(17) = '1' then
					Snapshot := DataIn;
				end if;
				DataIn := DataIn(8 downto 0) & ADCMISOPin;
			elsif Ticks = 2 then
				CSOut := CSOut(16 downto 0) & CSOut(17);
				DataOut := DataOut(16 downto 0) & DataOut(17);
			end if;
			Ticks := (Ticks + 1) mod (ticks_t'high + 1);
		end if;

		if Ticks = 1 or Ticks = 2 then
			ADCClockPin <= '1';
		else
			ADCClockPin <= '0';
		end if;

		ADCCSPin <= CSOut(17);
		ADCMOSIPin <= DataOut(17);
		TestLEDsPin(2) <= Snapshot(9);
		TestLEDsPin(1) <= Snapshot(8);
		TestLEDsPIn(0) <= Snapshot(7);
		RadioLEDPin <= Snapshot(6);
		ChargedLEDPin <= Snapshot(5);
	end process;
end architecture TestADC;

architecture TestNavre of Top is
	signal Clocks : clocks_t;
	signal LEDs : std_ulogic_vector(4 downto 0);
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	WrapperInstance : entity work.NavreWrapper(Arch)
	port map(
		Clock => Clocks.Clock40MHz,
		LEDs => LEDs);

	TestLEDsPin(2) <= LEDs(4);
	TestLEDsPin(1) <= LEDs(3);
	TestLEDsPin(0) <= LEDs(2);
	RadioLEDPin <= LEDs(1);
	ChargedLEDPin <= LEDs(0);
end architecture TestNavre;
