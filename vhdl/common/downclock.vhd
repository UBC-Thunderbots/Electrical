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
	process(HighClock) is
	begin
		if rising_edge(HighClock) then
			if StrobeIn then
				DiffIn <= not DiffOut;
			end if;
		end if;
	end process;

	process(LowClock) is
	begin
		if rising_edge(LowClock) then
			StrobeOut <= DiffIn /= DiffOut;
			DiffOut <= DiffIn;
		end if;
	end process;
end architecture Arch;
