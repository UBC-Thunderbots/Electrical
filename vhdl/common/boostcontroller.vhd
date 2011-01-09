library ieee;
use ieee.std_logic_1164.all;


--! Boost converted controller
--! All inputs are sampled on rising clock edge
--! Charger is either active at full power or not with the 10 volt top up window

entity BoostController is 
port (
	Charge : in std_logic; --!Enables the Charger
	Reset : in std_logic;	 --!Resets the Charger (Synchronous)
	CapVoltage : in natural range 0 to 4095; --! Current Capacitor Voltage
	BattVoltage : in natural range 0 to 1023; --! Current Battery Voltage
	Switch : out std_logic; --! To the MOSFET, On is high
	Fault : out std_logic;	--! Signals a fault in the charger
	Activity :  out std_logic; --! Signals whether the it is actively charging
	Clock : in std_logic); --! Clock for the system to run on
end entity;

architecture Behavioural of BoostController is
	--We shoule probably make some or all of these generic parameters
	constant inductance : real := 22.0e-6; --! Inductance in switching element
	constant frequency : real := 1.0e6;	--! Frequency the system is running at
	constant Battbits : real := 1023.0; --! Number of levels for the battery
	constant Capbits : real := 4095.0;	--! Number of levels for the Cap
	constant maxcurrent : real := 10.0;	--! Maximum inductor Current
	constant maxBatt : real := 18.3;	--! Voltage of battery at maximum ADC range 
	constant maxCap : real := 330.0;	--! Voltage of Cap at maximum ADC range

	constant countermax : natural := natural(inductance * frequency * maxcurrent * Battbits / maxbatt);
	constant maxvoltage : natural := natural(230.0 / maxCap * Capbits);
	constant dangervoltage : natural := natural(240.0 / maxCap * Capbits);
	constant recharge : natural := natural(220.0 / maxCap * Capbits); 
	constant diode : natural := natural(0.7 / maxBatt * Battbits);
	
	constant charge_timeout : real := 2.5; -- timeout for charge cycle
	constant countermax_for_timeout : natural := natural(charge_timeout * frequency);
	
	--! ratio1 + 1 / ratio2 should be maxCap * Battbits / maxBatt / Capbits
	--! ratio2 MUST be power of 2, ratio1 SHOULD be power of 2 to avoid multiplier
	
	--! ratio = 4.5
	constant ratio1 : natural := 4;	
	constant ratio2 : natural := 2;
	
	constant max_increment : natural := natural( (natural(capbits)+diode) * ratio1 + (natural(capbits)+diode) / ratio2);

	type top_state is (disabled,charging,waiting,faulted); --! permissable states for the overall controller
	type bottom_state is (ontime,offtime,waiting); --! permissable states for the dutycycle
	signal counter_state : bottom_state;
	signal main_state : top_state;
	signal FaultActive : boolean;
	signal OverVoltage : boolean;
	signal Timeout : boolean;
	signal Increment : natural range 1 to max_increment;
begin

	FaultActive <= OverVoltage or Timeout; -- Or the faultlines together here

	--Compute increment based on current voltages
	--This is some what of a helper process to do some tests on new data
	--this really only needs to be trigged when we get new data
	process(Clock)
	begin
		if rising_edge(Clock) then
			--This increment is used to compute the off time.
			if((CapVoltage - 1)*(ratio1) + (CapVoltage - 1)/ratio2 + diode - BattVoltage > 0) then
				Increment <= ((CapVoltage - 1)*(ratio1) + (CapVoltage - 1)/ratio2 + diode - BattVoltage);
			else
				Increment <= diode;
			end if;
			--Test the Capacitor for an over voltage scenario
			if(CapVoltage > dangervoltage) then
				OverVoltage <= true;
			else
				OverVoltage <= false;
			end if;
		end if;
	end process;

	--Main Controlling State Machine to control the levels of the system;
	process(Clock)
	variable counter : natural range 0 to countermax_for_timeout + 1 := 0;
	begin
		if rising_edge(Clock) then
	
			--this case is superceeded by the ifs below
			case main_state is
				when disabled =>
					if(CapVoltage < maxvoltage) then
						main_state <= charging;
					end if; 

				--stop charging if above max
				when charging =>
					if(CapVoltage > maxvoltage) then
						main_state <= waiting;
					else
						main_state <= charging;
					end if;
					
					counter := counter + 1;

				--trigger top up if below recharge
				when waiting =>
					if(CapVoltage < recharge) then
						main_state <= charging;
					else
						main_state <= waiting;
					end if;

				--If the system faults lock it in
				when faulted =>
					main_state <= faulted;
			end case;
			
			if (main_state /= charging) then
				counter := 0;
			end if;
			
			Timeout <= counter >= countermax_for_timeout;

			-- The following ifs should override the above case statement
			
			if(charge = '0') AND (main_state /= faulted) then
				main_state <= disabled;
			end if;
			
			if(Reset = '1') then
				main_state <= disabled;
			end if;

			--Keep this on the bottom so a reset can't clear an active fault
			if(FaultActive = true) then 
				main_state <= faulted;
			end if;
		end if;
	end process;

	--Export some status to the world
	with main_state select
		Activity <= '1' when charging,
								'0' when others;

	with main_state select
		Fault <= 	'1' when faulted,
							'0' when others;

	-- This process controls the actual switch timing;
	process(Clock)
		variable counter : natural range 0 to countermax + max_increment;
	begin
		if rising_edge(Clock) then
			case counter_state is
				when ontime =>
						--This implements Counts*BatteryVoltage = countermax in order to calculate counts
						if(counter + BattVoltage > countermax) then
							counter := 0;
							counter_state <= offtime;
						else
							counter := counter + BattVoltage;
							counter_state <= ontime;
						end if;
				when offtime =>
						--This implements Counts*(CapVoltage*ratio + diode - BatteryVoltage) = countermax
						if(counter + Increment > countermax + Increment) then
							counter := 0;
							counter_state <= ontime;
						else
							counter := counter + Increment;
							counter_state <= offtime;
						end if;
				when waiting =>
						if(main_state = charging) then
							counter_state <= ontime;
						end if;
			end case;
			--if the charger shuts down stop pulsing
			if(main_state /= charging) then
				counter_state <= waiting;
			end if;
		end if;
	end process;
	
	--MOSFET is controlled by the bottom state machine
	with counter_state select
		Switch <= '1' when ontime,
							'0' when others;
end;
