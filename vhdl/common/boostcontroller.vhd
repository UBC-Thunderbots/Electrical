library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

--! Boost converted controller
--! All inputs are sampled on rising clock edge
--! Charger is either active at full power or not with the 10 volt top up window

entity BoostController is 
	port (
		ClockLow : in std_logic; --! Clock for the system to run on
		Enable : in boolean; --!Enables the Charger
		CapacitorVoltage : in capacitor_voltage_t; --! Current Capacitor Voltage
		BatteryVoltage : in battery_voltage_t; --! Current Battery Voltage
		Charge : out boolean; --! To the MOSFET
		Timeout : out boolean; --! Signals a fault in the charger
		Activity : out boolean; --! Signals whether the it is actively charging
		Done : out boolean := false); --! Signals whether charging is complete
end entity;

architecture Behavioural of BoostController is
	--We should probably make some or all of these generic parameters
	constant Inductance : real := 22.0e-6; --! Inductance in switching element
	constant Frequency : real := real(ClockLowFrequency);	--! Frequency the system is running at
	constant BattBits : real := real(battery_voltage_t'high); --! Number of levels for the battery
	constant CapBits : real := real(capacitor_voltage_t'high);	--! Number of levels for the Cap
	constant MaxCurrent : real := 10.0;	--! Maximum inductor Current
	constant MaxBatt : real := 18.3;	--! Voltage of battery at maximum ADC range 
	constant MaxCap : real := 330.0;	--! Voltage of Cap at maximum ADC range

	constant CounterMax : natural := natural(Inductance * Frequency * MaxCurrent * BattBits / MaxBatt);
	constant MaxVoltage : natural := natural(230.0 / MaxCap * CapBits);
	constant Diode : natural := natural(0.7 / MaxBatt * BattBits);
	
	constant ChargeTimeout : real := 4.0; -- timeout for charge cycle
	constant CounterMaxForTimeout : natural := natural(ChargeTimeout * Frequency);
	
	--! Ratio1 + 1 / Ratio2 should be MaxCap * BattBits / MaxBatt / CapBits
	--! Ratio2 MUST be power of 2, Ratio1 SHOULD be power of 2 to avoid multiplier
	
	--! ratio = 4.5
	constant Ratio1 : natural := 4;	
	constant Ratio2 : natural := 2;
	
	constant MaxIncrement : natural := natural((natural(CapBits)) * Ratio1 + (natural(CapBits)) / Ratio2) + Diode;

	signal TimeoutBuffer : boolean := false;
	signal Increment : natural range 1 to MaxIncrement;
	signal ActivityBuffer : boolean := false;
begin

	Timeout <= TimeoutBuffer; -- Or the faultlines together here

	--Compute increment based on current voltages
	--This is some what of a helper process to do some tests on new data
	--this really only needs to be trigged when we get new data
	process(CapacitorVoltage, BatteryVoltage)
		variable CapacitorVoltageAdjusted : capacitor_voltage_t;
		variable CapacitorVoltageAsBattery : natural range 0 to MaxIncrement;
	begin
		--This increment is used to compute the off time.
		if CapacitorVoltage > 0 then
			CapacitorVoltageAdjusted := CapacitorVoltage - 1;
		else
			CapacitorVoltageAdjusted := 0;
		end if;
		CapacitorVoltageAsBattery := CapacitorVoltageAdjusted * Ratio1 + CapacitorVoltageAdjusted / Ratio2;
		if CapacitorVoltageAsBattery > BatteryVoltage then
			Increment <= CapacitorVoltageAsBattery + Diode - BatteryVoltage;
		else
			Increment <= Diode;
		end if;
	end process;

	process(ClockLow)
		variable Counter : natural range 0 to CounterMaxForTimeout + 1 := 0;
	begin
		if rising_edge(ClockLow) then
			if ActivityBuffer then
				if Counter = CounterMaxForTimeout + 1 then
					Counter := 0;
					TimeoutBuffer <= true;
				else
					Counter := Counter + 1;
				end if;
			else
				Counter := 0;
			end if;
		end if;
	end process;

	--Export some status to the world
	Activity <= ActivityBuffer;

	-- This process controls the actual switch timing;
	process(ClockLow, TimeoutBuffer)
		type state_t is (ONTIME,OFFTIME,WAITING); --! permissable states for the dutycycle
		variable State : state_t := WAITING;
		variable Counter : natural range 0 to CounterMax + MaxIncrement;
		variable Multiplier : natural range 0 to MaxIncrement;
	begin
		if rising_edge(ClockLow) then
			case State is
				when ONTIME =>
					--This implements Counts*BatteryVoltage = CounterMax in order to calculate counts
					if (Counter + 1) * Multiplier > CounterMax then
						Counter := 0;
						State := OFFTIME;
						Multiplier := Increment;
					else
						Counter := Counter + 1;
					end if;

				when OFFTIME =>
					--This implements Counts*(CapacitorVoltage*ratio + Diode - BatteryVoltage) = CounterMax
					if (Counter + 1) * Multiplier > CounterMax + Increment then
						Counter := 0;
						State := WAITING;
						Multiplier := BatteryVoltage;
					else
						Counter := Counter + 1;
					end if;

				when WAITING =>
					if Enable then
						if CapacitorVoltage < MaxVoltage then
							State := ONTIME;
							Multiplier := BatteryVoltage;
							ActivityBuffer <= true;
						else
							ActivityBuffer <= false;
							Done <= true;
						end if;
					else
						ActivityBuffer <= false;
						Done <= false;
					end if;
			end case;
		end if;
		
		--MOSFET is controlled by the bottom state machine
		Charge <= State = ONTIME and not TimeoutBuffer;
	end process;
end architecture Behavioural;
