library ieee;
use ieee.std_logic_1164.all;

entity PWM is
	generic(
		Max : in positive;
		Phase : in natural);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		Value : in natural range 0 to Max;
		Output : buffer boolean);
end entity PWM;

architecture RTL of PWM is
	subtype count_t is natural range 0 to Max - 1;
	signal Count : count_t;
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				Count <= Phase;
			else
				Count <= (Count + 1) mod Max;
			end if;
		end if;
	end process;

	Output <= Count < Value;
end architecture RTL;
