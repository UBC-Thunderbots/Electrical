library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketTransmitter is
	port(
		Clock1 : in std_ulogic;

		Start : in std_ulogic;

		AddressByte : in std_ulogic_vector(7 downto 0);
		AddressStrobe : out std_ulogic;
		RSSI : in std_ulogic_vector(7 downto 0);
		DribblerSpeed : in signed(15 downto 0);
		BatteryLevel : in unsigned(9 downto 0);
		Fault1 : in std_ulogic;
		Fault2 : in std_ulogic;
		Fault3 : in std_ulogic;
		Fault4 : in std_ulogic;
		FaultD : in std_ulogic;
		CommandAck : in std_ulogic_vector(7 downto 0);

		ByteData : out std_ulogic_vector(7 downto 0) := X"00";
		ByteLoad : out std_ulogic := '0';
		ByteSOP : out std_ulogic := '0';
		ByteBusy : in std_ulogic
	);
end entity XBeePacketTransmitter;

architecture Behavioural of XBeePacketTransmitter is
	type StateType is (Idle, SendSOP, SendLengthMSB, SendLengthLSB, SendAPIID, SendFrame, SendAddress, SendOptions, SendFlags, SendOutRSSI, SendDribblerSpeedLSB, SendDribblerSpeedMSB, SendBatteryLevelLSB, SendBatteryLevelMSB, SendFaults, SendCommandAck, SendChecksum);
	signal State : StateType := Idle;
	signal DataLeft : natural range 0 to 7;
	signal Temp : std_ulogic_vector(7 downto 0);
	signal Checksum : unsigned(7 downto 0);

	signal Faults : std_ulogic_vector(4 downto 0);
begin
	process(Clock1)
		variable ClearChecksum : boolean;
		variable UpdateChecksum : boolean;
		variable ChecksumByte : unsigned(7 downto 0);
	begin
		if rising_edge(Clock1) then
			-- Clear these in case they aren't assigned later.
			ByteLoad <= '0';
			ByteSOP <= '0';
			ClearChecksum := false;
			ChecksumByte := X"00";
			AddressStrobe <= '0';

			-- Accumulate faults on every clock cycle.
			Faults(0) <= Faults(0) or not Fault1;
			Faults(1) <= Faults(1) or not Fault2;
			Faults(2) <= Faults(2) or not Fault3;
			Faults(3) <= Faults(3) or not Fault4;
			Faults(4) <= Faults(4) or not FaultD;

			if ByteBusy = '0' then
				if State = Idle then
					if Start = '1' then
						State <= SendSOP;
						ClearChecksum := true;
					end if;
				elsif State = SendSOP then
					State <= SendLengthMSB;
					ByteSOP <= '1';
				elsif State = SendLengthMSB then
					State <= SendLengthLSB;
					ByteData <= X"00";
					ByteLoad <= '1';
				elsif State = SendLengthLSB then
					State <= SendAPIID;
					ByteData <= X"13";
					ByteLoad <= '1';
				elsif State = SendAPIID then
					State <= SendFrame;
					ByteData <= X"00";
					ByteLoad <= '1';
				elsif State = SendFrame then
					State <= SendAddress;
					ByteData <= X"00";
					ByteLoad <= '1';
					DataLeft <= 7;
				elsif State = SendAddress then
					ChecksumByte := unsigned(AddressByte);
					ByteData <= AddressByte;
					ByteLoad <= '1';
					AddressStrobe <= '1';
					if DataLeft = 0 then
						State <= SendOptions;
					end if;
					DataLeft <= DataLeft - 1;
				elsif State = SendOptions then
					State <= SendFlags;
					ByteData <= X"00";
					ByteLoad <= '1';
				elsif State = SendFlags then
					State <= SendOutRSSI;
					ByteData <= X"80";
					ByteLoad <= '1';
					ChecksumByte := X"80";
				elsif State = SendOutRSSI then
					State <= SendDribblerSpeedLSB;
					ByteData <= RSSI;
					ByteLoad <= '1';
					ChecksumByte := unsigned(RSSI);
				elsif State = SendDribblerSpeedLSB then
					State <= SendDribblerSpeedMSB;
					ByteData <= std_ulogic_vector(DribblerSpeed(7 downto 0));
					ByteLoad <= '1';
					ChecksumByte := unsigned(DribblerSpeed(7 downto 0));
					Temp <= std_ulogic_vector(DribblerSpeed(15 downto 8));
				elsif State = SendDribblerSpeedMSB then
					State <= SendBatteryLevelLSB;
					ByteData <= Temp;
					ByteLoad <= '1';
					ChecksumByte := unsigned(Temp);
				elsif State = SendBatteryLevelLSB then
					State <= SendBatteryLevelMSB;
					ByteData <= std_ulogic_vector(BatteryLevel(7 downto 0));
					ByteLoad <= '1';
					ChecksumByte := BatteryLevel(7 downto 0);
					Temp <= std_ulogic_vector("000000" & BatteryLevel(9 downto 8));
				elsif State = SendBatteryLevelMSB then
					State <= SendFaults;
					ByteData <= Temp;
					ByteLoad <= '1';
					ChecksumByte := unsigned(Temp);
				elsif State = SendFaults then
					State <= SendCommandAck;
					ByteData <= "000" & Faults;
					ByteLoad <= '1';
					ChecksumByte := unsigned("000" & Faults);
					Faults <= "00000";
				elsif State = SendCommandAck then
					State <= SendChecksum;
					ByteData <= CommandAck;
					ByteLoad <= '1';
					ChecksumByte := unsigned(CommandAck);
				elsif State = SendChecksum then
					ByteData <= std_ulogic_vector(Checksum);
					ByteLoad <= '1';
					State <= Idle;
				end if;
			end if;

			if ClearChecksum then
				Checksum <= X"FF";
			else
				Checksum <= Checksum - ChecksumByte;
			end if;
		end if;
	end process;
end architecture Behavioural;
