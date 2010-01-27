library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBee is
	port(
		Clock1 : in std_ulogic;
		Clock100 : in std_ulogic;

		DirectDriveFlag : out std_ulogic;
		ControlledDriveFlag : out std_ulogic;
		DribbleFlag : out std_ulogic;
		Drive1 : out signed(10 downto 0);
		Drive2 : out signed(10 downto 0);
		Drive3 : out signed(10 downto 0);
		Drive4 : out signed(10 downto 0);
		Dribble : out signed(10 downto 0);

		DribblerSpeed : in signed(10 downto 0);
		VMon : in unsigned(9 downto 0);
		Fault1 : in std_ulogic;
		Fault2 : in std_ulogic;
		Fault3 : in std_ulogic;
		Fault4 : in std_ulogic;
		FaultD : in std_ulogic;

		SerialIn : in std_ulogic;
		SerialOut : out std_ulogic
	);
end entity XBee;

architecture Behavioural of XBee is
	signal AddressShifterIn : std_ulogic_vector(7 downto 0);
	signal AddressShifterOut : std_ulogic_vector(7 downto 0);
	signal AddressShifterRXStrobe : std_ulogic;
	signal AddressShifterTXStrobe : std_ulogic;
	signal AddressShifterStrobe : std_ulogic;

	signal RXStrobe : std_ulogic;
	signal RSSI : std_ulogic_vector(7 downto 0);
	signal FeedbackFlag : std_ulogic;
	signal TXStrobe : std_ulogic;
begin
	AddressShifter : entity work.ByteShifter(Behavioural)
	generic map(
		NumBytes => 8
	)
	port map(
		Clock => Clock1,
		InData => AddressShifterIn,
		OutData => AddressShifterOut,
		Strobe => AddressShifterStrobe
	);

	AddressShifterStrobe <= AddressShifterRXStrobe or AddressShifterTXStrobe;

	XBeeReceiverInstance : entity work.XBeeReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock100 => Clock100,
		Strobe => RXStrobe,
		AddressByte => AddressShifterIn,
		AddressStrobe => AddressShifterRXStrobe,
		RSSI => RSSI,
		FeedbackFlag => FeedbackFlag,
		DirectDriveFlag => DirectDriveFlag,
		ControlledDriveFlag => ControlledDriveFlag,
		DribbleFlag => DribbleFlag,
		Drive1 => Drive1,
		Drive2 => Drive2,
		Drive3 => Drive3,
		Drive4 => Drive4,
		Dribble => Dribble,
		Serial => SerialIn
	);

	XBeeTransmitterInstance : entity work.XBeeTransmitter(Behavioural)
	port map(
		Clock1 => Clock1,
		Start => TXStrobe,
		AddressByte => AddressShifterOut,
		AddressStrobe => AddressShifterTXStrobe,
		RSSI => RSSI,
		DribblerSpeed => DribblerSpeed,
		BatteryLevel => VMon,
		Fault1 => Fault1,
		Fault2 => Fault2,
		Fault3 => Fault3,
		Fault4 => Fault4,
		FaultD => FaultD,
		Serial => SerialOut
	);

	TXStrobe <= RXStrobe and FeedbackFlag;
end architecture Behavioural;
