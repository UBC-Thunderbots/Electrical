library ieee;
use ieee.std_logic_1164.all;

entity DownClock is
	port(
		HighClock : in std_ulogic;
		LowClock : in std_ulogic;
		StrobeIn : in boolean;
		StrobeOut : out boolean := false);
end entity DownClock;

architecture Arch of DownClock is
	signal DiffIn : boolean := false;
	signal DiffOut : boolean := false;
begin
	DiffIn <= not DiffOut when rising_edge(HighClock) and StrobeIn;
	StrobeOut <= DiffIn /= DiffOut when rising_edge(LowClock);
	DiffOut <= DiffIn when rising_edge(LowClock);
end architecture Arch;
