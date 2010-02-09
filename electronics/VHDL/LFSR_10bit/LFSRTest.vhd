LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.all;

ENTITY LFSRTest IS
END LFSRTest;
 
ARCHITECTURE behavior OF LFSRTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LFSR_10bit
    Port ( Reset	 : in STD_LOGIC;
	   CLK		: in STD_LOGIC;
	   Value_out : out  STD_LOGIC);
    END COMPONENT;
    
   constant CLK_period : time := 5 ms;

   --Inputs
   signal Reset : std_logic := '0';
   signal CLK : std_logic;
 
	--Outputs
   	signal Value_out : std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: LFSR_10bit PORT MAP (
          Reset => Reset,
          CLK => CLK,
          Value_out => Value_out
        );
 
	
	
	
 
   clock_process :process
   begin
	for i in 0 to 5000 loop
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;	 
	end loop;
	wait;
 end process;


   -- Stimulus process
   stim_proc: process
   begin	
   		reset <= '1';
   		wait for CLK_period*10;
   		reset <= '0';
		wait;
   end process;

END;
