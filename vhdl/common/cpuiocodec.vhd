library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.clock.all;
use work.types.all;

entity CPUIOCodec is
	port(
		Clocks : in work.clock.clocks_t;
		Inputs : in work.types.cpu_inputs_t;
		Outputs : out work.types.cpu_outputs_t);
end entity CPUIOCodec;

architecture Arch of CPUIOCodec is
	signal ReadEnable : boolean;
	signal WriteEnable : boolean;
	signal IOAddress : natural range 0 to 63;
	signal DO : std_ulogic_vector(7 downto 0);
	signal DI : std_ulogic_vector(7 downto 0);
	signal OBuf : work.types.cpu_outputs_t := (
		RadioLED => false,
		TestLEDsSoftware => true,
		TestLEDsValue => (others => '0'),
		PowerLaser => false,
		PowerMotors => false,
		PowerLogic => true,
		MotorsControl => (others => (Phases => (others => FLOAT), AutoCommutate => false, Direction => false, Power => 0)),
		Charge => false,
		Discharge => false,
		KickPeriod => 0,
		StartKick => false,
		StartChip => false,
		FlashCS => '1',
		FlashDataWrite => X"00",
		FlashStrobe => false,
		MRFReset => '1',
		MRFWake => '0',
		MRFCS => '1',
		MRFDataWrite => X"00",
		MRFStrobe => false,
		LPSDrives => (others => '0'),
		LFSRTick => false,
		DebugEnabled => false,
		DebugData => X"00",
		DebugStrobe => false,
		ICAPData => X"0000",
		ICAPStrobe => false);

	signal RadioLEDLevel : boolean := false;
	signal RadioLEDBlinkX : boolean := false;
	signal RadioLEDBlinkY : boolean := false;

	signal MotorIndex : natural range 0 to 4 := 0;

	signal HallsStuckHighLatch : halls_stuck_t := (others => false);
	signal HallsStuckHighClear : halls_stuck_t := (others => false);
	signal HallsStuckLowLatch : halls_stuck_t := (others => false);
	signal HallsStuckLowClear : halls_stuck_t := (others => false);

	signal EncoderCountLatch : std_ulogic_vector(15 downto 0) := X"0000";

	signal MCP3004Latch : std_ulogic_vector(9 downto 0);
