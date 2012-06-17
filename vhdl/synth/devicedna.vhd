library ieee;
library unisim;

use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use work.clock.all;

entity DeviceDNA is
	port(
		signal Clocks : in clocks_t;
		signal Value : out std_ulogic_vector(56 downto 0));
end entity;

architecture Arch of DeviceDNA is
	signal Clock2MHz : std_ulogic := '0';
	type state_t is (LOAD, SHIFT);
	signal State : state_t := LOAD;
	signal Shifter : std_ulogic_vector(56 downto 0) := (others => '0');
	signal DataOut : std_ulogic;
	signal Read : std_ulogic := '1';
begin
	Value <= Shifter;

	--max internal clock 2 Mhz
	process(Clocks.Clock4Mhz) is
	begin
		if rising_edge(Clocks.Clock4Mhz) then
			Clock2MHz <= not Clock2MHz;
		end if;
	end process;

	process(Clock2MHz) is
	begin
		if rising_edge(Clock2MHz) then
			if Read = '1' then
				Read <= '0';
			elsif Shifter(56) /= '1' then
				Shifter <= Shifter(55 downto 0) & DataOut;
			end if;
		end if;
	end process;

	DNAPort : DNA_PORT
	port map(
		DOUT => DataOut,
		DIN => '0',
		READ => Read,
		SHIFT => '1',
		CLK => Clock2MHz);
end architecture;
