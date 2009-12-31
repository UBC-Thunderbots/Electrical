library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SSMultiplierTest is
end entity SSMultiplierTest;

architecture Behavioural of SSMultiplierTest is
	component SSMultiplier
		generic(
			Width : positive
		);
		port(
			Clock : in std_logic;

			A : in signed(Width - 1 downto 0);
			B : in signed(Width - 1 downto 0);
			Prod : out signed(Width * 2 - 1 downto 0)
		);
	end component SSMultiplier;

	constant ClockPeriod : time := 20 ns;
	constant Width : positive := 6;

	signal Clock : std_logic := '0';
	signal A : signed(Width - 1 downto 0) := to_signed(0, Width);
	signal B : signed(Width - 1 downto 0) := to_signed(0, Width);
	signal Prod : signed(Width * 2 - 1 downto 0);
	signal Done : std_logic := '0';
begin
	uut: SSMultiplier
	generic map(
		Width => Width
	)
	port map(
		Clock => Clock,
		A => A,
		B => B,
		Prod => Prod
	);

	process
		procedure TickMany is
			variable i : natural;
		begin
			wait for ClockPeriod / 4;
			Clock <= '1';
			i := 0;
			while i < Width loop
				wait for ClockPeriod / 2;
				Clock <= '0';
				wait for ClockPeriod / 2;
				Clock <= '1';
				i := i + 1;
			end loop;
			wait for ClockPeriod / 2;
			Clock <= '0';
			wait for ClockPeriod / 4;
		end procedure TickMany;

		variable i, j : integer;
	begin
		i := -2 ** (Width - 1);
		while i < 2 ** (Width - 1) loop
			j := -2 ** (Width - 1);
			while j < 2 ** (Width - 1) loop
				A <= to_signed(i, Width);
				B <= to_signed(j, Width);
				TickMany;
				assert Prod = to_signed(i * j, Width * 2);
				j := j + 1;
			end loop;
			i := i + 1;
		end loop;

		Done <= '1';
		wait;
	end process;
end architecture Behavioural;
