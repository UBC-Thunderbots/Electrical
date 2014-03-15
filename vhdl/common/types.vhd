library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package types is
	subtype mcp3008_value_t is natural range 0 to 2 ** 10 - 1;
	type mcp3008_t is record
		Value : mcp3008_value_t;
		Strobe : boolean;
	end record;
	type mcp3008s_t is array(0 to 7) of mcp3008_t;

	subtype laser_diff_t is integer range -mcp3008_value_t'high to mcp3008_value_t'high;

	subtype battery_voltage_t is mcp3008_value_t;
	subtype capacitor_voltage_t is mcp3008_value_t;

	type encoder_t is array(0 to 1) of boolean;

	type hall_t is array(0 to 2) of boolean;

	type motor_commutate_phase_t is (FLOAT, PWM, LOW, HIGH);
	type motor_commutate_phases_t is array(0 to 2) of motor_commutate_phase_t;

	type motor_drive_phase_t is (FLOAT, LOW, HIGH);
	type motor_drive_phases_t is array(0 to 2) of motor_drive_phase_t;

	subtype motor_position_t is unsigned(15 downto 0);
	
	subtype WORD is std_ulogic_vector(7 downto 0);

	type SPIOutput_t is record
		ReadData : WORD;
		ReadStrobe : boolean;
		ReadCRCOk : boolean;
		ReadFirst : boolean;
		WriteReady : boolean;
	end record;

	type SPIInput_t is record
		WriteData : WORD;
		WriteStrobe : boolean;
		WriteCRC : boolean;
	end record;

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
