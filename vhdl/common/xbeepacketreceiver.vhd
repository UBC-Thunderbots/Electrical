library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketReceiver is
	port(
		Clock1 : in std_ulogic;
		Clock100 : in std_ulogic;

		ByteData : in std_ulogic_vector(7 downto 0);
		ByteStrobe : in std_ulogic;
		ByteSOP : in std_ulogic;

		Strobe : out std_ulogic := '0';
		RSSI : out std_ulogic_vector(7 downto 0);
		FeedbackFlag : out std_ulogic := '0';
		DirectDriveFlag : out std_ulogic := '0';
		ControlledDriveFlag : out std_ulogic := '0';
		ChickerEnableFlag : out std_ulogic := '0';
		ChipFlag : out std_ulogic := '0';
		Drive1 : out signed(10 downto 0) := to_signed(0, 11);
		Drive2 : out signed(10 downto 0) := to_signed(0, 11);
		Drive3 : out signed(10 downto 0) := to_signed(0, 11);
		Drive4 : out signed(10 downto 0) := to_signed(0, 11);
		Dribble : out unsigned(10 downto 0) := to_unsigned(0, 11);
		ChickerPower : out unsigned(8 downto 0) := to_unsigned(0, 9)
	);
end entity XBeePacketReceiver;

architecture Behavioural of XBeePacketReceiver is
	type StateType is (ExpectSOP, ExpectLengthMSB, ExpectLengthLSB, ExpectAPIID, ExpectAddressHigh, ExpectAddressLow, ExpectRSSI, ExpectOptions, ExpectRunDataOffset, ExpectChecksumRunDataOffset, CheckChecksumRunDataOffset, ExpectData, ExpectChecksumData, CheckChecksumData);
	signal State : StateType := ExpectSOP;
	signal RunDataOffset : natural range 0 to 255 := 255;
	signal RunDataOffsetShadow : natural range 0 to 255;
	signal DataCounter : natural range 0 to 255;
	signal DataLength : natural range 0 to 255;
	signal ShadowWritePointer : natural range 0 to 255;
	signal Checksum : unsigned(7 downto 0);
	type DataType is array(0 to 8) of std_ulogic_vector(7 downto 0);
	signal Data : DataType;
	type ShadowType is array(0 to 255) of std_ulogic_vector(7 downto 0);
	signal Shadow : ShadowType;
	signal Flag1 : boolean := false;
	signal Flag2 : boolean := false;
	signal Flag3 : boolean := false;
	type CopyStateType is (ReadShadow, WriteData);
	signal CopyState : CopyStateType := ReadShadow;
	signal CopyCounter : natural range 0 to 15 := 9;
	signal CopyOffset : natural range 0 to 255;
	signal CopyBuffer : std_ulogic_vector(7 downto 0);
	signal CopyFirst : boolean := true;
