library ieee;
use ieee.std_logic_1164.all;

entity SyncDownStrobe is
	port(
		ClockHigh : in std_ulogic;
		ClockLow : in std_ulogic;
		Input : in boolean;
		Output : out boolean := false);
end entity SyncDownStrobe;

architecture Behavioural of SyncDownStrobe is
	signal LowPol : boolean := false;
	signal HighPol : boolean := false;
begin
	process(ClockHigh) is
	begin
		if rising_edge(ClockHigh) and Input then
			HighPol <= not HighPol;
		end if;
	end process;

	process(ClockLow) is
	begin
		if rising_edge(ClockLow) then
			Output <= LowPol /= HighPol;
			LowPol <= HighPol;
		end if;
	end process;
end architecture Behavioural;
