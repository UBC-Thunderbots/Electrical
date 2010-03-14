library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketReceiver is
	port(
		Clock1 : in std_ulogic;

		ByteData : in std_ulogic_vector(7 downto 0);
		ByteStrobe : in std_ulogic;
		ByteSOP : in std_ulogic;

		Strobe : out std_ulogic := '0';
		AddressByte : out std_ulogic_vector(7 downto 0);
		AddressStrobe : out std_ulogic := '0';
		RSSI : out std_ulogic_vector(7 downto 0);
		FeedbackFlag : out std_ulogic := '0';
		DirectDriveFlag : out std_ulogic := '0';
		ControlledDriveFlag : out std_ulogic := '0';
		ChickerEnableFlag : out std_ulogic := '0';
		Drive1 : out signed(10 downto 0) := to_signed(0, 11);
		Drive2 : out signed(10 downto 0) := to_signed(0, 11);
		Drive3 : out signed(10 downto 0) := to_signed(0, 11);
		Drive4 : out signed(10 downto 0) := to_signed(0, 11);
		Dribble : out signed(10 downto 0) := to_signed(0, 11)
	);
end entity XBeePacketReceiver;

architecture Behavioural of XBeePacketReceiver is
	type StateType is (ExpectSOP, ExpectLengthMSB, ExpectLengthLSB, ExpectAPIID, ExpectAddress, ExpectRSSI, ExpectOptions, ExpectData, ExpectChecksum, CheckChecksum);
	signal State : StateType := ExpectSOP;
	signal DataLeft : natural range 0 to 8;
	signal Checksum : unsigned(7 downto 0);
	type DataType is array(0 to 8) of std_ulogic_vector(7 downto 0);
	signal Data : DataType;
begin
	process(Clock1)
		variable ClearChecksum : boolean;
		variable AddChecksum : boolean;
		variable SetStrobe : boolean;
	begin
		if rising_edge(Clock1) then
			ClearChecksum := false;
			AddChecksum := false;
			SetStrobe := false;
			AddressStrobe <= '0';
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
					if ByteData = X"14" then
						State <= ExpectAPIID;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectAPIID then
					AddChecksum := true;
					if ByteData = X"80" then
						State <= ExpectAddress;
						DataLeft <= 7;
					else
						State <= ExpectSOP;
					end if;
				elsif State = ExpectAddress then
					AddChecksum := true;
					AddressByte <= ByteData;
					AddressStrobe <= '1';
					if DataLeft = 0 then
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
					DataLeft <= 8;
				elsif State = ExpectData then
					AddChecksum := true;
					Data <= Data(1 to 8) & ByteData;
					if DataLeft = 0 then
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
						ChickerEnableFlag <= Data(0)(2);
						Drive1 <= signed(std_ulogic_vector'(Data(2)(2 downto 0) & Data(1)(7 downto 0)));
						Drive2 <= signed(std_ulogic_vector'(Data(3)(5 downto 0) & Data(2)(7 downto 3)));
						Drive3 <= signed(std_ulogic_vector'(Data(5)(0) & Data(4)(7 downto 0) & Data(3)(7 downto 6)));
						Drive4 <= signed(std_ulogic_vector'(Data(6)(3 downto 0) & Data(5)(7 downto 1)));
						Dribble <= signed(std_ulogic_vector'(Data(7)(6 downto 0) & Data(6)(7 downto 4)));
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
