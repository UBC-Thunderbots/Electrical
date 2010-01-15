library ieee;
use ieee.std_logic_1164.all;

package Types is
	constant ROMLength : positive := 4;
	type ROMDataType is array(ROMLength - 1 downto 0) of std_ulogic_vector(17 downto 0);
end package Types;
