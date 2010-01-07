library ieee;
use ieee.numeric_std.all;

-- Computes AX+BY+CZ combinationally.
entity MAdd is
	port(
		A : in signed(17 downto 0);
		B : in signed(17 downto 0);
		C : in signed(17 downto 0);
		X : in signed(17 downto 0);
		Y : in signed(17 downto 0);
		Z : in signed(17 downto 0);
		Prod : out signed(35 downto 0)
	);
end entity MAdd;

architecture Behavioural of MAdd is
begin
	Prod <= A * X + B * Y + C * Z;
end architecture Behavioural;
library ieee;
use ieee.numeric_std.all;

-- Computes AX+BY+CZ combinationally.
entity MAdd is
	port(
		A : in signed(17 downto 0);
		B : in signed(17 downto 0);
		C : in signed(17 downto 0);
		X : in signed(17 downto 0);
		Y : in signed(17 downto 0);
		Z : in signed(17 downto 0);
		Prod : out signed(35 downto 0)
	);
end entity MAdd;

architecture Behavioural of MAdd is
begin
	Prod <= A * X + B * Y + C * Z;
end architecture Behavioural;
