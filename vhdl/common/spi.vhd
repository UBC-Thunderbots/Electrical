library ieee;
library unisim;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use work.types.all;

entity SPI is
	generic(
		MaxWidth : in positive);
	port(
		rst : in std_ulogic;
		HostClock : in std_ulogic;
		BusClock : in std_ulogic;
		Strobe : in boolean;
		Width : in positive range 1 to MaxWidth;
		WriteData : in std_ulogic_vector(MaxWidth - 1 downto 0);
		ReadData : buffer std_ulogic_vector(MaxWidth - 1 downto 0);
		Busy : buffer boolean;
		ClockOE : buffer boolean;
		MOSIPin : buffer std_ulogic;
		MISOPin : in std_ulogic);
end entity SPI;

architecture RTL of SPI is
	signal StrobeHost : boolean;
	signal StrobeBus : boolean;
	signal ShiftCount : natural range 0 to MaxWidth;
	signal MISOBuffer : std_ulogic;
begin
	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			if Strobe then
				StrobeHost <= not StrobeBus;
			end if;
		end if;
	end process;

	process(BusClock) is
	begin
		if falling_edge(BusClock) then
			if rst = '0' then
				ShiftCount <= 0;
			elsif StrobeHost /= StrobeBus then
				ShiftCount <= Width;
				ReadData <= WriteData;
			elsif ShiftCount /= 0 then
				ShiftCount <= ShiftCount - 1;
				ReadData <= ReadData(MaxWidth - 2 downto 0) & MISOBuffer;
			end if;
			StrobeBus <= StrobeHost;
		end if;
		if rising_edge(BusClock) then
			MISOBuffer <= MISOPin;
		end if;
	end process;

	ClockOE <= ShiftCount /= 0;
	Busy <= (ShiftCount /= 0) or (StrobeHost /= StrobeBus) or Strobe;
	MOSIPin <= ReadData(MaxWidth - 1);
end architecture RTL;
