library ieee;
use ieee.std_logic_1164.all;

entity XBeeByteTransmitter is
	port (
		Clock1M : in std_ulogic;

		Data : in std_ulogic_vector(7 downto 0);
		Load : in std_ulogic;
		SOP : in std_ulogic;
		Busy : out std_ulogic;

		SerialData : out std_ulogic_vector(7 downto 0);
		SerialLoad : out std_ulogic := '0';
		SerialBusy : in std_ulogic
	);
end entity XBeeByteTransmitter;

architecture Behavioural of XBeeByteTransmitter is
	signal NeedsEscape : boolean;
	type StateType is (Idle, SendingData, SendingEscape);
	signal State : StateType := Idle;
begin
	NeedsEscape <= (Data = X"7E") or (Data = X"7D") or (Data = X"11") or (Data = X"13");
	Busy <= '1' when (Load = '1') or (SOP = '1') or (State /= Idle) else '0';

	process(Clock1M)
	begin
		if rising_edge(Clock1M) then
			SerialLoad <= '0';

			if SerialBusy = '0' then
				if State = Idle then
					if SOP = '1' then
						SerialData <= X"7E";
						SerialLoad <= '1';
						State <= SendingData;
					elsif Load = '1' and NeedsEscape then
						SerialData <= X"7D";
						SerialLoad <= '1';
						State <= SendingEscape;
					elsif Load = '1' and not NeedsEscape then
						SerialData <= Data;
						SerialLoad <= '1';
						State <= SendingData;
					end if;
				elsif State = SendingData then
					State <= Idle;
				elsif State = SendingEscape then
					SerialData <= Data xor X"20";
					SerialLoad <= '1';
					State <= SendingData;
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
