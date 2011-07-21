library ieee;
use ieee.std_logic_1164.all;

entity SyncDownStrobe is
	port(
		ClockInput : in std_ulogic;
		ClockOutput : in std_ulogic;
		Input : in boolean;
		Output : out boolean := false);
end entity SyncDownStrobe;

architecture Behavioural of SyncDownStrobe is
	signal Req : boolean := false;
	signal Ack : boolean := false;
begin
	process(ClockInput) is
	begin
		if rising_edge(ClockInput) then
			if Input then
				Req <= not Req;
			end if;
		end if;
	end process;

	process(ClockOutput) is
	begin
		if rising_edge(ClockOutput) then
			Output <= Req /= Ack;
			Ack <= Req;
		end if;
	end process;
end architecture Behavioural;