begin
	FeedbackFlag <= Data(0)(6);
	DirectDriveFlag <= Data(0)(0);
	ControlledDriveFlag <= Data(0)(1);
	ChickerEnableFlag <= Data(0)(2);
	ChipFlag <= Data(0)(3);
	Drive1 <= signed(std_ulogic_vector'(Data(2)(2 downto 0) & Data(1)(7 downto 0)));
	Drive2 <= signed(std_ulogic_vector'(Data(3)(5 downto 0) & Data(2)(7 downto 3)));
	Drive3 <= signed(std_ulogic_vector'(Data(5)(0) & Data(4)(7 downto 0) & Data(3)(7 downto 6)));
	Drive4 <= signed(std_ulogic_vector'(Data(6)(3 downto 0) & Data(5)(7 downto 1)));
	Dribble <= unsigned(std_ulogic_vector'(Data(7)(6 downto 0) & Data(6)(7 downto 4)));
	ChickerPower <= unsigned(std_ulogic_vector'(Data(8) & Data(7)(7)));

	process(Clock1)
		variable ClearChecksum : boolean;
		variable AddChecksum : boolean;
		variable ClearDataCounter : boolean;
		variable IncrementDataCounter : boolean;
	begin
		if rising_edge(Clock1) then
			ClearChecksum := false;
			AddChecksum := false;
			Strobe <= '0';
			ClearDataCounter := false;
			IncrementDataCounter := false;
			if ByteSOP = '1' then
				State <= ExpectLengthMSB;
			elsif ByteStrobe = '1' then
				if State = ExpectLengthMSB then
					if ByteData = X"00" then
						State <= ExpectLengthLSB;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectLengthLSB then
					ClearChecksum := true;
					DataLength <= to_integer(unsigned(ByteData));
					ClearDataCounter := true;
					if ByteData >= X"06" then
						State <= ExpectAPIID;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectAPIID then
					AddChecksum := true;
					IncrementDataCounter := true;
					if ByteData = X"81" then
						State <= ExpectAddressHigh;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectAddressHigh then
					AddChecksum := true;
					IncrementDataCounter := true;
					State <= ExpectAddressLow;
				elsif State = ExpectAddressLow then
					AddChecksum := true;
					IncrementDataCounter := true;
					State <= ExpectRSSI;
				elsif State = ExpectRSSI then
					AddChecksum := true;
					IncrementDataCounter := true;
					RSSI <= ByteData;
					State <= ExpectOptions;
				elsif State = ExpectOptions then
					AddChecksum := true;
					IncrementDataCounter := true;
					if ByteData(1) = '1' then
						State <= ExpectData;
					else
						State <= ExpectRunDataOffset;
					end if;
					ShadowWritePointer <= 0;
				elsif State = ExpectData then
					AddChecksum := true;
					IncrementDataCounter := true;
					Shadow(ShadowWritePointer) <= ByteData;
					ShadowWritePointer <= ShadowWritePointer + 1;
					if DataCounter = DataLength then
						State <= ExpectChecksumData;
					end if;
				elsif State = ExpectChecksumData then
					AddChecksum := true;
					State <= CheckChecksumData;
				elsif State = ExpectRunDataOffset then
					AddChecksum := true;
					RunDataOffsetShadow <= to_integer(unsigned(ByteData));
					State <= ExpectChecksumRunDataOffset;
				elsif State = ExpectChecksumRunDataOffset then
					AddChecksum := true;
					State <= CheckChecksumRunDataOffset;
				end if;
			elsif State = CheckChecksumData then
				if Checksum = X"FF" then
					Flag1 <= not Flag1;
				end if;
				State <= ExpectSOP;
			elsif State = CheckChecksumRunDataOffset then
				if Checksum = X"FF" then
					RunDataOffset <= RunDataOffsetShadow;
				end if;
				State <= ExpectSOP;
			end if;
			if ClearChecksum then
				Checksum <= to_unsigned(0, 8);
			elsif AddChecksum then
				Checksum <= Checksum + unsigned(ByteData);
			end if;
			if ClearDataCounter then
				DataCounter <= 1;
			elsif IncrementDataCounter then
				DataCounter <= DataCounter + 1;
			end if;
			if Flag3 /= Flag2 then
				Strobe <= '1';
			else
				Strobe <= '0';
			end if;
			Flag3 <= Flag2;
		end if;
	end process;

	process(Clock100)
		variable ClearCopyCounter : boolean;
		variable IncrementCopyCounter : boolean;
	begin
		if rising_edge(Clock100) then
			ClearCopyCounter := false;
			IncrementCopyCounter := false;
			if CopyCounter /= 9 then
				if CopyState = ReadShadow then
					CopyBuffer <= Shadow(CopyOffset);
					CopyState <= WriteData;
				elsif CopyState = WriteData then
					if CopyFirst and CopyBuffer(7) = '0' then
						CopyCounter <= 9;
					else
						Data(CopyCounter) <= CopyBuffer;
						IncrementCopyCounter := true;
					end if;
					CopyState <= ReadShadow;
					CopyFirst <= false;
				end if;
			elsif Flag2 /= Flag1 then
				if RunDataOffset /= 255 then
					CopyState <= ReadShadow;
					ClearCopyCounter := true;
					CopyFirst <= true;
				end if;
			end if;
			Flag2 <= Flag1;
			if ClearCopyCounter then
				CopyCounter <= 0;
				CopyOffset <= RunDataOffset;
			elsif IncrementCopyCounter then
				CopyCounter <= CopyCounter + 1;
				CopyOffset <= CopyOffset + 1;
			end if;
		end if;
	end process;
end architecture Behavioural;
