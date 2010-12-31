library ieee;
use ieee.std_logic_1164.all;

entity BoostController is 
port (
	Charge : in std_logic;
	Reset : in std_logic;
	CapVoltage : in natural range 0 to 4095; --full range = 330 volts
	BattVoltage : in natural range 0 to 1023; --full range = 18.3 volts
	Switch : out std_logic; --this is the output to the mosfet right now its positive sense
	Fault : out std_logic; 
	Clock : in std_logic); --I'm expecting this to be 256 MHz
end entity;

architecture Behavioural of BoostController is
	constant inductance : real := 22.0e-6;
	constant frequency : real := 1.0e6;
	constant Battbits : real := 1023.0;
	constant Capbits : real := 4095.0;
	constant maxcurrent : real := 10.0;
	constant maxBatt : real := 18.3;
	constant maxCap : real := 330.0;

	constant countermax : natural := natural(inductance * frequency * maxcurrent * Battbits / maxbatt);
	constant maxvoltage : natural := natural(230.0 / maxCap * Capbits);
	constant dangervoltage : natural := natural(240.0 / maxCap * Capbits);
	constant recharge : natural := natural(220.0 / maxCap * Capbits); 
	constant diode : natural := natural(0.7 / maxBatt * Battbits);
	constant ratio : natural := natural(maxCap * Battbits / maxBatt / Capbits); -- we should make sure this is power of 2

	type top_state is (disabled,charging,waiting,faulted);
	type bottom_state is (ontime,offtime,waiting);
	signal counter_state : bottom_state;
	signal main_state : top_state;
	signal FaultActive : std_logic;
	signal OverVoltage : std_logic;
	signal Increment : natural range 1 to ratio*4095+diode;
begin

	FaultActive <= OverVoltage; -- Or the faultlines together here

	--Compute increment based on current voltages;
	process(Clock)
	begin
		if rising_edge(Clock) then
			if(CapVoltage*ratio - BattVoltage > 0) then
				Increment <= CapVoltage*ratio + diode - BattVoltage;
			else
				Increment <= diode;
			end if;
			if(CapVoltage > dangervoltage) then
				OverVoltage <= '1';
			else
				OverVoltage <= '0';
			end if;
		end if;
	end process;

	--Main Controlling State Machine to control the levels of the system;
	process(Clock)
	begin
		if rising_edge(Clock) then
			case main_state is
				when disabled =>
					if(CapVoltage < maxvoltage) then
						main_state <= charging;
					end if; 
				when charging =>

					if(CapVoltage > maxvoltage) then
						main_state <= waiting;
					else
						main_state <= charging;
					end if;

				when waiting =>
					if(CapVoltage < recharge) then
						main_state <= charging;
					else
						main_state <= waiting;
					end if;
				when faulted =>
					main_state <= faulted;
			end case;
			if(charge = '0') then
				main_state <= disabled;
			end if;
			if(Reset = '1') then
				main_state <= disabled;
			end if;
			if(FaultActive = '1') then 
				main_state <= faulted;
			end if;
	end if;
	end process;

	with main_state select
		Fault <= 	'1' when faulted,
							'0' when others;

	-- This process controls the actual switch timing;
	process(Clock)
		variable counter : natural range 0 to countermax;
	begin
		if rising_edge(Clock) then
			case counter_state is
				when ontime =>
						if(counter + BattVoltage > countermax) then
							counter := 0;
							counter_state <= offtime;
						else
							counter := counter + BattVoltage;
							counter_state <= ontime;
						end if;
				when offtime =>
						if(counter + Increment > countermax) then
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
			if(main_state /= charging) then
				counter_state <= waiting;
			end if;
		end if;
	end process;
	
	with counter_state select
		Switch <= '1' when ontime,
							'0' when others;
end;
