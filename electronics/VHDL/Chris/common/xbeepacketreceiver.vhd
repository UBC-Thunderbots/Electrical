library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketReceiver is
	port(
		Clock1 : in std_ulogic;

		ByteFErr : in std_ulogic;
		ByteData : in std_ulogic_vector(7 downto 0);
		ByteStrobe : in std_ulogic;
		ByteSOP : in std_ulogic;

		Strobe : out std_ulogic := '0';
		Address : out std_ulogic_vector(63 downto 0);
		RSSI : out std_ulogic_vector(7 downto 0);
		FeedbackFlag : out std_ulogic := '0';
		DirectDriveFlag : out std_ulogic := '0';
		ControlledDriveFlag : out std_ulogic := '0';
		DribbleFlag : out std_ulogic := '0';
		Drive1 : out signed(10 downto 0) := to_signed(0, 11);
		Drive2 : out signed(10 downto 0) := to_signed(0, 11);
		Drive3 : out signed(10 downto 0) := to_signed(0, 11);
		Drive4 : out signed(10 downto 0) := to_signed(0, 11);
		Dribble : out signed(10 downto 0) := to_signed(0, 11);
		CommandSeq : out std_ulogic_vector(7 downto 0) := X"00";
		Command : out std_ulogic_vector(7 downto 0) := X"00";
		CommandData : out std_ulogic_vector(15 downto 0) := X"0000"
	);
end entity XBeePacketReceiver;

architecture Behavioural of XBeePacketReceiver is
	type StateType is (ExpectSOP, ExpectLengthMSB, ExpectLengthLSB, ExpectAPIID, ExpectAddress, ExpectRSSI, ExpectOptions, ExpectData, ExpectChecksum, CheckChecksum);
	signal State : StateType := ExpectSOP;
	signal DataLeft : natural range 1 to 15;
	signal Checksum : unsigned(7 downto 0);
	signal AddressBuf : std_ulogic_vector(63 downto 0);
	type DataType is array(0 to 14) of std_ulogic_vector(7 downto 0);
	signal Data : DataType;
begin
	Address <= AddressBuf;

	process(Clock1)
		variable Word : std_ulogic_vector(10 downto 0);
		variable ClearChecksum : boolean;
		variable AddChecksum : boolean;
		variable SetStrobe : boolean;
	begin
		if rising_edge(Clock1) then
			ClearChecksum := false;
			AddChecksum := false;
			SetStrobe := false;
			if ByteFErr = '1' then
				State <= ExpectSOP;
			elsif ByteSOP = '1' then
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
					if ByteData = X"1A" then
						State <= ExpectAPIID;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectAPIID then
					AddChecksum := true;
					if ByteData = X"80" then
						State <= ExpectAddress;
						DataLeft <= 8;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectAddress then
					AddChecksum := true;
					AddressBuf <= AddressBuf(55 downto 0) & ByteData;
					if DataLeft = 1 then
						State <= ExpectRSSI;
					end if;
					DataLeft <= DataLeft - 1;
				elsif State = ExpectRSSI then
					AddChecksum := true;
					RSSI <= ByteData;
					State <= ExpectOptions;
				elsif State = ExpectOptions then
					AddChecksum := true;
					State <= ExpectData;
					DataLeft <= 15;
				elsif State = ExpectData then
					AddChecksum := true;
					Data <= Data(1 to 14) & ByteData;
					if DataLeft = 1 then
						State <= ExpectChecksum;
					end if;
					DataLeft <= DataLeft - 1;
				elsif State = ExpectChecksum then
					AddChecksum := true;
					State <= CheckChecksum;
				end if;
			elsif State = CheckChecksum then
				if Checksum = X"FF" then
					if Data(0)(7) = '1' then
						FeedbackFlag <= Data(0)(6);
						DirectDriveFlag <= Data(0)(0);
						ControlledDriveFlag <= Data(0)(1);
						DribbleFlag <= Data(0)(2);
						Word := Data(2)(2 downto 0) & Data(1);
						Drive1 <= signed(Word);
						Word := Data(4)(2 downto 0) & Data(3);
						Drive2 <= signed(Word);
						Word := Data(6)(2 downto 0) & Data(5);
						Drive3 <= signed(Word);
						Word := Data(8)(2 downto 0) & Data(7);
						Drive4 <= signed(Word);
						Word := Data(10)(2 downto 0) & Data(9);
						Dribble <= signed(Word);
						CommandSeq <= Data(11);
						Command <= Data(12);
						CommandData <= Data(14) & Data(13);
						SetStrobe := true;
					end if;
				end if;
				State <= ExpectSOP;
			end if;
			if ClearChecksum then
				Checksum <= to_unsigned(0, 8);
			elsif AddChecksum then
				Checksum <= Checksum + unsigned(ByteData);
			end if;
			if SetStrobe then
				Strobe <= '1';
			else
				Strobe <= '0';
			end if;
		end if;
	end process;
end architecture Behavioural;
