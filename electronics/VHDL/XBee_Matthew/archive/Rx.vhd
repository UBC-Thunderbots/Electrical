----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:28:07 11/19/2009 
-- Design Name: 
-- Module Name:    Rx - Beh
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

entity Rx is
    Port ( clock : in STD_LOGIC;
	   data_in : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0); -- 7 is the MSB
           data_avail : out  STD_LOGIC);
end Rx;

architecture Beh of Rx is

begin

	process(clock)
	
	constant BIT_LENGTH : integer := 2;
	
	type State_t is (idle, start, bit0, bit1, bit2, bit3, 
											bit4, bit5, bit6, bit7); -- (LSB first)
	
	variable state : State_t;
	
	variable waiting : integer range 0 to BIT_LENGTH;
	
	variable data_register : std_logic_vector (7 downto 0);
	
	variable data_ready : std_logic;
	
	begin
		if (clock'event and clock = '1') then
		
			data_avail <= data_ready; -- default, only overridden in last state
			
			data_ready := '0';
		
			if (waiting /= 0) then
				waiting := waiting - 1;
			else
				
				waiting := BIT_LENGTH; -- default, to save a few lines of code
				
				case state is
					when idle =>
						if (data_in = '1') then
							waiting := BIT_LENGTH / 2;
							state := start;
						else
							waiting := 0;
							state := idle;
						end if;
					when start =>
						if (data_in = '1') then -- as expected
							state := bit0;
						else -- huh? what's going on
							waiting := 0;
							state := idle;
						end if;
					when bit0 =>
						data_register(0) := data_in;
						state := bit1;
					when bit1 =>
						data_register(1) := data_in;
						state := bit2;
					when bit2 =>
						data_register(2) := data_in;
						state := bit3;
					when bit3 =>
						data_register(3) := data_in;
						state := bit4;
					when bit4 =>
						data_register(4) := data_in;
						state := bit5;
					when bit5 =>
						data_register(5) := data_in;
						state := bit6;
					when bit6 =>
						data_register(6) := data_in;
						state := bit7;
					when bit7 =>
						data_register(7) := data_in;
						state := idle;
						-- latch data to output
						data_out <= data_register;
						data_ready := '1'; -- enable the flag on next clock
				end case;
			end if;
		end if;
	end process;

end Beh;

