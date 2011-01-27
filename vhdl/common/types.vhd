package types is
	subtype battery_voltage_t is natural range 0 to 2 ** 10 - 1;

	subtype capacitor_voltage_t is natural range 0 to 2 ** 12 - 1;

	subtype chicker_power_t is natural range 0 to 4095;

	type encoder_t is array(0 to 1) of boolean;
	type encoders_t is array(1 to 4) of encoder_t;

	subtype encoder_count_t is natural range 0 to 2 ** 11 - 1;
	type encoders_count_t is array(1 to 4) of encoder_count_t;

	type hall_t is array(0 to 2) of boolean;
	type halls_t is array(1 to 5) of hall_t;

	type leds_t is array(3 downto 0) of boolean;

	type motors_direction_t is array(1 to 5) of boolean;

	type motor_phase_t is (FLOAT, LOW, HIGH);
	type motor_phases_t is array(0 to 2) of motor_phase_t;
	type motors_phases_t is array(1 to 5) of motor_phases_t;

	subtype motor_power_t is natural range 0 to 2 ** 8 - 1;
	type motors_power_t is array(1 to 5) of motor_power_t;

	type test_mode_t is (NONE, LAMPTEST, HALL, ENCODER_LINES, ENCODER_COUNT, BOOSTCONVERTER);
end package types;
