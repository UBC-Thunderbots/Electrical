library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBee is
	port(
		Clock1 : in std_ulogic;
		Clock10 : in std_ulogic;
		Clock100 : in std_ulogic;

		DirectDriveFlag : out std_ulogic;
		ControlledDriveFlag : out std_ulogic;
		ChickerEnable : out boolean;
		Drive1 : out signed(10 downto 0);
		Drive2 : out signed(10 downto 0);
		Drive3 : out signed(10 downto 0);
		Drive4 : out signed(10 downto 0);
		Dribble : out unsigned(10 downto 0);
		ChickerPower : out unsigned(8 downto 0);
		ChipFlag : out boolean;
		Timeout : out boolean;

		DribblerSpeed : in unsigned(10 downto 0);
		VMon : in unsigned(9 downto 0);
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

		SerialIn : in std_ulogic;
		SerialOut : out std_ulogic
	);
end entity XBee;

architecture Behavioural of XBee is
	signal RXStrobe : std_ulogic;
	signal RSSI : std_ulogic_vector(7 downto 0);
	signal FeedbackFlag : std_ulogic;
	signal TXStrobe : std_ulogic;
	subtype TimeoutCounterType is natural range 0 to 499999;
	signal TimeoutCounter : TimeoutCounterType := 0;
begin
	XBeeReceiverInstance : entity work.XBeeReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock10 => Clock10,
		Clock100 => Clock100,
		Strobe => RXStrobe,
		RSSI => RSSI,
		FeedbackFlag => FeedbackFlag,
		DirectDriveFlag => DirectDriveFlag,
		ControlledDriveFlag => ControlledDriveFlag,
		ChickerEnable => ChickerEnable,
		ChipFlag => ChipFlag,
		Drive1 => Drive1,
		Drive2 => Drive2,
		Drive3 => Drive3,
		Drive4 => Drive4,
		Dribble => Dribble,
		ChickerPower => ChickerPower,
		Serial => SerialIn
	);

	XBeeTransmitterInstance : entity work.XBeeTransmitter(Behavioural)
	port map(
		Clock1 => Clock1,
		Start => TXStrobe,
		RSSI => RSSI,
		DribblerSpeed => DribblerSpeed,
		BatteryLevel => VMon,
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
		CapacitorVoltage => CapacitorVoltage,
		Serial => SerialOut
	);

	TXStrobe <= RXStrobe and FeedbackFlag;

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if RXStrobe = '1' then
				TimeoutCounter <= TimeoutCounterType'high;
			elsif TimeoutCounter /= 0 then
				TimeoutCounter <= TimeoutCounter - 1;
			end if;
		end if;
	end process;

	Timeout <= TimeoutCounter = 0;
end architecture Behavioural;
