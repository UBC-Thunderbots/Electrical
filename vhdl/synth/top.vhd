library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.clock.all;
use work.pintypes.all;
use work.types.all;

entity Top is
	port(
		OscillatorPin : in std_ulogic_vector(1 downto 0);
		OscillatorEnablePin : out std_ulogic := '1';

		LogicPowerPin : out std_ulogic := '1';
		HVPowerPin : out std_ulogic := '0';

		ADCCSPin : out std_ulogic := '1';
		ADCClockPin : out std_ulogic := '0';
		ADCMOSIPin : out std_ulogic := '0';
		ADCMISOPin : in std_ulogic;

		FlashCSPin : out std_ulogic := '1';
		ChickerCSPin : out std_ulogic := '1';
		ChickerChargePin : out std_ulogic := '1';
		ChickerKickPin : out std_ulogic := '1';
		ChickerChipPin : out std_ulogic := '1';
		ChickerSparePin : out std_ulogic := '0';
		MRFCSPin : out std_ulogic := '1';
		MRFResetPin : out std_ulogic := '0';
		MRFWakePin : out std_ulogic := '0';
		MRFInterruptPin : in std_ulogic;
		FlashMRFChickerClockPin : out std_ulogic := '0';
		FlashMRFChickerMOSIPin : out std_ulogic := '0';
		FlashMRFChickerMISOPin : in std_ulogic;

		BreakbeamDrivePin : out std_ulogic := '0';

		LPSResetPin : out std_ulogic := '0';
		LPSClockPin : out std_ulogic := '0';

		ChargedLEDPin : out std_ulogic := '0';
		RadioLEDPin : out std_ulogic := '0';
		TestLEDsPin : out std_ulogic_vector(2 downto 0) := (others => '0');

		EncodersPin : in encoders_pin_t;

		MotorsPhasesPPin : out motors_phases_pin_t := (others => (others => '1'));
		MotorsPhasesNPin : out motors_phases_pin_t := (others => (others => '0'));

		HallsPin : in halls_pin_t;

		VirtualGroundPin : out std_ulogic_vector(0 to 1) := (others => '0'));
end entity Top;

architecture TestStaticLEDs of Top is
begin
	ChargedLEDPin <= '1';
	RadioLEDPin <= '1';
	TestLEDsPin <= (others => '1');
end architecture TestStaticLEDs;

architecture TestBasicClock of Top is
begin
	process(OscillatorPin(0)) is
		variable Ticks : natural range 0 to 7999999 := 0;
		variable Seconds : unsigned(4 downto 0) := to_unsigned(0, 5);
	begin
		if rising_edge(OscillatorPin(0)) then
			if Ticks = 7999999 then
				Ticks := 0;
				Seconds := Seconds + 1;
			else
				Ticks := Ticks + 1;
			end if;
		end if;

		ChargedLEDPin <= Seconds(0);
		RadioLEDPin <= Seconds(1);
		TestLEDsPin(2 downto 0) <= std_ulogic_vector(Seconds(4 downto 2));
	end process;
end architecture TestBasicClock;

architecture TestFullClock of Top is
	signal Clocks : clocks_t;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	process(Clocks.Clock40MHz) is
		subtype ticks_t is natural range 0 to 3999999;
		variable Ticks : ticks_t := 0;
		variable Seconds : unsigned(4 downto 0) := to_unsigned(0, 5);
	begin
		if rising_edge(Clocks.Clock40MHz) then
			if Ticks = ticks_t'high then
				Ticks := 0;
				Seconds := Seconds + 1;
			else
				Ticks := Ticks + 1;
			end if;
		end if;

		ChargedLEDPin <= Seconds(0);
		RadioLEDPin <= Seconds(1);
		TestLEDsPin(2 downto 0) <= std_ulogic_vector(Seconds(4 downto 2));
	end process;
end architecture TestFullClock;

