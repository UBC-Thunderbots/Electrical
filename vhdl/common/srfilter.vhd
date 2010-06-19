library ieee;
use ieee.std_logic_1164.all;

entity SRFilter is
	generic(
		Width : positive;
		Default : std_ulogic
	);
	port(
		Clock : in std_ulogic;
		Input : in std_ulogic;
		Output : out std_ulogic := Default
	);
end entity SRFilter;

architecture Behavioural of SRFilter is
	signal Shifter : std_ulogic_vector(Width - 1 downto 0);
begin
	process(Clock)
		variable Same : boolean;
	begin
		if rising_edge(Clock) then
			Shifter <= Shifter(Width - 2 downto 0) & Input;
			Same := true;
			for I in 1 to Width - 1 loop
				Same := Same and (Shifter(I) = Shifter(I - 1));
			end loop;
			if Same then
				Output <= Shifter(0);
			end if;
		end if;
	end process;
end architecture Behavioural;
