library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity ClockGen is
	port(
		Oscillator : in std_ulogic;
		Clock100 : out std_ulogic;
		Clock10 : out std_ulogic;
		Clock1 : out std_ulogic
	);
end entity ClockGen;

architecture Behavioural of ClockGen is
	signal OscillatorBuffered : std_ulogic;
	signal DCM1Clk100 : std_ulogic;
	signal DCM1Clk10 : std_ulogic;
	signal DCM1Locked : std_ulogic;
	signal DCM2Clk10 : std_ulogic;
	signal DCM2Clk1 : std_ulogic;
	signal BufGOut100 : std_ulogic;
	signal BufGOut10DCM1 : std_ulogic;
	signal BufGOut10DCM2 : std_ulogic;
	signal BufGOut1 : std_ulogic;
begin
	IBufferG : IBufG
	port map(
		I => Oscillator,
		O => OscillatorBuffered
	);

	DCM1 : DCM_SP
	generic map(
		CLKIN_PERIOD => 20.0,
		CLK_FEEDBACK => "2X",
		CLKDV_DIVIDE => 5.0,
		STARTUP_WAIT => true
	)
	port map(
		CLKIN => OscillatorBuffered,
		CLKFB => BufGOut100,
		RST => '0',
		PSEN => '0',
		CLK2X => DCM1Clk100,
		CLKDV => DCM1Clk10,
		LOCKED => DCM1Locked
	);

	BufG100 : BufG
	port map(
		I => DCM1Clk100,
		O => BufGOut100
	);

	BufG10DCM1 : BufG
	port map(
		I => DCM1Clk10,
		O => BufGOut10DCM1
	);

	DCM2 : DCM_SP
	generic map(
		CLKIN_PERIOD => 100.0,
		CLKDV_DIVIDE => 10.0,
		STARTUP_WAIT => true
	)
	port map(
		CLKIN => BufGOut10DCM1,
		CLKFB => BufGOut10DCM2,
		RST => not DCM1Locked,
		PSEN => '0',
		CLK0 => DCM2Clk10,
		CLKDV => DCM2Clk1
	);

	BufG10DCM2 : BufG
	port map(
		I => DCM2Clk10,
		O => BufGOut10DCM2
	);

	BufG1 : BufG
	port map(
		I => DCM2Clk1,
		O => BufGOut1
	);

	Clock100 <= BufGOut100;
	Clock10 <= BufGOut10DCM1;
	Clock1 <= BufGOut1;
end architecture Behavioural;
