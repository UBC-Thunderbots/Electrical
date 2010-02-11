library ieee;
use ieee.std_logic_1164.all;

entity LFSR10 is
    port(
		Clock : in std_ulogic;
		Shift : in std_ulogic;
		Reset : in std_ulogic;
		Data : out std_ulogic
	);	  
end entity LFSR10;

architecture Behavioural of LFSR10 is
	signal State : std_ulogic_vector(9 downto 0) := "1111111111";
begin
	Data <= State(0);

	process(Clock)
	begin
		if rising_edge(Clock) then
			if Reset = '1' then
				State <= "1111111111";
			elsif Shift = '1' then
				State <= (State(3) xor State(0)) & State(9 downto 1);
			end if;
		end if;
	end process;
end architecture Behavioural;
