library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity ClockGen is
	port(
		Oscillator : in std_logic;
		Clock : out std_logic
	);
end entity ClockGen;

architecture Behavioural of ClockGen is
	signal OscillatorBuffered : std_logic;
	signal DCMOut : std_logic;
	signal BufGOut : std_logic;
begin
	IBufferG : IBufG
	port map(
		I => Oscillator,
		O => OscillatorBuffered
	);

	DCM : DCM_SP
	generic map(
		CLKIN_PERIOD => 20.0,
		CLKDV_DIVIDE => 2.0,
		STARTUP_WAIT => TRUE
	)
	port map(
		CLKIN => OscillatorBuffered,
		CLKFB => BufGOut,
		RST => '0',
		PSEN => '0',
		CLK0 => DCMOut
	);

	BufferG : BufG
	port map(
		I => DCMOut,
		O => BufGOut
	);

	Clock <= BufGOut;
end architecture Behavioural;
