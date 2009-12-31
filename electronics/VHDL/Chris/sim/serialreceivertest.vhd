library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialReceiverTest is
end entity SerialReceiverTest;

architecture Behavioural of SerialReceiverTest is
	component SerialReceiver
		port(
			Clock : in std_logic;

			Data : out std_logic_vector(7 downto 0);
			Good : out std_logic;
			FErr : buffer std_logic;

			Serial : in std_logic
		);
	end component SerialReceiver;

	constant ClockPeriod : time := 20 ns;
	constant BitTime : time := 4 us;

	signal Clock : std_logic := '0';
	signal Serial : std_logic := '1';
	signal Data : std_logic_vector(7 downto 0);
	signal Good : std_logic := '0';
	signal FErr : std_logic := '0';
	signal Done : std_logic := '0';
	signal FErrSeen : natural := 0;
	signal BytesSeen : natural := 0;
	signal LastByte : std_logic_vector(7 downto 0);
begin
	uut: SerialReceiver
	port map(
		Clock => Clock,
		Data => Data,
		Good => Good,
		FErr => FErr,
		Serial => Serial
	);

	process
	begin
		Clock <= '1';
		wait for ClockPeriod / 2;
		if Good = '1' then
			LastByte <= Data;
			BytesSeen <= BytesSeen + 1;
		elsif FErr = '1' then
			FErrSeen <= FErrSeen + 1;
		end if;
		Clock <= '0';
		wait for ClockPeriod / 2;
		if Done = '1' then
			wait;
		end if;
	end process;

	process
	begin
		wait for 50 ns;
		assert FErrSeen = 0;
		assert BytesSeen = 0;

		Serial <= '0';
		wait for BitTime;
		Serial <= '1';
		wait for 10 * BitTime;
		assert FErrSeen = 0;
		assert BytesSeen = 1;
		assert LastByte = X"FF";

		Serial <= '0';
		wait for BitTime;
		Serial <= '1';
		wait for BitTime;
		Serial <= '0';
		wait for BitTime;
		Serial <= '1';
		wait for BitTime;
		Serial <= '0';
		wait for BitTime;
		Serial <= '1';
		wait for BitTime;
		Serial <= '0';
		wait for BitTime;
		Serial <= '1';
		wait for BitTime;
		Serial <= '0';
		wait for BitTime;
		Serial <= '1';
		wait for 1.1 * BitTime;
		assert FErrSeen = 0;
		assert BytesSeen = 2;
		assert LastByte = X"55";

		Serial <= '0';
		wait for 10 * BitTime;
		Serial <= '1';
		wait for 3 * BitTime;
		assert FErrSeen > 0;

		Done <= '1';
		wait;
	end process;
end architecture Behavioural;
