library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity BoostControllerTest is
end entity;

architecture Behavioural of BoostControllerTest is
	constant ClockTime : time := 250 ns;
	constant ClockTimeSecs : real := real(ClockTime / 1 ns) * 1.0e-9;
	constant Capacitance : real := 4.0e-3;
	constant MaxCap : real := 303.3;	--! Voltage of Cap at maximum ADC range

	signal Done : boolean := false;
	signal Clock : std_logic := '0';
	signal CapVoltage : capacitor_voltage_t;
	signal BattVoltage : battery_voltage_t;
	signal Timeout : boolean;
	signal Enable : boolean := false;
	signal Charge : boolean;
	signal Activity : boolean;
	signal CapVoltageReal : real := 14.4;
	signal CapVoltageInteger : natural;
	signal BattVoltageReal : real := 14.4; 
	signal InductorCurrent : real := 0.0;
	signal InductorCurrentMilliamps : natural;
begin
	UUT: entity work.BoostController(Arch)
	generic map(
		ClockFrequency => real(1.0 sec / ClockTime))
	port map(
		Clock => Clock,
		Enable => Enable,
		CapacitorVoltage => CapVoltage,
		BatteryVoltage => BattVoltage,
		Charge => Charge,
		Timeout => Timeout,
		Activity => Activity);

	process
	begin
		Clock <= '1';
		wait for ClockTime / 2.0;
		Clock <= '0';
		wait for ClockTime / 2.0;
		
		if Done then
			wait;
		end if;
	end process;

	process
	begin
		Enable <= false;
		CapVoltage <= natural(CapVoltageReal / MaxCap * 1024.0);
		BattVoltage <= natural(BattVoltageReal / 33.3 * 1024.0);
		wait for 4.5 * ClockTime;
		Enable <= true;
		wait for 2.0 * ClockTime;
		while Activity and not Timeout loop
			wait for 876.0 * ClockTime;
			CapVoltage <= natural(CapVoltageReal / MaxCap * 1024.0);
		end loop;

		assert not Timeout;
		assert CapVoltageReal >= 237.0;

		wait for 250 ms;
		
		Done <= true;
		wait;
	end process;

	process(Clock)
		variable CapVoltageDrop : real;
		variable NewInductorCurrent : real;
	begin
		if rising_edge(Clock) then
			CapVoltageDrop := CapVoltageReal / 220.0e3 / 4.5e-3 * 1.0e-6;
			
			if Charge then
				NewInductorCurrent := InductorCurrent + BattVoltageReal / 22.0e-6 * ClockTimeSecs;
				CapVoltageReal <= CapVoltageReal - CapVoltageDrop;
			else
				NewInductorCurrent := InductorCurrent - (CapVoltageReal + 0.7 - BattVoltageReal) / 22.0e-6 * ClockTimeSecs;
				CapVoltageReal <= CapVoltageReal + InductorCurrent / Capacitance * ClockTimeSecs - CapVoltageDrop;
			end if;

			if NewInductorCurrent < 0.0 then
				NewInductorCurrent := 0.0;
			end if;

			InductorCurrent <= NewInductorCurrent;
		end if;
	end process;

	InductorCurrentMilliamps <= natural(InductorCurrent * 1000.0);
	CapVoltageInteger <= natural(CapVoltageReal);

	assert InductorCurrent <= 10.5 severity failure;
end architecture Behavioural;
