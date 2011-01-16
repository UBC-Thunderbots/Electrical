package types is
	type hall is array(1 to 3) of boolean;
	type motor_phase is (FLOAT, LOW, HIGH);
	type motor_phase3 is array(1 to 3) of motor_phase;
end package types;
