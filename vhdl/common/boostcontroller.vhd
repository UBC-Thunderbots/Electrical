library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;
use work.types.all;

--! Boost converted controller
--! All inputs are sampled on rising clock edge
--! Charger is either active at full power or not with the 10 volt top up window

entity BoostController is 
	generic(
		ClockFrequency : real);
	port(
		Clock : in std_logic; --! Clock for the system to run on
		Enable : in boolean; --!Enables the Charger
		CapacitorVoltage : in capacitor_voltage_t; --! Current Capacitor Voltage
		BatteryVoltage : in battery_voltage_t; --! Current Battery Voltage
		Charge : out boolean; --! To the MOSFET
		Timeout : out boolean; --! Signals a fault in the charger
		Activity : out boolean; --! Signals whether the it is actively charging
		Done : out boolean := false); --! Signals whether charging is complete
end entity;

architecture Arch of BoostController is
	constant ClockPeriod : real := 1.0 / ClockFrequency;
	--We should probably make some or all of these generic parameters
	constant Inductance : real := 22.0e-6; --! Inductance in switching element
	constant BattBits : real := real(battery_voltage_t'high); --! Number of levels for the battery
	constant CapBits : real := real(capacitor_voltage_t'high);	--! Number of levels for the Cap
	constant MaxCurrent : real := 10.0;	--! Maximum inductor Current
	constant MaxBatt : real := 33.3;	--! Voltage of battery at maximum ADC range 
	constant MaxCap : real := 303.3;	--! Voltage of Cap at maximum ADC range

	constant CounterMax : natural := natural(Inductance * ClockFrequency * MaxCurrent * BattBits / MaxBatt);
	constant MaxVoltage : natural := natural(230.0 / MaxCap * CapBits);
	constant Diode : natural := natural(0.7 / MaxBatt * BattBits);
	
	constant ChargeTimeout : real := 4.0; -- timeout for charge cycle
	constant CounterMaxForTimeout : natural := natural(ChargeTimeout * ClockFrequency);
	
	--! Ratio1 + 1 / Ratio2 should be MaxCap * BattBits / MaxBatt / CapBits
	--! Ratio2 MUST be power of 2, Ratio1 SHOULD be power of 2 to avoid multiplier
	
	--! ratio = 9.108…
	--! 9+1/1=10 gives ~1% error
	constant Ratio1 : natural := 9;
	constant Ratio2 : natural := 8;
	
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

	process(Clock)
		variable Counter : natural range 0 to CounterMaxForTimeout + 1 := 0;
	begin
		if rising_edge(Clock) then
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
	process(Clock, TimeoutBuffer)
		type state_t is (ONTIME, OFFTIME, WAITING); --! permissable states for the dutycycle
		variable State : state_t := WAITING;
		variable Counter : natural range 1 to CounterMax + MaxIncrement := 1;
		type counter_disposition_t is (HOLD, INC, RESET);
		variable CounterDisposition : counter_disposition_t;
		variable Multiplier : natural range 0 to MaxIncrement;
		constant ThermalAmbient : natural := natural(30.0 / 0.4472e-3);
		constant ThermalLimit : natural := natural(140.0 / 0.4472e-3);
		constant ThermalRange : natural := ThermalLimit - ThermalAmbient;
		variable ThermalAccumulator : natural range 0 to ThermalRange := 0;
		constant ThermalTimeInterval : real := 23.0 / 256.0;
		constant ThermalTimeTickCount : natural := natural(ThermalTimeInterval / ClockPeriod);
		variable ThermalTimeCounter : natural range 0 to ThermalTimeTickCount - 1 := 0;
	begin
		if rising_edge(Clock) then
			CounterDisposition := HOLD;

			case State is
				when ONTIME =>
					--This implements Counts*BatteryVoltage = CounterMax in order to calculate counts
					if Counter * Multiplier > CounterMax then
						CounterDisposition := RESET;
						State := OFFTIME;
						Multiplier := Increment;
					else
						CounterDisposition := INC;
					end if;

				when OFFTIME =>
					--This implements Counts*(CapacitorVoltage*ratio + Diode - BatteryVoltage) = CounterMax
					if Counter * Multiplier > CounterMax + Increment then
						CounterDisposition := RESET;
						State := WAITING;
						Multiplier := BatteryVoltage;
					else
						CounterDisposition := INC;
					end if;

				when WAITING =>
					if Enable and ThermalAccumulator /= ThermalRange then
						if CapacitorVoltage < MaxVoltage then
							State := ONTIME;
							Multiplier := BatteryVoltage;
							ActivityBuffer <= true;
							ThermalAccumulator := ThermalAccumulator + 1;
						else
							ActivityBuffer <= false;
							Done <= true;
						end if;
					else
						ActivityBuffer <= false;
						Done <= false;
					end if;
			end case;

			if CounterDisposition = RESET then
				Counter := 1;
			elsif CounterDisposition = INC then
				Counter := Counter + 1;
			end if;

			if ThermalTimeCounter = ThermalTimeTickCount - 1 then
				ThermalAccumulator := ThermalAccumulator - (ThermalAccumulator + 128) / 256;
				ThermalTimeCounter := 0;
			else
				ThermalTimeCounter := ThermalTimeCounter + 1;
			end if;
		end if;

		--MOSFET is controlled by the bottom state machine
		Charge <= State = ONTIME and not TimeoutBuffer;
	end process;
end architecture Arch;
