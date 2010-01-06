library ieee;
use ieee.std_logic_1164.all;

entity XBeeByteReceiver is
	port(
		Clock1 : in std_ulogic;

		SerialData : in std_ulogic_vector(7 downto 0);
		SerialGood : in std_ulogic;
		SerialFErr : in std_ulogic;

		FErr : out std_ulogic := '0';
		Data : out std_ulogic_vector(7 downto 0) := X"00";
		Good : out std_ulogic := '0';
		SOP : out std_ulogic := '0'
	);
end entity XBeeByteReceiver;

architecture Behavioural of XBeeByteReceiver is
	signal Escaped : boolean := false;
begin
	FErr <= '1' when (SerialFErr = '1' or (SerialGood = '1' and SerialData = X"7D" and Escaped)) else '0';
	Data <= SerialData xor X"20" when Escaped else SerialData;
	Good <= '1' when SerialGood = '1' and SerialData /= X"7D" and SerialData /= X"7E" else '0';
	SOP <= '1' when SerialGood = '1' and SerialData = X"7E" else '0';

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if SerialGood = '1' then
				if SerialData = X"7D" then
					Escaped <= true;
				else
					Escaped <= false;
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
