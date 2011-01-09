library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity BoostControllerTest is
end entity;

architecture Behavioural of BoostControllerTest is
	constant ClockPeriod : time := 1 uS;
	signal Done : std_logic := '0';
	signal Clock : std_logic := '0';
	signal Reset : std_logic := '1';
	signal CapVoltage : natural range 0 to 4095;
	signal BattVoltage : natural range 0 to 1023;
	signal Fault : std_logic := '0';
	signal Charge : std_logic := '0';
	signal Switch : std_logic := '0';
	signal Activity : std_logic := '0';
	signal CapVoltageReal : real := 14.4;
	signal BattVoltageReal : real := 14.4; 
	signal InductorCurrent : real := 0.0;
	signal InductorQuant : natural range 0 to 1000;
	
	constant maxCap : real := 330.0;	--! Voltage of Cap at maximum ADC range
begin
	UUT : entity work.BoostController(Behavioural)
		port map(
			Charge => Charge,
			Reset => Reset,
			CapVoltage => CapVoltage,
			BattVoltage => BattVoltage,
			Switch => Switch,
			Fault => Fault,
			Activity => Activity,
			Clock => Clock
		);
	
	process
	begin
		Clock <= '1';
		wait for ClockPeriod / 2;
		Clock <= '0';
		wait for ClockPeriod / 2; 
		if Done = '1' then
			wait;
		end if;
	end process;
	
	process
	begin
		Charge <= '0';
		Reset <= '1';
		CapVoltage <= natural(CapVoltageReal/maxCap * 4095.0);
		BattVoltage <= natural(BattVoltageReal/18.3*1023.0);
		Done <= '0';
		wait for 4.5*ClockPeriod;
		Reset <= '0';
		Charge <= '1';
		Done <= '0';
		wait for 2*ClockPeriod;
		charge_loop: while  activity ='1' loop
			wait for 876*ClockPeriod;
			CapVoltage <= natural(CapVoltageReal/maxCap * 4095.0);
		end loop charge_loop;

		discharge_loop: while activity = '0' loop
			wait for 876*ClockPeriod;
			CapVoltage <= natural(CapVoltageReal/maxCap * 4095.0);
		end loop discharge_loop;
		Done <= '1';
		wait;
	end process;

	process(Clock)
	begin
		if rising_edge(Clock) then	
			if(Switch = '1') then
				InductorCurrent <= InductorCurrent + BattVoltageReal / 22.0e-6 * 1.0e-6;
			else
				InductorCurrent <= InductorCurrent - (CapVoltageReal + 0.7 - BattVoltageReal) * 1.0e-6 / 22.0e-6;
				CapVoltageReal <= CapVoltageReal + (InductorCurrent - CapVoltageReal/220.0e3) / 4.5e-3 * 1.0e-6;
			end if;

			if InductorCurrent < 0.0 then
				InductorCurrent <= 0.0;
			else
				InductorQuant <= natural(InductorCurrent);
			end if;
		
		end if;
	end process;

end;
