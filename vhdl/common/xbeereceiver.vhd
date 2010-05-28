library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeeReceiver is
	port(
		Clock1 : in std_ulogic;
		Clock10 : in std_ulogic;
		Clock100 : in std_ulogic;

		Strobe : out std_ulogic;
		RSSI : out std_ulogic_vector(7 downto 0);
		FeedbackFlag : out std_ulogic;
		DirectDriveFlag : out std_ulogic;
		ControlledDriveFlag : out std_ulogic;
		ChickerEnableFlag : out std_ulogic;
		ChipFlag : out std_ulogic;
		Drive1 : out signed(10 downto 0);
		Drive2 : out signed(10 downto 0);
		Drive3 : out signed(10 downto 0);
		Drive4 : out signed(10 downto 0);
		Dribble : out unsigned(10 downto 0);
		ChickerPower : out unsigned(8 downto 0);

		Serial : in std_ulogic
	);
end entity XBeeReceiver;

architecture Behavioural of XBeeReceiver is
	signal SerialData : std_ulogic_vector(7 downto 0);
	signal SerialStrobe : std_ulogic;
	signal ByteData : std_ulogic_vector(7 downto 0);
	signal ByteStrobe : std_ulogic;
	signal ByteSOP : std_ulogic;
begin
	SerialReceiverInstance : entity work.SerialReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock10 => Clock10,
		Serial => Serial,
		Data => SerialData,
		Strobe => SerialStrobe
	);

	XBeeByteReceiverInstance : entity work.XBeeByteReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		SerialData => SerialData,
		SerialStrobe => SerialStrobe,
		Data => ByteData,
		Strobe => ByteStrobe,
		SOP => ByteSOP
	);

	XBeePacketReceiverInstance : entity work.XBeePacketReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock100 => Clock100,
		ByteData => ByteData,
		ByteStrobe => ByteStrobe,
		ByteSOP => ByteSOP,
		Strobe => Strobe,
		RSSI => RSSI,
		FeedbackFlag => FeedbackFlag,
		DirectDriveFlag => DirectDriveFlag,
		ControlledDriveFlag => ControlledDriveFlag,
		ChickerEnableFlag => ChickerEnableFlag,
		ChipFlag => ChipFlag,
		Drive1 => Drive1,
		Drive2 => Drive2,
		Drive3 => Drive3,
		Drive4 => Drive4,
		Dribble => Dribble,
		ChickerPower => ChickerPower
	);
end architecture Behavioural;
