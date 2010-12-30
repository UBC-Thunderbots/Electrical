library ieee;
use ieee.std_logic_1164.all;


Entity BrushlessController  is
port (
	Reverse	: in std_logic;
	HallSensor : in std_logic_vector(3 downto 1);
	AllLow : out std_logic;
	AllHigh : out std_logic;
	UpperPhase : out std_logic_vector(3 downto 1);
	LowerPhase : out std_logic_vector(3 downto 1)
);
end entity;


architecture Behaviour of BrushlessController is
	signal Swapped : std_logic_vector(3 downto 1);
begin
	Swapped <= Reverse&Reverse&Reverse XOR HallSensor;	
	
	UpperPhase(1) <= Swapped(2) OR NOT Swapped(1);
	UpperPhase(2) <= Swapped(3) OR NOT Swapped(2);
	UpperPhase(3) <= Swapped(1) OR NOT Swapped(3);

	LowerPhase(1) <= NOT Swapped(1) AND Swapped(2);
	LowerPhase(2) <= NOT Swapped(2) AND Swapped(3);
	LowerPhase(3) <= NOT Swapped(3) AND Swapped(1);
	
	AllLow <= NOT ( HallSensor(1) OR HallSensor(2) OR HallSensor(3) );
	AllHigh <= HallSensor(1) AND HallSensor(2) AND HallSensor(3);
end;

