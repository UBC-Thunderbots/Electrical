library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

entity Motor is
	generic(
		PWMMax : positive;
		PWMPhase : natural);
	port(
		ClockMid : in std_ulogic;
		ClockHigh : in std_ulogic;
		Enable : in boolean;
		Power : in natural range 0 to PWMMax;
		Direction : in boolean;
		Hall : in hall_t;
		EncodersStrobe : in boolean;
		HallStuck : buffer boolean;
		HallCommutated : out boolean;
		Phases : out motor_phases_t);
end entity Motor;

architecture Behavioural of Motor is
	constant DeadBandSeconds : real := 80.0e-9;
	constant DeadBandWidth : natural := natural(DeadBandSeconds * real(ClockHighFrequency));
	signal CommutatorPhases : motor_phases_t;
	signal PWMOutput : boolean;
	signal PWMPhases : motor_phases_t;
begin
	process(ClockMid) is
		type seen_hall_high_t is array(0 to 2) of boolean;
		variable SeenHallHigh : seen_hall_high_t := (others => false);
	begin
		if rising_edge(ClockMid) then
			if EncodersStrobe then
				SeenHallHigh := (others => false);
			else
				for I in 0 to 2 loop
					if Hall(I) then
						SeenHallHigh(I) := true;
					end if;
				end loop;
			end if;
		end if;

		HallCommutated <= true;
		for I in 0 to 2 loop
			if not SeenHallHigh(I) then
				HallCommutated <= false;
			end if;
		end loop;
	end process;

	Commutator: entity work.Commutator(Behavioural)
	port map(
		Direction => Direction,
		Hall => Hall,
		HallStuck => HallStuck,
		Phase => CommutatorPhases);

	PWM: entity work.PWM(Behavioural)
	generic map(
		Max => PWMMax,
		Phase => PWMPhase)
	port map(
		Clock => ClockMid,
		Value => Power,
		Output => PWMOutput);

	GeneratePhases: for I in 0 to 2 generate
		process(ClockHigh) is
		begin
			if rising_edge(ClockHigh) then
				if Enable then
					if CommutatorPhases(I) = HIGH then
						if PWMOutput then
							PWMPhases(I) <= HIGH;
						else
							PWMPhases(I) <= LOW;
						end if;
					else
						PWMPhases(I) <= CommutatorPhases(I);
					end if;
				else
					PWMPhases(I) <= FLOAT;
				end if;
			end if;
		end process;

		DeadBand: entity work.DeadBand(Behavioural)
		generic map(
			Width => DeadBandWidth)
		port map(
			Clock => ClockHigh,
			Input => PWMPhases(I),
			Output => Phases(I));
	end generate;
end architecture Behavioural;
