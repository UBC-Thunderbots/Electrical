library ieee;
use ieee.std_logic_1164.all;
use work.types;

entity Chicker is
	port(
		ClockLow : in std_ulogic;
		Reset : in boolean;
		Sequence : in boolean;
		Power : in natural range 0 to 65535;
		Active : out boolean);
end entity Chicker;

architecture Behavioural of Chicker is
begin
	process(ClockLow) is
		variable LastSequence : boolean;
		variable Counter : natural range 0 to 65535;
	begin
		if rising_edge(ClockLow) then
			if Reset then
				LastSequence := false;
				Counter := 0;
			elsif Sequence /= LastSequence then
				Counter := Power;
			elsif Counter /= 0 then
				Counter := Counter - 1;
			end if;

			LastSequence := Sequence;
		end if;

		Active <= Counter /= 0;
	end process;
end architecture Behavioural;
