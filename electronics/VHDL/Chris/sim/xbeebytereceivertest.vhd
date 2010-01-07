library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeeByteReceiverTest is
end entity XBeeByteReceiverTest;

architecture Behavioural of XBeeByteReceiverTest is
	constant ClockPeriod : time := 100 ns;

	signal Clock1 : std_ulogic := '0';
	signal SerialData : std_ulogic_vector(7 downto 0) := X"00";
	signal SerialStrobe : std_ulogic := '0';
	signal SerialFErr : std_ulogic := '0';
	signal FErr : std_ulogic;
	signal Data : std_ulogic_vector(7 downto 0);
	signal Strobe : std_ulogic;
	signal SOP : std_ulogic;
begin
	uut : entity work.XBeeByteReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		SerialData => SerialData,
		SerialStrobe => SerialStrobe,
		SerialFErr => SerialFErr,
		FErr => FErr,
		Data => Data,
		Strobe => Strobe,
		SOP => SOP
	);

	process
		procedure Tick is
		begin
			wait for ClockPeriod / 4;
			Clock1 <= '1';
			wait for ClockPeriod / 2;
			Clock1 <= '0';
			wait for ClocKperiod / 4;
		end procedure Tick;

		procedure Delta is
		begin
			wait for 1 fs;
		end procedure Delta;
	begin
		Tick;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';

		SerialData <= X"7D";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialStrobe <= '0';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"FF";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Data = X"DF";
		assert Strobe = '1';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialStrobe <= '0';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		Tick;
		Tick;

		SerialData <= X"7E";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '1';
		Tick;

		SerialStrobe <= '0';
		SerialData <= X"00";
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		Tick;
		Tick;

		SerialData <= X"7D";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialStrobe <= '0';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		Tick;
		Tick;
		Tick;

		SerialData <= X"5E";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Data = X"7E";
		assert Strobe = '1';
		assert SOP = '0';
		Tick;

		SerialData <= X"7D";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"7E";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '1';
		Tick;

		SerialData <= X"27";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Data = X"27";
		assert Strobe = '1';
		assert SOP = '0';
		Tick;

		SerialData <= X"7D";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"7D";
		SerialStrobe <= '1';
		Delta;
		assert FErr = '1';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		SerialData <= X"00";
		SerialStrobe <= '0';
		Delta;
		assert FErr = '0';
		assert Strobe = '0';
		assert SOP = '0';
		Tick;

		wait;
	end process;
end architecture Behavioural;
