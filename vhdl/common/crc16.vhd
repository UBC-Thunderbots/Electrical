----------------------------------------------------------------------------------
-- Engineer: Koko
-- Create Date:    22:23:36 05/03/2013 
-- Design Name: 
-- Module Name:    CRC16 - Behav
-- 
-- This CRC16 module implement generator polynomial 
-- x^16 + x^12 + x^5 + x^1
-- Reference: 
-- 	1.	Datasheet/sdcard/part1_410.pdf section 4.5 
--	2. 	wikipedia Computation of CRC/parallel implementation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD;

entity crc16 is
    Port ( 	data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           	clock 	: in  STD_LOGIC;
           	clear 	: in  STD_LOGIC;
		enable 	: in STD_LOGIC;
           	checksum : out  STD_LOGIC_VECTOR (15 downto 0));
end crc16;

architecture Behav of crc16 is
	
begin
	Process(clock, clear, data_in) is
		variable interm : STD_LOGIC_VECTOR (7 downto 0);
		variable next_check : STD_LOGIC_VECTOR (15 downto 0);
		variable last_check : STD_LOGIC_VECTOR (15 downto 0);
		variable interm_parity : STD_LOGIC;
	begin
		if (clock' event and clock = '1') then
			if enable = '1' then 
			last_check := next_check;
			interm := data_in xor next_check(15 downto 8);
				
			-- refer to 
			next_check(0) := interm(4) xor interm(0);
			next_check(1) := interm(5) xor interm(1);
			next_check(2) := interm(6) xor interm(2);
			next_check(3) := interm(7) xor interm(3);
			next_check(4) := interm(4);
			next_check(5) := interm(5) xor interm(4) xor interm(0);
			next_check(6) := interm(6) xor interm(5) xor interm(1);
			next_check(7) := interm(7) xor interm(6) xor interm(2);
			next_check(8) := last_check(0) xor interm(7) xor interm(3);
			next_check(9) := last_check(1) xor interm(4);
			next_check(10) := last_check(2) xor interm(5);
			next_check(11) := last_check(3) xor interm(6);
			next_check(12) := last_check(4) xor interm(7) xor interm(4) xor interm(0);
			next_check(13) := last_check(5) xor interm(5) xor interm(1);
			next_check(14) := last_check(6) xor interm(6) xor interm(2);
			next_check(15) := last_check(7) xor interm(7) xor interm(3);
			
			checksum <= next_check;
			end if;

			if clear = '1' then
				checksum <= "0000000000000000";
				next_check := "0000000000000000";
			end if;
		end if;

	end process;

end Behav;


