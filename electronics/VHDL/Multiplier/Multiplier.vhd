----------------------------------------------------------------------------------
-- Company: UBC Thunderbots
-- Engineer: David Lo
-- 
-- Create Date:    13:16:19 10/17/2009 
-- Design Name: 
-- Module Name:    Multiplier - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity Multiplier is
    Port ( FCLK, SCLK: in  STD_LOGIC;
           In1, In2 : in std_logic_vector(15 downto 0);
			  Out1 : out  STD_LOGIC_vector(31 downto 0));
end Multiplier;

architecture Behavioral of Multiplier is
signal sigA, sigC, sigD : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal sigB : std_logic_vector(15 downto 0) := "0000000000000000";
begin

--=======Shifter A and Shifter B============ 
process(FCLK,SCLK,In1,In2)
variable prevSCLK : std_logic := '0';
begin

if rising_edge(FCLK) then
	if (prevSCLK = '0' AND SCLK = '1') then
		sigA <= "0000000000000000" & In1;
		sigB <= In2;
		sigD <= "00000000000000000000000000000000";
	else
		sigA <= sigA(30 downto 0) & '0'; 
		sigB <= '0' & sigB(15 downto 1);
		sigD <= sigD + sigC;
	end if;
	prevSCLK := SCLK;
	if sigB = "0000000000000000" then
		Out1 <= sigD;
	end if;
end if;

	
end process;
--==========================================


--32-bit AND gate of DOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOM!!!!!
with sigB(0) select 
sigC <= 	sigA when '1', 
			"00000000000000000000000000000000" when '0',
			"00000000000000000000000000000000" when others;

end Behavioral;

