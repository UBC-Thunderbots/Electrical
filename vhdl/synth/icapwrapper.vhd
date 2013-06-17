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
	pure function ReverseBits(Input : std_ulogic_vector) return std_ulogic_vector is
		variable Result : std_ulogic_vector(Input'reverse_range);
	begin
		for I in Input'range loop
			Result(I) := Input(I);
		end loop;
		return Result;
	end function ReverseBits;

	signal DataReversed : std_ulogic_vector(15 downto 0);
	signal StrobeX : boolean := false;
	signal StrobeY : boolean := false;
	signal StrobeZ : boolean := false;
	signal ClockDisable : boolean := false;
begin
	DataReversed(15 downto 8) <= ReverseBits(Data(15 downto 8));
	DataReversed(7 downto 0) <= ReverseBits(Data(7 downto 0));

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
		I => std_logic_vector(DataReversed),
		O => open,
		BUSY => open);

	Busy <= (StrobeX /= StrobeY) or (StrobeY /= StrobeZ);
end architecture Arch;
