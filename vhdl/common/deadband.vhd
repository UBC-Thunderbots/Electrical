library ieee;
use ieee.std_logic_1164.all;
use work.clock;
use work.types;

entity DeadBand is
	generic(
		Width : natural);
	port(
		Clock : in std_ulogic;
		Reset : in boolean;
		Input : in types.motor_phase_t;
		Output : out types.motor_phase_t);
end entity DeadBand;

architecture Behavioural of DeadBand is
begin
	process(Clock) is
		subtype timeout_t is natural range 0 to Width - 1;
		variable OldInput : types.motor_phase_t;
		variable Timeout : timeout_t;
	begin
		if rising_edge(Clock) then
			if Reset then
				OldInput := types.FLOAT;
				Timeout := timeout_t'high;
			else
				if Input /= OldInput then
					Timeout := timeout_t'high;
				elsif Timeout /= 0 then
					Timeout := Timeout - 1;
				end if;
				OldInput := Input;
			end if;
		end if;

		if Timeout = 0 then
			Output <= OldInput;
		else
			Output <= types.FLOAT;
		end if;
	end process;
end architecture Behavioural;
