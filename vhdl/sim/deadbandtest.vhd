library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity DeadBandTest is
end entity DeadBandTest;

architecture Behavioural of DeadBandTest is
	type stimulus_t is array(natural range <>) of motor_phase_t;
	constant Stimulus : stimulus_t := (
		-- Flush through the startup delay.
		LOW,
		LOW,
		LOW,
		LOW,
		-- Perform an instant switch to verify that a delay is added.
		HIGH,
		HIGH,
		HIGH,
		HIGH,
		-- Pulse low for a moment then return high. Try this for a few different pulse widths.
		LOW,
		HIGH,
		HIGH,
		HIGH,
		HIGH,
		LOW,
		LOW,
		HIGH,
		HIGH,
		HIGH,
		HIGH,
		LOW,
		LOW,
		LOW,
		HIGH,
		HIGH,
		HIGH,
		HIGH,
		LOW,
		LOW,
		LOW,
		LOW,
		HIGH,
		HIGH,
		HIGH,
		HIGH,
		-- Oscillate rapidly.
		LOW,
		HIGH,
		LOW,
		HIGH,
		LOW,
		HIGH,
		LOW,
		HIGH,
		LOW,
		HIGH,
		LOW,
		HIGH,
		LOW,
		HIGH,
		LOW,
		HIGH,
		LOW,
		HIGH,
		-- Try explicitly floating for a while.
		HIGH,
		HIGH,
		HIGH,
		HIGH,
		FLOAT,
		LOW,
		LOW,
		LOW,
		LOW,
		FLOAT,
		FLOAT,
		HIGH,
		HIGH,
		HIGH,
		HIGH,
		FLOAT,
		FLOAT,
		FLOAT,
		LOW,
		-- Do some random crap.
		HIGH,
		FLOAT,
		HIGH,
		FLOAT,
		LOW,
		FLOAT,
		HIGH);
	signal Done : boolean := false;
	signal Clock : std_ulogic := '0';
	signal Input : motor_phase_t := LOW;
	signal Output : motor_phase_t;
begin
	-- Construct the unit under test.
	UUT: entity work.DeadBand(Behavioural)
	generic map(
		Width => 3)
	port map(
		Clock => Clock,
		Input => Input,
		Output => Output);

	-- Generate a 1MHz clock.
	process
	begin
		while not Done loop
			Clock <= '1';
			wait for 0.5 us;
			Clock <= '0';
			wait for 0.5 us;
		end loop;
		wait;
	end process;

	-- Direct the stimulus into the UUT.
	process(Clock)
		variable I : natural range 0 to Stimulus'Length := 0;
	begin
		if rising_edge(Clock) then
			if I < Stimulus'Length then
				Input <= Stimulus(I);
				I := I + 1;
			else
				Done <= true;
			end if;
		end if;
	end process;

	-- Verify that no transition from LOW to HIGH ever occurs with less than 2 ticks of FLOAT between.
	process
		variable StartTime : time;
		variable EndTime : time;
	begin
		wait until Output = LOW;
		wait until Output /= LOW;
		StartTime := NOW;
		assert Output = FLOAT;
		wait until Output /= FLOAT;
		if Output = HIGH then
			EndTime := NOW;
			assert (EndTime - StartTime) >= 3 us;
		end if;
	end process;

	-- Verify that no transition from HIGH to LOW ever occurs with less than 2 ticks of FLOAT between.
	process
		variable StartTime : time;
		variable EndTime : time;
	begin
		wait until Output = HIGH;
		wait until Output /= HIGH;
		StartTime := NOW;
		assert Output = FLOAT;
		wait until Output /= FLOAT;
		if Output = LOW then
			EndTime := NOW;
			assert (EndTime - StartTime) >= 3 us;
		end if;
	end process;
end architecture Behavioural;
