----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:25:04 10/17/2009 
-- Design Name: 
-- Module Name:    Tx - Beh 
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

entity Tx is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           send : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           data_out : out  STD_LOGIC;
           busy : out  STD_LOGIC );
end Tx;

architecture Beh of Tx is

begin

	process(clock)
	variable state : integer := 0;
	
	-- state 0 - idle
	-- state 1 - start
	-- state 2 - sending MSB
	-- state 3 - sending 2nd bit
	-- ...
	-- state 9 - sending LSB
	-- state 10 - stop bit
	
	constant baud : integer := 2;
	variable waiting : integer range 0 to baud;
	
	variable data_buf : std_logic_vector (7 downto 0);
	begin
		if (clock = '1') then
			if (waiting > 0) then
				waiting := waiting - 1;
				busy <= '1';
			else
				if (state = 0) then
					busy <= '0';
					data_out <= '0';
					if (send = '1') then
						data_buf := data_in;
						state := 1;
					else
						state := 0;
					end if;
					waiting := 0;
				elsif (state = 1) then
					busy <= '1';
					data_out <= '1';
					state := 2;
					waiting := baud - 1;
				elsif (state >= 2 and state <= 9) then
					busy <= '1';
					data_out <= data_buf(state - 2);
					waiting := baud - 1;
					state := state + 1;
				else
					busy <= '1';
					data_out <= '0';
					state := 0;
					waiting := baud - 1;
				end if;
			end if;
		end if;
	end process;
	
end Beh;

