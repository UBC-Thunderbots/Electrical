--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:36:19 10/24/2009
-- Design Name:   
-- Module Name:   C:/Users/DDLO86/Desktop/ThunderBot/Multiplier/Multiplier/MultiplierTest.vhd
-- Project Name:  Multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Multiplier
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY MultiplierTest IS
END MultiplierTest;
 
ARCHITECTURE behavior OF MultiplierTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Multiplier
    PORT(
         FCLK : IN  std_logic;
         SCLK : IN  std_logic;
         In1 : IN  std_logic_vector(15 downto 0);
         In2 : IN  std_logic_vector(15 downto 0);
         Out1 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal FCLK : std_logic := '0';
   signal SCLK : std_logic := '0';
   signal In1 : std_logic_vector(15 downto 0) := (others => '0');
   signal In2 : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal Out1 : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Multiplier PORT MAP (
          FCLK => FCLK,
          SCLK => SCLK,
          In1 => In1,
          In2 => In2,
          Out1 => Out1
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

FCLK_process :process
  begin
		FCLK <= '0';
		wait for 1ns;
		FCLK <= '1';
		wait for 1ns;
   end process;
 
 SCLK_process :process
  begin
		SCLK <= '0';
		wait for 10ns;
		SCLK <= '1';
		wait for 10ns;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 1ns.
      wait for 1ns;
		In1 <= "0000000000000100";
		In2 <= "0000000000000100";
		wait for 7ns;
		In1 <= "0000000000001100";
		In2 <= "0000000000000110";
		wait for 7ns;	
		In1 <= "0000000000001111";
		In2 <= "0000000000010110";
		-- insert stimulus here 

      wait;
   end process;

END;
