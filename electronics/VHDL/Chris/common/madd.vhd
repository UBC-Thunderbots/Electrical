library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Computes AX+BY+CZ combinationally.
entity MAdd is
	port(
		Clock : in std_ulogic;
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
	signal AL : signed(17 downto 0);
	signal BL : signed(17 downto 0);
	signal CL : signed(17 downto 0);
	signal XL : signed(17 downto 0);
	signal YL : signed(17 downto 0);
	signal ZL : signed(17 downto 0);
	signal PL : signed(35 downto 0);
	signal QL : signed(35 downto 0);
	signal RL : signed(35 downto 0);
begin
	process(Clock)
	begin
		if rising_edge(Clock) then
			PL <= AL * XL;
			QL <= BL * YL;
			RL <= CL * ZL;
			AL <= A;
			BL <= B;
			CL <= C;
			XL <= X;
			YL <= Y;
			ZL <= Z;
		end if;
	end process;

	Prod <= PL + QL + RL;
end architecture Behavioural;
