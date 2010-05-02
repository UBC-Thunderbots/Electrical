library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignMagnitude is
	generic(
		Width : positive
	);
	port(
		Value : in signed(Width - 1 downto 0);
		Absolute : out unsigned(Width - 2 downto 0);
		Sign : out std_ulogic
	);
end entity SignMagnitude;

architecture Behavioural of SignMagnitude is
begin
	Absolute <= to_unsigned(abs(to_integer(Value)), Width - 1);
	Sign <= '1' when to_integer(Value) < 0 else '0';
end architecture Behavioural;
