----------------------------------------------------------------------------------
-- Engineer: Koko
-- Create Date:	22:23:36 05/03/2013 
-- Design Name: 
-- Module Name:	CRC16 - Behav
-- 
-- This CRC16 module implement generator polynomial 
-- x^16 + x^12 + x^5 + x^1
-- Reference: 
-- 	1.	Datasheet/sdcard/part1_410.pdf section 4.5 
--	2. 	wikipedia Computation of CRC/parallel implementation
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std;

entity CRC16 is
	port(
		Clock : in std_ulogic;
		Data : in std_ulogic_vector(7 downto 0);
		Clear : in boolean;
		Enable : in boolean;
		Checksum : buffer std_ulogic_vector(15 downto 0));
end entity CRC16;

architecture RTL of CRC16 is
begin
	process(Clock) is
		variable Interm : std_ulogic_vector(7 downto 0);
		variable NextCheck : std_ulogic_vector(15 downto 0);
		variable LastCheck : std_ulogic_vector(15 downto 0);
		variable IntermParity : std_ulogic;
	begin
		if rising_edge(Clock) then
			if Clear then
				Checksum <= "0000000000000000";
				NextCheck := "0000000000000000";
			elsif Enable then
				LastCheck := NextCheck;
				Interm := Data xor NextCheck(15 downto 8);

				-- refer to 
				NextCheck(0) := Interm(4) xor Interm(0);
				NextCheck(1) := Interm(5) xor Interm(1);
				NextCheck(2) := Interm(6) xor Interm(2);
				NextCheck(3) := Interm(7) xor Interm(3);
				NextCheck(4) := Interm(4);
				NextCheck(5) := Interm(5) xor Interm(4) xor Interm(0);
				NextCheck(6) := Interm(6) xor Interm(5) xor Interm(1);
				NextCheck(7) := Interm(7) xor Interm(6) xor Interm(2);
				NextCheck(8) := LastCheck(0) xor Interm(7) xor Interm(3);
				NextCheck(9) := LastCheck(1) xor Interm(4);
				NextCheck(10) := LastCheck(2) xor Interm(5);
				NextCheck(11) := LastCheck(3) xor Interm(6);
				NextCheck(12) := LastCheck(4) xor Interm(7) xor Interm(4) xor Interm(0);
				NextCheck(13) := LastCheck(5) xor Interm(5) xor Interm(1);
				NextCheck(14) := LastCheck(6) xor Interm(6) xor Interm(2);
				NextCheck(15) := LastCheck(7) xor Interm(7) xor Interm(3);

				Checksum <= NextCheck;
			end if;
		end if;
	end process;
end architecture RTL;
