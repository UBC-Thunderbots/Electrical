library ieee;
use ieee.std_logic_1164.all;

library work;

entity GrayCounter is
	generic(
		Max : positive);
	port(
		Clock : in std_ulogic;
		Reset : in boolean;
		Input : in work.types.encoder;
		Strobe : in boolean;
		Value : out integer range -Max to Max);
end entity GrayCounter;

architecture Behavioural of GrayCounter is
begin
	process(Clock)
		type DeltaType is (NONE, ADD, SUB);

		variable Accumulator : integer range -Max to Max;
		variable OldInput : work.types.encoder;

		variable Delta : DeltaType;
	begin
		if rising_edge(Clock) then
			if Reset then
				Value <= 0;
				Accumulator := 0;
			else
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

				case Delta is
					when NONE => null;
					when ADD => Accumulator := Accumulator + 1;
					when SUB => Accumulator := Accumulator - 1;
				end case;

				if Strobe then
					Value <= Accumulator;
					Accumulator := 0;
				end if;
			end if;

			OldInput := Input;
		end if;
	end process;
end architecture Behavioural;