begin
	Outputs <= OBuf;

	Wrapper : entity work.NavreWrapper(Arch)
	port map(
		Clock => Clocks.Clock40MHz,
		IOReadEnable => ReadEnable,
		IOWriteEnable => WriteEnable,
		IOAddress => IOAddress,
		IODO => DO,
		IODI => DI);

	process(Clocks.Clock40MHz) is
		variable DIBuffer : std_ulogic_vector(7 downto 0);
	begin
		if rising_edge(Clocks.Clock40MHz) then
			HallsStuckHighClear <= (others => false);
			HallsStuckLowClear <= (others => false);
			OBuf.StartKick <= false;
			OBuf.StartChip <= false;
			OBuf.FlashStrobe <= false;
			OBuf.MRFStrobe <= false;
			OBuf.LFSRTick <= false;
			OBuf.DebugStrobe <= false;
			OBuf.ICAPStrobe <= false;

			case IOAddress is
				when 16#00# => -- LED_CTL
					DIBuffer := to_stdulogic(RadioLEDLevel) & '0' & to_stdulogic(OBuf.TestLEDsSoftware) & OBuf.TestLEDsValue;
					if WriteEnable then
						RadioLEDLevel <= to_boolean(DO(7));
						if DO(6) = '1' then
							RadioLEDBlinkX <= not RadioLEDBlinkY;
						end if;
						OBuf.TestLEDsSoftware <= to_boolean(DO(5));
						OBuf.TestLEDsValue <= DO(4 downto 0);
					end if;

				when 16#01# => -- POWER_CTL
					DIBuffer := "0000" & to_stdulogic(OBuf.PowerLaser) & '0' & to_stdulogic(OBuf.PowerMotors) & to_stdulogic(OBuf.PowerLogic);
					if WriteEnable then
						OBuf.PowerLaser <= to_boolean(DO(3));
						OBuf.PowerMotors <= to_boolean(DO(1));
						OBuf.PowerLogic <= to_boolean(DO(0));
					end if;

				when 16#02# => -- TICKS
					DIBuffer := std_ulogic_vector(to_unsigned(Inputs.Ticks, 8));

				when 16#03# => -- MOTOR_INDEX
					DIBuffer := std_ulogic_vector(to_unsigned(MotorIndex, 8));
					if WriteEnable then
						if to_integer(unsigned(DO)) <= 4 then
							MotorIndex <= to_integer(unsigned(DO));
						end if;
					end if;

				when 16#04# => -- MOTOR_CTL
					for Index in 0 to 2 loop
						case OBuf.MotorsControl(MotorIndex).Phases(Index) is
							when FLOAT => DIBuffer(Index * 2 + 3 downto Index * 2 + 2) := "00";
							when PWM => DIBuffer(Index * 2 + 3 downto Index * 2 + 2) := "01";
							when LOW => DIBuffer(Index * 2 + 3 downto Index * 2 + 2) := "10";
							when HIGH => DIBuffer(Index * 2 + 3 downto Index * 2 + 2) := "11";
						end case;
					end loop;
					DIBuffer(1) := to_stdulogic(OBuf.MotorsControl(MotorIndex).AutoCommutate);
					DIBuffer(0) := to_stdulogic(OBuf.MotorsControl(MotorIndex).Direction);
					if WriteEnable then
						for Index in 0 to 2 loop
							case DO(Index * 2 + 3 downto Index * 2 + 2) is
								when "00" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= FLOAT;
								when "01" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= PWM;
								when "10" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= LOW;
								when "11" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= HIGH;
								when others => OBuf.MotorsControl(MotorIndex).Phases(Index) <= FLOAT;
							end case;
						end loop;
						OBuf.MotorsControl(MotorIndex).AutoCommutate <= to_boolean(DO(1));
						OBuf.MotorsControl(MotorIndex).Direction <= to_boolean(DO(0));
					end if;

				when 16#05# => -- MOTOR_STATUS
					DIBuffer(1) := to_stdulogic(HallsStuckHighLatch(MotorIndex));
					DIBuffer(0) := to_stdulogic(HallsStuckLowLatch(MotorIndex));
					if WriteEnable then
						if DO(1) = '1' then
							HallsStuckHighClear(MotorIndex) <= true;
						end if;
						if DO(0) = '1' then
							HallsStuckLowClear(MotorIndex) <= true;
						end if;
					end if;

				when 16#06# => -- MOTOR_PWM
					DIBuffer := std_ulogic_vector(to_unsigned(OBuf.MotorsControl(MotorIndex).Power, 8));
					if WriteEnable then
						OBuf.MotorsControl(MotorIndex).Power <= to_integer(unsigned(DO));
					end if;

				when 16#0C# => -- ENCODER_LSB
					DIBuffer := EncoderCountLatch(7 downto 0);
					if WriteEnable then
						EncoderCountLatch <= std_ulogic_vector(to_unsigned(Inputs.EncodersCount(to_integer(unsigned(DO))), 16));
					end if;

				when 16#0D# => -- ENCODER_MSB
					DIBuffer := EncoderCountLatch(15 downto 8);

				when 16#0E# => -- ENCODER_FAIL
					DIBuffer := "00000000";

				when 16#0F# => -- ADC_LSB
					DIBuffer := MCP3004Latch(7 downto 0);
					if WriteEnable then
						MCP3004Latch <= std_ulogic_vector(to_unsigned(Inputs.MCP3004Levels(to_integer(unsigned(DO))), 10));
					end if;

				when 16#10# => -- ADC_MSB
					DIBuffer := "000000" & MCP3004Latch(9 downto 8);

				when 16#13# => -- CHICKER_CTL
					DIBuffer := "00" & to_stdulogic(OBuf.Discharge) & to_stdulogic(Inputs.ChargeDone) & to_stdulogic(Inputs.ChargeTimeout) & to_stdulogic(Inputs.ChipActive) & to_stdulogic(Inputs.KickActive) & to_stdulogic(OBuf.Charge);
					if WriteEnable then
						OBuf.Discharge <= to_boolean(DO(5));
						if DO(2) = '1' then
							OBuf.StartChip <= true;
						end if;
						if DO(1) = '1' then
							OBuf.StartKick <= true;
						end if;
						OBuf.Charge <= to_boolean(DO(0));
					end if;

				when 16#14# => -- CHICKER_PULSE_LSB
					DIBuffer := std_ulogic_vector(to_unsigned(OBuf.KickPeriod mod 256, 8));
					if WriteEnable then
						OBuf.KickPeriod <= to_integer(to_unsigned(OBuf.KickPeriod / 256, 8) & unsigned(DO));
					end if;

				when 16#15# => -- CHICKER_PULSE_MSB
					DIBuffer := std_ulogic_vector(to_unsigned(OBuf.KickPeriod / 256, 8));
					if WriteEnable then
						OBuf.KickPeriod <= to_integer(unsigned(DO) & to_unsigned(OBuf.KickPeriod mod 256, 8));
					end if;

				when 16#16# => -- FLASH_CTL
					DIBuffer := "000000" & OBuf.FlashCS & to_stdulogic(Inputs.FlashBusy);
					if WriteEnable then
						OBuf.FlashCS <= DO(1);
					end if;

				when 16#17# => -- FLASH_DATA
					DIBuffer := Inputs.FlashDataRead;
					if WriteEnable then
						OBuf.FlashDataWrite <= DO;
						OBuf.FlashStrobe <= true;
					end if;

				when 16#18# => -- MRF_CTL
					DIBuffer := "000" & Inputs.MRFInterrupt & OBuf.MRFWake & OBuf.MRFReset & OBuf.MRFCS & to_stdulogic(Inputs.MRFBusy);
					if WriteEnable then
						OBuf.MRFWake <= DO(3);
						OBuf.MRFReset <= DO(2);
						OBuf.MRFCS <= DO(1);
					end if;

				when 16#19# => -- MRF_DATA
					DIBuffer := Inputs.MRFDataRead;
					if WriteEnable then
						OBuf.MRFDataWrite <= DO;
						OBuf.MRFStrobe <= true;
					end if;

				when 16#1B# => -- LPS_CTL
					DIBuffer := "0000" & OBuf.LPSDrives;
					if WriteEnable then
						OBuf.LPSDrives <= DO(3 downto 0);
					end if;

				when 16#1C# => -- DEVICE_ID0
					DIBuffer := Inputs.DeviceID(7 downto 0);
				when 16#1D# => -- DEVICE_ID1
					DIBuffer := Inputs.DeviceID(15 downto 8);
				when 16#1E# => -- DEVICE_ID2
					DIBuffer := Inputs.DeviceID(23 downto 16);
				when 16#1F# => -- DEVICE_ID3
					DIBuffer := Inputs.DeviceID(31 downto 24);
				when 16#20# => -- DEVICE_ID4
					DIBuffer := Inputs.DeviceID(39 downto 32);
				when 16#21# => -- DEVICE_ID5
					DIBuffer := Inputs.DeviceID(47 downto 40);
				when 16#22# => -- DEVICE_ID6
					DIBuffer := Inputs.DeviceID(55 downto 48);

				when 16#23# => -- DEVICE_ID_STATUS
					DIBuffer := "0000000" & to_stdulogic(Inputs.DeviceIDReady);

				when 16#24# => -- LFSR
					DIBuffer := "0000000" & Inputs.LFSRBit;
					if WriteEnable then
						OBuf.LFSRTick <= true;
					end if;

				when 16#25# => -- DEBUG_CTL
					DIBuffer := "000000" & to_stdulogic(Inputs.DebugBusy) & to_stdulogic(OBuf.DebugEnabled);
					if WriteEnable then
						OBuf.DebugEnabled <= to_boolean(DO(0));
					end if;

				when 16#26# => -- DEBUG_DATA
					DIBuffer := X"00";
					if WriteEnable then
						OBuf.DebugData <= DO;
						OBuf.DebugStrobe <= true;
					end if;

				when 16#27# => -- ICAP_CTL
					DIBuffer := "0000000" & to_stdulogic(OBuf.ICAPStrobe or Inputs.ICAPBusy);

				when 16#28# => -- ICAP_LSB
					DIBuffer := OBuf.ICAPData(7 downto 0);
					if WriteEnable then
						OBuf.ICAPData(7 downto 0) <= DO;
						OBuf.ICAPStrobe <= true;
					end if;

				when 16#29# => -- ICAP_MSB
					DIBuffer := OBuf.ICAPData(15 downto 8);
					if WriteEnable then
						OBuf.ICAPData(15 downto 8) <= DO;
					end if;

				when others =>
					DIBuffer := "--------";
			end case;

			if not Inputs.InterlockOverride then
				-- If interlocks are not overridden, the only direct phase control options legal are all low or all float.
				for I in 0 to 4 loop
					if OBuf.MotorsControl(I).Phases /= (FLOAT, FLOAT, FLOAT) and OBuf.MotorsControl(I).Phases /= (LOW, LOW, LOW) then
						OBuf.MotorsControl(I).Phases(0) <= FLOAT;
						OBuf.MotorsControl(I).Phases(1) <= FLOAT;
						OBuf.MotorsControl(I).Phases(2) <= FLOAT;
					end if;
				end loop;
			end if;

			if ReadEnable then
				DI <= DIBuffer;
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

		OBuf.RadioLED <= RadioLEDLevel and not Polarity;
	end process;

	process(Clocks.Clock40MHz) is
	begin
		if rising_edge(Clocks.Clock40MHz) then
			for Index in 0 to 4 loop
				HallsStuckHighLatch(Index) <= (HallsStuckHighLatch(Index) and not HallsStuckHighClear(Index)) or Inputs.HallsStuckHigh(Index);
				HallsStuckLowLatch(Index) <= (HallsStuckLowLatch(Index) and not HallsStuckLowClear(Index)) or Inputs.HallsStuckLow(Index);
			end loop;
		end if;
	end process;
end architecture Arch;
