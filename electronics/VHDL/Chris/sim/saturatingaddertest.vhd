library ieee;
use ieee.numeric_std.all;

entity SaturatingAdderTest is
end entity SaturatingAdderTest;

architecture Behavioural of SaturatingAdderTest is
	signal X : integer range -128 to 127 := 0;
	signal Y : integer range -128 to 127 := 0;
	signal XS : signed(7 downto 0) := to_signed(0, 8);
	signal YS : signed(7 downto 0) := to_signed(0, 8);
	signal SumS : signed(7 downto 0) := to_signed(0, 8);
	signal Sum : integer range -128 to 127 := 0;
begin
	XS <= to_signed(X, 8);
	YS <= to_signed(Y, 8);
	UUT : entity work.SaturatingAdder(Behavioural)
	generic map(
		Width => 8
	)
	port map(
		X => XS,
		Y => YS,
		Sum => SumS
	);
	Sum <= to_integer(SumS);

	process
	begin
		X <= 1;
		Y <= 2;
		wait for 1 ns;
		assert Sum = 3;

		X <= 27;
		Y <= -32;
		wait for 1 ns;
		assert Sum = -5;

		X <= 32;
		Y <= -27;
		wait for 1 ns;
		assert Sum = 5;

		X <= -12;
		Y <= -30;
		wait for 1 ns;
		assert Sum = -42;

		X <= 100;
		Y <= 100;
		wait for 1 ns;
		assert Sum = 127;

		X <= -100;
		Y <= -30;
		wait for 1 ns;
		assert Sum = -128;

		wait;
	end process;
end architecture Behavioural;
