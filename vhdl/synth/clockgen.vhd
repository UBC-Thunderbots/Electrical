library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.clock.all;

entity ClockGen is
	port(
		Oscillator : in std_ulogic;
		Clocks : out clocks_t);
end entity ClockGen;

architecture Behavioural of ClockGen is
	signal OscillatorBuffered : std_ulogic;
	signal PLLInputClock : std_ulogic;
	signal StepUpDCMStatus : std_logic_vector(7 downto 0);
	signal StepUpDCMLocked : std_ulogic;
	signal PLLReset : std_ulogic;
	signal PLLOutputs : std_ulogic_vector(0 to 5);
	signal PLLFeedbackClock : std_ulogic;
	signal PLLLocked : std_ulogic;
	signal BufferedPLLOutputs : std_ulogic_vector(PLLOutputs'range);
begin
	IBufferG : IBufG
	port map(
		I => Oscillator,
		O => OscillatorBuffered);

	-- Input from the oscillator is 8 MHz
	-- CLKFX output (PLLInputClock) is 8 × 5 = 40 MHz
	StepUpDCM : DCM_SP
	generic map(
		CLKIN_PERIOD => 1.0e9 / 8.0e6,
		CLK_FEEDBACK => "NONE",
		CLKFX_MULTIPLY => 5,
		CLKFX_DIVIDE => 1)
	port map(
		CLKIN => OscillatorBuffered,
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
		CLKOUT2_DIVIDE => 10, -- CLKOUT2 is 400 ÷ 10 = 40 MHz
		CLKOUT3_DIVIDE => 100, -- CLKOUT3 is 400 ÷ 100 = 4 MHz
		CLKOUT3_PHASE => 180.0, -- CLKOUT3 is 180° phase shifted for use with an ODDR2 clock output generator
		CLKOUT4_DIVIDE => 50, -- CLKOUT4 is 400 ÷ 50 = 8 MHz
		CLKOUT4_PHASE => 180.0, -- CLKOUT4 is 180° phase shifted for use with an ODDR2 clock output generator
		CLKOUT5_DIVIDE => 10, -- CLKOUT5 is 400 ÷ 10 = 40 MHz
		CLKOUT5_PHASE => 180.0, -- CLKOUT5 is 180° phase shifted for use with an ODDR2 clock output generator
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
		CLKOUT3 => PLLOutputs(3),
		CLKOUT4 => PLLOutputs(4),
		CLKOUT5 => PLLOutputs(5),
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
	Clocks.Clock4MHzI <= BufferedPLLOutputs(3);
	Clocks.Clock8MHz <= BufferedPLLOutputs(1);
	Clocks.Clock8MHzI <= BufferedPLLOutputs(4);
	Clocks.Clock40MHz <= BufferedPLLOutputs(2);
	Clocks.Clock40MHzI <= BufferedPLLOutputs(5);
end architecture Behavioural;
