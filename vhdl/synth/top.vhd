library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity Top is
	port(
		OscillatorPin : in std_ulogic;
		DCMResetPin : in std_ulogic;
		DCMLockedPin : out std_ulogic;
		ResetPin : in std_ulogic;
		ParbusDataPin : inout std_ulogic_vector(7 downto 0);
		ParbusReadPin : in std_ulogic;
		ParbusWritePin : in std_ulogic;
		LEDPin : out std_ulogic_vector(3 downto 0);
		EncoderPin1 : in std_ulogic_vector(0 to 1);
		EncoderPin2 : in std_ulogic_vector(0 to 1);
		EncoderPin3 : in std_ulogic_vector(0 to 1);
		EncoderPin4 : in std_ulogic_vector(0 to 1);
		MotorDriveNPin1 : out std_ulogic_vector(1 to 3);
		MotorDriveNPin2 : out std_ulogic_vector(1 to 3);
		MotorDriveNPin3 : out std_ulogic_vector(1 to 3);
		MotorDriveNPin4 : out std_ulogic_vector(1 to 3);
		MotorDriveNPin5 : out std_ulogic_vector(1 to 3);
		MotorDrivePPin1 : out std_ulogic_vector(1 to 3);
		MotorDrivePPin2 : out std_ulogic_vector(1 to 3);
		MotorDrivePPin3 : out std_ulogic_vector(1 to 3);
		MotorDrivePPin4 : out std_ulogic_vector(1 to 3);
		MotorDrivePPin5 : out std_ulogic_vector(1 to 3);
		HallPin1 : in std_ulogic_vector(1 to 3);
		HallPin2 : in std_ulogic_vector(1 to 3);
		HallPin3 : in std_ulogic_vector(1 to 3);
		HallPin4 : in std_ulogic_vector(1 to 3);
		HallPin5 : in std_ulogic_vector(1 to 3);
		ChickerMISOPin : in std_ulogic;
		ChickerCLKPin : out std_ulogic;
		ChickerCSPin : out std_ulogic;
		ChickerChargePin : out std_ulogic;
		KickPin : out std_ulogic;
		ChipPin : out std_ulogic;
		ChickerPresentPin : in std_ulogic;
		VirtualGroundPin : out std_ulogic_vector(0 to 1);
		VirtualVDDPin : out std_ulogic_vector(0 to 3));
end entity Top;

architecture Behavioural of Top is
	type halls is array(1 to 5) of types.hall;
	signal ClockLow : std_ulogic;
	signal ClockMid : std_ulogic;
	signal ClockHigh : std_ulogic;
	signal Reset : boolean;
	signal ParbusDataIn : std_ulogic_vector(7 downto 0);
	signal ParbusDataOut : std_ulogic_vector(7 downto 0);
	signal ParbusRead : boolean;
	signal ParbusWrite : boolean;
	signal LED : std_ulogic_vector(3 downto 0);
	signal Hall : halls;
	signal AllLow : boolean;
	signal AllHigh : boolean;
	signal Phase : types.motor_phase3;
	signal Power : natural range 0 to 255;
	signal ADCLevel : natural range 0 to 4095;
	signal ChickerMISO : boolean;
	signal ChickerCLK : boolean;
	signal ChickerCS : boolean;
	signal Foo : std_ulogic;
	signal Bar : std_ulogic;
begin
	ClockGen: entity work.ClockGen(Behavioural)
	port map(
		Oscillator => OscillatorPin,
		Reset => DCMResetPin,
		Locked => DCMLockedPin,
		ClockLow => ClockLow,
		ClockMid => ClockMid,
		ClockHigh => ClockHigh);

	process(ClockHigh) is
	begin
		if rising_edge(ClockHigh) then
			Reset <= ResetPin = '1';
			ParbusDataIn <= ParbusDataPin;
			ParbusRead <= ParbusReadPin = '1';
			ParbusWrite <= ParbusWritePin = '1';
			ChickerMISO <= ChickerMISOPin = '1';
		end if;
	end process;

	process(ParbusRead, ParbusDataOut) is
	begin
		if ParbusRead then
			ParbusDataPin <= ParbusDataOut;
		else
			ParbusDataPin <= (others => 'Z');
		end if;
	end process;

