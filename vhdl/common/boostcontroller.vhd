library ieee;
use ieee.std_logic_1164.all;
use work.clock.all;

--! Boost converted controller
--! All inputs are sampled on rising clock edge
--! Charger is either active at full power or not with the 10 volt top up window

entity BoostController is 
	port (
		Clock : in std_logic; --! Clock for the system to run on
		Enable : in boolean; --!Enables the Charger
		CapacitorVoltage : in natural range 0 to 4095; --! Current Capacitor Voltage
		BatteryVoltage : in natural range 0 to 1023; --! Current Battery Voltage
		Charge : out boolean; --! To the MOSFET
		Fault : out boolean; --! Signals a fault in the charger
		Activity : out boolean); --! Signals whether the it is actively charging
end entity;

architecture Behavioural of BoostController is
	--We should probably make some or all of these generic parameters
	constant Inductance : real := 22.0e-6; --! Inductance in switching element
	constant Frequency : real := real(ClockLowFrequency);	--! Frequency the system is running at
	constant BattBits : real := 1023.0; --! Number of levels for the battery
	constant CapBits : real := 4095.0;	--! Number of levels for the Cap
	constant MaxCurrent : real := 10.0;	--! Maximum inductor Current
	constant MaxBatt : real := 18.3;	--! Voltage of battery at maximum ADC range 
	constant MaxCap : real := 330.0;	--! Voltage of Cap at maximum ADC range

	constant CounterMax : natural := natural(Inductance * Frequency * MaxCurrent * BattBits / MaxBatt);
	constant MaxVoltage : natural := natural(230.0 / MaxCap * CapBits);
	constant DangerVoltage : natural := natural(240.0 / MaxCap * CapBits);
	constant Recharge : natural := natural(220.0 / MaxCap * CapBits); 
	constant Diode : natural := natural(0.7 / MaxBatt * BattBits);
	
	constant ChargeTimeout : real := 3.5; -- timeout for charge cycle
	constant CounterMaxForTimeout : natural := natural(ChargeTimeout * Frequency);
	
	--! Ratio1 + 1 / Ratio2 should be MaxCap * BattBits / MaxBatt / CapBits
	--! Ratio2 MUST be power of 2, Ratio1 SHOULD be power of 2 to avoid multiplier
	
	--! ratio = 4.5
	constant Ratio1 : natural := 4;	
	constant Ratio2 : natural := 2;
	
	constant MaxIncrement : natural := natural((natural(CapBits) + Diode) * Ratio1 + (natural(CapBits) + Diode) / Ratio2);

	type top_state_t is (DISABLED,CHARGING,WAITING,FAULTED); --! permissable states for the overall controller
	type bottom_state_t is (ONTIME,OFFTIME,WAITING); --! permissable states for the dutycycle
	signal CounterState : bottom_state_t;
	signal MainState : top_state_t := DISABLED;
	signal FaultActive : boolean;
	signal OverVoltage : boolean;
	signal Timeout : boolean;
	signal Increment : natural range 1 to MaxIncrement;
begin

	FaultActive <= OverVoltage or Timeout; -- Or the faultlines together here

	--Compute increment based on current voltages
	--This is some what of a helper process to do some tests on new data
	--this really only needs to be trigged when we get new data
	process(Clock)
	begin
		if rising_edge(Clock) then
			--This increment is used to compute the off time.
			if (CapacitorVoltage - 1) * Ratio1 + (CapacitorVoltage - 1) / Ratio2 + Diode - BatteryVoltage > 0 then
				Increment <= (CapacitorVoltage - 1) * Ratio1 + (CapacitorVoltage - 1) / Ratio2 + Diode - BatteryVoltage;
			else
				Increment <= Diode;
			end if;
			--Test the Capacitor for an over voltage scenario
			if CapacitorVoltage > DangerVoltage then
				OverVoltage <= true;
			else
				OverVoltage <= false;
			end if;
		end if;
	end process;

	--Main Controlling State Machine to control the levels of the system;
	process(Clock)
		variable Counter : natural range 0 to CounterMaxForTimeout + 1 := 0;
	begin
		if rising_edge(Clock) then
			--this case is superceeded by the ifs below
			case MainState is
				when DISABLED =>
					if CapacitorVoltage < MaxVoltage then
						MainState <= CHARGING;
					end if; 

				--stop charging if above max
				when CHARGING =>
					if CapacitorVoltage > MaxVoltage then
						MainState <= WAITING;
					else
						MainState <= CHARGING;
					end if;
					
					Counter := Counter + 1;

				--trigger top up if below Recharge
				when WAITING =>
					if CapacitorVoltage < Recharge then
						MainState <= CHARGING;
					else
						MainState <= WAITING;
					end if;

				--If the system faults lock it in
				when FAULTED =>
					MainState <= FAULTED;
			end case;
			
			if MainState /= CHARGING then
				Counter := 0;
			end if;
			
			Timeout <= Counter >= CounterMaxForTimeout;

			-- The following ifs should override the above case statement
			
			if not Enable and MainState /= FAULTED then
				MainState <= DISABLED;
			end if;
			
			--Keep this on the bottom so a reset can't clear an active fault
			if FaultActive then 
				MainState <= FAULTED;
			end if;
		end if;
	end process;

	--Export some status to the world
	Activity <= MainState = CHARGING;

	Fault <= MainState = FAULTED;

	-- This process controls the actual switch timing;
	process(Clock)
		variable Counter : natural range 0 to CounterMax + MaxIncrement;
	begin
		if rising_edge(Clock) then
			case CounterState is
				when ONTIME =>
						--This implements Counts*BatteryVoltage = CounterMax in order to calculate counts
						if Counter + BatteryVoltage > CounterMax then
							Counter := 0;
							CounterState <= OFFTIME;
						else
							Counter := Counter + BatteryVoltage;
							CounterState <= ONTIME;
						end if;
				when OFFTIME =>
						--This implements Counts*(CapacitorVoltage*ratio + Diode - BatteryVoltage) = CounterMax
						if Counter + Increment > CounterMax + Increment then
							Counter := 0;
							CounterState <= ONTIME;
						else
							Counter := Counter + Increment;
							CounterState <= OFFTIME;
						end if;
				when WAITING =>
						if MainState = CHARGING then
							CounterState <= ONTIME;
						end if;
			end case;
			--if the charger shuts down stop pulsing
			if MainState /= CHARGING then
				CounterState <= WAITING;
			end if;
		end if;
	end process;
	
	--MOSFET is controlled by the bottom state machine
	Charge <= CounterState = ONTIME;
end architecture Behavioural;
