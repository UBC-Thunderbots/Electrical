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
		FlashClockPin : out std_ulogic := '0';
		FlashMOSIPin : out std_ulogic := '0';
		FlashMISODebugPin : inout std_ulogic;

		MRFResetPin : out std_ulogic := '0';
		MRFWakePin : out std_ulogic := '0';
		MRFInterruptPin : in std_ulogic;
		MRFCSPin : out std_ulogic := '1';
		MRFClockPin : out std_ulogic := '0';
		MRFMOSIPin : out std_ulogic := '0';
		MRFMISOPin : in std_ulogic;

		ChickerChargePin : out std_ulogic := '1';
		ChickerKickPin : out std_ulogic := '1';
		ChickerChipPin : out std_ulogic := '1';
		ChickerPowerPin : out std_ulogic := '0';
		ChickerCSPin : out std_ulogic := '1';
		ChickerClockPin : out std_ulogic := '0';
		ChickerMISOPin : in std_ulogic;

		BreakbeamDrivePin : out std_ulogic := '0';

		LPSResetPin : out std_ulogic := '0';
		LPSClockPin : out std_ulogic := '0';

		ChargedLEDPin : out std_ulogic := '0';
		RadioLEDPin : out std_ulogic := '0';
		TestLEDsPin : out std_ulogic_vector(2 downto 0) := (others => '0');

		EncodersPin : in encoders_pin_t;

		MotorsPhasesPPin : out motors_phases_pin_t := (others => (others => '1'));
		MotorsPhasesNPin : out motors_phases_pin_t := (others => (others => '0'));

		HallsPin : in halls_pin_t);
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
						MRFClockPin <= '1';
						State := CLK_RAISED;
						DataIn := DataIn(14 downto 0) & MRFMISOPin;
					when CLK_RAISED =>
						MRFClockPin <= '0';
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
		MRFMOSIPin <= DataOut(15);
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

