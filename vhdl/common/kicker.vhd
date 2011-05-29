library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity Kicker is
	port(
		ClockHigh : in std_ulogic;
		ClockLow : in std_ulogic;
		Strobe : in boolean;
		Power : in kicker_powers_t;
		Offset : in kicker_offset_t;
		OffsetDisableMask : in kicker_offset_disable_mask_t;
		Active : out kicker_active_t);
end entity Kicker;

architecture Behavioural of Kicker is
	signal StrobeLow : boolean;
begin
	SyncDownStrobe: entity work.SyncDownStrobe(Behavioural)
	port map(
		ClockHigh => ClockHigh,
		ClockLow => ClockLow,
		Input => Strobe,
		Output => StrobeLow);

	process(ClockLow, Power, OffsetDisableMask) is
		variable PulseCounter : kicker_power_t := kicker_power_t'high;
		variable OffsetCounter : kicker_offset_t := 0;
	begin
		if rising_edge(ClockLow) then
			if StrobeLow then
				PulseCounter := 0;
				OffsetCounter := Offset;
			else
				if PulseCounter /= kicker_power_t'high then
					PulseCounter := PulseCounter + 1;
				end if;
				if OffsetCounter /= 0 then
					OffsetCounter := OffsetCounter - 1;
				end if;
			end if;
		end if;

		for I in 1 to 2 loop
			Active(I) <= PulseCounter < Power(I) and (OffsetCounter = 0 or OffsetDisableMask(I));
		end loop;
	end process;
end architecture Behavioural;
