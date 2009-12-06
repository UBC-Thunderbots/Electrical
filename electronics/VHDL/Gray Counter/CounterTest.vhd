--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:40:30 10/16/2009
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Binaryblade/My Documents/GrayCounter/CounterTest.vhd
-- Project Name:  GrayCounter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GrayCounter
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
use ieee.std_logic_arith.all;

ENTITY CounterTest IS
END CounterTest;
 
ARCHITECTURE behavior OF CounterTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GrayCounter
    PORT(
         Encoder : IN  std_logic_vector(1 downto 0);
         Reset : IN  std_logic;
         CLK : IN std_logic;
         Count_out : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    constant CLK_period : time := 10 ns;

   --Inputs
   signal Encoder : std_logic_vector(1 downto 0) := "00";
   signal Reset : std_logic := '0';

 	--Outputs
   signal Count_out : std_logic_vector(15 downto 0);
	signal EncoderSel : std_logic_vector(1 downto 0);
	signal CLK : std_logic;
	signal StopSignal : std_logic := '0';
BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: GrayCounter PORT MAP (
          Encoder => Encoder,
          Reset => Reset,
          CLK => CLK,
          Count_out => Count_out
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
	with EncoderSel select
		Encoder <= 	"00" when "00",
				"10" when "01",
				"11" when "10",
				"01" when others;
	
	
	
 
   clock_process :process
   begin
   	if StopSignal = '1' then
   		wait;
   	end if;
	CLK <= '0';
	wait for CLK_period/2;
	CLK <= '1';
	wait for CLK_period/2;
  end process;

   -- Stimulus process
   stim_proc: process
   begin	
   		reset <= '1';
   		wait for CLK_period*10;
   		reset <= '0';
   		wait for CLK_period;
   		
		for i in 0 to 6 loop
			wait for CLK_period*10;
			EncoderSel <= conv_std_logic_vector(i,2);
		end loop;
		for i in 0 to 6 loop
			wait for CLK_period*10;
			EncoderSel <= conv_std_logic_vector(6-i,2);
		end loop;
		StopSignal <= '1';
		wait;
   end process;

END;
