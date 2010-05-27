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
	signal Counter : unsigned(13 downto 0) := to_unsigned(0, 14);
	signal CounterMSW : unsigned(Power'range) := to_unsigned(0, Power'length);
begin
	CounterMSW <= Counter(Counter'high downto Counter'high - Power'length + 1);
	ReadyFlag <= '1' when Done = '0' else '0';
	FaultFlag <= '1' when Fault = '0' else '0';
	Charge <= '0' when ChickerEnableFlag = '1' and RXTimeout = '0' else '1';
	Kick <= '0' when ChipFlag = '0' and Power /= 0 and CounterMSW /= Power else '1';
	Chip <= '0' when ChipFlag = '1' and Power /= 0 and CounterMSW /= Power else '1';

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if Power = 0 then
				Counter <= to_unsigned(0, 14);
			elsif CounterMSW /= Power then
				Counter <= Counter + 1;
			end if;
		end if;
	end process;
end architecture Behavioural;
