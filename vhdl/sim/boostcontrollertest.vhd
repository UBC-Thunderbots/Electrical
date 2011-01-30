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
	signal Fault : boolean;
	signal Enable : boolean := false;
	signal Charge : boolean;
	signal Activity : boolean;
	signal CapVoltageReal : real := 14.4;
	signal BattVoltageReal : real := 14.4; 
	signal InductorCurrent : real := 0.0;
	signal InductorQuant : natural range 0 to 1000;
begin
	UUT: entity work.BoostController(Behavioural)
	port map(
		Clock => ClockLow,
		Enable => Enable,
		CapacitorVoltage => CapVoltage,
		BatteryVoltage => BattVoltage,
		Charge => Charge,
		Fault => Fault,
		Activity => Activity);

	process
	begin
		ClockLow <= '1';
		wait for ClockLowTime / 2;
		ClockLow <= '0';
		wait for ClockLowTime / 2; 
		
		if Done then
			wait;
		end if;
	end process;

	process
	begin
		Enable <= false;
		CapVoltage <= natural(CapVoltageReal / MaxCap * 4095.0);
		BattVoltage <= natural(BattVoltageReal / 18.3 * 1023.0);
		wait for 4.5 * ClockLowTime;
		Enable <= true;
		wait for 2 * ClockLowTime;
		while Activity and not Fault loop
			wait for 876 * ClockLowTime;
			CapVoltage <= natural(CapVoltageReal / MaxCap * 4095.0);
		end loop;

		while not Activity and not Fault loop
			wait for 876 * ClockLowTime;
			CapVoltage <= natural(CapVoltageReal / MaxCap * 4095.0);
		end loop;
		
		if Fault then -- capture some data after faulting
			wait for 500 ms;
		end if;
		
		Done <= true;
		wait;
	end process;

	process(ClockLow)
		variable CapVoltageDrop : real;
	begin
		if rising_edge(ClockLow) then
			CapVoltageDrop := CapVoltageReal / 220.0e3 / 4.5e-3 * 1.0e-6;
			
			if Charge then
				InductorCurrent <= InductorCurrent + BattVoltageReal / 22.0e-6 * 1.0e-6;
				CapVoltageReal <= CapVoltageReal - CapVoltageDrop;
			else
				InductorCurrent <= InductorCurrent - (CapVoltageReal + 0.7 - BattVoltageReal) * 1.0e-6 / 22.0e-6;
				CapVoltageReal <= CapVoltageReal + InductorCurrent / 4.5e-3 * 1.0e-6 - CapVoltageDrop;
			end if;

			if InductorCurrent < 0.0 then
				InductorCurrent <= 0.0;
			else
				InductorQuant <= natural(InductorCurrent);
			end if;
		end if;
	end process;

	assert InductorCurrent <= 10.5;
end architecture Behavioural;
