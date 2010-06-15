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
		ChipFaultFlag : out std_ulogic := '0';
		Fault0Flag : out std_ulogic := '0';
		Fault150Flag : out std_ulogic := '0';
		TimeoutFlag : out std_ulogic := '0';

		-- I/O lines.
		Charge : out std_ulogic := '1';
		Done : in std_ulogic;
		Fault : in std_ulogic;
		Kick : out std_ulogic := '1';
		Chip : out std_ulogic := '1';

		-- ADC flags.
		Chicker0 : in boolean;
		Chicker110 : in boolean;
		Chicker150 : in boolean;
		Debug : out boolean
	);
end entity Chicker;

architecture Behavioural of Chicker is
	signal EffectiveEnableFlag : boolean := false;
	signal Counter : unsigned(13 downto 0) := to_unsigned(0, 14);
	signal CounterMSW : unsigned(Power'range) := to_unsigned(0, Power'length);
	subtype ChargeCounterType is natural range 0 to 999999;
	signal ChargeCounter : ChargeCounterType := ChargeCounterType'high;
	signal Latch150 : boolean := false;
	signal LatchBad0 : boolean := false;
	signal LatchTimeout : boolean := false;
	subtype DoneCounterType is natural range 0 to 255;
	signal DoneCounter : DoneCounterType := DoneCounterType'high;
	signal ShouldCharge : boolean := false;
	subtype TimeoutCounterType is natural range 0 to 4999999;
	signal TimeoutCounter : TimeoutCounterType := TimeoutCounterType'high;
begin
	EffectiveEnableFlag <= ChickerEnableFlag = '1' and RXTimeout = '0' and not Latch150 and not LatchBad0 and not LatchTimeout;
	CounterMSW <= Counter(Counter'high downto Counter'high - Power'length + 1);
	ReadyFlag <= '1' when DoneCounter = 0 else '0';
	ChipFaultFlag <= '1' when Fault = '0' else '0';
	Fault0Flag <= '1' when LatchBad0 else '0';
	Fault150Flag <= '1' when Latch150 else '0';
	TimeoutFlag <= '1' when LatchTimeout else '0';
	ShouldCharge <= EffectiveEnableFlag and not (not Chicker110 and DoneCounter = 0) and Power = 0;
	Charge <= '0' when ShouldCharge else '1';
	Debug <= Fault = '0';

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if TimeoutCounter = 0 then
				LatchTimeout <= true;
			end if;
			if ShouldCharge and Done = '1' then
				TimeoutCounter <= TimeoutCounter - 1;
			else
				TimeoutCounter <= TimeoutCounterType'high;
			end if;
			if Power /= 0 and CounterMSW /= Power then
				if ChipFlag = '1' then
					Kick <= '1';
					Chip <= '0';
				else
					Kick <= '0';
					Chip <= '1';
				end if;
			else
				Kick <= '1';
				Chip <= '1';
			end if;
			Latch150 <= Latch150 or Chicker150;
			LatchBad0 <= LatchBad0 or (ChargeCounter = 0 and Chicker0);
			if Done = '0' and not Chicker0 and DoneCounter /= 0 then
				DoneCounter <= DoneCounter - 1;
			elsif Power /= 0 or not EffectiveEnableFlag then
				DoneCounter <= DoneCounterType'high;
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
