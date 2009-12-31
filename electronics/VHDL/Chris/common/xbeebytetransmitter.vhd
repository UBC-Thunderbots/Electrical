library ieee;
use ieee.std_logic_1164.all;

entity XBeeByteTransmitter is
	port (
		Clock : in std_logic;

		Data : in std_logic_vector(7 downto 0);
		Load : in std_logic;
		SOP : in std_logic;
		Busy : out std_logic := '0';

		SerialData : out std_logic_vector(7 downto 0);
		SerialLoad : out std_logic := '0';
		SerialBusy : in std_logic
	);
end entity XBeeByteTransmitter;

architecture Behavioural of XBeeByteTransmitter is
	signal HoldBusy : std_logic := '0';
	signal EscapedData : std_logic_vector(7 downto 0) := "00000000";
	signal EscapeSent : std_logic := '0';
begin
	process(Clock)
	begin
		if rising_edge(Clock) then
			if SOP = '1' then
				Busy <= '1';
				SerialData <= X"7E";
				SerialLoad <= '1';
				HoldBusy <= '1';
				EscapeSent <= '0';
			elsif Load = '1' then
				Busy <= '1';
				SerialLoad <= '1';
				HoldBusy <= '1';
				if Data = X"7E" or Data = X"7D" or Data = X"11" or Data = X"13" then
					SerialData <= X"7D";
					EscapedData <= Data xor X"20";
					EscapeSent <= '1';
				else
					SerialData <= Data;
					EscapeSent <= '0';
				end if;
			elsif SerialBusy = '1' then
				Busy <= '1';
				SerialData <= Data;
				SerialLoad <= '0';
				HoldBusy <= '1';
			else
				SerialData <= EscapedData;
				if HoldBusy = '1' then
					Busy <= '1';
					SerialLoad <= '0';
					HoldBusy <= '0';
				elsif EscapeSent = '1' then
					Busy <= '1';
					SerialLoad <= '1';
					HoldBusy <= '1';
					EscapeSent <= '0';
				else
					Busy <= '0';
					SerialLoad <= '0';
					HoldBusy <= '0';
					EscapeSent <= '0';
				end if;
			end if; 
		end if;
	end process;
end architecture Behavioural;
