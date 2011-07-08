library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity GrayCounter is
	port(
		Clock : in std_ulogic;
		Input : in encoder_t;
		Strobe : in boolean;
		Value : out encoder_count_t;
		SeenAllStates : out boolean := false);
end entity GrayCounter;

architecture Behavioural of GrayCounter is
begin
	process(Clock) is
		type seen_t is array(0 to 1) of boolean;
		variable SeenLow, SeenHigh : seen_t := (others => false);
	begin
		if rising_edge(Clock) then
			if Strobe then
				SeenLow := (others => false);
				SeenHigh := (others => false);
			else
				for I in 0 to 1 loop
					if Input(I) then
						SeenHigh(I) := true;
					else
						SeenLow(I) := true;
					end if;
				end loop;
			end if;
		end if;

		SeenAllStates <= SeenLow(0) and SeenLow(1) and SeenHigh(0) and SeenHigh(1);
	end process;

	process(Clock) is
		type DeltaType is (NONE, ADD, SUB);
		variable OldInput : encoder_t;
		variable Delta : DeltaType;
		variable ValueTemp : encoder_count_t := 0;
	begin
		if rising_edge(Clock) then
			if Strobe then
				Value <= ValueTemp;
				ValueTemp := 0;
			else
				if not OldInput(0) and not OldInput(1) and Input(0) and not Input(1) then 
					Delta := SUB;
				elsif OldInput(0) and not OldInput(1) and Input(0) and Input(1) then 
					Delta := SUB;
				elsif OldInput(0) and OldInput(1) and not Input(0) and Input(1) then 
					Delta := SUB;
				elsif not OldInput(0) and OldInput(1) and not Input(0) and not Input(1) then 
					Delta := SUB;
				elsif not OldInput(0) and not OldInput(1) and not Input(0) and Input(1) then 
					Delta := ADD;
				elsif not OldInput(0) and OldInput(1) and Input(0) and Input(1) then 
					Delta := ADD;
				elsif OldInput(0) and OldInput(1) and Input(0) and not Input(1) then 
					Delta := ADD;
				elsif OldInput(0) and not OldInput(1) and not Input(0) and not Input(1) then 
					Delta := ADD;
				else
					Delta := NONE;
				end if;

				if Delta /= NONE then
					if Delta = ADD then
						ValueTemp := ValueTemp + 1;
					else
						ValueTemp := ValueTemp - 1;
					end if;
				end if;

				OldInput := Input;
			end if;
		end if;
	end process;
end architecture Behavioural;
