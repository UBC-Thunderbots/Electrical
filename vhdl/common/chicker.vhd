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
		Chip : out std_ulogic := '1';

		-- ADC flags.
		Chicker0 : in boolean;
		Chicker110 : in boolean;
		Chicker150 : in boolean
	);
end entity Chicker;

architecture Behavioural of Chicker is
	signal EffectiveEnableFlag : boolean := false;
	signal Counter : unsigned(13 downto 0) := to_unsigned(0, 14);
	signal CounterMSW : unsigned(Power'range) := to_unsigned(0, Power'length);
	subtype ChargeCounterType is natural range 0 to 79999;
	signal ChargeCounter : ChargeCounterType := ChargeCounterType'high;
	signal Latch150 : boolean := false;
	signal LatchBad0 : boolean := false;
begin
	EffectiveEnableFlag <= ChickerEnableFlag = '1' and RXTimeout = '0' and not Latch150 and not LatchBad0;
	CounterMSW <= Counter(Counter'high downto Counter'high - Power'length + 1);
	FaultFlag <= '1' when Fault = '0' or Latch150 or LatchBad0 else '0';
	Charge <= '0' when EffectiveEnableFlag and not (not Chicker110 and Done = '0') else '1';
	Kick <= '0' when ChipFlag = '0' and Power /= 0 and CounterMSW /= Power else '1';
	Chip <= '0' when ChipFlag = '1' and Power /= 0 and CounterMSW /= Power else '1';

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			Latch150 <= Latch150 or Chicker150;
			LatchBad0 <= LatchBad0 or (ChargeCounter = 0 and Chicker0);
			if Done = '0' and not Chicker0 then
				ReadyFlag <= '1';
			elsif Power /= 0 or not EffectiveEnableFlag then
				ReadyFlag <= '0';
			end if;
			if Power = 0 then
				Counter <= to_unsigned(0, 14);
			elsif CounterMSW /= Power then
				Counter <= Counter + 1;
			end if;
			if EffectiveEnableFlag and Power = 0 and ChargeCounter /= 0 then
				ChargeCounter <= ChargeCounter - 1;
			else
				ChargeCounter <= ChargeCounterType'high;
			end if;
		end if;
	end process;
end architecture Behavioural;
