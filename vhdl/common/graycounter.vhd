library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity GrayCounter is
	port(
		Clock : in std_ulogic;
		Input : in encoder_t;
		Clear : in boolean;
		Value : out encoder_count_t);
end entity GrayCounter;

architecture Arch of GrayCounter is
begin
	process(Clock) is
		type DeltaType is (NONE, ADD, SUB);
		variable OldInput : encoder_t;
		variable Delta : DeltaType;
		variable ValueInternal : encoder_count_t := 0;
	begin
		if rising_edge(Clock) then
			if Clear then
				ValueInternal := 0;
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
						ValueInternal := ValueInternal + 1;
					else
						ValueInternal := ValueInternal - 1;
					end if;
				end if;

				OldInput := Input;
			end if;
		end if;

		Value <= ValueInternal;
	end process;
end architecture Arch;