--	process(ClockHigh) is
--		subtype CounterType is natural range 0 to 255;
--		variable Counter : CounterType;
--		subtype MicroCounterType is natural range 0 to work.clock.HighFrequency / 4;
--		variable MicroCounter : MicroCounterType;
--	begin
--		if rising_edge(ClockHigh) then
--			if Reset then
--				Counter := 0;
--				MicroCounter := 0;
--			elsif MicroCounter = MicroCounterType'high then
--				MicroCounter := 0;
--				Counter := (Counter + 1) mod (CounterType'high + 1);
--			else
--				MicroCounter := MicroCounter + 1;
--			end if;
--		end if;
--
--		ParbusDataOut <= std_ulogic_vector(to_unsigned(Counter, 8));
--		LED(3 downto 0) <= std_ulogic_vector(to_unsigned(Counter / 16, 4));
--	end process;

--	LED(3 downto 0) <= std_ulogic_vector(to_unsigned(ADCLevel / 256, 4));
	ParbusDataOut <= std_ulogic_vector(to_unsigned(ADCLevel / 16, 8));
	ChickerCLKPin <= '1' when ChickerCLK else '0';
	ChickerCSPin <= '0' when ChickerCS else '1';

	GenerateLEDs: for I in 0 to 3 generate
		LEDPin(I) <= LED(I);
	end generate;

	GenerateHalls: for I in 1 to 3 generate
		Hall(1)(I) <= HallPin1(I) = '1';
		Hall(2)(I) <= HallPin2(I) = '1';
		Hall(3)(I) <= HallPin3(I) = '1';
		Hall(4)(I) <= HallPin4(I) = '1';
		Hall(5)(I) <= HallPin5(I) = '1';
	end generate;

	ADC: entity work.ADC(Behavioural)
	port map(
		Clock => ClockLow,
		Reset => Reset,
		MISO => ChickerMISO,
		CLK => ChickerCLK,
		CS => ChickerCS,
		Level => ADCLevel);

	Bar <= '1' when Reset else '0';

--	BoostController: entity work.BoostController(Behavioural)
--	port map(
--		Charge => '1',
--		Reset => Bar,
--		CapVoltage => ADCLevel,
--		BattVoltage => natural(14.5 * 1023.0),
--		Switch => Foo,
--		Fault => open,
--		Activity => open,
--		Clock => ClockLow);
--	
--	process(ClockLow) is
--		subtype CounterType is natural range 0 to work.clock.LowFrequency / 2 - 1;
--		variable Counter : CounterType;
--	begin
--		if rising_edge(ClockLow) then
--			if Reset then
--				Counter := 0;
--				LED(1) <= '0';
--			elsif Counter < CounterType'high then
--				Counter := Counter + 1;
--				LED(1) <= '1';
--			end if;
--		end if;
--
--		if Counter < 50 or Counter = CounterType'high then
--			LED(0) <= '1';
--			ChickerChargePin <= '0';
--		else
--			LED(0) <= '0';
--			ChickerChargePin <= Foo;
--		end if;
--	end process;

--	Foo: for I in 1 to 3 generate
--		LED(I - 1) <= '1' when Hall(1)(I) else '0';
--	end generate;
--
--	Motor: entity work.Motor(Behavioural)
--	generic map(
--		PWMMax => 255)
--	port map(
--		PWMClock => ClockMid,
--		ClockHigh => ClockHigh,
--		Reset => Reset,
--		Power => Power,
--		Reverse => false,
--		HallSensor => Hall(1),
--		AllLow => AllLow,
--		AllHigh => AllHigh,
--		Phase => Phase);
--
--	process(ClockLow) is
--		subtype CounterType is natural range 0 to work.clock.LowFrequency / 20;
--		variable Counter : CounterType;
--	begin
--		if rising_edge(ClockLow) then
--			if Reset then
--				Power <= 0;
--				Counter := 0;
--			elsif Counter = CounterType'high then
--				if Power < 255 then
--					Power <= Power + 1;
--				end if;
--				Counter := 0;
--			else
--				Counter := Counter + 1;
--			end if;
--		end if;
--	end process;

	MotorDriveNPin1 <= (others => '1');
	MotorDriveNPin2 <= (others => '1');
	MotorDriveNPin3 <= (others => '1');
	MotorDriveNPin4 <= (others => '1');
	MotorDriveNPin5 <= (others => '1');
	MotorDrivePPin1 <= (others => '0');
	MotorDrivePPin2 <= (others => '0');
	MotorDrivePPin3 <= (others => '0');
	MotorDrivePPin4 <= (others => '0');
	MotorDrivePPin5 <= (others => '0');
	KickPin <= '0';
	ChipPin <= '0';

	VirtualGroundPin <= (others => '0');
	VirtualVDDPin <= (others => '1');
end architecture Behavioural;
