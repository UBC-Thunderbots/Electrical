library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.clock.all;
use work.types.all;

entity ADS7866 is
	port(
		Clocks : in clocks_t;
		MISO : in std_ulogic;
		CLK : out std_ulogic := '1';
		CS : out std_ulogic := '1';
		Level : out capacitor_voltage_t := 0);
end entity ADS7866;

architecture Arch of ADS7866 is
begin
	process(Clocks.Clock4MHz) is
		subtype bit_count_t is natural range 0 to 14;
		variable CLKInternal : boolean := false;
		variable CSInternal : boolean := false;
		variable BitCount : bit_count_t := 0;
		variable Data : std_ulogic_vector(11 downto 0);
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if not CSInternal then
				CSInternal := true;
			elsif not CLKInternal then
				CLKInternal := true;
			else
				CLKInternal := false;
				Data := Data(10 downto 0) & MISO;
				if BitCount = bit_count_t'high then
					BitCount := 0;
					CSInternal := false;
					Level <= to_integer(unsigned(Data));
				else
					BitCount := BitCount + 1;
				end if;
			end if;
		end if;

		CLK <= to_stdulogic(not CLKInternal);
		CS <= to_stdulogic(not CSInternal);
	end process;
end architecture Arch;
