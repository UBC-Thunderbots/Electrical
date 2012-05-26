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
		Clock1MHz : out std_ulogic;
		Clock8MHz : out std_ulogic;
		Failed : out boolean := false);
--		Reset : in std_ulogic;
--		Locked : out std_ulogic;
--		ClockLow : out std_ulogic;
--		ClockMid : out std_ulogic;
--		ClockHigh : out std_ulogic);
end entity ClockGen;

architecture Behavioural of ClockGen is
	signal Oscillator0Buffered : std_ulogic;
	signal MainDCMClockSelect : std_ulogic := '0';
	signal MainDCMClockInput : std_ulogic;
	signal MainDCMReset : std_ulogic;
	signal MainDCMClock1 : std_ulogic;
	signal MainDCMClock8 : std_ulogic;
	signal MainDCMStatus : std_logic_vector(7 downto 0);
	signal MainDCMLocked : std_ulogic;
	signal MainDCMInputStopped : std_ulogic;
	signal BackupDCMClock8 : std_ulogic;
	signal BackupDCMClock8Buffered : std_ulogic;
	signal BackupDCMLocked : std_ulogic;
	signal EnableOutput : std_ulogic := '1';
begin
	IBufferG : IBufG
	port map(
		I => Oscillator0,
		O => Oscillator0Buffered);

	ClockSourceSelector : BUFGMUX
	generic map(
		CLK_SEL_TYPE => "ASYNC")
	port map(
		I0 => Oscillator0Buffered,
		I1 => BackupDCMClock8,
		O => MainDCMClockInput,
		S => MainDCMClockSelect);

	MainDCM : DCM_SP
	generic map(
		CLKIN_PERIOD => 1.0e9 / 8.0e6,
		CLK_FEEDBACK => "NONE",
		CLKDV_DIVIDE => 8.0,
		CLKOUT_PHASE_SHIFT => "NONE",
		DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
		STARTUP_WAIT => true,
		CLKIN_DIVIDE_BY_2 => false)
	port map(
		CLKIN => MainDCMClockInput,
		RST => MainDCMReset,
		CLK0 => MainDCMClock8,
		CLKDV => MainDCMClock1,
		STATUS => MainDCMStatus,
		LOCKED => MainDCMLocked);

	MainDCMInputStopped <= MainDCMStatus(1);

	BufferG1 : BUFGCE
	port map(
		I => MainDCMClock1,
		O => Clock1MHz,
		CE => EnableOutput);

	BufferG8 : BUFGCE
	port map(
		I => MainDCMClock8,
		O => Clock8MHz,
		CE => EnableOutput);

	BackupDCM : DCM_CLKGEN
	generic map(
		CLKIN_PERIOD => 1.0e9 / 8.0e6,
		CLKFX_MULTIPLY => 2,
		CLKFX_DIVIDE => 2,
		STARTUP_WAIT => true)
	port map(
		CLKIN => Oscillator0Buffered,
		RST => '0',
		FREEZEDCM => BackupDCMLocked,
		CLKFX => BackupDCMClock8,
		LOCKED => BackupDCMLocked);

	BufferG8Backup : BUFG
	port map(
		I => BackupDCMClock8,
		O => BackupDCMClock8Buffered);

	process(BackupDCMClock8Buffered) is
		variable Fired : boolean := false;
		variable MainDCMResetCount : natural range 0 to 7 := 0;
	begin
		if rising_edge(BackupDCMClock8Buffered) then
			if (MainDCMLocked = '0' or MainDCMInputStopped = '1') and not Fired then
				Fired := true;
				MainDCMResetCount := 7;
				EnableOutput <= '0';
				MainDCMClockSelect <= '1';
			elsif MainDCMResetCount /= 0 then
				MainDCMResetCount := MainDCMResetCount - 1;
			elsif Fired and MainDCMResetCount = 0 and MainDCMLocked = '1' and MainDCMInputStopped = '0' then
				EnableOutput <= '1';
			end if;
		end if;

		if MainDCMResetCount /= 0 then
			MainDCMReset <= '1';
		else
			MainDCMReset <= '0';
		end if;

		Failed <= Fired;
	end process;
end architecture Behavioural;
