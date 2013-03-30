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
	signal Clock1MHz : std_ulogic := '0';
	signal Shifter : std_ulogic_vector(56 downto 0) := (others => '0');
	signal DataOut : std_ulogic;
	signal Read : std_ulogic := '1';
begin
	Value <= Shifter;

	-- The DNA port allows clocks up to 2 MHz.
	-- Run a clock at 1 MHz.
	process(Clocks.Clock4MHz) is
		variable Clock2MHz : boolean := false;
	begin
		if rising_edge(Clocks.Clock4Mhz) then
			if Clock2MHz then
				Clock1MHz <= not Clock1MHz;
			end if;
			Clock2MHz := not Clock2MHz;
		end if;
	end process;

	process(Clock1MHz) is
		type state_t is (RESET, LOAD, SHIFT);
		variable State : state_t := RESET;
		variable ResetShifter : std_ulogic_vector(15 downto 0) := X"FFFF";
	begin
		if rising_edge(Clock1MHz) then
			if ResetShifter(0) = '1' then
				State := RESET;
				Shifter <= (others => '0');
				Read <= '0';
				ResetShifter := '0' & ResetShifter(15 downto 1);
			elsif State = RESET then
				State := LOAD;
				Read <= '1';
			elsif State = LOAD then
				State := SHIFT;
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
		CLK => Clock1MHz);
end architecture;
