library ieee;
use ieee.std_logic_1164.all;

package clock is
	type clocks_t is record
		Clock4MHz : std_ulogic;
		Clock8MHz : std_ulogic;
		Clock10MHz : std_ulogic;
		Clock10MHzI : std_ulogic;
		Clock40MHz : std_ulogic;
		Clock40MHzI : std_ulogic;
	end record;
end package clock;
