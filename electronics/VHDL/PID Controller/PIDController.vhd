----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:19:37 11/21/2009 
-- Design Name: 
-- Module Name:    PIDController - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PIDController is
    Port ( Error1 : in  STD_LOGIC_VECTOR (17 downto 0);
           Error2 : in  STD_LOGIC_VECTOR (17 downto 0);
           Error3 : in  STD_LOGIC_VECTOR (17 downto 0);
           Error4 : in  STD_LOGIC_VECTOR (17 downto 0);
           PWM1 : out  STD_LOGIC_VECTOR (35 downto 0);
           PWM2 : out  STD_LOGIC_VECTOR (35 downto 0);
           PWM3 : out  STD_LOGIC_VECTOR (35 downto 0);
           PWM4 : out  STD_LOGIC_VECTOR (35 downto 0);
           NewData : in  STD_LOGIC;
           DataReady : out  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  RST : in STD_LOGIC);
end PIDController;

architecture Behavioral of PIDController is
type State is (Waiting, LoadData, MultiplyLoad,MultiplyWait,MultiplyDone, Output);
type Signals is array(3 downto 0) of std_logic_vector(17 downto 0);
type Signals_big is array(3 downto 0) of std_logic_vector(35 downto 0);
type PID_States is (PID1,PID2,PID3,PID4);
Signal Error : Signals;
Signal PWM : Signals_big;

constant P : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000001";
constant I : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000001";
constant D : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000001";
Signal P_multout : STD_LOGIC_VECTOR(35 downto 0) := x"000000000";
Signal P_multin : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000";
Signal I_multout : STD_LOGIC_VECTOR(35 downto 0) := x"000000000";
Signal I_multin : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000";
Signal D_multout : STD_LOGIC_VECTOR(35 downto 0) := x"000000000";
Signal D_multin : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000";
Signal Sum : STD_LOGIC_VECTOR(35 downto 0) := x"000000000";
Begin

Error(0)(17 downto 0) <= Error1;
Error(1)(17 downto 0) <= Error2;
Error(2)(17 downto 0) <= Error3;
Error(3)(17 downto 0) <= Error4;
PWM1 <= PWM(0);
PWM2 <=PWM(1);
PWM3 <=PWM(2);
PWM4 <=PWM(3);
process(CLK)
variable Integral : Signals;
variable PrevError: Signals;
variable Diff: Signals;

variable Current_State : State := Waiting;
variable Next_State : State := Waiting;
variable Current_Loop : PID_States;
variable Count : std_logic_vector(1 downto 0) := "00";
begin
	if rising_edge(CLK) then
		if RST = '1' then
		Current_State := Waiting;
		Next_State := Waiting;
for i in 0 to 3 loop
Integral(i) := "000000000000000000";
PrevError(i) := Error(i);
Diff(i) := "000000000000000000";
end loop;
		
		else
			Current_State := Next_State;
			case Current_State is
			When Waiting =>
				if NewData = '1' then
					Next_State := LoadData;
				end if;
				DataReady <= '0';
			When LoadData =>
				for i in 0 to 3 loop
					Integral(i) := Integral(i) + Error(i);
					Diff(i) := Error(i) - PrevError(i);
					PrevError(i) := Error(i);
				end loop;
				Next_State := MultiplyLoad;
				DataReady <= '0';
			When MultiplyLoad =>
				case Current_Loop is
					When PID1 =>
						P_Multin <= PrevError(0);
						I_Multin <= Integral(0);
						D_Multin <= Diff(0);
					When PID2 =>
						P_Multin <= PrevError(1);
						I_Multin <= Integral(1);
						D_Multin <= Diff(1);
					When PID3 =>
						P_Multin <= PrevError(2);
						I_Multin <= Integral(2);
						D_Multin <= Diff(2);
					When others =>
						P_Multin <= PrevError(3);
						I_Multin <= Integral(3);
						D_Multin <= Diff(3);
				end case;
				Next_State := MultiplyDone;
				DataReady <= '0';
			When MultiplyDone =>
				case Current_Loop is
					When PID1 =>
						PWM(0) <= Sum;
						Current_Loop := PID2;
					When PID2 =>
						PWM(1) <= Sum;
						Current_Loop := PID3;
					When PID3 =>
						PWM(2) <= Sum;
						Current_Loop := PID4;
					When others =>
						PWM(3) <= Sum;
						Current_Loop := PID1;
				end case;
				if(Current_Loop = PID1) then
					Next_State := Output;
				else
					Next_State := MultiplyLoad;
				end if;
				DataReady <= '0';
			When others =>
				DataReady <= '1';
				Next_State := Waiting;
			end case;
		end if;
	end if;
	end process;
	P_MultOut <= P*P_MultIn;
	I_MultOut <= I*I_MultIn;
	D_MultOut <= D*D_MultIn;
	Sum <=P_MultOut+I_MultOut+D_MultOut;
end Behavioral;