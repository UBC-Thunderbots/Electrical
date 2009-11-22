--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:17:45 11/21/2009
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Binaryblade/My Documents/VHDL/PIDController/PIDTest.vhd
-- Project Name:  PIDController
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PIDController
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
 
ENTITY PIDTest IS
END PIDTest;
 
ARCHITECTURE behavior OF PIDTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PIDController
    PORT(
         Error1 : IN  std_logic_vector(17 downto 0);
         Error2 : IN  std_logic_vector(17 downto 0);
         Error3 : IN  std_logic_vector(17 downto 0);
         Error4 : IN  std_logic_vector(17 downto 0);
         PWM1 : OUT  std_logic_vector(35 downto 0);
         PWM2 : OUT  std_logic_vector(35 downto 0);
         PWM3 : OUT  std_logic_vector(35 downto 0);
         PWM4 : OUT  std_logic_vector(35 downto 0);
         NewData : IN  std_logic;
         DataReady : OUT  std_logic;
         CLK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Error1 : std_logic_vector(17 downto 0) := (others => '0');
   signal Error2 : std_logic_vector(17 downto 0) := (others => '0');
   signal Error3 : std_logic_vector(17 downto 0) := (others => '0');
   signal Error4 : std_logic_vector(17 downto 0) := (others => '0');
   signal NewData : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal PWM1 : std_logic_vector(35 downto 0);
   signal PWM2 : std_logic_vector(35 downto 0);
   signal PWM3 : std_logic_vector(35 downto 0);
   signal PWM4 : std_logic_vector(35 downto 0);
   signal DataReady : std_logic;
	
	constant CLK_period : time := 20 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PIDController PORT MAP (
          Error1 => Error1,
          Error2 => Error2,
          Error3 => Error3,
          Error4 => Error4,
          PWM1 => PWM1,
          PWM2 => PWM2,
          PWM3 => PWM3,
          PWM4 => PWM4,
          NewData => NewData,
          DataReady => DataReady,
          CLK => CLK,
          RST => RST
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      Error1 <= "00" & x"0000";
		Error2 <= "00" & x"0000";
		Error3 <= "00" & x"0000";
		Error4 <= "00" & x"0000";
		RST <= '1';
		wait for CLK_period;
		RST <= '0';
		wait for CLK_period;
      Error1 <= "00" & x"0001";
		for i in 0 to 10 loop
		NewData <= '1';
		wait for CLK_period;
		NewData <= '0';
		wait for CLK_period*10;
		end loop;
      wait;
   end process;

END;
