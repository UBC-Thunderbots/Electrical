library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeeByteReceiverTest is
end entity XBeeByteReceiverTest;

architecture Behavioural of XBeeByteReceiverTest is
	component XBeeByteReceiver is
		port(
			Clock : in std_ulogic;

			SerialData : in std_ulogic_vector(7 downto 0);
			SerialGood : in std_ulogic;
			SerialFErr : in std_ulogic;

			FErr : out std_ulogic := '0';
			Data : out std_ulogic_vector(7 downto 0);
			Good : out std_ulogic := '0';
			SOP : out std_ulogic := '0'
		);
	end component XBeeByteReceiver;

	constant ClockPeriod : time := 20 ns;

	signal Clock : std_ulogic := '0';
	signal SerialData : std_ulogic_vector(7 downto 0) := X"00";
	signal SerialGood : std_ulogic := '0';
	signal SerialFErr : std_ulogic := '0';
	signal FErr : std_ulogic;
	signal Data : std_ulogic_vector(7 downto 0);
	signal Good : std_ulogic;
	signal SOP : std_ulogic;
begin
	uut: XBeeByteReceiver
	port map(
		Clock => Clock,
		SerialData => SerialData,
		SerialGood => SerialGood,
		SerialFErr => SerialFErr,
		FErr => FErr,
		Data => Data,
		Good => Good,
		SOP => SOP
	);

	process
		procedure Tick is
		begin
			wait for ClockPeriod / 4;
			Clock <= '1';
			wait for ClockPeriod / 2;
			Clock <= '0';
			wait for ClocKperiod / 4;
		end procedure Tick;

		procedure Delta is
		begin
			wait for 1 fs;
		end procedure Delta;
	begin
		Tick;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';

		SerialData <= X"7D";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialGood <= '0';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"FF";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Data = X"DF";
		assert Good = '1';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialGood <= '0';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		Tick;
		Tick;

		SerialData <= X"7E";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '1';
		Tick;

		SerialGood <= '0';
		SerialData <= X"00";
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		Tick;
		Tick;

		SerialData <= X"7D";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialGood <= '0';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		Tick;
		Tick;
		Tick;

		SerialData <= X"5E";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Data = X"7E";
		assert Good = '1';
		assert SOP = '0';
		Tick;

		SerialData <= X"7D";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"7E";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '1';
		Tick;

		SerialData <= X"27";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Data = X"27";
		assert Good = '1';
		assert SOP = '0';
		Tick;

		SerialData <= X"7D";
		SerialGood <= '1';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"7D";
		SerialGood <= '1';
		Delta;
		assert FErr = '1';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialGood <= '0';
		Delta;
		assert FErr = '0';
		assert Good = '0';
		assert SOP = '0';
		Tick;

		wait;
	end process;
end architecture Behavioural;
