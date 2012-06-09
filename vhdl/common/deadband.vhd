library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity DeadBand is
	port(
		Clock : in std_ulogic;
		Input : in motor_phase_t;
		Output : out motor_phase_t);
end entity DeadBand;

architecture Arch of DeadBand is
begin
	process(Clock) is
		variable OutputInternal : motor_phase_t := FLOAT;
	begin
		if rising_edge(Clock) then
			if (Input = HIGH and OutputInternal = LOW) or (Input = LOW and OutputInternal = HIGH) then
				OutputInternal := FLOAT;
			else
				OutputInternal := Input;
			end if;
		end if;

		Output <= OutputInternal;
	end process;
end architecture Arch;
