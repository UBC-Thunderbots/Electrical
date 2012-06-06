library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.clock.all;

entity ClockGen is
	port(
		Oscillator0 : in std_ulogic;
		Oscillator1 : in std_ulogic;
		Clocks : out clocks_t);
end entity ClockGen;

architecture Behavioural of ClockGen is
	signal Oscillator0Buffered : std_ulogic;
	signal PLLInputClock : std_ulogic;
	signal StepUpDCMStatus : std_logic_vector(7 downto 0);
	signal StepUpDCMLocked : std_ulogic;
	signal PLLReset : std_ulogic;
	signal PLLOutputs : std_ulogic_vector(2 downto 0);
	signal PLLFeedbackClock : std_ulogic;
	signal PLLLocked : std_ulogic;
	signal BufferedPLLOutputs : std_ulogic_vector(PLLOutputs'range);
begin
	IBufferG : IBufG
	port map(
		I => Oscillator0,
		O => Oscillator0Buffered);

	-- Input from the oscillator is 8 MHz
	-- CLKFX output (PLLInputClock) is 8 × 5 = 40 MHz
	StepUpDCM : DCM_SP
	generic map(
		CLKIN_PERIOD => 1.0e9 / 8.0e6,
		CLK_FEEDBACK => "NONE",
		CLKFX_MULTIPLY => 5,
		CLKFX_DIVIDE => 1)
	port map(
		CLKIN => Oscillator0Buffered,
		RST => '0',
		CLKFX => PLLInputClock,
		STATUS => StepUpDCMStatus,
		LOCKED => StepUpDCMLocked);

	PLLReset <= StepUpDCMStatus(2) or not StepUpDCMLocked;

	-- PLLInputClock is 40 MHz
	-- VCO is 40 × 10 = 400 MHz
	MainPLL : PLL_BASE
	generic map(
		CLKOUT0_DIVIDE => 100, -- CLKOUT0 is 400 ÷ 100 = 4 MHz
		CLKOUT1_DIVIDE => 50, -- CLKOUT1 is 400 ÷ 50 = 8 MHz
		CLKOUT2_DIVIDE => 10, -- CLKOUT3 is 400 ÷ 10 = 40 MHz
		CLKFBOUT_MULT => 10,
		CLKIN_PERIOD => 1.0e9 / 40.0e6,
		CLK_FEEDBACK => "CLKFBOUT")
	port map(
		CLKIN => PLLInputClock,
		CLKFBIN => PLLFeedbackClock,
		RST => PLLReset,
		CLKOUT0 => PLLOutputs(0),
		CLKOUT1 => PLLOutputs(1),
		CLKOUT2 => PLLOutputs(2),
		CLKFBOUT => PLLFeedbackClock,
		LOCKED => PLLLocked);

	BufferGs : for Index in PLLOutputs'range generate
		BufferG : BUFGCE
		port map(
			I => PLLOutputs(Index),
			O => BufferedPLLOutputs(Index),
			CE => PLLLocked);
	end generate;

	Clocks.Clock4MHz <= BufferedPLLOutputs(0);
	Clocks.Clock8MHz <= BufferedPLLOutputs(1);
	Clocks.Clock40MHz <= BufferedPLLOutputs(2);
end architecture Behavioural;
