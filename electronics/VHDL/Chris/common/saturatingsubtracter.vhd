library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SaturatingSubtracter is
	generic(
		Width : positive
	);
	port(
		X : in signed(Width - 1 downto 0);
		Y : in signed(Width - 1 downto 0);
		Difference : out signed(Width - 1 downto 0) := to_signed(0, Width)
	);
end entity SaturatingSubtracter;

architecture Behavioural of SaturatingSubtracter is
	signal MinusY : signed(Width - 1 downto 0);
begin
	MinusY <= -Y;
	Adder : entity work.SaturatingAdder(Behavioural)
	generic map(
		Width => Width
	)
	port map(
		X => X,
		Y => MinusY,
		Sum => Difference
	);
end architecture Behavioural;
