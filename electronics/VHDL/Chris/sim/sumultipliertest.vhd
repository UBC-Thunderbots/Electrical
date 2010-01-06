library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUMultiplierTest is
end entity SUMultiplierTest;

architecture Behavioural of SUMultiplierTest is
	constant ClockPeriod : time := 10 ns;
	constant Width : positive := 6;

	signal Clock100 : std_ulogic := '0';
	signal A : unsigned(Width - 1 downto 0) := to_unsigned(0, Width);
	signal B : unsigned(Width - 1 downto 0) := to_unsigned(0, Width);
	signal Prod : unsigned(Width * 2 - 1 downto 0);
	signal Done : std_ulogic := '0';
begin
	uut : entity work.SUMultiplier(Behavioural)
	generic map(
		Width => Width
	)
	port map(
		Clock100 => Clock100,
		A => A,
		B => B,
		Prod => Prod
	);

	process
		procedure TickMany is
			variable i : natural;
		begin
			wait for ClockPeriod / 4;
			Clock100 <= '1';
			i := 0;
			while i < Width loop
				wait for ClockPeriod / 2;
				Clock100 <= '0';
				wait for ClockPeriod / 2;
				Clock100 <= '1';
				i := i + 1;
			end loop;
			wait for ClockPeriod / 2;
			Clock100 <= '0';
			wait for ClockPeriod / 4;
		end procedure TickMany;

		variable i, j : natural;
	begin
		i := 0;
		while i < 2 ** Width loop
			j := 0;
			while j < 2 ** Width loop
				A <= to_unsigned(i, Width);
				B <= to_unsigned(j, Width);
				TickMany;
				assert Prod = to_unsigned(i * j, Width * 2);
				j := j + 1;
			end loop;
			i := i + 1;
		end loop;

		Done <= '1';
		wait;
	end process;
end architecture Behavioural;
