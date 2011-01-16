library ieee;
use ieee.std_logic_1164.all;

library work;

entity DeadBand is
	generic(
		Width : natural);
	port(
		Clock : in std_ulogic;
		Reset : in boolean;
		Input : in work.types.motor_phase;
		Output : out work.types.motor_phase);
end entity DeadBand;

architecture Behavioural of DeadBand is
begin
	process(Clock) is
		subtype TimeoutType is natural range 0 to Width - 1;
		variable OldInput : work.types.motor_phase;
		variable Timeout : TimeoutType;
	begin
		if rising_edge(Clock) then
			if Reset then
				OldInput := work.types.FLOAT;
				Timeout := TimeoutType'high;
			else
				if Input /= OldInput then
					Timeout := TimeoutType'high;
				elsif Timeout /= 0 then
					Timeout := Timeout - 1;
				end if;
				OldInput := Input;
			end if;
		end if;

		if Timeout = 0 then
			Output <= OldInput;
		else
			Output <= work.types.FLOAT;
		end if;
	end process;
end architecture Behavioural;
