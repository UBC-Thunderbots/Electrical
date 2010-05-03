library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Types is
	type RAMDataType is array(0 to 63) of signed(15 downto 0);
	type ROMDataType is array(0 to 1023) of std_ulogic_vector(15 downto 0);
end package Types;
