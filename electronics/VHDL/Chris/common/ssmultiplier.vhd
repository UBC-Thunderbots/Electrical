library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SSMultiplier is
	generic(
		Width : positive
	);
	port(
		Clock100 : in std_ulogic;

		A : in signed(Width - 1 downto 0);
		B : in signed(Width - 1 downto 0);
		Prod : out signed(Width * 2 - 1 downto 0)
	);
end entity SSMultiplier;

architecture Behavioural of SSMultiplier is
	pure function NotNegated2U(X : in signed(Width - 1 downto 0))
	return unsigned is
	begin
		return to_unsigned(to_integer(X), Width);
	end function NotNegated2U;

	pure function Negated2U(X : in signed(Width - 1 downto 0))
	return unsigned is
	begin
		return to_unsigned(-to_integer(X), Width);
	end function Negated2U;

	pure function NotNegated2S(X : in unsigned(Width * 2 - 1 downto 0))
	return signed is
	begin
		return to_signed(to_integer(X), Width * 2);
	end function NotNegated2S;

	pure function Negated2S(X : in unsigned(Width * 2 - 1 downto 0))
	return signed is
	begin
		return to_signed(-to_integer(X), Width * 2);
	end function Negated2S;

	signal SgnA : boolean;
	signal AbsA : unsigned(Width - 1 downto 0);
	signal SgnB : boolean;
	signal AbsB : unsigned(Width - 1 downto 0);
	signal SgnProd : boolean;
	signal AbsProd : unsigned(Width * 2 - 1 downto 0);
begin
	um : entity work.SUMultiplier(Behavioural)
	generic map(
		Width => Width
	)
	port map(
		Clock100 => Clock100,
		A => AbsA,
		B => AbsB,
		Prod => AbsProd
	);

	SgnA <= A < 0;
	AbsA <= Negated2U(A) when A < 0 else NotNegated2U(A);
	SgnB <= B < 0;
	AbsB <= Negated2U(B) when B < 0 else NotNegated2U(B);
	SgnProd <= SgnA xor SgnB;
	Prod <= Negated2S(AbsProd) when SgnProd else NotNegated2S(AbsProd);
end architecture Behavioural;
