library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketReceiver is
	port(
		Clock : in std_ulogic;

		ByteFErr : in std_ulogic;
		ByteData : in std_ulogic_vector(7 downto 0);
		ByteGood : in std_ulogic;
		ByteSOP : in std_ulogic;

		Good : out std_ulogic := '0';
		Address : out std_ulogic_vector(63 downto 0) := X"0000000000000000";
		RSSI : out std_ulogic_vector(7 downto 0);
		FeedbackFlag : out std_ulogic := '0';
		DirectDriveFlag : out std_ulogic := '0';
		Drive1 : out signed(15 downto 0) := to_signed(0, 16);
		Drive2 : out signed(15 downto 0) := to_signed(0, 16);
		Drive3 : out signed(15 downto 0) := to_signed(0, 16);
		Drive4 : out signed(15 downto 0) := to_signed(0, 16);
		Dribble : out signed(15 downto 0) := to_signed(0, 16);
		CommandSeq : out std_ulogic_vector(7 downto 0) := X"00";
		Command : out std_ulogic_vector(7 downto 0) := X"00";
		CommandData : out std_ulogic_vector(15 downto 0) := X"0000"
	);
end entity XBeePacketReceiver;

architecture Behavioural of XBeePacketReceiver is
	type StateType is (ExpectSOP, ExpectLengthMSB, ExpectLengthLSB, ExpectData, ExpectChecksum, CheckChecksum);
	signal State : StateType := ExpectSOP;
	signal DataLeft : natural range 1 to 26;
	signal Checksum : unsigned(7 downto 0);
	type DataType is array(0 to 25) of std_ulogic_vector(7 downto 0);
	signal Data : DataType;
begin
	process(Clock)
		variable Word : std_ulogic_vector(15 downto 0);
	begin
		if rising_edge(Clock) then
			Good <= '0';
			if ByteFErr = '1' then
				State <= ExpectSOP;
			elsif ByteSOP = '1' then
				State <= ExpectLengthMSB;
			elsif ByteGood = '1' then
				if State = ExpectLengthMSB then
					if ByteData = X"00" then
						State <= ExpectLengthLSB;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectLengthLSB then
					if ByteData = X"1A" then
						State <= ExpectData;
						DataLeft <= 26;
						Checksum <= X"00";
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectData then
					Data <= Data(1 to 25) & ByteData;
					Checksum <= Checksum + unsigned(ByteData);
					if DataLeft = 1 then
						State <= ExpectChecksum;
					end if;
					DataLeft <= DataLeft - 1;
				elsif State = ExpectChecksum then
					Checksum <= Checksum + unsigned(ByteData);
					State <= CheckChecksum;
				end if;
			elsif State = CheckChecksum then
				if Checksum = X"FF" then
					if Data(0) = X"80" and Data(11)(7) = '1' then
						Address <= Data(1) & Data(2) & Data(3) & Data(4) & Data(5) & Data(6) & Data(7) & Data(8);
						RSSI <= Data(9);
						FeedbackFlag <= Data(11)(6);
						DirectDriveFlag <= Data(11)(0);
						Word := Data(13) & Data(12);
						Drive1 <= signed(Word);
						Word := Data(15) & Data(14);
						Drive2 <= signed(Word);
						Word := Data(17) & Data(16);
						Drive3 <= signed(Word);
						Word := Data(19) & Data(18);
						Drive4 <= signed(Word);
						Word := Data(21) & Data(20);
						Dribble <= signed(Word);
						CommandSeq <= Data(22);
						Command <= Data(23);
						CommandData <= Data(25) & Data(24);
						Good <= '1';
					end if;
				end if;
				State <= ExpectSOP;
			end if;
		end if;
	end process;
end architecture Behavioural;
