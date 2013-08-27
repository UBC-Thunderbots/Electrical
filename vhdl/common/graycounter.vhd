library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types;

entity GrayCounter is
	port(
		clk : in std_ulogic;
		Input : in work.types.encoder_t;
		Value : buffer work.types.motor_position_t);
end entity GrayCounter;

architecture RTL of GrayCounter is
	signal OldInput : work.types.encoder_t;
begin
	process(clk) is
		type delta_t is (NONE, ADD, SUB);
		variable Delta : delta_t;
	begin
		if rising_edge(clk) then
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

			case Delta is
				when NONE => null;
				when ADD => Value <= Value + 1;
				when SUB => Value <= Value - 1;
			end case;

			OldInput <= Input;
		end if;
	end process;
end architecture RTL;
