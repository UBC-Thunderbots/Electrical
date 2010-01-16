library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Types.all;

entity ROM is
	generic(
		InitData : ROMDataType
	);
	port(
		Clock : in std_ulogic;
		Address : in natural range 0 to ROMLength - 1;
		Data : out std_ulogic_vector(17 downto 0)
	);
end entity ROM;

architecture Behavioural of ROM is
	signal Memory : ROMDataType;
	attribute rom_style : string;
	attribute rom_style of Memory : signal is "block";
begin
	Memory <= InitData;

	process(Clock)
	begin
		if rising_edge(Clock) then
			Data <= Memory(Address);
		end if;
	end process;
end architecture Behavioural;
