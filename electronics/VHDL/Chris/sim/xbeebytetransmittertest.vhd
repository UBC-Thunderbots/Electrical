library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeeByteTransmitterTest is
end XBeeByteTransmitterTest;

architecture Behavioural of XBeeByteTransmitterTest is
	component XBeeByteTransmitter is
		port(
			Clock : in std_ulogic;

			Data : in std_ulogic_vector(7 downto 0);
			Load : in std_ulogic;
			SOP : in std_ulogic;
			Busy : out std_ulogic;

			SerialData : out std_ulogic_vector(7 downto 0) := "00000000";
			SerialLoad : out std_ulogic := '0';
			SerialBusy : in std_ulogic
		);
	end component XBeeByteTransmitter;

	constant ClockPeriod : time := 20 ns;

	signal Clock : std_ulogic := '0';
	signal Data : std_ulogic_vector(7 downto 0) := X"00";
	signal Load : std_ulogic := '0';
	signal SOP : std_ulogic := '0';
	signal Busy : std_ulogic;
	signal SerialData : std_ulogic_vector(7 downto 0);
	signal SerialLoad : std_ulogic;
	signal SerialBusy : std_ulogic;
	signal SerialWorking : std_ulogic := '0';

	signal NumBytesSeen : natural := 0;
	type BytesSeenType is array(16 downto 0) of std_ulogic_vector(7 downto 0);
	signal BytesSeen : BytesSeenType;
begin
	uut: XBeeByteTransmitter
	port map(
		Clock => Clock,

		Data => Data,
		Load => Load,
		SOP => SOP,
		Busy => Busy,

		SerialData => SerialData,
		SerialLoad => SerialLoad,
		SerialBusy => SerialBusy
	);

	process
	begin
		while SerialLoad = '0' loop
			wait until rising_edge(Clock);
		end loop;
		SerialWorking <= '1';
		BytesSeen(NumBytesSeen) <= SerialData;
		NumBytesSeen <= NumBytesSeen + 1;
		wait for ClockPeriod * 200 * 10;
		wait until rising_edge(Clock);
		SerialWorking <= '0';
	end process;
	SerialBusy <= SerialWorking or SerialLoad;

	process(SerialWorking, SerialLoad)
	begin
		assert not (SerialWorking = '1' and SerialLoad = '1');
	end process;

	process
		procedure Tick is
		begin
			wait for ClockPeriod / 4;
			Clock <= '1';
			wait for ClockPeriod / 2;
			Clock <= '0';
			wait for ClockPeriod / 4;
		end procedure Tick;

		procedure WaitSerial is
		begin
			while SerialBusy = '1' loop
				assert Busy = '1';
				Tick;
			end loop;
		end procedure WaitSerial;
	begin
		Tick;

		SOP <= '1';
		Tick;
		assert Busy = '1';
		SOP <= '0';
		Tick;
		WaitSerial;
		assert Busy = '1';
		Tick;
		assert Busy = '0';
		assert NumBytesSeen = 1;
		assert BytesSeen(0) = X"7E";

		Data <= X"27";
		Load <= '1';
		Tick;
		assert Busy = '1';
		Data <= X"00";
		Load <= '0';
		Tick;
		WaitSerial;
		assert Busy = '1';
		Tick;
		assert Busy = '0';
		assert NumBytesSeen = 2;
		assert BytesSeen(1) = X"27";

		Data <= X"7E";
		Load <= '1';
		Tick;
		assert Busy = '1';
		Data <= X"00";
		Load <= '0';
		Tick;
		WaitSerial;
		assert Busy = '1';
		Tick;
		assert Busy = '1';
		Tick;
		assert Busy = '1';
		Tick;
		assert Busy = '1';
		WaitSerial;
		assert Busy = '1';
		Tick;
		assert Busy = '0';
		assert NumBytesSeen = 4;
		assert BytesSeen(2) = X"7D";
		assert BytesSeen(3) = X"5E";

		wait;
	end process;
end architecture Behavioural;
