library ieee;
use ieee.std_logic_1164.all;

package types is
	subtype battery_voltage_t is natural range 0 to 2 ** 10 - 1;

	subtype capacitor_voltage_t is natural range 0 to 2 ** 12 - 1;

	subtype mcp3004_t is natural range 0 to 2 ** 10 - 1;
	type mcp3004s_t is array(0 to 3) of mcp3004_t;

	type encoder_t is array(0 to 1) of boolean;
	type encoders_t is array(0 to 3) of encoder_t;

	type encoders_clear_t is array(0 to 3) of boolean;

	subtype encoder_count_t is integer range -32768 to 32767;
	type encoders_count_t is array(0 to 3) of encoder_count_t;

	type encoders_fail_t is array(0 to 3) of boolean;

	type hall_t is array(0 to 2) of boolean;
	type halls_t is array(0 to 4) of hall_t;

	type halls_stuck_t is array(0 to 4) of boolean;

	type motor_mode_t is (FLOAT, BRAKE, FORWARD, REVERSE);
	type motors_mode_t is array(4 downto 0) of motor_mode_t;

	type motor_phase_t is (FLOAT, LOW, HIGH);
	type motor_phases_t is array(0 to 2) of motor_phase_t;
	type motors_phases_t is array(0 to 4) of motor_phases_t;

	subtype motor_power_t is natural range 0 to 2 ** 8 - 1;
	type motors_power_t is array(0 to 4) of motor_power_t;

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
