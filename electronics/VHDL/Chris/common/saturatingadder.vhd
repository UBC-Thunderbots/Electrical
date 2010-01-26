library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SaturatingAdder is
	generic(
		Width : positive
	);
	port(
		X : in signed(Width - 1 downto 0);
		Y : in signed(Width - 1 downto 0);
		Sum : out signed(Width - 1 downto 0) := to_signed(0, Width)
	);
end entity SaturatingAdder;

architecture Behavioural of SaturatingAdder is
	constant SaturateNegValue : signed(Width - 1 downto 0) := '1' & to_signed(0, Width - 1);
	constant SaturatePosValue : signed(Width - 1 downto 0) := not SaturateNegValue;
	signal SignX : std_ulogic;
	signal SignY : std_ulogic;
	signal SignsSame : std_ulogic;
	signal RealSum : signed(Width - 1 downto 0);
	signal SignRealSum : std_ulogic;
	signal Overflow : std_ulogic;
begin
	SignX <= X(Width - 1);
	SignY <= Y(Width - 1);
	SignsSame <= SignX xnor SignY;
	RealSum <= X + Y;
	SignRealSum <= RealSum(Width - 1);
	Overflow <= SignsSame and (SignRealSum xor SignX);

	Sum <= RealSum when Overflow = '0'
		else SaturateNegValue when SignX = '1'
		else SaturatePosValue;
end architecture Behavioural;
