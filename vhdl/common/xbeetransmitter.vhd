library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeeTransmitter is
	port(
		Clock1 : in std_ulogic;

		Start : in std_ulogic;

		RSSI : in std_ulogic_vector(7 downto 0);
		DribblerSpeed : in unsigned(10 downto 0);
		BatteryLevel : in unsigned(9 downto 0);
		Fault1 : in std_ulogic;
		Fault2 : in std_ulogic;
		Fault3 : in std_ulogic;
		Fault4 : in std_ulogic;
		FaultD : in std_ulogic;
		ChickerReady : in boolean;
		ChickerFaultLT3751 : in boolean;
		ChickerFaultLow : in boolean;
		ChickerFaultHigh : in boolean;
		ChickerChargeTimeout : in boolean;
		CapacitorVoltage : in unsigned(9 downto 0);

		Serial : out std_ulogic
	);
end entity XBeeTransmitter;

architecture Behavioural of XBeeTransmitter is
	signal ByteData : std_ulogic_vector(7 downto 0);
	signal ByteLoad : std_ulogic;
	signal ByteSOP : std_ulogic;
	signal ByteBusy : std_ulogic;
	signal SerialData : std_ulogic_vector(7 downto 0);
	signal SerialLoad : std_ulogic;
	signal SerialBusy : std_ulogic;
begin
	XBeePacketTransmitterInstance : entity work.XBeePacketTransmitter(Behavioural)
	port map(
		Clock1 => Clock1,
		Start => Start,
		RSSI => RSSI,
		DribblerSpeed => DribblerSpeed,
		BatteryLevel => BatteryLevel,
		CapacitorVoltage => CapacitorVoltage,
		Fault1 => Fault1,
		Fault2 => Fault2,
		Fault3 => Fault3,
		Fault4 => Fault4,
		FaultD => FaultD,
		ChickerReady => ChickerReady,
		ChickerFaultLT3751 => ChickerFaultLT3751,
		ChickerFaultLow => ChickerFaultLow,
		ChickerFaultHigh => ChickerFaultHigh,
		ChickerChargeTimeout => ChickerChargeTimeout,
		ByteData => ByteData,
		ByteLoad => ByteLoad,
		ByteSOP => ByteSOP,
		ByteBusy => ByteBusy
	);

	XBeeByteTransmitterInstance : entity work.XBeeByteTransmitter(Behavioural)
	port map(
		Clock1 => Clock1,
		Data => ByteData,
		Load => ByteLoad,
		SOP => ByteSOP,
		Busy => ByteBusy,
		SerialData => SerialData,
		SerialLoad => SerialLoad,
		SerialBusy => SerialBusy
	);

	SerialTransmitterInstance : entity work.SerialTransmitter(Behavioural)
	port map(
		Clock1 => Clock1,
		Data => SerialData,
		Load => SerialLoad,
		Busy => SerialBusy,
		Serial => Serial
	);
end architecture Behavioural;
