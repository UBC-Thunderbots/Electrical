library ieee;
use ieee.std_logic_1164.all;

entity XBeeByteTransmitter is
	port (
		Clock : in std_ulogic;

		Data : in std_ulogic_vector(7 downto 0);
		Load : in std_ulogic;
		SOP : in std_ulogic;
		Busy : out std_ulogic := '0';

		SerialData : out std_ulogic_vector(7 downto 0);
		SerialLoad : out std_ulogic := '0';
		SerialBusy : in std_ulogic
	);
end entity XBeeByteTransmitter;

architecture Behavioural of XBeeByteTransmitter is
	signal HoldBusy : boolean := false;
	signal EscapedData : std_ulogic_vector(7 downto 0) := X"00";
	signal EscapeSent : boolean := false;
begin
	process(Clock)
	begin
		if rising_edge(Clock) then
			if SOP = '1' then
				Busy <= '1';
				SerialData <= X"7E";
				SerialLoad <= '1';
				HoldBusy <= true;
				EscapeSent <= false;
			elsif Load = '1' then
				Busy <= '1';
				SerialLoad <= '1';
				HoldBusy <= true;
				if Data = X"7E" or Data = X"7D" or Data = X"11" or Data = X"13" then
					SerialData <= X"7D";
					EscapedData <= Data xor X"20";
					EscapeSent <= true;
				else
					SerialData <= Data;
					EscapeSent <= false;
				end if;
			elsif SerialBusy = '1' then
				Busy <= '1';
				SerialData <= Data;
				SerialLoad <= '0';
				HoldBusy <= true;
			else
				SerialData <= EscapedData;
				if HoldBusy then
					Busy <= '1';
					SerialLoad <= '0';
					HoldBusy <= false;
				elsif EscapeSent then
					Busy <= '1';
					SerialLoad <= '1';
					HoldBusy <= true;
					EscapeSent <= false;
				else
					Busy <= '0';
					SerialLoad <= '0';
					HoldBusy <= false;
					EscapeSent <= false;
				end if;
			end if; 
		end if;
	end process;
end architecture Behavioural;
