library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialReceiverTest is
end entity SerialReceiverTest;

architecture Behavioural of SerialReceiverTest is
	constant ClockPeriod : time := 100 ns;
	constant BitTime : time := 4 us;

	signal Clock1 : std_ulogic := '0';
	signal Clock10 : std_ulogic := '0';
	signal Serial : std_ulogic := '1';
	signal Data : std_ulogic_vector(7 downto 0);
	signal Good : std_ulogic := '0';
	signal FErr : std_ulogic := '0';
	signal Done : std_ulogic := '0';
	signal FErrSeen : natural := 0;
	signal BytesSeen : natural := 0;
	signal LastByte : std_ulogic_vector(7 downto 0);
begin
	uut : entity work.SerialReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock10 => Clock10,
		Data => Data,
		Good => Good,
		FErr => FErr,
		Serial => Serial
	);

	process
	begin
		Clock1 <= '1';
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock1 <= '0';
		Clock10 <= '1';
		if Good = '1' then
			LastByte <= Data;
			BytesSeen <= BytesSeen + 1;
		elsif FErr = '1' then
			FErrSeen <= FErrSeen + 1;
		end if;
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
		wait for ClockPeriod / 2;
		Clock10 <= '1';
		wait for ClockPeriod / 2;
		Clock10 <= '0';
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
		wait for 10 * BitTime + 20 * ClockPeriod;
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
		wait for 1.1 * BitTime + 20 * ClockPeriod;
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
