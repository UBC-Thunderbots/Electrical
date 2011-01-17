library ieee;
use ieee.std_logic_1164.all;

package pintypes is
	type encoders_t is array(1 to 4) of std_ulogic_vector(0 to 1);

	type halls_t is array(1 to 5) of std_ulogic_vector(0 to 2);

	type motors_phases_t is array(1 to 5) of std_ulogic_vector(0 to 2);
end package pintypes;
