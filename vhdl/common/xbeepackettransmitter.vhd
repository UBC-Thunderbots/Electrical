library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketTransmitter is
	port(
		Clock1 : in std_ulogic;

		Start : in std_ulogic;

		RSSI : in std_ulogic_vector(7 downto 0);
		DribblerSpeed : in unsigned(10 downto 0);
		BatteryLevel : in unsigned(9 downto 0);
		CapacitorLevel : in unsigned(9 downto 0);
		Fault1 : in std_ulogic;
		Fault2 : in std_ulogic;
		Fault3 : in std_ulogic;
		Fault4 : in std_ulogic;
		FaultD : in std_ulogic;
		ChickerReady : in std_ulogic;
		ChickerChipFault : in std_ulogic;
		ChickerFault0 : in std_ulogic;
		ChickerFault150 : in std_ulogic;
		ChickerTimeout : in std_ulogic;

		ByteData : out std_ulogic_vector(7 downto 0) := X"00";
		ByteLoad : out std_ulogic := '0';
		ByteSOP : out std_ulogic := '0';
		ByteBusy : in std_ulogic
	);
end entity XBeePacketTransmitter;

architecture Behavioural of XBeePacketTransmitter is
	type StateType is (Idle, SendSOP, SendLengthMSB, SendLengthLSB, SendAPIID, SendFrame, SendAddressHigh, SendAddressLow, SendOptions, SendFlags, SendOutRSSI, SendDribblerSpeedLSB, SendDribblerSpeedMSB, SendBatteryLevelLSB, SendBatteryLevelMSB, SendCapacitorLevelLSB, SendCapacitorLevelMSB, SendFaults, SendChecksum);
	signal State : StateType := Idle;
	signal Temp : std_ulogic_vector(2 downto 0);
	signal Checksum : unsigned(7 downto 0);

	signal Faults : std_ulogic_vector(4 downto 0);
	signal ChickerReadyL : std_ulogic := '0';
	signal ChickerChipFaultL : std_ulogic := '0';
begin
	process(Clock1)
		variable ClearChecksum : boolean;
		variable ChecksumByte : unsigned(7 downto 0);
	begin
		if rising_edge(Clock1) then
			-- Clear these in case they aren't assigned later.
			ByteLoad <= '0';
			ByteSOP <= '0';
			ClearChecksum := false;
			ChecksumByte := X"00";

			-- Accumulate faults and chicker readiness on every clock cycle.
			Faults(0) <= Faults(0) or not Fault1;
			Faults(1) <= Faults(1) or not Fault2;
			Faults(2) <= Faults(2) or not Fault3;
			Faults(3) <= Faults(3) or not Fault4;
			Faults(4) <= Faults(4) or not FaultD;
			ChickerReadyL <= ChickerReadyL or ChickerReady;
			ChickerChipFaultL <= ChickerChipFaultL or ChickerChipFault;

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
					ByteData <= X"0E";
					ByteLoad <= '1';
				elsif State = SendAPIID then
					State <= SendFrame;
					ByteData <= X"01";
					ByteLoad <= '1';
					ChecksumByte := X"01";
				elsif State = SendFrame then
					State <= SendAddressHigh;
					ByteData <= X"00";
					ByteLoad <= '1';
				elsif State = SendAddressHigh then
					State <= SendAddressLow;
					ByteData <= X"00";
					ByteLoad <= '1';
				elsif State = SendAddressLow then
					State <= SendOptions;
					ByteData <= X"00";
					ByteLoad <= '1';
				elsif State = SendOptions then
					State <= SendFlags;
					ByteData <= X"01";
					ByteLoad <= '1';
					ChecksumByte := X"01";
				elsif State = SendFlags then
					State <= SendOutRSSI;
					ByteData(7) <= '1';
					ByteData(6 downto 5) <= "00";
					ByteData(4) <= ChickerTimeout;
					ByteData(3) <= ChickerFault150;
					ByteData(2) <= ChickerFault0;
					ByteData(1) <= ChickerChipFaultL;
					ByteData(0) <= ChickerReadyL;
					ByteLoad <= '1';
					ChecksumByte(7) := '1';
					ChecksumByte(6 downto 5) := "00";
					ChecksumByte(4) := ChickerTimeout;
					ChecksumByte(3) := ChickerFault150;
					ChecksumByte(2) := ChickerFault0;
					ChecksumByte(1) := ChickerChipFaultL;
					ChecksumByte(0) := ChickerReadyL;
					ChickerReadyL <= '0';
					ChickerChipFaultL <= '0';
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
					Temp <= std_ulogic_vector(DribblerSpeed(10 downto 8));
				elsif State = SendDribblerSpeedMSB then
					State <= SendBatteryLevelLSB;
					ByteData <= "00000" & Temp;
					ByteLoad <= '1';
					ChecksumByte := unsigned("00000" & Temp);
				elsif State = SendBatteryLevelLSB then
					State <= SendBatteryLevelMSB;
					ByteData <= std_ulogic_vector(BatteryLevel(7 downto 0));
					ByteLoad <= '1';
					ChecksumByte := BatteryLevel(7 downto 0);
					Temp <= std_ulogic_vector("0" & BatteryLevel(9 downto 8));
				elsif State = SendBatteryLevelMSB then
					State <= SendCapacitorLevelLSB;
					ByteData <= "00000" & Temp;
					ByteLoad <= '1';
					ChecksumByte := unsigned("00000" & Temp);
				elsif State = SendCapacitorLevelLSB then
					State <= SendCapacitorLevelMSB;
					ByteData <= std_ulogic_vector(CapacitorLevel(7 downto 0));
					ByteLoad <= '1';
					ChecksumByte := CapacitorLevel(7 downto 0);
					Temp <= std_ulogic_vector("0" & CapacitorLevel(9 downto 8));
				elsif State = SendCapacitorLevelMSB then
					State <= SendFaults;
					ByteData <= "00000" & Temp;
					ByteLoad <= '1';
					ChecksumByte := unsigned("00000" & Temp);
				elsif State = SendFaults then
					State <= SendChecksum;
					ByteData <= "000" & Faults;
					ByteLoad <= '1';
					ChecksumByte := unsigned("000" & Faults);
					Faults <= "00000";
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
