library ieee;
use ieee.std_logic_1164.all;
use work.types;

entity Chicker is
	port(
		ClockHigh : in std_ulogic;
		ClockLow : in std_ulogic;
		Strobe : in boolean;
		Power : in types.chicker_power_t;
		Active : out boolean);
end entity Chicker;

architecture Behavioural of Chicker is
	signal StrobeLow : boolean;
begin
	SyncDownStrobe: entity work.SyncDownStrobe(Behavioural)
	port map(
		ClockHigh => ClockHigh,
		ClockLow => ClockLow,
		Input => Strobe,
		Output => StrobeLow);

	process(ClockLow) is
		variable Counter : types.chicker_power_t := 0;
	begin
		if rising_edge(ClockLow) then
			if StrobeLow then
				Counter := Power;
			elsif Counter /= 0 then
				Counter := Counter - 1;
			end if;
		end if;

		Active <= Counter /= 0;
	end process;
end architecture Behavioural;
