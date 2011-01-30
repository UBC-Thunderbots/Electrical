library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

entity DeadBand is
	generic(
		Width : natural);
	port(
		Clock : in std_ulogic;
		Input : in motor_phase_t;
		Output : out motor_phase_t);
end entity DeadBand;

architecture Behavioural of DeadBand is
begin
	process(Clock) is
		subtype timeout_t is natural range 0 to Width - 1;
		variable OldInput : motor_phase_t := FLOAT;
		variable Timeout : timeout_t := timeout_t'high;
	begin
		if rising_edge(Clock) then
			if Input /= OldInput then
				Timeout := timeout_t'high;
			elsif Timeout /= 0 then
				Timeout := Timeout - 1;
			end if;
			OldInput := Input;
		end if;

		if Timeout = 0 then
			Output <= OldInput;
		else
			Output <= FLOAT;
		end if;
	end process;
end architecture Behavioural;
