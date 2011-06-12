library ieee;
use ieee.std_logic_1164.all;
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
	signal OldOutput : motor_phase_t := HIGH;
	signal CurOutput : motor_phase_t;
	subtype timeout_t is natural range 0 to Width;
	signal Timeout : timeout_t := 0;
begin
	CurOutput <= Input when Input = OldOutput or Timeout = timeout_t'high else FLOAT;

	Output <= FLOAT when Input = FLOAT else CurOutput;

	process(Clock) is
	begin
		if rising_edge(Clock) then
			if CurOutput = FLOAT then
				if Timeout /= timeout_t'high then
					Timeout <= Timeout + 1;
				end if;
			else
				Timeout <= 0;
				OldOutput <= CurOutput;
			end if;
		end if;
	end process;
end architecture Behavioural;
