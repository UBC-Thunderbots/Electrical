library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PWM is
	generic(
		Width : positive
	);
	port(
		Clock : in std_ulogic;

		PWM : out std_ulogic;

		DutyCycle : in unsigned(Width - 1 downto 0)
	);
end entity PWM;

architecture Behavioural of PWM is
	signal Count : unsigned(Width - 1 downto 0) := to_unsigned(0, Width);
begin
	PWM <= '0' when (Count < DutyCycle) else '1';
	process(Clock)
	begin
		if rising_edge(Clock) then
			Count <= Count + 1;
		end if;
	end process;
end architecture Behavioural;
