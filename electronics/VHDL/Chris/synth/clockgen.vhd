library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity ClockGen is
	port(
		Oscillator : in std_ulogic;
		Clock50M : out std_ulogic;
		Clock10M : out std_ulogic;
		Clock1M : out std_ulogic
	);
end entity ClockGen;

architecture Behavioural of ClockGen is
	signal OscillatorBuffered : std_ulogic;
	signal DCM1Clk50M : std_ulogic;
	signal DCM1Clk10M : std_ulogic;
	signal DCM1Locked : std_ulogic;
	signal DCM2Clk10M : std_ulogic;
	signal DCM2Clk1M : std_ulogic;
	signal ResetDCM2 : std_ulogic_vector(7 downto 0) := X"FF";
	signal BufGOut50M : std_ulogic;
	signal BufGOut10M1 : std_ulogic;
	signal BufGOut10M2 : std_ulogic;
	signal BufGOut1M : std_ulogic;
begin
	IBufferG : IBufG
	port map(
		I => Oscillator,
		O => OscillatorBuffered
	);

	DCM1 : DCM_SP
	generic map(
		CLKIN_PERIOD => 20.0,
		CLKDV_DIVIDE => 5.0,
		STARTUP_WAIT => true
	)
	port map(
		CLKIN => OscillatorBuffered,
		CLKFB => BufGOut50M,
		RST => '0',
		PSEN => '0',
		CLK0 => DCM1Clk50M,
		CLKDV => DCM1Clk10M,
		LOCKED => DCM1Locked
	);

	BufG50M : BufG
	port map(
		I => DCM1Clk50M,
		O => BufGOut50M
	);

	BufG10M1 : BufG
	port map(
		I => DCM1Clk10M,
		O => BufGOut10M1
	);

	process(BufGOut10M1)
	begin
		if rising_edge(BufGOut10M1) then
			if DCM1Locked = '1' then
				ResetDCM2 <= '0' & ResetDCM2(6 downto 0);
			end if;
		end if;
	end process;

	DCM2 : DCM_SP
	generic map(
		CLKIN_PERIOD => 100.0,
		CLKDV_DIVIDE => 10.0,
		STARTUP_WAIT => true
	)
	port map(
		CLKIN => BufGOut10M1,
		CLKFB => BufGOut10M2,
		RST => ResetDCM2(0),
		PSEN => '0',
		CLK0 => DCM2Clk10M,
		CLKDV => DCM2Clk1M
	);

	BufG10M2 : BufG
	port map(
		I => DCM2Clk10M,
		O => BufGOut10M2
	);

	BufG1M : BufG
	port map(
		I => DCM2Clk1M,
		O => BufGOut1M
	);

	Clock50M <= BufGOut50M;
	Clock10M <= BufGOut10M1;
	Clock1M <= BufGOut1M;
end architecture Behavioural;
