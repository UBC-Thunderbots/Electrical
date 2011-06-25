library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

entity Motor is
	generic(
		PWMMax : positive);
	port(
		ClockLow : in std_ulogic;
		ClockMid : in std_ulogic;
		ClockHigh : in std_ulogic;
		Enable : in boolean;
		Power : in natural range 0 to PWMMax;
		Direction	: in boolean;
		Hall : in hall_t;
		AllLow : out boolean;
		AllHigh : out boolean;
		Phases : out motor_phases_t);
end entity Motor;

architecture Behavioural of Motor is
	constant DeadBandSeconds : real := 80.0e-9;
	constant DeadBandWidth : natural := natural(DeadBandSeconds * real(ClockHighFrequency));
	signal HallFiltered : hall_t;
	signal CommutatorPhases : motor_phases_t;
	signal PWMOutput : boolean;
	signal PWMPhases : motor_phases_t;
begin
	FilterHalls: for I in 0 to 2 generate
		process(ClockLow) is
			constant WindowSize : natural := 25;
			constant Threshold : natural := WindowSize / 2;
			type shift_reg_t is array(0 to WindowSize - 1) of boolean;
			variable ShiftReg : shift_reg_t := (others => false);
			variable Counter : natural range 0 to WindowSize := 0;
		begin
			if rising_edge(ClockLow) then
				if Hall(I) /= ShiftReg(WindowSize - 1) then
					if Hall(I) then
						Counter := Counter + 1;
					else
						Counter := Counter - 1;
					end if;
				end if;
				ShiftReg := Hall(I) & ShiftReg(0 to WindowSize - 2);
			end if;

			HallFiltered(I) <= Counter >= Threshold;
		end process;
	end generate;

	Commutator: entity work.Commutator(Behavioural)
	port map(
		Direction => Direction,
		Hall => HallFiltered,
		AllLow => AllLow,
		AllHigh => AllHigh,
		Phase => CommutatorPhases);

	PWM: entity work.PWM(Behavioural)
	generic map(
		Max => PWMMax)
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
