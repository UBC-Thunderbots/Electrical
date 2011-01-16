library ieee;
use ieee.std_logic_1164.all;

entity PWM is
	generic(
		Max : in positive);
	port(
		Clock : in std_ulogic;
		Reset : in boolean;
		Value : in natural range 0 to Max;
		Output : out boolean);
end entity PWM;

architecture Behavioural of PWM is
begin
	process(Clock) is
		subtype CountType is natural range 0 to Max - 1;
		variable ValueLatch : natural range 0 to Max;
		variable Count : CountType;
	begin
		if rising_edge(Clock) then
			if Reset then
				ValueLatch := 0;
				Count := 0;
			else
				if Count = 0 then
					ValueLatch := Value;
				end if;

				if Count = CountType'high then
					Count := 0;
				else
					Count := Count + 1;
				end if;
			end if;
		end if;

		Output <= Count < ValueLatch;
	end process;
end architecture Behavioural;
