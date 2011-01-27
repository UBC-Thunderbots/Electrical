library ieee;
use ieee.std_logic_1164.all;

entity PWM is
	generic(
		Max : in positive);
	port(
		Clock : in std_ulogic;
		Value : in natural range 0 to Max;
		Output : out boolean := false);
end entity PWM;

architecture Behavioural of PWM is
begin
	process(Clock) is
		subtype CountType is natural range 0 to Max - 1;
		variable ValueLatch : natural range 0 to Max := 0;
		variable Count : CountType := 0;
	begin
		if rising_edge(Clock) then
			if Count = CountType'high then
				Count := 0;
				ValueLatch := Value;
			else
				Count := Count + 1;
			end if;
		end if;

		Output <= Count < ValueLatch;
	end process;
end architecture Behavioural;
