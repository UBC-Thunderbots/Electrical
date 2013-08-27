library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity Commutator is
	port(
		Direction : in boolean;
		Hall : in work.types.hall_t;
		HallStuckHigh : buffer boolean;
		HallStuckLow : buffer boolean;
		Phase : buffer work.types.motor_commutate_phases_t);
end entity Commutator;

architecture RTL of Commutator is
	type phase_half_t is array(0 to 2) of boolean;
	signal Swapped : work.types.hall_t;
	signal NPhase : phase_half_t;
	signal PPhase : phase_half_t;
begin
	Swapped <= Hall when Direction else not Hall;

	HallStuckHigh <= (Hall(0) and Hall(1) and Hall(2));
	HallStuckLow <= ((not Hall(0)) and (not Hall(1)) and (not Hall(2)));

	GeneratePhases: for I in 0 to 2 generate
		PPhase(I) <= not (Swapped((I + 1) mod 3) or not Swapped(I));
		NPhase(I) <= not Swapped(I) and Swapped((I + 1) mod 3);

		Phase(I) <=
			FLOAT when (HallStuckHigh or HallStuckLow) else
			LOW when NPhase(I) else
			PWM when PPhase(I) else
			FLOAT;
	end generate;
end architecture RTL;
