library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity ClockGen is
	port(
		Oscillator : in std_ulogic;
		Clock : out std_ulogic
	);
end entity ClockGen;

architecture Behavioural of ClockGen is
	signal OscillatorBuffered : std_ulogic;
	signal DCMOut : std_ulogic;
	signal BufGOut : std_ulogic;
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
