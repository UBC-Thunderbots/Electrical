library ieee;
use ieee.std_logic_1164.all;

package Types is
	type ROMDataType is array(3 downto 0) of std_ulogic_vector(17 downto 0);
end package Types;
