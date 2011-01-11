library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity ClockGen is
	port(
		Oscillator : in std_ulogic;
		Reset : in std_ulogic;
		Locked : out std_ulogic;
		Clock500k : out std_ulogic;
		Clock8M : out std_ulogic;
		Clock256M : out std_ulogic);
end entity ClockGen;

--
-- This entity generates clocks for the FPGA from an input 8MHz clock provided by the packaged oscillator.
-- The buffers and DCMs are arranged in the following layout:
--
--
--     /------------------------------------------\
--     |                                          |
--     |  /------------------------\              |
--     |  |                        |  8MHz    |\  |
--     \--| CLKFB             CLK0 |----------| +-+--[]
--        |                        |          |/
--        |                        |
--   |\   |                        |  256Mhz  |\
-- --| +--| CLKIN      CLKFX (32×) |----------| +----[]
--   |/   |                        |          |/
--        |                        |
--        |                        |  500kHz  |\
-- -------| RST        CLKDV (÷32) |----------| +----[]
--        |                        |          |/
--        \------------------------/
--
architecture Behavioural of ClockGen is
	signal OscillatorBuffered : std_ulogic;
	signal DCMClock0 : std_ulogic;
	signal DCMClock0Buffered : std_ulogic;
	signal DCMClockDV : std_ulogic;
	signal DCMClockFX : std_ulogic;
begin
	IBufferG : IBufG
	port map(
		I => Oscillator,
		O => OscillatorBuffered
	);

	DCM : DCM_SP
	generic map(
		CLKIN_PERIOD => 125.0,
		CLKDV_DIVIDE => 16.0,
		CLKFX_MULTIPLY => 32,
		CLKFX_DIVIDE => 1,
		STARTUP_WAIT => false)
	port map(
		CLKIN => OscillatorBuffered,
		CLKFB => DCMClock0Buffered,
		RST => Reset,
		PSEN => '0',
		CLK0 => DCMClock0,
		CLKDV => DCMClockDV,
		CLKFX => DCMClockFX,
		LOCKED => Locked);

	BufG0 : BufG
	port map(
		I => DCMClock0,
		O => DCMClock0Buffered);

	BufGDV : BufG
	port map(
		I => DCMClockDV,
		O => Clock500k);

	BufGFX : BufG
	port map(
		I => DCMClockFX,
		O => Clock256M);

	Clock8M <= DCMClock0Buffered;
end architecture Behavioural;
