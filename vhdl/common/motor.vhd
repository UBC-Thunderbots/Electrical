library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

entity Motor is
	generic(
		PWMMax : positive;
		PWMPhase : natural);
	port(
		Clock : in std_ulogic;
		Mode : in motor_mode_t;
		Power : in natural range 0 to PWMMax;
		Hall : in hall_t;
		HallStuckHigh : out boolean;
		HallStuckLow : out boolean;
		Phases : out motor_phases_t);
end entity Motor;

architecture Arch of Motor is
	signal Direction : boolean;
	signal CommutatorPhases : motor_phases_t;
	signal PWMOutput : boolean;
begin
	Direction <= Mode = REVERSE;

	Commutator: entity work.Commutator(Arch)
	port map(
		Direction => Direction,
		Hall => Hall,
		HallStuckHigh => HallStuckHigh,
		HallStuckLow => HallStuckLow,
		Phase => CommutatorPhases);

	PWM: entity work.PWM(Arch)
	generic map(
		Max => PWMMax,
		Phase => PWMPhase)
	port map(
		Clock => Clock,
		Value => Power,
		Output => PWMOutput);

	GeneratePhases: for I in 0 to 2 generate
		process(Clock) is
		begin
			if rising_edge(Clock) then
				case Mode is
					when FLOAT =>
						Phases(I) <= FLOAT;

					when BRAKE =>
						Phases(I) <= LOW;

					when FORWARD | REVERSE =>
						if CommutatorPhases(I) = HIGH then
							if PWMOutput then
								Phases(I) <= HIGH;
							else
								Phases(I) <= LOW;
							end if;
						else
							Phases(I) <= CommutatorPhases(I);
						end if;
				end case;
			end if;
		end process;
	end generate;
end architecture Arch;
