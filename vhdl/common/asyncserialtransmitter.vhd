library ieee;
use ieee.std_logic_1164.all;

entity AsyncSerialTransmitter is
	generic(
		BusClockDivider : natural);
	port(
		HostClock : in std_ulogic;
		BusClock : in std_ulogic;
		Data : in std_ulogic_vector(7 downto 0);
		Strobe : in boolean;
		Busy : out boolean;
		Output : out std_ulogic);
end entity AsyncSerialTransmitter;

architecture Arch of AsyncSerialTransmitter is
	signal StrobeX : boolean := false;
	signal StrobeY : boolean := false;
	signal Shifter : std_ulogic_vector(8 downto 0);
	signal Counter : natural range 0 to 11;
begin
	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			if Strobe then
				StrobeX <= not StrobeY;
			end if;
		end if;
	end process;

	process(BusClock) is
		subtype divider_t is natural range 0 to BusClockDivider - 1;
		variable Divider : divider_t := 0;
	begin
		if rising_edge(BusClock) then
			if Divider = divider_t'high then
				if StrobeX /= StrobeY then
					Shifter <= Data & '0';
					Counter <= 11;
					StrobeY <= StrobeX;
				else
					if Counter /= 0 then
						Counter <= Counter - 1;
					end if;
					Shifter <= '1' & Shifter(8 downto 1);
				end if;
			end if;
			Divider := (Divider + 1) mod (divider_t'high + 1);
		end if;
	end process;

	Output <= Shifter(0);
	Busy <= Strobe or StrobeX /= StrobeY or Counter /= 0;
end architecture Arch;
