library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUMultiplier is
	generic(
		Width : positive
	);
	port(
		Clock50M : in std_ulogic;

		A : in unsigned(Width - 1 downto 0);
		B : in unsigned(Width - 1 downto 0);
		Prod : buffer unsigned(Width * 2 - 1 downto 0) := to_unsigned(0, Width * 2)
	);
end entity SUMultiplier;

architecture Behavioural of SUMultiplier is
	signal OldA : unsigned(Width - 1 downto 0) := to_unsigned(0, Width);
	signal OldB : unsigned(Width - 1 downto 0) := to_unsigned(0, Width);
	signal Shift : unsigned(Width * 2 - 1 downto 0) := to_unsigned(0, Width * 2);
	signal Key : unsigned(Width - 1 downto 0) := to_unsigned(0, Width);
begin
	process(Clock50M)
	begin
		if rising_edge(Clock50M) then
			if A /= OldA or B /= OldB then
				Prod <= to_unsigned(0, Width * 2);
				OldA <= A;
				OldB <= B;
				Shift <= to_unsigned(to_integer(A), Width * 2);
				Key <= B;
			else
				if Key(0) = '1' then
					Prod <= Prod + Shift;
				end if;
				Shift <= Shift(Width * 2 - 2 downto 0) & '0';
				Key <= '0' & Key(Width - 1 downto 1);
			end if;
		end if;
	end process;
end architecture Behavioural;
