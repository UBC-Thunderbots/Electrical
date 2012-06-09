library ieee;
use ieee.std_logic_1164.all;

package pintypes is
	type encoders_pin_t is array(0 to 3) of std_ulogic_vector(0 to 1);

	type halls_pin_t is array(0 to 4) of std_ulogic_vector(0 to 2);

	type motors_phases_pin_t is array(0 to 4) of std_ulogic_vector(0 to 2);
end package pintypes;
