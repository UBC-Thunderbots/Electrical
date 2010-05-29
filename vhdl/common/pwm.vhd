library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PWM is
	generic(
		Width : positive;
		Invert : boolean
	);
	port(
		Clock100 : in std_ulogic;

		PWM : out std_ulogic;

		DutyCycle : in unsigned(Width - 1 downto 0)
	);
end entity PWM;

architecture Behavioural of PWM is
	constant Modulus : positive := (2 ** Width) - 1; -- Minus 1 so we can have full-off AND full-on.
	signal Count : unsigned(Width - 1 downto 0) := to_unsigned(0, Width);
begin
	PWM <= '1' when (Count < DutyCycle) xor Invert else '0';

	process(Clock100)
	begin
		if rising_edge(Clock100) then
			Count <= (Count + 1) mod Modulus;
		end if;
	end process;
end architecture Behavioural;
