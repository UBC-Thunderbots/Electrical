library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SSMultiplier is
	generic(
		Width : positive
	);
	port(
		Clock : in std_ulogic;

		A : in signed(Width - 1 downto 0);
		B : in signed(Width - 1 downto 0);
		Prod : out signed(Width * 2 - 1 downto 0)
	);
end entity SSMultiplier;

architecture Behavioural of SSMultiplier is
	component SUMultiplier
		generic(
			Width : positive
		);
		port(
			Clock : in std_ulogic;
			A : in unsigned(Width - 1 downto 0);
			B : in unsigned(Width - 1 downto 0);
			Prod : buffer unsigned(Width * 2 - 1 downto 0)
		);
	end component;

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

	signal SgnA : std_ulogic;
	signal AbsA : unsigned(Width - 1 downto 0);
	signal SgnB : std_ulogic;
	signal AbsB : unsigned(Width - 1 downto 0);
	signal SgnProd : std_ulogic;
	signal AbsProd : unsigned(Width * 2 - 1 downto 0);
begin
	um : SUMultiplier
	generic map(
		Width => Width
	)
	port map(
		Clock => Clock,
		A => AbsA,
		B => AbsB,
		Prod => AbsProd
	);

	SgnA <= '1' when A < 0 else '0';
	AbsA <= Negated2U(A) when A < 0 else NotNegated2U(A);
	SgnB <= '1' when B < 0 else '0';
	AbsB <= Negated2U(B) when B < 0 else NotNegated2U(B);
	SgnProd <= SgnA xor SgnB;
	Prod <= Negated2S(AbsProd) when SgnProd = '1' else NotNegated2S(AbsProd);
end architecture Behavioural;
