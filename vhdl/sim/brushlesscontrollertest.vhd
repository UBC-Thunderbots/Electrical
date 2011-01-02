library ieee;
use ieee.std_logic_1164.all;
use work.types.all;


entity BrushlessControllerTest is
end entity;

architecture Behavioural of BrushlessControllerTest is
	signal Reverse : std_logic;
	signal HallSensor : std_logic_vector(3 downto 1);
	signal AllLow : std_logic;
	signal AllHigh : std_logic;
	signal UpperPhase : std_logic_vector(3 downto 1);
	signal LowerPhase : std_logic_vector(3 downto 1);
	constant Delay : time := 1 uS;
begin

	UUT: entity work.BrushlessController(Behavioural)
		port map(
			Reverse => Reverse,
			HallSensor => HallSensor,
			AllLow => AllLow,
			AllHigh => AllHigh,
			UpperPhase => UpperPhase,
			LowerPhase => LowerPhase
		);

		process
		begin
			HallSensor <= "001";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "110");
			assert(LowerPhase = "100");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "011";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "101");
			assert(LowerPhase = "100");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "010";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "101");
			assert(LowerPhase = "001");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "110";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "011");
			assert(LowerPhase = "001");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "100";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "011");
			assert(LowerPhase = "010");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "101";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "110");
			assert(LowerPhase = "010");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "001";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "011");
			assert(LowerPhase = "001");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "011";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "011");
			assert(LowerPhase = "010");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "010";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "110");
			assert(LowerPhase = "010");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "110";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "110");
			assert(LowerPhase = "100");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "100";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "101");
			assert(LowerPhase = "100");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "101";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "101");
			assert(LowerPhase = "001");
			assert(AllLow = '0');
			assert(AllHigh = '0');

			HallSensor <= "111";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "111");
			assert(LowerPhase = "000");
			assert(AllLow = '0');
			assert(AllHigh = '1');

			HallSensor <= "111";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "111");
			assert(LowerPhase = "000");
			assert(AllLow = '0');
			assert(AllHigh = '1');

			HallSensor <= "000";
			Reverse <= '0';
			wait for Delay;
			assert(UpperPhase = "111");
			assert(LowerPhase = "000");
			assert(AllLow = '1');
			assert(AllHigh = '0');

			HallSensor <= "000";
			Reverse <= '1';
			wait for Delay;
			assert(UpperPhase = "111");
			assert(LowerPhase = "000");
			assert(AllLow = '1');
			assert(AllHigh = '0');
			wait;
		end process;
		
end;
