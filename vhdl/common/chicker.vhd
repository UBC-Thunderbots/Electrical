library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Chicker is
	port(
		-- Clock line.
		Clock1 : in std_ulogic;

		-- XBee lines.
		RXTimeout : in boolean;
		Enable : in boolean;
		ChipFlag : in boolean;
		Power : in unsigned(8 downto 0);
		Ready : out boolean := false;
		FaultLT3751 : out boolean := false;
		FaultLow : buffer boolean := false;
		FaultHigh : buffer boolean := false;
		ChargeTimeout : buffer boolean := false;
		Voltage : buffer unsigned(9 downto 0);

		-- I/O lines.
		Charge : out std_ulogic := '1';
		Done : in std_ulogic;
		Fault : in std_ulogic;
		Kick : out std_ulogic := '1';
		Chip : out std_ulogic := '1';

		-- ADC value.
		VoltageRaw : in unsigned(9 downto 0)
	);
end entity Chicker;

architecture Behavioural of Chicker is
	-- Divider is 220k and 2.2k.
	-- Threshold for 0 is 10V: ADC reading = 10 / 222200 * 2200 / 3.3 * 1023 = 31
	-- Threshold for 110V: ADC reading = 110 / 222200 * 2200 / 3.3 * 1023 = 338
	-- Threshold for 150V: ADC reading = 150 / 222200 * 2200 / 3.3 * 1023 = 460
	constant CHICKER0_THRESHOLD : unsigned(9 downto 0) := to_unsigned(31, 10);
	constant CHICKER110_THRESHOLD : unsigned(9 downto 0) := to_unsigned(338, 10);
	constant CHICKER150_THRESHOLD : unsigned(9 downto 0) := to_unsigned(460, 10);

	-- Number of clock cycles the voltage is allowed to be less than
	-- CHICKER0_THRESHOLD before a low fault is declared.
	constant LOW_CHARGE_TIMEOUT : positive := 1000000;

	-- Number of clock cycles the charger is allowed to be charging and not done
	-- before a timeout fault is declared.
	constant HIGH_CHARGE_TIMEOUT : positive := 5000000;

	-- Number of clock cycles the LT3751 CHARGE line must be deasserted for
	-- during the PreTopup state before reasserting the line in the Topup state.
	constant PRETOPUP_TIME : positive := 40;

	subtype VoltageFilterCounterType is natural range 0 to 9999;
	signal VoltageFilterCounter : VoltageFilterCounterType := 0;

	signal DoneFiltered : std_ulogic := '1';
	signal FaultFiltered : std_ulogic := '1';

	type StateType is (Off, LowCharging, HighCharging, Idle, PreTopup, Topup);
	signal State : StateType := Off;

	subtype ChargeCounterType is natural range 0 to 4999999;
	signal ChargeCounter : ChargeCounterType;

	signal FireCounter : unsigned(Power'high + 5 downto 0) := to_unsigned(0, Power'length + 5);
begin
	-- Filter the chicker voltage. Use 90% of old value and 10% of new value.
	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if VoltageFilterCounter = 0 then
				Voltage <= (Voltage * 117965 + VoltageRaw * 13107) srl 17;
			end if;
			
			VoltageFilterCounter <= (VoltageFilterCounter + 1) mod (VoltageFilterCounterType'high + 1);
		end if;
	end process;

	-- Filter the done and fault lines.
	DoneFilter : entity work.SRFilter(Behavioural)
	generic map(
		Width => 5,
		Default => '1'
	)
	port map(
		Clock => Clock1,
		Input => Done,
		Output => DoneFiltered
	);

	FaultFilter : entity work.SRFilter(Behavioural)
	generic map(
		Width => 5,
		Default => '1'
	)
	port map(
		Clock => Clock1,
		Input => Fault,
		Output => FaultFiltered
	);

	-- Check for the voltage being too high.
	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if Voltage > CHICKER150_THRESHOLD then
				FaultHigh <= true;
			end if;
		end if;
	end process;

	-- The charger state machine.
	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if RXTimeout or not Enable or Power /= 0 or FaultLow or FaultHigh or ChargeTimeout then
				State <= Off;
			elsif State = Off then
				if Enable then
					State <= LowCharging;
					ChargeCounter <= LOW_CHARGE_TIMEOUT - 1;
				end if;
			elsif State = LowCharging then
				if ChargeCounter = 0 then
					FaultLow <= true;
				elsif Voltage > CHICKER0_THRESHOLD then
					State <= HighCharging;
					ChargeCounter <= HIGH_CHARGE_TIMEOUT - 1;
				end if;
			elsif State = HighCharging then
				if ChargeCounter = 0 then
					ChargeTimeout <= true;
				elsif DoneFiltered = '0' then
					State <= Idle;
				end if;
			elsif State = Idle then
				if Voltage < CHICKER110_THRESHOLD then
					State <= Topup;
					ChargeCounter <= PRETOPUP_TIME - 1;
				end if;
			elsif State = PreTopup then
				if ChargeCounter = 0 then
					State <= Topup;
					ChargeCounter <= HIGH_CHARGE_TIMEOUT - 1;
				end if;
			elsif State = Topup then
				if ChargeCounter = 0 then
					ChargeTimeout <= true;
				elsif DoneFiltered = '0' then
					State <= Idle;
				end if;
			end if;

			ChargeCounter <= ChargeCounter - 1;
		end if;
	end process;

	-- Generate the outputs from the charger state machine.
	Ready <= State = Idle or State = PreTopup or State = Topup;
	FaultLT3751 <= FaultFiltered = '0';
	Charge <= '1' when State = LowCharging or State = HighCharging or State = Idle or State = Topup;

	-- Fire control.
	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if FireCounter(FireCounter'high downto FireCounter'high - Power'length) < Power then
				if ChipFlag then
					Chip <= '0';
					Kick <= '1';
				else
					Chip <= '1';
					Kick <= '0';
				end if;
				FireCounter <= FireCounter + 1;
			else
				Chip <= '1';
				Kick <= '1';
				FireCounter(FireCounter'high downto FireCounter'high - Power'length + 1) <= Power;
				FireCounter(FireCounter'high - Power'length downto 0) <= to_unsigned(0, FireCounter'length - Power'length);
			end if;
		end if;
	end process;
end architecture Behavioural;