architecture Main of Top is
	signal Clocks : clocks_t;

	signal NavreReadEnable : boolean;
	signal NavreWriteEnable : boolean;
	signal NavreIOAddress : natural range 0 to 63;
	signal NavreDO : std_ulogic_vector(7 downto 0);
	signal NavreDI : std_ulogic_vector(7 downto 0);

	signal RadioLEDLevel : boolean := false;
	signal RadioLEDBlinkX : boolean := false;
	signal RadioLEDBlinkY : boolean := false;
	signal LEDSoftware : boolean := true;
	signal LEDValue : std_ulogic_vector(4 downto 0) := "00000";

	signal PowerChicker : boolean := false;
	signal PowerMotors : boolean := false;
	signal PowerLogic : boolean := true;

	signal FiveMilliTicks : natural range 0 to 255 := 0;

	signal Halls : halls_t := (others => (others => false));
	signal HallsStuckHigh : halls_stuck_t := (others => false);
	signal HallsStuckHighLatch : halls_stuck_t := (others => false);
	signal HallsStuckHighClear : halls_stuck_t := (others => false);
	signal HallsStuckLow : halls_stuck_t := (others => false);
	signal HallsStuckLowLatch : halls_stuck_t := (others => false);
	signal HallsStuckLowClear : halls_stuck_t := (others => false);

	signal MotorsMode : motors_mode_t := (others => FLOAT);
	signal MotorsPower : motors_power_t := (others => 0);
	signal MotorsPhases : motors_phases_t := (others => (others => FLOAT));

	signal Encoders : encoders_t := (others => (others => false));
	signal EncodersCount : encoders_count_t := (others => 0);
	signal EncoderCountLatch : std_ulogic_vector(15 downto 0) := X"0000";
	signal EncodersClear : encoders_clear_t := (others => false);

	signal MCP3004Levels : mcp3004s_t := (others => 0);
	signal MCP3004Latch : std_ulogic_vector(9 downto 0);

	signal ADS7866Level : capacitor_voltage_t := 0;
	signal ADS7866Latch : std_ulogic_vector(11 downto 0);

	signal ChipX : boolean := false;
	signal ChipY : boolean := false;
	signal ChipActive : boolean := false;
	signal KickX : boolean := false;
	signal KickY : boolean := false;
	signal KickActive : boolean := false;
	signal KickPeriod : natural range 0 to 65535 := 0;
	signal KickPeriodLSBPost : natural range 0 to 255 := 0;
	signal KickPeriodLoadLSBX : boolean := false;
	signal KickPeriodLoadLSBY : boolean := false;
	signal KickPeriodMSBPost : natural range 0 to 255 := 0;
	signal KickPeriodLoadMSBX : boolean := false;
	signal KickPeriodLoadMSBY : boolean := false;
	signal Charge : boolean := false;
	signal ChargeTimeout : boolean := false;
	signal ChargeDone : boolean := false;
	signal ChargePulse : boolean := false;
	constant CapacitorDangerousThreshold : natural := natural(30.0 / (220000.0 + 2200.0) * 2200.0 / 3.3 * 4095.0);
	constant CapacitorStopDischargeThreshold : natural := natural(20.0 / (220000.0 + 2200.0) * 2200.0 / 3.3 * 4095.0);
	signal Discharge : boolean := false;
	signal DischargePulse : boolean := false;

	signal FlashCS : std_ulogic := '1';
	signal FlashDataRead : std_ulogic_vector(7 downto 0) := X"00";
	signal FlashDataWrite : std_ulogic_vector(7 downto 0) := X"00";
	signal FlashStrobe : boolean := false;
	signal FlashBusy : boolean := false;

	signal MRFWake : std_ulogic := '0';
	signal MRFReset : std_ulogic := '0';
	signal MRFCS : std_ulogic := '1';
	signal MRFDataRead : std_ulogic_vector(7 downto 0) := X"00";
	signal MRFDataWrite : std_ulogic_vector(7 downto 0) := X"00";
	signal MRFStrobe : boolean := false;
	signal MRFBusy : boolean := false;

	signal DeviceID : std_ulogic_vector(56 downto 0);

	signal BreakbeamDrive : boolean := false;

	signal LPSReset : boolean := false;
	signal LPSClock : boolean := false;

	signal DebugEnabled : boolean := false;
	signal DebugBusy : boolean := false;
	signal DebugStrobe : boolean := false;
	signal DebugData : std_ulogic_vector(7 downto 0) := X"00";
	signal DebugOut : std_ulogic := '1';

	signal ICAPData : std_ulogic_vector(15 downto 0) := X"0000";
	signal ICAPStrobe : boolean := false;
	signal ICAPBusy : boolean := false;
