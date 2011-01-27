library ieee;
use ieee.std_logic_1164.all;
use work.clock;
use work.types;

entity Motor is
	generic(
		PWMMax : positive);
	port(
		PWMClock : in std_ulogic;
		ClockHigh : in std_ulogic;
		Enable : in boolean;
		Power : in natural range 0 to PWMMax;
		Direction	: in boolean;
		Hall : in types.hall_t;
		AllLow : out boolean;
		AllHigh : out boolean;
		Phases : out types.motor_phases_t);
end entity Motor;

architecture Behavioural of Motor is
	constant DeadBandSeconds : real := 50.0e-9;
	constant DeadBandWidth : natural := natural(DeadBandSeconds * real(clock.HighFrequency));
	signal CommutatorPhases : types.motor_phases_t;
	signal PWMOutput : boolean;
	signal PWMPhases : types.motor_phases_t;
begin
	Commutator: entity Commutator(Behavioural)
	port map(
		Direction => Direction,
		Hall => Hall,
		AllLow => AllLow,
		AllHigh => AllHigh,
		Phase => CommutatorPhases);

	PWM: entity PWM(Behavioural)
	generic map(
		Max => PWMMax)
	port map(
		Clock => PWMClock,
		Value => Power,
		Output => PWMOutput);

	GeneratePhases: for I in 0 to 2 generate
		process(Enable, CommutatorPhases(I), PWMOutput) is
		begin
			if Enable then
				if CommutatorPhases(I) = types.HIGH then
					if PWMOutput then
						PWMPhases(I) <= types.HIGH;
					else
						PWMPhases(I) <= types.FLOAT;
					end if;
				else
					PWMPhases(I) <= CommutatorPhases(I);
				end if;
			else
				PWMPhases(I) <= types.FLOAT;
			end if;
		end process;

		DeadBand: entity DeadBand(Behavioural)
		generic map(
			Width => DeadBandWidth)
		port map(
			Clock => ClockHigh,
			Input => PWMPhases(I),
			Output => Phases(I));
	end generate;
end architecture Behavioural;
