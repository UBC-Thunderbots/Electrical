use work.motor_common.all;
use work.types.all;

--! \brief Generates a commutation pattern given Hall sensor inputs and a desired direction.
entity MotorCommutator is
	port(
		Direction : in commutation_direction; --! The desired drive direction.
		Hall : in boolean_vector(0 to 2); --! The Hall sensor readings.
		Phases : buffer phase_drive_mode_vector(0 to 2); --! The phase drive pattern.
		StuckHigh : buffer boolean; --! Whether all Hall sensors are stuck high.
		StuckLow : buffer boolean); --! Whether all Hall sensors are stuck low.
end entity MotorCommutator;

architecture RTL of MotorCommutator is
	signal Swapped : boolean_vector(0 to 2);
	signal NPhase : boolean_vector(0 to 2);
	signal PPhase : boolean_vector(0 to 2);
begin
	Swapped <= Hall when Direction = REVERSE else not Hall;

	StuckHigh <= (Hall(0) and Hall(1) and Hall(2));
	StuckLow <= ((not Hall(0)) and (not Hall(1)) and (not Hall(2)));

	process(Swapped, StuckHigh, StuckLow) is
	begin
		for I in Phases'range loop
			if StuckHigh or StuckLow then
				Phases(I) <= FLOAT;
			elsif not Swapped(I) and Swapped((I + 1) mod 3) then
				Phases(I) <= LOW;
			elsif not (Swapped((I + 1) mod 3) or not Swapped(I)) then
				Phases(I) <= PWM;
			else
				Phases(I) <= FLOAT;
			end if;
		end loop;
	end process;
end architecture RTL;