begin
	ClockGen : entity work.ClockGen(Behavioural)
	port map(
		Oscillator0 => OscillatorPin(0),
		Oscillator1 => OscillatorPin(1),
		Clocks => Clocks);

	WrapperInstance : entity work.NavreWrapper(Arch)
	port map(
		Clock => Clocks.Clock40MHz,
		IOReadEnable => NavreReadEnable,
		IOWriteEnable => NavreWriteEnable,
		IOAddress => NavreIOAddress,
		IODO => NavreDO,
		IODI => NavreDI);

	process(Clocks.Clock40MHz) is
		variable DIBuffer : std_ulogic_vector(7 downto 0);
		variable LFSR : std_ulogic_vector(31 downto 0) := (others => '1');
	begin
		if rising_edge(Clocks.Clock40MHz) then
			HallsStuckHighClear <= (others => false);
			HallsStuckLowClear <= (others => false);
			EncodersClear <= (others => false);
			FlashStrobe <= false;
			MRFStrobe <= false;
			DebugStrobe <= false;
			ICAPStrobe <= false;

			case NavreIOAddress is
				when 16#00# => -- LED_CTL
					DIBuffer := to_stdulogic(RadioLEDLevel) & '0' & to_stdulogic(LEDSoftware) & LEDValue;
					if NavreWriteEnable then
						RadioLEDLevel <= to_boolean(NavreDO(7));
						if NavreDO(6) = '1' then
							RadioLEDBlinkX <= not RadioLEDBlinkY;
						end if;
						LEDSoftware <= to_boolean(NavreDO(5));
						LEDValue <= NavreDO(4 downto 0);
					end if;

				when 16#01# => -- POWER_CTL
					DIBuffer := "00000" & to_stdulogic(PowerChicker) & to_stdulogic(PowerMotors) & to_stdulogic(PowerLogic);
					if NavreWriteEnable then
						PowerChicker <= to_boolean(NavreDO(2));
						PowerMotors <= to_boolean(NavreDO(1));
						PowerLogic <= to_boolean(NavreDO(0));
					end if;

				when 16#02# => -- TICKS
					DIBuffer := std_ulogic_vector(to_unsigned(FiveMilliTicks, 8));

				when 16#03# => -- WHEEL_CTL
					for Index in 0 to 3 loop
						case MotorsMode(Index) is
							when FLOAT => DIBuffer(Index * 2 + 1 downto Index * 2) := "00";
							when BRAKE => DIBuffer(Index * 2 + 1 downto Index * 2) := "01";
							when FORWARD => DIBuffer(Index * 2 + 1 downto Index * 2) := "10";
							when REVERSE => DIBuffer(Index * 2 + 1 downto Index * 2) := "11";
						end case;
					end loop;
					if NavreWriteEnable then
						for Index in 0 to 3 loop
							case NavreDO(Index * 2 + 1 downto Index * 2) is
								when "00" => MotorsMode(Index) <= FLOAT;
								when "01" => MotorsMode(Index) <= BRAKE;
								when "10" => MotorsMode(Index) <= FORWARD;
								when "11" => MotorsMode(Index) <= REVERSE;
								when others => null;
							end case;
						end loop;
					end if;

				when 16#04# => -- WHEEL_HALL_FAIL
					for Index in 0 to 3 loop
						DIBuffer(Index) := to_stdulogic(HallsStuckLowLatch(Index));
						DIBuffer(Index + 4) := to_stdulogic(HallsStuckHighLatch(Index));
					end loop;
					if NavreWriteEnable then
						for Index in 0 to 3 loop
							HallsStuckLowClear(Index) <= to_boolean(NavreDO(Index));
							HallsStuckHighClear(Index) <= to_boolean(NavreDO(Index + 4));
						end loop;
					end if;

				when 16#05# to 16#08# => -- WHEEL0_PWM … WHEEL3_PWM
					DIBuffer := std_ulogic_vector(to_unsigned(MotorsPower(NavreIOAddress - 16#05#), 8));
					if NavreWriteEnable then
						MotorsPower(NavreIOAddress - 16#05#) <= to_integer(unsigned(NavreDO));
					end if;

				when 16#09# => -- DRIBBLER_CTL
					DIBuffer(7 downto 2) := "000000";
					case MotorsMode(4) is
						when FLOAT => DIBuffer(1 downto 0) := "00";
						when BRAKE => DIBuffer(1 downto 0) := "01";
						when FORWARD => DIBuffer(1 downto 0) := "10";
						when REVERSE => DIBuffer(1 downto 0) := "11";
					end case;
					if NavreWriteEnable then
						case NavreDO(1 downto 0) is
							when "00" => MotorsMode(4) <= FLOAT;
							when "01" => MotorsMode(4) <= BRAKE;
							when "10" => MotorsMode(4) <= FORWARD;
							when "11" => MotorsMode(4) <= REVERSE;
							when others => null;
						end case;
					end if;

				when 16#0A# => -- DRIBBLER_HALL_FAIL
					DIBuffer := "000000" & to_stdulogic(HallsStuckHighLatch(4)) & to_stdulogic(HallsStuckLowLatch(4));
					if NavreWriteEnable then
						HallsStuckHighClear(4) <= to_boolean(NavreDO(1));
						HallsStuckLowClear(4) <= to_boolean(NavreDO(0));
					end if;

				when 16#0B# => -- DRIBBLER_PWM
					DIBuffer := std_ulogic_vector(to_unsigned(MotorsPower(4), 8));
					if NavreWriteEnable then
						MotorsPower(4) <= to_integer(unsigned(NavreDO));
					end if;

				when 16#0C# => -- ENCODER_LSB
					DIBuffer := EncoderCountLatch(7 downto 0);
					if NavreWriteEnable then
						EncoderCountLatch <= std_ulogic_vector(to_unsigned(EncodersCount(to_integer(unsigned(NavreDO))), 16));
						EncodersClear(to_integer(unsigned(NavreDO))) <= true;
					end if;

				when 16#0D# => -- ENCODER_MSB
					DIBuffer := EncoderCountLatch(15 downto 8);

				when 16#0E# => -- ENCODER_FAIL
					DIBuffer := "00000000";

				when 16#0F# => -- ADC_LSB
					DIBuffer := MCP3004Latch(7 downto 0);
					if NavreWriteEnable then
						MCP3004Latch <= std_ulogic_vector(to_unsigned(MCP3004Levels(to_integer(unsigned(NavreDO))), 10));
					end if;

				when 16#10# => -- ADC_MSB
					DIBuffer := "000000" & MCP3004Latch(9 downto 8);

				when 16#11# => -- CHICKER_ADC_LSB
					DIBuffer := ADS7866Latch(7 downto 0);
					if NavreWriteEnable then
						ADS7866Latch <= std_ulogic_vector(to_unsigned(ADS7866Level, 12));
					end if;

				when 16#12# => -- CHICKER_ADC_MSB
					DIBuffer := "0000" & ADS7866Latch(11 downto 8);

				when 16#13# => -- CHICKER_CTL
					DIBuffer := "00" & to_stdulogic(Discharge) & to_stdulogic(ChargeDone) & to_stdulogic(ChargeTimeout) & to_stdulogic(ChipActive or (ChipX xor ChipY)) & to_stdulogic(KickActive or (KickX xor KickY)) & to_stdulogic(Charge);
					if NavreWriteEnable then
						Discharge <= to_boolean(NavreDO(5));
						if NavreDO(2) = '1' then
							ChipX <= not ChipY;
						end if;
						if NavreDO(1) = '1' then
							KickX <= not KickY;
						end if;
						Charge <= to_boolean(NavreDO(0));
					end if;

				when 16#14# => -- CHICKER_PULSE_LSB
					if KickPeriodLoadLSBX /= KickPeriodLoadLSBY then
						DIBuffer := std_ulogic_vector(to_unsigned(KickPeriodLSBPost, 8));
					else
						DIBuffer := std_ulogic_vector(to_unsigned(KickPeriod mod 256, 8));
					end if;
					if NavreWriteEnable then
						KickPeriodLSBPost <= to_integer(unsigned(NavreDO));
						KickPeriodLoadLSBX <= not KickPeriodLoadLSBY;
					end if;

				when 16#15# => -- CHICKER_PULSE_MSB
					if KickPeriodLoadMSBX /= KickPeriodLoadMSBY then
						DIBuffer := std_ulogic_vector(to_unsigned(KickPeriodMSBPost, 8));
					else
						DIBuffer := std_ulogic_vector(to_unsigned(KickPeriod mod 256, 8));
					end if;
					if NavreWriteEnable then
						KickPeriodMSBPost <= to_integer(unsigned(NavreDO));
						KickPeriodLoadMSBX <= not KickPeriodLoadMSBY;
					end if;

				when 16#16# => -- FLASH_CTL
					DIBuffer := "000000" & FlashCS & to_stdulogic(FlashBusy);
					if NavreWriteEnable then
						FlashCS <= NavreDO(1);
					end if;

				when 16#17# => -- FLASH_DATA
					DIBuffer := FlashDataRead;
					if NavreWriteEnable then
						FlashDataWrite <= NavreDO;
						FlashStrobe <= true;
					end if;

				when 16#18# => -- MRF_CTL
					DIBuffer := "000" & MRFInterruptPin & MRFWake & MRFReset & MRFCS & to_stdulogic(MRFBusy);
					if NavreWriteEnable then
						MRFWake <= NavreDO(3);
						MRFReset <= NavreDO(2);
						MRFCS <= NavreDO(1);
					end if;

				when 16#19# => -- MRF_DATA
					DIBuffer := MRFDataRead;
					if NavreWriteEnable then
						MRFDataWrite <= NavreDO;
						MRFStrobe <= true;
					end if;

				when 16#1A# => -- BREAK_BEAM_CTL
					DIBuffer := "0000000" & to_stdulogic(BreakbeamDrive);
					if NavreWriteEnable then
						BreakbeamDrive <= to_boolean(NavreDO(0));
					end if;

				when 16#1B# => -- LPS_CTL
					DIBuffer := "000000" & to_stdulogic(LPSReset) & to_stdulogic(LPSClock);
					if NavreWriteEnable then
						LPSReset <= to_boolean(NavreDO(1));
						LPSClock <= to_boolean(NavreDO(0));
					end if;

				when 16#1C# => -- DEVICE_ID0
					DIBuffer := DeviceID(7 downto 0);
				when 16#1D# => -- DEVICE_ID1
					DIBuffer := DeviceID(15 downto 8);
				when 16#1E# => -- DEVICE_ID2
					DIBuffer := DeviceID(23 downto 16);
				when 16#1F# => -- DEVICE_ID3
					DIBuffer := DeviceID(31 downto 24);
				when 16#20# => -- DEVICE_ID4
					DIBuffer := DeviceID(39 downto 32);
				when 16#21# => -- DEVICE_ID5
					DIBuffer := DeviceID(47 downto 40);
				when 16#22# => -- DEVICE_ID6
					DIBuffer := DeviceID(55 downto 48);

				when 16#23# => -- DEVICE_ID_STATUS
					DIBuffer := "0000000" & DeviceID(56);

				when 16#24# => -- LFSR
					DIBuffer := "0000000" & LFSR(0);
					if NavreWriteEnable then
						LFSR := (LFSR(19) XOR LFSR(24) XOR LFSR(26) XOR LFSR(31)) & LFSR(31 downto 1);
					end if;

				when 16#25# => -- DEBUG_CTL
					DIBuffer := "000000" & to_stdulogic(DebugBusy) & to_stdulogic(DebugEnabled);
					if NavreWriteEnable then
						DebugEnabled <= to_boolean(NavreDO(0));
					end if;

				when 16#26# => -- DEBUG_DATA
					DIBuffer := X"00";
					if NavreWriteEnable then
						DebugData <= NavreDO;
						DebugStrobe <= true;
					end if;

				when 16#27# => -- ICAP_CTL
					DIBuffer := "0000000" & to_stdulogic(ICAPStrobe or ICAPBusy);

				when 16#28# => -- ICAP_LSB
					DIBuffer := ICAPData(7 downto 0);
					if NavreWriteEnable then
						ICAPData(7 downto 0) <= NavreDO;
						ICAPStrobe <= true;
					end if;

				when 16#29# => -- ICAP_MSB
					DIBuffer := ICAPData(15 downto 8);
					if NavreWriteEnable then
						ICAPData(15 downto 8) <= NavreDO;
					end if;

				when others =>
					DIBuffer := "--------";
			end case;

			if NavreReadEnable then
				NavreDI <= DIBuffer;
			end if;
		end if;
	end process;

	process(Clocks.Clock4MHz, RadioLEDLevel) is
		subtype ticks_t is natural range 0 to 999999;
		variable Ticks : ticks_t := 0;
		variable Polarity : boolean := false;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if Ticks = ticks_t'high then
				if Polarity then
					Polarity := false;
				elsif RadioLEDBlinkX /= RadioLEDBlinkY then
					RadioLEDBlinkY <= RadioLEDBlinkX;
					Polarity := true;
				end if;
			end if;
			Ticks := (Ticks + 1) mod (ticks_t'high + 1);
		end if;

		if RadioLEDLevel and not Polarity then
			RadioLEDPin <= '1';
		else
			RadioLEDPin <= '0';
		end if;
	end process;

	process(LEDSoftware, LEDValue, Halls, Encoders) is
	begin
		if LEDSoftware then
			TestLEDsPin <= LEDValue(2 downto 0);
		else
			case LEDValue is
				when "00000" | "00001" | "00010" | "00011" | "00100" =>
					for Index in 0 to 2 loop
						TestLEDsPin(Index) <= to_stdulogic(Halls(to_integer(unsigned(LEDValue)))(Index));
					end loop;

				when "00101" | "00110" | "00111" | "01000" =>
					for Index in 0 to 1 loop
						TestLEDsPin(Index) <= to_stdulogic(Encoders(to_integer(unsigned(LEDValue)) - 5)(Index));
					end loop;
					TestLEDsPin(2) <= '0';

				when others =>
					TestLEDsPin <= "---";
			end case;
		end if;
	end process;

	LogicPowerPin <= '1' when PowerLogic else '0';
	HVPowerPin <= '1' when PowerMotors else '0';
	ChickerPowerPin <= '1' when PowerChicker else '0';

	process(Clocks.Clock4MHz) is
		subtype subticks_t is natural range 0 to 19999;
		variable Subticks : subticks_t := 0;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if Subticks = subticks_t'high then
				FiveMilliTicks <= (FiveMilliTicks + 1) mod 256;
			end if;
			Subticks := (Subticks + 1) mod (subticks_t'high + 1);
		end if;
	end process;

	process(Clocks.Clock8MHz) is
	begin
		if rising_edge(Clocks.Clock8MHz) then
			for Index in 0 to 4 loop
				for Pin in 0 to 2 loop
					Halls(Index)(Pin) <= to_boolean(HallsPin(Index)(Pin));
				end loop;
			end loop;
		end if;
	end process;

	process(Clocks.Clock40MHz) is
	begin
		if rising_edge(Clocks.Clock40MHz) then
			for Index in 0 to 4 loop
				HallsStuckHighLatch(Index) <= (HallsStuckHighLatch(Index) and not HallsStuckHighClear(Index)) or HallsStuckHigh(Index);
				HallsStuckLowLatch(Index) <= (HallsStuckLowLatch(Index) and not HallsStuckLowClear(Index)) or HallsStuckLow(Index);
			end loop;
		end if;
	end process;

	Motors : for Index in 0 to 4 generate
		Motor : entity work.Motor(Arch)
		generic map(
			PWMMax => 255,
			PWMPhase => Index * 51)
		port map(
			Clocks => Clocks,
			Mode => MotorsMode(Index),
			Power => MotorsPower(Index),
			Hall => Halls(Index),
			HallStuckHigh => HallsStuckHigh(Index),
			HallStuckLow => HallsStuckLow(Index),
			Phases => MotorsPhases(Index));

		Phases : for Phase in 0 to 2 generate
			MotorsPhasesPPin(Index)(Phase) <= '0' when MotorsPhases(Index)(Phase) = HIGH else '1';
			MotorsPHasesNPin(Index)(Phase) <= '1' when MotorsPhases(Index)(Phase) = LOW else '0';
		end generate;
	end generate;

	GenerateEncoders : for Index in 0 to 3 generate
		process(Clocks.Clock40MHz) is
		begin
			if rising_edge(Clocks.Clock40MHz) then
				for Channel in 0 to 1 loop
					Encoders(Index)(Channel) <= to_boolean(EncodersPin(Index)(Channel));
				end loop;
			end if;
		end process;

		Encoder : entity work.GrayCounter(Arch)
		port map(
			Clock => Clocks.Clock40MHz,
			Input => Encoders(Index),
			Clear => EncodersClear(Index),
			Value => EncodersCount(Index));
	end generate;

	MCP3004 : entity work.MCP3004(Arch)
	port map(
		Clocks => Clocks,
		MOSI => ADCMOSIPin,
		MISO => ADCMISOPin,
		CLK => ADCClockPin,
		CS => ADCCSPin,
		Levels => MCP3004Levels);

	ADS7866 : entity work.ADS7866(Arch)
	port map(
		Clocks => Clocks,
		MISO => ChickerMISOPin,
		CLK => ChickerClockPin,
		CS => ChickerCSPin,
		Level => ADS7866Level);
	-- 30 V ÷ (2200 R + 220000 R) × 2200 R / 3.3 V × 4096 = 369 ADC counts
	ChargedLEDPin <= to_stdulogic(ADS7866Level > CapacitorDangerousThreshold);

	BoostController : entity work.BoostController(Arch)
	generic map(
		ClockFrequency => 4000000.0)
	port map(
		Clock => Clocks.Clock4MHz,
		Enable => Charge,
		CapacitorVoltage => ADS7866Level,
		BatteryVoltage => MCP3004Levels(3),
		Charge => ChargePulse,
		Timeout => ChargeTimeout,
		Done => ChargeDone);
	ChickerChargePin <= to_stdulogic(not ChargePulse);

	process(Clocks.Clock4MHz) is
		variable KickPeriodTemp : unsigned(15 downto 0);
	begin
		if rising_edge(Clocks.Clock4MHz) then
			-- Count
			if ChipActive or KickActive then
				if KickPeriod = 0 then
					ChipActive <= false;
					KickActive <= false;
				else
					KickPeriod <= KickPeriod - 1;
				end if;
			end if;
			-- Bring in posted writes
			if ChipX /= ChipY then
				ChipActive <= true;
				ChipY <= ChipX;
			end if;
			if KickX /= KickY then
				KickActive <= true;
				KickY <= KickX;
			end if;
			KickPeriodTemp := to_unsigned(KickPeriod, 16);
			if KickPeriodLoadLSBX /= KickPeriodLoadLSBY then
				KickPeriodTemp(7 downto 0) := to_unsigned(KickPeriodLSBPost, 8);
				KickPeriod <= to_integer(KickPeriodTemp);
				KickPeriodLoadLSBY <= KickPeriodLoadLSBX;
			end if;
			if KickPeriodLoadMSBX /= KickPeriodLoadMSBY then
				KickPeriodTemp(15 downto 8) := to_unsigned(KickPeriodMSBPost, 8);
				KickPeriod <= to_integer(KickPeriodTemp);
				KickPeriodLoadMSBY <= KickPeriodLoadMSBX;
			end if;
		end if;
	end process;
	process(Clocks.Clock4MHz, Discharge, ADS7866Level) is
		subtype count_t is natural range 0 to 19999;
		variable Count : count_t := 0;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			Count := (Count + 1) mod (count_t'high + 1);
		end if;
		DischargePulse <= (Count < 1200) and Discharge and (ADS7866Level > CapacitorStopDischargeThreshold);
	end process;
	ChickerChipPin <= to_stdulogic(not (ChipActive or DischargePulse));
	ChickerKickPin <= to_stdulogic(not (KickActive or DischargePulse));

	FlashCSPin <= FlashCS;
	FlashSPI : entity work.SPI(Arch)
	port map(
		HostClock => Clocks.Clock40MHz,
		BusClock => Clocks.Clock40MHz,
		BusClockI => Clocks.Clock40MHzI,
		WriteData => FlashDataWrite,
		ReadData => FlashDataRead,
		Strobe => FlashStrobe,
		Busy => FlashBusy,
		ClockPin => FlashClockPin,
		MOSIPin => FlashMOSIPin,
		MISOPin => FlashMISODebugPin);

	MRFWakePin <= MRFWake;
	MRFResetPin <= MRFReset;
	MRFCSPin <= MRFCS;
	MRFSPI : entity work.SPI(Arch)
	port map(
		HostClock => Clocks.Clock40MHz,
		BusClock => Clocks.Clock10MHz,
		BusClockI => Clocks.Clock10MHzI,
		WriteData => MRFDataWrite,
		ReadData => MRFDataRead,
		Strobe => MRFStrobe,
		Busy => MRFBusy,
		ClockPin => MRFClockPin,
		MOSIPin => MRFMOSIPin,
		MISOPin => MRFMISOPin);

	
	DNAPort : entity work.DeviceDNA
	port map(
		Clocks => Clocks,
		Value => DeviceID);

	BreakbeamDrivePin <= to_stdulogic(BreakbeamDrive);

	LPSResetPin <= to_stdulogic(not LPSReset);
	LPSClockPin <= to_stdulogic(LPSClock);

	DebugPort : entity work.AsyncSerialTransmitter(Arch)
	generic map(
		BusClockDivider => (4000000 + 9600 / 2) / 9600 - 1)
	port map(
		HostClock => Clocks.Clock40MHz,
		BusClock => Clocks.Clock4MHz,
		Data => DebugData,
		Strobe => DebugStrobe,
		Busy => DebugBusy,
		Output => DebugOut);
	FlashMISODebugPin <= DebugOut when DebugEnabled else 'Z';

	ICAPWrapper : entity work.ICAPWrapper(Arch)
	port map(
		HostClock => Clocks.Clock40MHz,
		ICAPClock => Clocks.Clock4MHz,
		Data => ICAPData,
		Strobe => ICAPStrobe,
		Busy => ICAPBusy);
end architecture Main;
