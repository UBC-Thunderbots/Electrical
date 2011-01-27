library ieee;
use ieee.std_logic_1164.all;
use work.types;

entity GrayCounter is
	port(
		Clock : in std_ulogic;
		Input : in types.encoder_t;
		Value : out types.encoder_count_t);
end entity GrayCounter;

architecture Behavioural of GrayCounter is
begin
	process(Clock)
		type DeltaType is (NONE, ADD, SUB);
		variable OldInput : types.encoder_t;
		variable Delta : DeltaType;
		variable ValueTemp : types.encoder_count_t := 0;
	begin
		if rising_edge(Clock) then
			if not OldInput(0) and not OldInput(1) and Input(0) and not Input(1) then 
				Delta := ADD;
			elsif OldInput(0) and not OldInput(1) and Input(0) and Input(1) then 
				Delta := ADD;
			elsif OldInput(0) and OldInput(1) and not Input(0) and Input(1) then 
				Delta := ADD;
			elsif not OldInput(0) and OldInput(1) and not Input(0) and not Input(1) then 
				Delta := ADD;
			elsif not OldInput(0) and not OldInput(1) and not Input(0) and Input(1) then 
				Delta := SUB;
			elsif not OldInput(0) and OldInput(1) and Input(0) and Input(1) then 
				Delta := SUB;
			elsif OldInput(0) and OldInput(1) and Input(0) and not Input(1) then 
				Delta := SUB;
			elsif OldInput(0) and not OldInput(1) and not Input(0) and not Input(1) then 
				Delta := SUB;
			else
				Delta := NONE;
			end if;

			if Delta /= NONE then
				if Delta = ADD then
					if ValueTemp = encoder_count_t'high then
						ValueTemp := 0;
					else
						ValueTemp := ValueTemp + 1;
					end if;
				else
					if ValueTemp = 0 then
						ValueTemp := encoder_count_t'high;
					else
						ValueTemp := ValueTemp - 1;
					end if;
				end if;
			end if;

			OldInput := Input;
		end if;

		Value <= ValueTemp;
	end process;
end architecture Behavioural;
