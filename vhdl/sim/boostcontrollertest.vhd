library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

entity BoostControllerTest is
end entity;

architecture Behavioural of BoostControllerTest is
	constant MaxCap : real := 330.0;	--! Voltage of Cap at maximum ADC range

	signal Done : boolean := false;
	signal ClockLow : std_logic := '0';
	signal CapVoltage : natural range 0 to 4095;
	signal BattVoltage : natural range 0 to 1023;
	signal Timeout : boolean;
	signal Enable : boolean := false;
	signal Charge : boolean;
	signal Activity : boolean;
	signal CapVoltageReal : real := 14.4;
	signal BattVoltageReal : real := 14.4; 
	signal InductorCurrent : real := 0.0;
	signal InductorCurrentMilliamps : natural;
begin
	UUT: entity work.BoostController(Behavioural)
	port map(
		ClockLow => ClockLow,
		Enable => Enable,
		CapacitorVoltage => CapVoltage,
		BatteryVoltage => BattVoltage,
		Charge => Charge,
		Timeout => Timeout,
		Activity => Activity);

	process
	begin
		ClockLow <= '1';
		wait for (ClockLowTime / 2.0) * 1 sec;
		ClockLow <= '0';
		wait for (ClockLowTime / 2.0) * 1 sec;
		
		if Done then
			wait;
		end if;
	end process;

	process
	begin
		Enable <= false;
		CapVoltage <= natural(CapVoltageReal / MaxCap * 4096.0 + 0.5);
		BattVoltage <= natural(BattVoltageReal / 18.3 * 1024.0);
		wait for (4.5 * ClockLowTime) * 1 sec;
		Enable <= true;
		wait for (2.0 * ClockLowTime) * 1 sec;
		while Activity and not Timeout loop
			wait for (876.0 * ClockLowTime) * 1 sec;
			CapVoltage <= natural(CapVoltageReal / MaxCap * 4096.0 + 0.5);
		end loop;

		assert not Timeout;
		assert CapVoltageReal >= 227.0;

		wait for 250 ms;
		
		Done <= true;
		wait;
	end process;

	process(ClockLow)
		variable CapVoltageDrop : real;
		variable NewInductorCurrent : real;
	begin
		if rising_edge(ClockLow) then
			CapVoltageDrop := CapVoltageReal / 220.0e3 / 4.5e-3 * 1.0e-6;
			
			if Charge then
				NewInductorCurrent := InductorCurrent + BattVoltageReal / 22.0e-6 * 1.0e-6;
				CapVoltageReal <= CapVoltageReal - CapVoltageDrop;
			else
				NewInductorCurrent := InductorCurrent - (CapVoltageReal + 0.7 - BattVoltageReal) * 1.0e-6 / 22.0e-6;
				CapVoltageReal <= CapVoltageReal + InductorCurrent / 4.5e-3 * 1.0e-6 - CapVoltageDrop;
			end if;

			if NewInductorCurrent < 0.0 then
				NewInductorCurrent := 0.0;
			end if;

			InductorCurrent <= NewInductorCurrent;
		end if;
	end process;

	InductorCurrentMilliamps <= natural(InductorCurrent * 1000.0);

	assert InductorCurrent <= 10.5 severity failure;
end architecture Behavioural;
