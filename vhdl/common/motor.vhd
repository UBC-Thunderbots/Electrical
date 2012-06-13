library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

entity Motor is
	generic(
		PWMMax : positive;
		PWMPhase : natural);
	port(
		Clocks : in clocks_t;
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
	signal PWMPhases : motor_phases_t;
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
		Clock => Clocks.Clock8MHz,
		Value => Power,
		Output => PWMOutput);

	GeneratePhases: for I in 0 to 2 generate
		process(Clocks.Clock8MHz) is
		begin
			if rising_edge(Clocks.Clock8MHz) then
				case Mode is
					when FLOAT =>
						PWMPhases(I) <= FLOAT;

					when BRAKE =>
						PWMPhases(I) <= LOW;

					when FORWARD | REVERSE =>
						if CommutatorPhases(I) = HIGH then
							if PWMOutput then
								PWMPhases(I) <= HIGH;
							else
								PWMPhases(I) <= LOW;
							end if;
						else
							PWMPhases(I) <= CommutatorPhases(I);
						end if;
				end case;
			end if;
		end process;

		DeadBand: entity work.DeadBand(Arch)
		port map(
			Clock => Clocks.Clock4MHz,
			Input => PWMPhases(I),
			Output => Phases(I));
	end generate;
end architecture Arch;
