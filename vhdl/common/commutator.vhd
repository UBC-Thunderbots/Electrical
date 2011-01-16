library ieee;
use ieee.std_logic_1164.all;

library work;

entity Commutator is
	port(
		Reverse	: in boolean;
		HallSensor : in work.types.hall;
		AllLow : out boolean;
		AllHigh : out boolean;
		Phase : out work.types.motor_phase3);
end entity Commutator;

architecture Behavioural of Commutator is
	type phase_half is array(1 to 3) of boolean;
	signal Swapped : work.types.hall;
	signal AllLowBuf : boolean;
	signal AllHighBuf : boolean;
	signal NPhase : phase_half;
	signal PPhase : phase_half;
begin
	Swapped <= not HallSensor when Reverse else HallSensor;

	AllLowBuf <= not (HallSensor(1) or HallSensor(2) or HallSensor(3));
	AllHighBuf <= HallSensor(1) and HallSensor(2) and HallSensor(3);

	AllLow <= AllLowBuf;
	AllHigh <= AllHighBuf;

	GeneratePhases: for I in 1 to 3 generate
		PPhase(I) <= not (Swapped(I mod 3 + 1) or not Swapped(I));
		NPhase(I) <= not Swapped(I) and Swapped(I mod 3 + 1);

		Phase(I) <=
			work.types.FLOAT when AllLowBuf or AllHighBuf else
			work.types.LOW when NPhase(I) else
			work.types.HIGH when PPhase(I) else
			work.types.FLOAT;
	end generate;
end architecture Behavioural;
