library ieee;
use ieee.std_logic_1164.all;

package types is
	subtype battery_voltage_t is natural range 0 to 2 ** 10 - 1;

	subtype capacitor_voltage_t is natural range 0 to 2 ** 12 - 1;

	type kicker_active_t is array(1 to 2) of boolean;

	subtype kicker_time_t is natural range 0 to 16383;
	type kicker_times_t is array(1 to 2) of kicker_time_t;

	type encoder_t is array(0 to 1) of boolean;
	type encoders_t is array(1 to 4) of encoder_t;

	subtype encoder_count_t is integer range -1023 to 1023;
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

	function to_boolean(X : std_ulogic) return boolean;

	function to_stdulogic(X : boolean) return std_ulogic;
end package types;

package body types is
	function to_boolean(X : std_ulogic) return boolean is
	begin
		return X = '1';
	end function to_boolean;

	function to_stdulogic(X : boolean) return std_ulogic is
	begin
		if X then
			return '1';
		else
			return '0';
		end if;
	end function to_stdulogic;
end package body types;
