library ieee;
use ieee.std_logic_1164.all;

package clock is
	type clocks_t is record
		Clock4MHz : std_ulogic;
		Clock8MHz : std_ulogic;
		Clock40MHz : std_ulogic;
	end record;
end package clock;
