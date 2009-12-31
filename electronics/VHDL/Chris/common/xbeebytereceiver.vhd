library ieee;
use ieee.std_logic_1164.all;

entity XBeeByteReceiver is
	port(
		Clock : in std_logic;

		SerialData : in std_logic_vector(7 downto 0);
		SerialGood : in std_logic;
		SerialFErr : in std_logic;

		FErr : out std_logic := '0';
		Data : out std_logic_vector(7 downto 0) := X"00";
		Good : out std_logic := '0';
		SOP : out std_logic := '0'
	);
end entity XBeeByteReceiver;

architecture Behavioural of XBeeByteReceiver is
	signal Escaped : std_logic := '0';
begin
	FErr <= '1' when (SerialFErr = '1' or (SerialData = X"7D" and Escaped = '1')) else '0';
	Data <= SerialData xor X"20" when Escaped = '1' else SerialData;
	Good <= '1' when SerialGood = '1' and SerialData /= X"7D" and SerialData /= X"7E" else '0';
	SOP <= '1' when SerialGood = '1' and SerialData = X"7E" else '0';

	process(Clock)
	begin
		if rising_edge(Clock) then
			if SerialGood = '1' then
				if SerialData = X"7D" then
					Escaped <= '1';
				else
					Escaped <= '0';
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
