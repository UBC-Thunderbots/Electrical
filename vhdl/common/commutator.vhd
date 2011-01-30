library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity Commutator is
	port(
		Direction : in boolean;
		Hall : in hall_t;
		AllLow : out boolean;
		AllHigh : out boolean;
		Phase : out motor_phases_t);
end entity Commutator;

architecture Behavioural of Commutator is
	type phase_half_t is array(0 to 2) of boolean;
	signal Swapped : hall_t;
	signal AllLowBuf : boolean;
	signal AllHighBuf : boolean;
	signal NPhase : phase_half_t;
	signal PPhase : phase_half_t;
begin
	Swapped <= Hall when Direction else not Hall;

	AllLowBuf <= not (Hall(0) or Hall(1) or Hall(2));
	AllHighBuf <= Hall(0) and Hall(1) and Hall(2);

	AllLow <= AllLowBuf;
	AllHigh <= AllHighBuf;

	GeneratePhases: for I in 0 to 2 generate
		PPhase(I) <= not (Swapped((I + 1) mod 3) or not Swapped(I));
		NPhase(I) <= not Swapped(I) and Swapped((I + 1) mod 3);

		Phase(I) <=
			FLOAT when AllLowBuf or AllHighBuf else
			LOW when NPhase(I) else
			HIGH when PPhase(I) else
			FLOAT;
	end generate;
end architecture Behavioural;
