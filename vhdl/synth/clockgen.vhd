library ieee;
library unisim;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use work.types.all;

entity ClockGen is
	port(
		Oscillator : in std_ulogic;
		Clock250kHz : buffer std_ulogic;
		Clock1MHz : buffer std_ulogic;
		Clock1MHzI : buffer std_ulogic;
		Clock4MHz : buffer std_ulogic;
		Clock4MHzI : buffer std_ulogic;
		Clock8MHz : buffer std_ulogic;
		Clock8MHzI : buffer std_ulogic;
		Clock48MHz : buffer std_ulogic;
		Clock48MHzI : buffer std_ulogic;
		CE1MHz48 : buffer boolean);
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
	signal DividerCounter : unsigned(3 downto 0);
	signal CE1MHz48X, CE1MHz48Y : boolean;
begin
	IBufferG : IBufG
	port map(
		I => Oscillator,
		O => OscillatorBuffered);

	-- Input from the oscillator is 8 MHz
	-- CLKFX output (PLLInputClock) is 8 × 6 = 48 MHz
	StepUpDCM : DCM_SP
	generic map(
		CLKIN_PERIOD => 1.0e9 / 8.0e6,
		CLK_FEEDBACK => "NONE",
		CLKFX_MULTIPLY => 6,
		CLKFX_DIVIDE => 1)
	port map(
		CLKIN => OscillatorBuffered,
		RST => '0',
		CLKFX => PLLInputClock,
		STATUS => StepUpDCMStatus,
		LOCKED => StepUpDCMLocked);

	PLLReset <= StepUpDCMStatus(2) or not StepUpDCMLocked;

	-- PLLInputClock is 48 MHz
	-- VCO is 48 × 10 = 480 MHz
	MainPLL : PLL_BASE
	generic map(
		CLKOUT0_DIVIDE => 120, -- CLKOUT0 is 480 ÷ 120 = 4 MHz
		CLKOUT1_DIVIDE => 60, -- CLKOUT1 is 480 ÷ 60 = 8 MHz
		CLKOUT2_DIVIDE => 10, -- CLKOUT2 is 480 ÷ 10 = 48 MHz
		CLKOUT3_DIVIDE => 120, -- CLKOUT3 is 400 ÷ 120 = 4 MHz
		CLKOUT3_PHASE => 180.0, -- CLKOUT3 is 180° phase shifted for use with an ODDR2 clock output generator
		CLKOUT4_DIVIDE => 60, -- CLKOUT4 is 480 ÷ 60 = 8 MHz
		CLKOUT4_PHASE => 180.0, -- CLKOUT4 is 180° phase shifted for use with an ODDR2 clock output generator
		CLKOUT5_DIVIDE => 10, -- CLKOUT5 is 480 ÷ 10 = 48 MHz
		CLKOUT5_PHASE => 180.0, -- CLKOUT5 is 180° phase shifted for use with an ODDR2 clock output generator
		CLKFBOUT_MULT => 10,
		CLKIN_PERIOD => 1.0e9 / 48.0e6,
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

	Clock4MHz <= BufferedPLLOutputs(0);
	Clock4MHzI <= BufferedPLLOutputs(3);
	Clock8MHz <= BufferedPLLOutputs(1);
	Clock8MHzI <= BufferedPLLOutputs(4);
	Clock48MHz <= BufferedPLLOutputs(2);
	Clock48MHzI <= BufferedPLLOutputs(5);

	process(Clock4MHz) is
	begin
		if rising_edge(Clock4MHz) then
			DividerCounter <= DividerCounter + 1;
		end if;
	end process;
	Clock250kHz <= DividerCounter(3);
	Clock1MHz <= DividerCounter(1);
	Clock1MHzI <= not DividerCounter(1);

	CE1MHz48X <= not CE1MHz48X when rising_edge(Clock1MHz);
	CE1MHz48Y <= CE1MHz48X when rising_edge(Clock48MHz);
	CE1MHz48 <= CE1MHz48X /= CE1MHz48Y;
end architecture Behavioural;
