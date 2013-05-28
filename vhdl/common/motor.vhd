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
		Control : in motor_control_t;
		Hall : in hall_t;
		HallStuckHigh : out boolean;
		HallStuckLow : out boolean;
		Drive : out motor_drive_phases_t);
end entity Motor;

architecture Arch of Motor is
	signal CommutatorPhases : motor_control_phases_t;
	signal PWMOutput : boolean;
begin
	Commutator: entity work.Commutator(Arch)
	port map(
		Clock => Clock,
		Direction => Control.Direction,
		Hall => Hall,
		HallStuckHigh => HallStuckHigh,
		HallStuckLow => HallStuckLow,
		Phase => CommutatorPhases);

	PWMGenerator: entity work.PWM(Arch)
	generic map(
		Max => PWMMax,
		Phase => PWMPhase)
	port map(
		Clock => Clock,
		Value => Control.Power,
		Output => PWMOutput);

	process(Clock) is
		variable ControlPhase : motor_control_phase_t;
		variable PWMPhase : motor_drive_phase_t;
	begin
		if rising_edge(Clock) then
			if PWMOutput then
				PWMPhase := HIGH;
			else
				PWMPhase := LOW;
			end if;
			for I in 0 to 2 loop
				if Control.AutoCommutate then
					ControlPhase := CommutatorPhases(I);
				else
					ControlPhase := Control.Phases(I);
				end if;
				case ControlPhase is
					when FLOAT => Drive(I) <= FLOAT;
					when PWM => Drive(I) <= PWMPhase;
					when LOW => Drive(I) <= LOW;
					when HIGH => Drive(I) <= HIGH;
				end case;
			end loop;
		end if;
	end process;
end architecture Arch;
