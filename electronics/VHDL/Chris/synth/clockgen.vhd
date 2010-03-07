library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity ClockGen is
	port(
		PICOscillator : in std_ulogic;
		Clock100 : out std_ulogic;
		Clock10 : out std_ulogic;
		Clock1 : out std_ulogic
	);
end entity ClockGen;

--
-- This entity generates clocks for the FPGA from an input 2MHz clock provided
-- by the PIC. The buffers and DCMs are arranged in the following layout:
--
--
--                                                     /------------------------------------------\
--                                                     |                                          |
--                                                     |  /------------------------\              |
--                                                     |  |                        |  10MHz   |\  |
--                                                     \--| CLKFB             CLK0 |----------| +-+--[]
--                                                        |                        |          |/
--                 /-----------------------\              |                        |
--    2MHz   |\    |                       |  10MHz  |\   |                        |  100MHz  |\
-- []--------| +---| CLKIN      CLKFX (5×) |---------| +--| CLKIN      CLKFX (10×) |----------| +----[]
--           |/    |                       |         |/   |                        |          |/
--         IBufG   |                       |              |                        |
--                 |                LOCKED |--\   |\      |                        |   1MHz   |\
--                 |                       |   \--| O-----| RST        CLKDV (÷10) |----------| +----[]
--                 \-----------------------/      |/      |                        |          |/
--                                                        \------------------------/
--
architecture Behavioural of ClockGen is
	signal PICOscillatorBuffered : std_ulogic;

	signal DCM1Locked : std_ulogic;
	signal DCM1Clock10 : std_ulogic;
	signal DCM1Clock10Buffered : std_ulogic;

	signal DCM2Clock1 : std_ulogic;
	signal DCM2Clock1Buffered : std_ulogic;
	signal DCM2Clock10 : std_ulogic;
	signal DCM2Clock10Buffered : std_ulogic;
	signal DCM2Clock100 : std_ulogic;
	signal DCM2Clock100Buffered : std_ulogic;
begin
	IBufferG : IBufG
	port map(
		I => PICOscillator,
		O => PICOscillatorBuffered
	);

	DCM1 : DCM_SP
	generic map(
		CLKIN_PERIOD => 500.0,
		CLK_FEEDBACK => "NONE",
		CLKFX_MULTIPLY => 5,
		CLKFX_DIVIDE => 1,
		STARTUP_WAIT => true
	)
	port map(
		CLKIN => PICOscillatorBuffered,
		RST => '0',
		PSEN => '0',
		CLKFX => DCM1Clock10,
		LOCKED => DCM1Locked
	);

	DCM2 : DCM_SP
	generic map(
		CLKIN_PERIOD => 100.0,
		CLKDV_DIVIDE => 10.0,
		CLKFX_MULTIPLY => 10,
		CLKFX_DIVIDE => 1,
		STARTUP_WAIT => true
	)
	port map(
		CLKIN => DCM1Clock10Buffered,
		CLKFB => DCM2Clock10Buffered,
		RST => not DCM1Locked,
		PSEN => '0',
		CLK0 => DCM2Clock10,
		CLKDV => DCM2Clock1,
		CLKFX => DCM2Clock100
	);

	BufG1 : BufG
	port map(
		I => DCM1Clock10,
		O => DCM1Clock10Buffered
	);

	BufG2 : BufG
	port map(
		I => DCM2Clock1,
		O => DCM2Clock1Buffered
	);

	BufG3 : BufG
	port map(
		I => DCM2Clock10,
		O => DCM2Clock10Buffered
	);

	BufG4 : BufG
	port map(
		I => DCM2Clock100,
		O => DCM2Clock100Buffered
	);

	Clock1 <= DCM2Clock1Buffered;
	Clock10 <= DCM2Clock10Buffered;
	Clock100 <= DCM2Clock100Buffered;
end architecture Behavioural;