architecture TestMRFBasic of Top is
	signal Clocks : clocks_t;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	MRFWakePin <= '0';
	MRFResetPin <= '1';

	process(Clocks.Clock4MHz) is
		subtype ticks_t is natural range 0 to 3;
		variable Ticks : ticks_t := 0;
		type state_t is (IDLE, CS_ASSERTED, CLK_RAISED, DONE);
		variable State : state_t := IDLE;
		-- Reset value of ACKTMOUT (0x12) should be 0b00111001 (0x39)
		variable DataOut : std_ulogic_vector(15 downto 0) := X"2400";
		variable DataIn : std_ulogic_vector(15 downto 0) := X"0000";
		variable Count : natural range 0 to 15 := 15;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if Ticks = ticks_t'high then
				case State is
					when IDLE =>
						MRFCSPin <= '0';
						State := CS_ASSERTED;
					when CS_ASSERTED =>
						FlashMRFChickerClockPin <= '1';
						State := CLK_RAISED;
						DataIn := DataIn(14 downto 0) & FlashMRFChickerMISOPin;
					when CLK_RAISED =>
						FlashMRFChickerClockPin <= '0';
						State := CS_ASSERTED;
						DataOut := DataOut(14 downto 0) & '0';
						if Count = 0 then
							TestLEDsPin(2) <= DataIn(4);
							TestLEDsPin(1) <= DataIn(3);
							TestLEDsPin(0) <= DataIn(2);
							RadioLEDPin <= DataIn(1);
							ChargedLEDPin <= DataIn(0);
							State := DONE;
						end if;
						Count := Count - 1;
					when DONE =>
						MRFCSPin <= '1';
				end case;
			end if;
			Ticks := (Ticks + 1) mod (ticks_t'high + 1);
		end if;
		FlashMRFChickerMOSIPin <= DataOut(15);
	end process;
end architecture TestMRFBasic;

architecture TestADC of Top is
	signal Clocks : clocks_t;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	process(Clocks.Clock4MHz) is
		subtype ticks_t is natural range 0 to 3;
		variable Ticks : ticks_t := 0;
		type state_t is (IDLE, ACTIVE);
		variable State : state_t := IDLE;
		variable CSOut : std_ulogic_vector(17 downto 0) := "100000000000000000";
		variable DataOut : std_ulogic_vector(17 downto 0) := "111011000000000000";
		variable DataIn : std_ulogic_vector(9 downto 0);
		variable Snapshot : std_ulogic_vector(9 downto 0);
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if Ticks = 0 then
				if CSOut(17) = '1' then
					Snapshot := DataIn;
				end if;
				DataIn := DataIn(8 downto 0) & ADCMISOPin;
			elsif Ticks = 2 then
				CSOut := CSOut(16 downto 0) & CSOut(17);
				DataOut := DataOut(16 downto 0) & DataOut(17);
			end if;
			Ticks := (Ticks + 1) mod (ticks_t'high + 1);
		end if;

		if Ticks = 1 or Ticks = 2 then
			ADCClockPin <= '1';
		else
			ADCClockPin <= '0';
		end if;

		ADCCSPin <= CSOut(17);
		ADCMOSIPin <= DataOut(17);
		TestLEDsPin(2) <= Snapshot(9);
		TestLEDsPin(1) <= Snapshot(8);
		TestLEDsPIn(0) <= Snapshot(7);
		RadioLEDPin <= Snapshot(6);
		ChargedLEDPin <= Snapshot(5);
	end process;
end architecture TestADC;

architecture TestNavre of Top is
	signal Clocks : clocks_t;

	signal NavreResetShifter : std_ulogic_vector(15 downto 0) := X"FFFF";
	signal NavreProgramMemoryClockEnable : std_ulogic;
	signal NavreProgramMemoryAddress : unsigned(11 downto 0);
	signal NavreProgramMemoryData : std_ulogic_vector(15 downto 0) := X"0000";
	signal NavreDataMemoryWriteEnable : std_ulogic;
	signal NavreDataMemoryAddress : unsigned(14 downto 0);
	signal NavreDataMemoryDI : std_ulogic_vector(7 downto 0) := X"00";
	signal NavreDataMemoryDO : std_ulogic_vector(7 downto 0);
	signal NavreIOReadEnable : std_ulogic;
	signal NavreIOWriteEnable : std_ulogic;
	signal NavreIOAddress : unsigned(5 downto 0);
	signal NavreIODO : std_ulogic_vector(7 downto 0);
	signal NavreIODI : std_ulogic_vector(7 downto 0) := X"00";

	component navre
	generic(
		pmem_width : natural;
		dmem_width : natural);
	port(
		clk : in std_ulogic;
		rst : in std_ulogic;
		pmem_ce : out std_ulogic;
		pmem_a : out std_ulogic_vector(pmem_width - 1 downto 0);
		pmem_d : in std_ulogic_vector(15 downto 0);
		dmem_we : out std_ulogic;
		dmem_a : out std_ulogic_vector(dmem_width - 1 downto 0);
		dmem_di : in std_ulogic_vector(7 downto 0);
		dmem_do : out std_ulogic_vector(7 downto 0);
		io_re : out std_ulogic;
		io_we : out std_ulogic;
		io_a : out std_ulogic_vector(5 downto 0);
		io_do : out std_ulogic_vector(7 downto 0);
		io_di : in std_ulogic_vector(7 downto 0);
		dbg_pc : out std_ulogic_vector(pmem_width - 1 downto 0));
	end component navre;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	NavreInstance : navre
	generic map(
		pmem_width => 12,
		dmem_width => 15)
	port map(
		clk => Clocks.Clock40MHz,
		rst => NavreResetShifter(0),
		pmem_ce => NavreProgramMemoryClockEnable,
		unsigned(pmem_a) => NavreProgramMemoryAddress,
		pmem_d => NavreProgramMemoryData,
		dmem_we => NavreDataMemoryWriteEnable,
		unsigned(dmem_a) => NavreDataMemoryAddress,
		dmem_di => NavreDataMemoryDI,
		dmem_do => NavreDataMemoryDO,
		io_re => NavreIOReadEnable,
		io_we => NavreIOWriteEnable,
		unsigned(io_a) => NavreIOAddress,
		io_do => NavreIODO,
		io_di => NavreIODI,
		dbg_pc => open);

	process(Clocks.Clock40MHz) is
		type program_memory_type is array(0 to 4095) of std_ulogic_vector(15 downto 0);
		variable ProgramMemory : program_memory_type := (
			X"B000", -- IN r0, 0x00
			X"B003", -- IN r0, 0x03
			X"9200", -- STS 0x0000, r0
			X"0000",
			X"9010", -- LDS r1, 0x0000
			X"0000",
			X"B810", -- OUT 0x00, r1
			X"CFF8", -- RJMP .-16 <0x00>
			others => X"0000");
		type data_memory_type is array(0 to 32767) of std_ulogic_vector(7 downto 0);
		variable DataMemory : data_memory_type;
		variable TSC : unsigned(31 downto 0) := X"00000000";
		variable TSCLatched : std_ulogic_vector(31 downto 0);
	begin
		if rising_edge(Clocks.Clock40MHz) then
			NavreResetShifter <= '0' & NavreResetShifter(15 downto 1);

			if NavreProgramMemoryClockEnable = '1' then
				NavreProgramMemoryData <= ProgramMemory(to_integer(NavreProgramMemoryAddress));
			end if;

			NavreDataMemoryDI <= DataMemory(to_integer(NavreDataMemoryAddress));
			if NavreDataMemoryWriteEnable = '1' then
				DataMemory(to_integer(NavreDataMemoryAddress)) := NavreDataMemoryDO;
			end if;

			NavreIODI <= X"00";
			if NavreIOReadEnable = '1' then
				case to_integer(NavreIOAddress) is
					when 0 =>
						TSCLatched := std_ulogic_vector(TSC);
						NavreIODI <= TSCLatched(7 downto 0);
					when 1 =>
						NavreIODI <= TSCLatched(15 downto 8);
					when 2 =>
						NavreIODI <= TSCLatched(23 downto 16);
					when 3 =>
						NavreIODI <= TSCLatched(31 downto 24);
					when others =>
						null;
				end case;
			end if;

			if NavreIOWriteEnable = '1' then
				case to_integer(NavreIOAddress) is
					when 0 =>
						TestLEDsPin(2) <= NavreIODO(4);
						TestLEDsPin(1) <= NavreIODO(3);
						TestLEDsPin(0) <= NavreIODO(2);
						RadioLEDPin <= NavreIODO(1);
						ChargedLEDPin <= NavreIODO(0);
					when others =>
						null;
				end case;
			end if;

			TSC := TSC + 1;
		end if;
	end process;
end architecture TestNavre;
