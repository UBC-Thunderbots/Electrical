library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GrayCounter is
	generic (
		Width : positive
	);
	port (
		Clock1 : in std_ulogic;

		A : in std_ulogic;
		B : in std_ulogic;

		Reset : in std_ulogic;
		Count : out signed(Width - 1 downto 0)
	);
end entity GrayCounter;

architecture Behavioural of GrayCounter is
	signal OldA : std_ulogic := '0';
	signal OldB : std_ulogic := '0';
	signal CountBuf : signed(Width - 1 downto 0) := to_signed(0, Width);
begin
	Count <= CountBuf;

	process(Clock1)
		variable Delta : signed(Width - 1 downto 0);
	begin
		if rising_edge(Clock1) then
			if OldA = '0' and OldB = '0' and A = '1' and B = '0' then 
				Delta := to_signed(1, Width);
			elsif OldA = '1' and OldB = '0' and A = '1' and B = '1' then 
				Delta := to_signed(1, Width);
			elsif OldA = '1' and OldB = '1' and A = '0' and B = '1' then 
				Delta := to_signed(1, Width);
			elsif OldA = '0' and OldB = '1' and A = '0' and B = '0' then 
				Delta := to_signed(1, Width);
			elsif OldA = '0' and OldB = '0' and A = '0' and B = '1' then 
				Delta := to_signed(-1, Width);
			elsif OldA = '0' and OldB = '1' and A = '1' and B = '1' then 
				Delta := to_signed(-1, Width);
			elsif OldA = '1' and OldB = '1' and A = '1' and B = '0' then 
				Delta := to_signed(-1, Width);
			elsif OldA = '1' and OldB = '0' and A = '0' and B = '0' then 
				Delta := to_signed(-1, Width);
			else
				Delta := to_signed(0, Width);
			end if;
			OldA <= A;
			OldB <= B;
			if Reset = '1' then
				CountBuf <= Delta;
			else
				CountBuf <= CountBuf + Delta;
			end if;
		end if;
	end process;
end architecture Behavioural;
