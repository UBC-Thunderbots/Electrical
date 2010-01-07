library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller is
	port(
		Clock1 : in std_ulogic;
		Clock100 : in std_ulogic;

		Drive1 : in signed(15 downto 0);
		Drive2 : in signed(15 downto 0);
		Drive3 : in signed(15 downto 0);

		Motor1 : out signed(10 downto 0);
		Motor2 : out signed(10 downto 0);
		Motor3 : out signed(10 downto 0);
		Motor4 : out signed(10 downto 0)
	);
end entity Controller;

architecture Behavioural of Controller is
begin
	process(Drive1, Drive2, Drive3)
	begin
		Motor1 <= to_signed(0, 11);
		Motor2 <= to_signed(0, 11);
		Motor3 <= to_signed(0, 11);
		Motor4 <= to_signed(0, 11);
	end process;
end architecture Behavioural;
