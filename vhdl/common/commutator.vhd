library ieee;
use ieee.std_logic_1164.all;
use work.types;

entity Commutator is
	port(
		signal Direction : in boolean;
		signal Hall : in types.hall_t;
		AllLow : out boolean;
		AllHigh : out boolean;
		Phase : out types.motor_phases_t);
end entity Commutator;

architecture Behavioural of Commutator is
	type phase_half_t is array(0 to 2) of boolean;
	signal Swapped : types.hall_t;
	signal AllLowBuf : boolean;
	signal AllHighBuf : boolean;
	signal NPhase : phase_half_t;
	signal PPhase : phase_half_t;
begin
	Swapped <= not Hall when Direction else Hall;

	AllLowBuf <= not (Hall(0) or Hall(1) or Hall(2));
	AllHighBuf <= Hall(0) and Hall(1) and Hall(2);

	AllLow <= AllLowBuf;
	AllHigh <= AllHighBuf;

	GeneratePhases: for I in 0 to 2 generate
		PPhase(I) <= not (Swapped((I + 1) mod 3) or not Swapped(I));
		NPhase(I) <= not Swapped(I) and Swapped((I + 1) mod 3);

		Phase(I) <=
			types.FLOAT when AllLowBuf or AllHighBuf else
			types.LOW when NPhase(I) else
			types.HIGH when PPhase(I) else
			types.FLOAT;
	end generate;
end architecture Behavioural;
