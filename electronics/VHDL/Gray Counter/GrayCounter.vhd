----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:20:05 10/16/2009 
-- Design Name: 
-- Module Name:    GrayCounter - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GrayCounter is
    Port ( Encoder : in  STD_LOGIC_VECTOR (1 downto 0);
           Reset	 : in STD_LOGIC;
			  Count_out : out  STD_LOGIC_VECTOR (15 downto 0));
			  
end GrayCounter;

architecture Behavioral of GrayCounter is
signal Trig : STD_LOGIC;
begin
Trig <= Encoder(1) xor Encoder(0);


count_process: process(Encoder,Reset)
variable Count : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
variable PrevEncoder : STD_LOGIC_VECTOR(1 downto 0) := "00";
begin
if Reset = '1' then
PrevEncoder := "00";
Count := x"0000";
else
	case Encoder is
		when "00"   => 
					case PrevEncoder is
						when "00"   => Count := Count;
						when "01"   => Count := Count + 1;
						when "10"   => Count := Count - 1;
						when others => Count := Count; 
					end case;		
		when "01"   => 					
					case PrevEncoder is
						when "00"   => Count := Count - 1;
						when "01"   => Count := Count;
						when "10"   => Count := Count;
						when others => Count := Count + 1; 
					end case;
		when "10"   =>  					
					case PrevEncoder is
						when "00"   => Count := Count + 1;
						when "01"   => Count := Count;
						when "10"   => Count := Count;
						when others => Count := Count - 1; 
					end case;
		when others => 
					case PrevEncoder is
						when "00"   => Count := Count;
						when "01"   => Count := Count - 1;
						when "10"   => Count := Count + 1;
						when others => Count := Count; 
					end case;
	end case;

end if;
PrevEncoder := Encoder;
Count_out <= Count;
end process;

end Behavioral;

