library ieee;
library unisim;

use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use work.types.all;

entity ICAPWrapper is
	port(
		HostClock : in std_ulogic;
		ICAPClock : in std_ulogic;
		Data : in std_ulogic_vector(15 downto 0);
		Strobe : in boolean;
		Busy : out boolean := false);
end entity ICAPWrapper;

architecture Arch of ICAPWrapper is
	signal StrobeX : boolean := false;
	signal StrobeY : boolean := false;
	signal StrobeZ : boolean := false;
	signal ClockDisable : boolean := false;
begin
	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			if Strobe then
				StrobeX <= not StrobeZ;
			end if;
		end if;
	end process;

	process(ICAPClock) is
	begin
		if rising_edge(ICAPClock) then
			StrobeY <= StrobeX;
			StrobeZ <= StrobeY;
		end if;
	end process;

	ClockDisable <= not (StrobeY /= StrobeZ);

	ICAP : ICAP_SPARTAN6
	port map(
		CLK => ICAPClock,
		CE => to_stdulogic(ClockDisable),
		WRITE => '0',
		I => std_logic_vector(Data),
		O => open,
		BUSY => open);

	Busy <= (StrobeX /= StrobeY) or (StrobeY /= StrobeZ);
end architecture Arch;
