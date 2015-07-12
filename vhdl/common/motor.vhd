library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.motor_common.all;
use work.types.all;

--! Ties together all the entities related to one motor.
entity Motor is
	generic(
		PWMPhase : natural); --! The reset value of the PWM counter.
	port(
		Reset : in boolean; --! The system reset signal.
		HostClock : in std_ulogic; --! The system clock.
		PWMClock : in std_ulogic; --! The PWM timebase clock.
		DriveMode : in motor_drive_mode; --! The requested operation mode.
		HallCount : buffer hall_count; --! The accumulated Hall sensor edge count.
		StuckLow : buffer boolean; --! Whether the sensors are currently stuck low.
		StuckHigh : buffer boolean; --! Whether the sensors are currently stuck high.
		HallFiltered : in std_ulogic_vector(0 to 2); --! The majority-detected Hall sensor signals.
		PhasesHPin : buffer std_ulogic_vector(0 to 2); --! The wires to the high-side motor phase drivers.
		PhasesLPin : buffer std_ulogic_vector(0 to 2)); --! The wires to the low-side motor phase drivers.
end entity Motor;

architecture RTL of Motor is
	-- The Hall sensor signals, converted to booleans.
	signal Hall : boolean_vector(0 to 2);

	-- The phases, as generated by the automatic commutator.
	signal CommutatorPhases : phase_drive_mode_vector(PhasesHPin'range);

	-- The output of the PWM generator.
	signal PWMOutput : boolean;
begin
	-- Convert Hall sensor signals to boolean.
	process(HallFiltered) is
		variable I : natural range 0 to 2;
	begin
		for I in 0 to 2 loop
			Hall(I) <= to_boolean(HallFiltered(I));
		end loop;
	end process;

	-- Generate an automatic commutation pattern given the motor's current position.
	Commutator : entity work.MotorCommutator(RTL)
	port map(
		Reset => Reset,
		HostClock => HostClock,
		Direction => DriveMode.Direction,
		Hall => Hall,
		Phases => CommutatorPhases,
		StuckHigh => StuckHigh,
		StuckLow => StuckLow);

	-- Generate a PWM waveform based on the duty cycle in the parameter block.
	MotorPWM : entity work.MotorPWM(RTL)
	generic map(
		Phase => PWMPhase)
	port map(
		Reset => Reset,
		PWMClock => PWMClock,
		DutyCycle => DriveMode.DutyCycle,
		Output => PWMOutput);

	-- Based on the requested mode, send the appropriate signals to the output.
	process(HostClock) is
		variable PWMPhase, PhaseDrive : phase_drive_mode;
	begin
		if rising_edge(HostClock) then
			-- Transform the PWM signal into a phase value.
			if PWMOutput then
				PWMPhase := HIGH;
			else
				PWMPhase := LOW;
			end if;

			-- Work the phases.
			for I in PhasesHPin'range loop
				-- Choose what phase drive will be used on this phase.
				case DriveMode.Mode is
					when COAST => PhaseDrive := FLOAT;
					when BRAKE => PhaseDrive := LOW;
					when DRIVE => PhaseDrive := CommutatorPhases(I);
				end case;

				-- Apply PWM if selected.
				if PhaseDrive = PWM then
					PhaseDrive := PWMPhase;
				end if;

				-- Generate outputs.
				case PhaseDrive is
					when LOW => 
						PhasesHPin(I) <= '0';
						PhasesLPin(I) <= '1';
					when HIGH =>
						PhasesHPin(I) <= '1';
						PhasesLPin(I) <= '0';
					when others =>
						PhasesHPin(I) <= '0';
						PhasesLPin(I) <= '0';
				end case;
			end loop;
		end if;
	end process;

	-- Decode current speed.
	HallSpeed : entity work.MotorHallSpeed(RTL)
	port map(
		HostClock => HostClock,
		Hall => Hall,
		Value => HallCount);
end architecture RTL;
