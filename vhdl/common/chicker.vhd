library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Chicker is
	port(
		-- Clock line.
		Clock1 : in std_ulogic;

		-- XBee lines.
		RXTimeout : in std_ulogic;
		ChickerEnableFlag : in std_ulogic;
		ChipFlag : in std_ulogic;
		Power : in unsigned(8 downto 0);
		ReadyFlag : out std_ulogic := '0';
		FaultFlag : out std_ulogic := '0';

		-- I/O lines.
		Charge : out std_ulogic := '1';
		Done : in std_ulogic;
		Fault : in std_ulogic;
		Kick : out std_ulogic := '1';
		Chip : out std_ulogic := '1'
	);
end entity Chicker;

architecture Behavioural of Chicker is
	type StateType is (Disabled, Precharging, Charging, Idle, Firing, Quiescing, Faulted);
	signal State : StateType := Disabled;
	signal Ticks : natural range 0 to 9999999 := 0;
	signal ChargedOnce : boolean := false;
begin
	ReadyFlag <= '1' when ChargedOnce else '0';
	FaultFlag <= '1' when State = Faulted or Fault = '0' else '0';
	Charge <= '0' when State = Precharging or State = Charging else '1';
	Kick <= '0' when State = Firing and ChipFlag = '0' else '1';
	Chip <= '0' when State = Firing and ChipFlag = '1' else '1';

	process(Clock1)
		variable CountTicks : boolean;
		variable ResetTicks : boolean;
	begin
		if rising_edge(Clock1) then
			CountTicks := false;
			ResetTicks := false;

			if ChickerEnableFlag = '0' or RXTimeout = '1' then
				State <= Disabled;
				ChargedOnce <= false;
			elsif State = Disabled then
				State <= Precharging;
				ResetTicks := true;
			elsif State = Precharging then
				if to_unsigned(Ticks, 24)(19) = '1' then
					State <= Idle;
					ResetTicks := true;
				else
					CountTicks := true;
				end if;
			elsif Fault = '0' then
				State <= Idle;
			elsif State = Charging then
				if Power /= to_unsigned(0, 9) then
					State <= Firing;
				elsif Done = '0' then
					State <= Idle;
				end if;
			elsif State = Idle then
				ChargedOnce <= true;
				if Power /= to_unsigned(0, 9) then
					State <= Firing;
					ResetTicks := true;
				else
					if Ticks = 999999 then
						State <= Precharging;
						ResetTicks := true;
					end if;
					CountTicks := true;
				end if;
			elsif State = Firing then
				ChargedOnce <= false;
				if Ticks = 999999 then
					State <= Quiescing;
					ResetTicks := true;
				end if;
				CountTicks := true;
			elsif State = Quiescing then
				if Power = to_unsigned(0, 9) then
					State <= Precharging;
				end if;
			end if;

			if ResetTicks then
				Ticks <= 0;
			elsif CountTicks then
				Ticks <= Ticks + 1;
			end if;
		end if;
	end process;
end architecture Behavioural;
