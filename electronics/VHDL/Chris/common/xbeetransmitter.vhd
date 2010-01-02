library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeeTransmitter is
	port(
		Clock : in std_ulogic;

		Start : in std_ulogic;
		Busy : out std_ulogic;

		Address : in std_ulogic_vector(63 downto 0);
		RSSI : in std_ulogic_vector(7 downto 0);
		DribblerSpeed : in unsigned(15 downto 0);
		BatteryLevel : in unsigned(15 downto 0);
		Fault1 : in std_ulogic;
		Fault2 : in std_ulogic;
		Fault3 : in std_ulogic;
		Fault4 : in std_ulogic;
		Fault5 : in std_ulogic;
		CommandAck : in std_ulogic_vector(7 downto 0);

		Serial : out std_ulogic
	);
end entity XBeeTransmitter;

architecture Behavioural of XBeeTransmitter is
	component SerialTransmitter is
		port(
			Clock : in std_ulogic;
			Data : in std_ulogic_vector(7 downto 0);
			Load : in std_ulogic;
			Busy : out std_ulogic;
			Serial : out std_ulogic
		);
	end component SerialTransmitter;

	component XBeeByteTransmitter is
		port (
			Clock : in std_ulogic;
			Data : in std_ulogic_vector(7 downto 0);
			Load : in std_ulogic;
			SOP : in std_ulogic;
			Busy : out std_ulogic;
			SerialData : out std_ulogic_vector(7 downto 0);
			SerialLoad : out std_ulogic;
			SerialBusy : in std_ulogic
		);
	end component XBeeByteTransmitter;

	component XBeePacketTransmitter is
		port(
			Clock : in std_ulogic;
			Start : in std_ulogic;
			Busy : out std_ulogic;
			Address : in std_ulogic_vector(63 downto 0);
			RSSI : in std_ulogic_vector(7 downto 0);
			DribblerSpeed : in unsigned(15 downto 0);
			BatteryLevel : in unsigned(15 downto 0);
			Fault1 : in std_ulogic;
			Fault2 : in std_ulogic;
			Fault3 : in std_ulogic;
			Fault4 : in std_ulogic;
			Fault5 : in std_ulogic;
			CommandAck : in std_ulogic_vector(7 downto 0);
			ByteData : out std_ulogic_vector(7 downto 0);
			ByteLoad : out std_ulogic;
			ByteSOP : out std_ulogic;
			ByteBusy : in std_ulogic
		);
	end component XBeePacketTransmitter;

	signal ByteData : std_ulogic_vector(7 downto 0);
	signal ByteLoad : std_ulogic;
	signal ByteSOP : std_ulogic;
	signal ByteBusy : std_ulogic;
	signal SerialData : std_ulogic_vector(7 downto 0);
	signal SerialLoad : std_ulogic;
	signal SerialBusy : std_ulogic;
begin
	XBeePacketTransmitterInstance : XBeePacketTransmitter
	port map(
		Clock => Clock,
		Start => Start,
		Busy => Busy,
		Address => Address,
		RSSI => RSSI,
		DribblerSpeed => DribblerSpeed,
		BatteryLevel => BatteryLevel,
		Fault1 => Fault1,
		Fault2 => Fault2,
		Fault3 => Fault3,
		Fault4 => Fault4,
		Fault5 => Fault5,
		CommandAck => CommandAck,
		ByteData => ByteData,
		ByteLoad => ByteLoad,
		ByteSOP => ByteSOP,
		ByteBusy => ByteBusy
	);

	XBeeByteTransmitterInstance : XBeeByteTransmitter
	port map(
		Clock => Clock,
		Data => ByteData,
		Load => ByteLoad,
		SOP => ByteSOP,
		Busy => ByteBusy,
		SerialData => SerialData,
		SerialLoad => SerialLoad,
		SerialBusy => SerialBusy
	);

	SerialTransmitterInstance : SerialTransmitter
	port map(
		Clock => Clock,
		Data => SerialData,
		Load => SerialLoad,
		Busy => SerialBusy,
		Serial => Serial
	);
end architecture Behavioural;
