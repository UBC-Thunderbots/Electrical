library ieee;
use ieee.std_logic_1164.all;

library work;

entity Motor is
	generic(
		PWMMax : positive);
	port(
		PWMClock : in std_ulogic;
		ClockHigh : in std_ulogic;
		Reset : in boolean;
		Power : in natural range 0 to PWMMax;
		Reverse	: in boolean;
		HallSensor : in work.types.hall;
		AllLow : out boolean;
		AllHigh : out boolean;
		Phase : out work.types.motor_phase3);
end entity Motor;

architecture Behavioural of Motor is
	constant DeadBandSeconds : real := 50.0e-9;
	constant DeadBandWidth : natural := natural(DeadBandSeconds * real(work.clock.HighFrequency) + 0.5);
	signal CommutatorPhase : work.types.motor_phase3;
	signal PWMOutput : boolean;
	signal PWMPhase : work.types.motor_phase3;
begin
	Commutator: entity work.Commutator(Behavioural)
	port map(
		Reverse => Reverse,
		HallSensor => HallSensor,
		AllLow => AllLow,
		AllHigh => AllHigh,
		Phase => CommutatorPhase);

	PWM: entity work.PWM(Behavioural)
	generic map(
		Max => PWMMax)
	port map(
		Clock => PWMClock,
		Reset => Reset,
		Value => Power,
		Output => PWMOutput);

	Phases: for I in 1 to 3 generate
		process(CommutatorPhase(I), PWMOutput) is
		begin
			if CommutatorPhase(I) = work.types.HIGH then
				if PWMOutput then
					PWMPhase(I) <= work.types.HIGH;
				else
					PWMPhase(I) <= work.types.FLOAT;
				end if;
			else
				PWMPhase(I) <= CommutatorPhase(I);
			end if;
		end process;

		DeadBand: entity work.DeadBand(Behavioural)
		generic map(
			Width => DeadBandWidth)
		port map(
			Clock => ClockHigh,
			Reset => Reset,
			Input => PWMPhase(I),
			Output => Phase(I));
	end generate;
end architecture Behavioural;
