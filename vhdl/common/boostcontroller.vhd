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

architecture Behaviour of BoostController is
	constant countermax : natural := 3148381; -- 22uH * 256 MHz * 10 Amps * 1023 bits / 18.3 Volts
	constant maxvoltage : natural := 2854; -- 230 volts / 330 volts * 4095 bits
	constant dangervoltage : natural := 2978; -- 240 volts / 330 volts * 4095 bits 
	constant recharge : natural := 2730; -- 220 volts / 330 volts * 4095 bits
	constant diode : natural := 39; -- 0.7 volts / 18.3 volts * 4095 bits
	constant ratio : natural := 4; -- 330 volts * 1023 bits / 18.3 volts / 4095 bits
	type top_state is (disabled,charging,waiting,faulted);
	type bottom_state is (ontime,offtime,waiting);
	signal counter_state : bottom_state;
	signal main_state : top_state;
	signal FaultActive : std_logic;
	signal OverVoltage : std_logic;
	signal Increment : natural range diode to ratio*4095+diode;
begin

	FaultActive <= OverVoltage; -- Or the faultlines together here

	--Compute increment based on current voltages;
	process(Clock)
	begin
		if(Clock'event AND Clock = '1') then
			Increment <= CapVoltage*ratio + diode - BattVoltage;
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
		if(Clock'Event AND Clock = '1') then
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

	if(main_state = faulted) then
		Fault <= '1';
	else
		Fault <= '0';
	end if;

	-- This process controls the actual switch timing;
	process(Clock)
		variable counter : natural range 0 to countermax;
	begin
		if(Clock'event AND Clock ='1') then
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
	
	if(counter_state = ontime) then
		Switch <= '1';
	else
		Switch <= '0';
	end if;

end;
