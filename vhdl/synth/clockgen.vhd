library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.clock.all;

entity ClockGen is
	port(
		Oscillator : in std_ulogic;
		Reset : in std_ulogic;
		Locked : out std_ulogic;
		ClockLow : out std_ulogic;
		ClockMid : out std_ulogic;
		ClockHigh : out std_ulogic);
end entity ClockGen;

--
-- This entity generates clocks for the FPGA from an input 8MHz clock provided by the packaged oscillator.
-- The buffers and DCMs are arranged in the following layout:
--
--
--     /------------------------------------------\
--     |                                          |
--     |  /------------------------\              |
--     |  |                        |  8 MHz   |\  |
--     \--| CLKFB             CLK0 |----------| +-+--[]
--        |                        |          |/
--        |                        |
--   |\   |                        |          |\
-- --| +--| CLKIN            CLKFX |----------| +----[]
--   |/   |                        |          |/
--        |                        |
--        |                        |          |\
-- -------| RST              CLKDV |----------| +----[]
--        |                        |          |/
--        \------------------------/
--
architecture Behavioural of ClockGen is
	signal OscillatorBuffered : std_ulogic;
	signal DCMClock0 : std_ulogic;
	signal DCMClock0Buffered : std_ulogic;
	signal DCMClockDV : std_ulogic;
	signal DCMClockFX : std_ulogic;

	constant ClockLowDivider : natural := 8;
	constant ClockHighMultiplier : natural := 25;
	constant ClockHighDivider : natural := 16;

	-- These will evaluate to nonzero numbers if the math doesn't work out, which will fail the assignment to natural range 0 to 0.
	constant ClockLowCheck : natural range 0 to 0 := ClockMidFrequency - ClockLowFrequency * ClockLowDivider;
	constant ClockHighCheck : natural range 0 to 0 := ClockMidFrequency * ClockHighMultiplier - ClockHighFrequency * ClockHighDivider;
begin
	IBufferG : IBufG
	port map(
		I => Oscillator,
		O => OscillatorBuffered
	);

	DCM : DCM_SP
	generic map(
		CLKIN_PERIOD => 125.0,
		CLKDV_DIVIDE => real(ClockLowDivider),
		CLKFX_MULTIPLY => ClockHighMultiplier,
		CLKFX_DIVIDE => ClockHighDivider,
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
		O => ClockLow);

	BufGFX : BufG
	port map(
		I => DCMClockFX,
		O => ClockHigh);

	ClockMid <= DCMClock0Buffered;
end architecture Behavioural;
