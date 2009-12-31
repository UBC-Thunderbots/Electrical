library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main is
	port(
		Oscillator : in std_logic;
		XBeeRX : in std_logic;
		XBeeTX : out std_logic;
		AppSS : in std_logic;
		AppOut : out std_logic;
		AppIn : in std_logic;
		AppClk : in std_logic;
		GPIO1 : out std_logic;
		GPIO2 : out std_logic;
		GPIO3 : out std_logic;
		GPIO4 : out std_logic;
		GPIO5 : out std_logic;
		GPIO6 : out std_logic;
		GPIO7 : out std_logic;
		GPIO8 : out std_logic;
		GPIO9 : out std_logic;
		GPIO10 : out std_logic;
		GPIO11 : out std_logic;
		GPIO12 : out std_logic;
		GPIO13 : out std_logic;
		GPIO14 : out std_logic;
		GPIO15 : out std_logic;
		GPIO16 : out std_logic;
		GPIO17 : out std_logic;
		GPIO18 : out std_logic;
		GPIO19 : out std_logic;
		GPIO20 : out std_logic;
		GPIO21 : out std_logic;
		GPIO22 : out std_logic;
		GPIO23 : out std_logic;
		GPIO24 : out std_logic;
		GPIO25 : out std_logic;
		GPIO26 : out std_logic;
		GPIO27 : out std_logic;
		GPIO28 : out std_logic;
		GPIO29 : out std_logic;
		GPIO30 : out std_logic;
		GPIO31 : out std_logic;
		GPIO32 : out std_logic;
		GPIO33 : out std_logic;
		GPIO34 : out std_logic;
		GPIO35 : out std_logic;
		GPIO36 : out std_logic;
		GPIO37 : out std_logic;
		GPIO38 : out std_logic
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
	
	signal Clock : std_logic;
	signal XBeeRXL : std_logic := '1';
	signal AppSSL : std_logic := '1';
	signal AppInL : std_logic := '0';
	signal AppClkL : std_logic := '0';
	signal DutyCycle : unsigned(9 downto 0);
begin
	ClockGen_Instance : ClockGen
	port map(
		Oscillator => Oscillator,
		Clock => Clock
	);

	process(Clock)
	begin
		if rising_edge(Clock) then
			XBeeRXL <= XBeeRX;
			AppSSL <= AppSS;
			AppInL <= AppIn;
			AppClkL <= AppClk;
		end if;
	end process;

	testpwm : PWM
	generic map(
		Width => 10
	)
	port map(
		Clock => Clock,
		DutyCycle => DutyCycle,
		PWM => GPIO3
	);
	
	testadc : ADC
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
	
	GPIO1 <= '1' when DutyCycle < to_unsigned(10, 10) else '0';
	GPIO13 <= '0';
	GPIO38 <= DutyCycle(9);
	
	XBEETX <= '1';
	APPOUT <= '0';
	GPIO2 <= '0';
	GPIO4 <= '0';
	GPIO5 <= '0';
	GPIO6 <= '0';
	GPIO7 <= '0';
	GPIO8 <= '0';
	GPIO9 <= '0';
	GPIO10 <= '0';
	GPIO11 <= '0';
	GPIO12 <= '0';
	GPIO14 <= '0';
	GPIO15 <= '0';
	GPIO16 <= '0';
	GPIO17 <= '0';
	GPIO18 <= '0';
	GPIO19 <= '0';
	GPIO20 <= '0';
	GPIO21 <= '0';
	GPIO22 <= '0';
	GPIO23 <= '0';
	GPIO24 <= '0';
	GPIO25 <= '0';
	GPIO26 <= '0';
	GPIO27 <= '0';
	GPIO28 <= '0';
	GPIO29 <= '0';
	GPIO30 <= '0';
	GPIO31 <= '0';
	GPIO32 <= '0';
	GPIO33 <= '0';
	GPIO34 <= '0';
	GPIO35 <= '0';
	GPIO36 <= '0';
	GPIO37 <= '0';
end architecture Behavioural;
