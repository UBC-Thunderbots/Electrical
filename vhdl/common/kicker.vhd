library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity Kicker is
	port(
		ClockMid : in std_ulogic;
		ClockLow : in std_ulogic;
		Strobe : in boolean;
		Power : in kicker_times_t;
		Offset : in kicker_time_t;
		OffsetSign : in boolean;
		Active : out kicker_active_t);
end entity Kicker;

architecture Behavioural of Kicker is
	signal StrobeLow : boolean;
	signal PulseCounters : kicker_times_t := (others => 0);
	signal OffsetCounter : kicker_time_t := 0;

	impure function PulseCounterEnabled(Index : natural range 1 to 2) return boolean is
	begin
		if Index = 1 then
			return OffsetSign or OffsetCounter = 0;
		else
			return not OffsetSign or OffsetCounter = 0;
		end if;
	end function PulseCounterEnabled;
begin
	SyncDownStrobe: entity work.SyncDownStrobe(Behavioural)
	port map(
		ClockInput => ClockMid,
		ClockOutput => ClockLow,
		Input => Strobe,
		Output => StrobeLow);

	process(ClockLow) is
	begin
		if rising_edge(ClockLow) then
			if StrobeLow then
				PulseCounters <= Power;
				OffsetCounter <= Offset;
			else
				for I in 1 to 2 loop
					if PulseCounterEnabled(I) and PulseCounters(I) /= 0 then
						PulseCounters(I) <= PulseCounters(I) - 1;
					end if;
				end loop;
				if OffsetCounter /= 0 then
					OffsetCounter <= OffsetCounter - 1;
				end if;
			end if;
		end if;
	end process;

	process(ClockLow) is
	begin
		if rising_edge(ClockLow) then
			for I in 1 to 2 loop
				Active(I) <= PulseCounterEnabled(I) and PulseCounters(I) /= 0;
			end loop;
		end if;
	end process;
end architecture Behavioural;
