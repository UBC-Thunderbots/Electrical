library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity Main is
	port(
		-- The 50MHz canned oscillator.
		Oscillator : in std_logic;

		-- Serial lines to and from the XBee.
		XBeeRX : in std_logic;
		XBeeTX : out std_logic;

		-- SPI lines to and from the PIC.
		AppSS : in std_logic;
		AppOut : out std_logic;
		AppIn : in std_logic;
		AppClk : in std_logic;

		-- Control lines to and from the motor controllers.
		Brake : out std_logic;
		PWM1 : out std_logic;
		PWM2 : out std_logic;
		PWM3 : out std_logic;
		PWM4 : out std_logic;
		PWM5 : out std_logic;
		Dir1 : out std_logic;
		Dir2 : out std_logic;
		Dir3 : out std_logic;
		Dir4 : out std_logic;
		Dir5 : out std_logic;
		Fault1 : in std_logic;
		Fault2 : in std_logic;
		Fault3 : in std_logic;
		Fault4 : in std_logic;
		Fault5 : in std_logic;
		DSense : in std_logic;

		-- Control lines to the chicker.
		Kick : out std_logic;
		Chip : out std_logic;
		Charge : out std_logic
	);
end entity Main;

architecture Behavioural of Main is
	component ClockGen is
		port(
			Oscillator : in std_logic;
			Clock : out std_logic
		);
	end component;

	component PWM is
		generic(
			Width : positive
		);
		port(
			Clock : in std_logic;
			DutyCycle : in unsigned(9 downto 0);
			PWM : out std_logic
		);
	end component;

	component ADC is
		port(
			Clock : in std_logic;
			SPICK : in std_logic;
			SPIDT : in std_logic;
			SPISS : in std_logic;
			Channel0 : out unsigned(9 downto 0);
			Channel1 : out unsigned(9 downto 0);
			Channel2 : out unsigned(9 downto 0);
			Channel3 : out unsigned(9 downto 0);
			Channel4 : out unsigned(9 downto 0);
			Channel5 : out unsigned(9 downto 0);
			Channel6 : out unsigned(9 downto 0);
			Channel7 : out unsigned(9 downto 0);
			Channel8 : out unsigned(9 downto 0);
			Channel9 : out unsigned(9 downto 0);
			Channel10 : out unsigned(9 downto 0);
			Channel11 : out unsigned(9 downto 0);
			Channel12 : out unsigned(9 downto 0);
			Good : out std_logic
		);
	end component;

	-- The clock generated by the DCM from Oscillator.
	signal Clock : std_logic;

	-- Latched versions of all input pins other than Oscillator.
	signal XBeeRXL : std_logic := '1';
	signal AppSSL : std_logic := '1';
	signal AppInL : std_logic := '0';
	signal AppClkL : std_logic := '0';
	signal Fault1L : std_logic := '1';
	signal Fault2L : std_logic := '1';
	signal Fault3L : std_logic := '1';
	signal Fault4L : std_logic := '1';
	signal Fault5L : std_logic := '1';

	-- Tristate controls for the Dir* pins.
	signal Dir1T : std_logic := '0';
	signal Dir2T : std_logic := '0';
	signal Dir3T : std_logic := '0';
	signal Dir4T : std_logic := '0';
	signal Dir5T : std_logic := '0';

	-- The duty cycle of the test PWM generator.
	signal DutyCycle : unsigned(9 downto 0);
begin
	-- Pass the Oscillator pin through a DCM to get Clock.
	ClockGen_Instance : ClockGen
	port map(
		Oscillator => Oscillator,
		Clock => Clock
	);

	-- Latch the inputs into the local signals.
	process(Clock)
	begin
		if rising_edge(Clock) then
			XBeeRXL <= XBeeRX;
			AppSSL <= AppSS;
			AppInL <= AppIn;
			AppClkL <= AppClk;
			Fault1L <= Fault1;
			Fault2L <= Fault2;
			Fault3L <= Fault3;
			Fault4L <= Fault4;
			Fault5L <= Fault5;
		end if;
	end process;

	-- A test PWM generator that follows analogue input channel 0.
	TestPWM : PWM
	generic map(
		Width => 10
	)
	port map(
		Clock => Clock,
		DutyCycle => DutyCycle,
		PWM => PWM1
	);

	-- Tristate drivers for the Dir* pins.
	Dir1Driver : OBUFT
	port map(
		I => '0',
		T => Dir1T,
		O => Dir1
	);
	Dir2Driver : OBUFT
	port map(
		I => '0',
		T => Dir2T,
		O => Dir2
	);
	Dir3Driver : OBUFT
	port map(
		I => '0',
		T => Dir3T,
		O => Dir3
	);
	Dir4Driver : OBUFT
	port map(
		I => '0',
		T => Dir4T,
		O => Dir4
	);
	Dir5Driver : OBUFT
	port map(
		I => '0',
		T => Dir5T,
		O => Dir5
	);
	PWM2 <= '1';
	PWM3 <= '1';
	PWM4 <= '1';
	PWM5 <= '1';
	Dir1T <= '0';
	Dir2T <= '0';
	Dir3T <= '0';
	Dir4T <= '0';
	Dir5T <= '0';

	-- The SPI receiver for the analogue to digital converters.
	ADC_Instance : ADC
	port map(
		Clock => Clock,
		SPICK => AppClkL,
		SPIDT => AppInL,
		SPISS => AppSSL,
		Channel0 => DutyCycle,
		Channel1 => open,
		Channel2 => open,
		Channel3 => open,
		Channel4 => open,
		Channel5 => open,
		Channel6 => open,
		Channel7 => open,
		Channel8 => open,
		Channel9 => open,
		Channel10 => open,
		Channel11 => open,
		Channel12 => open,
		Good => open
	);

	--  The brake line activates when the PWM duty cycle is small.
	Brake <= '1' when DutyCycle < to_unsigned(10, 10) else '0';

	XBeeTX <= '1';
	AppOut <= '0';

	Kick <= '1';
	Chip <= '1';
	Charge <= '1';
end architecture Behavioural;
