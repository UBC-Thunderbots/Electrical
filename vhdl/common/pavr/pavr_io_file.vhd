library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
library work;
use work.std_util.all;
use work.pavr_util.all;
use work.pavr_constants.all;
use work.types.all;

entity pavr_iof is
	port(
		-- General control stuff
		pavr_iof_clk      : in std_logic;
		pavr_iof_res      : in std_logic;
		pavr_iof_syncres  : in std_logic;

		-- AVR non-kernel (feature) register ports
		Inputs : in work.types.cpu_inputs_t;
		Outputs : out work.types.cpu_outputs_t;

		-- General IO file port
		pavr_iof_opcode   : in  std_logic_vector(pavr_iof_opcode_w - 1 downto 0);
		pavr_iof_addr     : in  std_logic_vector(5 downto 0);
		pavr_iof_di       : in  std_logic_vector(7 downto 0);
		pavr_iof_do       : out std_logic_vector(7 downto 0);
		pavr_iof_bitout   : out std_logic;
		pavr_iof_bitaddr  : in  std_logic_vector(2 downto 0);

		-- AVR core ports
		-- Status register (SREG)
		pavr_iof_sreg     : out std_logic_vector(7 downto 0);
		pavr_iof_sreg_wr  : in  std_logic;
		pavr_iof_sreg_di  : in  std_logic_vector(7 downto 0);

		-- Stack pointer (SP = SPH&SPL)
		pavr_iof_sph      : out std_logic_vector(7 downto 0);
		pavr_iof_sph_wr   : in  std_logic;
		pavr_iof_sph_di   : in  std_logic_vector(7 downto 0);
		pavr_iof_spl      : out std_logic_vector(7 downto 0);
		pavr_iof_spl_wr   : in  std_logic;
		pavr_iof_spl_di   : in  std_logic_vector(7 downto 0);

		-- Pointer registers extensions (RAMPX, RAMPY, RAMPZ)
		pavr_iof_rampx    : out std_logic_vector(7 downto 0);
		pavr_iof_rampx_wr : in  std_logic;
		pavr_iof_rampx_di : in  std_logic_vector(7 downto 0);

		pavr_iof_rampy    : out std_logic_vector(7 downto 0);
		pavr_iof_rampy_wr : in  std_logic;
		pavr_iof_rampy_di : in  std_logic_vector(7 downto 0);

		pavr_iof_rampz    : out std_logic_vector(7 downto 0);
		pavr_iof_rampz_wr : in  std_logic;
		pavr_iof_rampz_di : in  std_logic_vector(7 downto 0);

		-- Data Memory extension address register (RAMPD)
		pavr_iof_rampd    : out std_logic_vector(7 downto 0);
		pavr_iof_rampd_wr : in  std_logic;
		pavr_iof_rampd_di : in  std_logic_vector(7 downto 0);

		-- Program Memory extension address register (EIND)
		pavr_iof_eind     : out std_logic_vector(7 downto 0);
		pavr_iof_eind_wr  : in  std_logic;
		pavr_iof_eind_di  : in  std_logic_vector(7 downto 0);

		-- Interrupt-related interface signals to control module (to the pipeline).
		pavr_disable_int  : in  std_logic;
		pavr_int_rq       : out std_logic;
		pavr_int_vec      : out std_logic_vector(21 downto 0));
end;

architecture pavr_iof_arch of pavr_iof is
	-- Core registers
	signal pavr_iof_sreg_int:   std_logic_vector(7 downto 0) := X"00";
	signal pavr_iof_sph_int:    std_logic_vector(7 downto 0) := X"00";
	signal pavr_iof_spl_int:    std_logic_vector(7 downto 0) := X"00";
	signal pavr_iof_rampx_int:  std_logic_vector(7 downto 0) := X"00";
	signal pavr_iof_rampy_int:  std_logic_vector(7 downto 0) := X"00";
	signal pavr_iof_rampz_int:  std_logic_vector(7 downto 0) := X"00";
	signal pavr_iof_rampd_int:  std_logic_vector(7 downto 0) := X"00";
	signal pavr_iof_eind_int:   std_logic_vector(7 downto 0) := X"00";

	-- Peripheral registers
	constant IO_REG_LED_CTL : natural := 16#00#;
	constant IO_REG_POWER_CTL : natural := 16#01#;
	constant IO_REG_TICKS : natural := 16#02#;
	constant IO_REG_MOTOR_INDEX : natural := 16#03#;
	constant IO_REG_MOTOR_CTL : natural := 16#04#;
	constant IO_REG_MOTOR_STATUS : natural := 16#05#;
	constant IO_REG_MOTOR_PWM : natural := 16#06#;
	constant IO_REG_SIM_MAGIC : natural := 16#07#;
	constant IO_REG_ENCODER_LSB : natural := 16#0C#;
	constant IO_REG_ENCODER_MSB : natural := 16#0D#;
	constant IO_REG_ENCODER_FAIL : natural := 16#0E#;
	constant IO_REG_ADC_LSB : natural := 16#0F#;
	constant IO_REG_ADC_MSB : natural := 16#10#;
	constant IO_REG_CHICKER_CTL : natural := 16#13#;
	constant IO_REG_CHICKER_PULSE_LSB : natural := 16#14#;
	constant IO_REG_CHICKER_PULSE_MSB : natural := 16#15#;
	constant IO_REG_FLASH_CTL : natural := 16#16#;
	constant IO_REG_FLASH_DATA : natural := 16#17#;
	constant IO_REG_MRF_CTL : natural := 16#18#;
	constant IO_REG_MRF_DATA : natural := 16#19#;
	constant IO_REG_LPS_CTL : natural := 16#1B#;
	constant IO_REG_DEVICE_ID0 : natural := 16#1C#;
	constant IO_REG_DEVICE_ID1 : natural := 16#1D#;
	constant IO_REG_DEVICE_ID2 : natural := 16#1E#;
	constant IO_REG_DEVICE_ID3 : natural := 16#1F#;
	constant IO_REG_DEVICE_ID4 : natural := 16#20#;
	constant IO_REG_DEVICE_ID5 : natural := 16#21#;
	constant IO_REG_DEVICE_ID6 : natural := 16#22#;
	constant IO_REG_DEVICE_ID_STATUS : natural := 16#23#;
	constant IO_REG_LFSR : natural := 16#24#;
	constant IO_REG_DEBUG_CTL : natural := 16#25#;
	constant IO_REG_DEBUG_DATA : natural := 16#26#;
	constant IO_REG_ICAP_CTL : natural := 16#27#;
	constant IO_REG_ICAP_LSB : natural := 16#28#;
	constant IO_REG_ICAP_MSB : natural := 16#29#;
	constant OBufResetValues : work.types.cpu_outputs_t := (
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
		ICAPStrobe => false,
		SimMagic => X"00");
	signal OBuf : work.types.cpu_outputs_t := OBufResetValues;

	signal RadioLEDLevel : boolean := false;
	signal RadioLEDBlinkX : boolean := false;
	signal RadioLEDBlinkY : boolean := false;
	signal RadioLEDBlinkOut : boolean := false;

	signal MotorIndex : natural range 0 to 4 := 0;

	signal HallsStuckHighLatch : halls_stuck_t := (others => false);
	signal HallsStuckHighClear : halls_stuck_t := (others => true);
	signal HallsStuckLowLatch : halls_stuck_t := (others => false);
	signal HallsStuckLowClear : halls_stuck_t := (others => true);

	signal EncoderCountLatch : std_ulogic_vector(15 downto 0) := X"0000";

	signal MCP3004Latch : std_ulogic_vector(9 downto 0);

	-- Temporary stuff
	signal TempDI : std_ulogic_vector(7 downto 0);
begin
	-- Pass stuff out.
	process(OBuf, RadioLEDBlinkOut) is
	begin
		Outputs <= OBuf;
		Outputs.RadioLED <= RadioLEDBlinkOut;
	end process;

	-- Compute data in.
	process(pavr_iof_opcode, pavr_iof_bitaddr, pavr_iof_di) is
	begin
		TempDI <= X"00";

		case pavr_iof_opcode is
			when pavr_iof_opcode_wrbyte =>
				TempDI <= std_ulogic_vector(pavr_iof_di);
			when pavr_iof_opcode_clrbit =>
				TempDI <= std_ulogic_vector(pavr_iof_di);
				TempDI(std_logic_vector_to_nat(pavr_iof_bitaddr)) <= '0';
			when pavr_iof_opcode_setbit =>
				TempDI <= std_ulogic_vector(pavr_iof_di);
				TempDI(std_logic_vector_to_nat(pavr_iof_bitaddr)) <= '1';
			when others =>
				null;
		end case;
	end process;

	-- Managing IOF registers
	process(pavr_iof_clk, pavr_iof_res) is
		variable Temp2b : std_ulogic_vector(1 downto 0);
		variable TempDO : std_ulogic_vector(7 downto 0);
	begin
		if pavr_iof_res = '1' then
			pavr_iof_sreg_int <= X"00";
			pavr_iof_sph_int <= X"00";
			pavr_iof_spl_int <= X"00";
			pavr_iof_rampx_int <= X"00";
			pavr_iof_rampy_int <= X"00";
			pavr_iof_rampz_int <= X"00";
			pavr_iof_rampd_int <= X"00";
			pavr_iof_eind_int <= X"00";
			OBuf <= OBufResetValues;
			RadioLEDLevel <= false;
			MotorIndex <= 0;
			HallsStuckHighClear <= (others => true);
			HallsStuckLowClear <= (others => true);
			EncoderCountLatch <= X"0000";
			MCP3004Latch <= std_ulogic_vector(int_to_std_logic_vector(0, 10));
		elsif rising_edge(pavr_iof_clk) then
			pavr_iof_bitout <= '0';
			pavr_int_rq  <= '0';
			pavr_int_vec <= int_to_std_logic_vector(0, 22);

			HallsStuckHighClear <= (others => false);
			HallsStuckLowClear <= (others => false);
			OBuf.StartKick <= false;
			OBuf.StartChip <= false;
			OBuf.FlashStrobe <= false;
			OBuf.MRFStrobe <= false;
			OBuf.LFSRTick <= false;
			OBuf.DebugStrobe <= false;
			OBuf.ICAPStrobe <= false;

			TempDO := X"00";

			-- Check IOF opcode and process it.
			case pavr_iof_opcode is
				-- Read byte.
				when pavr_iof_opcode_rdbyte =>
					case std_logic_vector_to_nat(pavr_iof_addr) is
						when IO_REG_LED_CTL =>
							TempDO := to_stdulogic(RadioLEDLevel) & '0' & to_stdulogic(OBuf.TestLEDsSoftware) & OBuf.TestLEDsValue;
						when IO_REG_POWER_CTL =>
							TempDO := "0000" & to_stdulogic(OBuf.PowerLaser) & '0' & to_stdulogic(OBuf.PowerMotors) & to_stdulogic(OBuf.PowerLogic);
						when IO_REG_TICKS =>
							TempDO := std_ulogic_vector(to_unsigned(Inputs.Ticks, 8));
						when IO_REG_MOTOR_INDEX =>
							TempDO := std_ulogic_vector(to_unsigned(MotorIndex, 8));
						when IO_REG_MOTOR_CTL =>
							for Index in 0 to 2 loop
								case OBuf.MotorsControl(MotorIndex).Phases(Index) is
									when FLOAT => TempDO(Index * 2 + 3 downto Index * 2 + 2) := "00";
									when PWM => TempDO(Index * 2 + 3 downto Index * 2 + 2) := "01";
									when LOW => TempDO(Index * 2 + 3 downto Index * 2 + 2) := "10";
									when HIGH => TempDO(Index * 2 + 3 downto Index * 2 + 2) := "11";
								end case;
							end loop;
							TempDO(1) := to_stdulogic(OBuf.MotorsControl(MotorIndex).AutoCommutate);
							TempDO(0) := to_stdulogic(OBuf.MotorsControl(MotorIndex).Direction);
						when IO_REG_MOTOR_STATUS =>
							TempDO(1) := to_stdulogic(HallsStuckHighLatch(MotorIndex));
							TempDO(0) := to_stdulogic(HallsStuckLowLatch(MotorIndex));
						when IO_REG_MOTOR_PWM =>
							TempDO := std_ulogic_vector(to_unsigned(OBuf.MotorsControl(MotorIndex).Power, 8));
						when IO_REG_SIM_MAGIC =>
							TempDO := OBuf.SimMagic;
						when IO_REG_ENCODER_LSB =>
							TempDO := EncoderCountLatch(7 downto 0);
						when IO_REG_ENCODER_MSB =>
							TempDO := EncoderCountLatch(15 downto 8);
						when IO_REG_ENCODER_FAIL =>
							TempDO := "00000000";
						when IO_REG_ADC_LSB =>
							TempDO := MCP3004Latch(7 downto 0);
						when IO_REG_ADC_MSB =>
							TempDO := "000000" & MCP3004Latch(9 downto 8);
						when IO_REG_CHICKER_CTL =>
							TempDO := "00" & to_stdulogic(OBuf.Discharge) & to_stdulogic(Inputs.ChargeDone) & to_stdulogic(Inputs.ChargeTimeout) & to_stdulogic(Inputs.ChipActive) & to_stdulogic(Inputs.KickActive) & to_stdulogic(OBuf.Charge);
						when IO_REG_CHICKER_PULSE_LSB =>
							TempDO := std_ulogic_vector(to_unsigned(OBuf.KickPeriod mod 256, 8));
						when IO_REG_CHICKER_PULSE_MSB =>
							TempDO := std_ulogic_vector(to_unsigned(OBuf.KickPeriod / 256, 8));
						when IO_REG_FLASH_CTL =>
							TempDO := "000000" & OBuf.FlashCS & to_stdulogic(Inputs.FlashBusy);
						when IO_REG_FLASH_DATA =>
							TempDO := Inputs.FlashDataRead;
						when IO_REG_MRF_CTL =>
							TempDO := "000" & Inputs.MRFInterrupt & OBuf.MRFWake & OBuf.MRFReset & OBuf.MRFCS & to_stdulogic(Inputs.MRFBusy);
						when IO_REG_MRF_DATA =>
							TempDO := Inputs.MRFDataRead;
						when IO_REG_LPS_CTL =>
							TempDO := "0000" & OBuf.LPSDrives;
						when IO_REG_DEVICE_ID0 =>
							TempDO := Inputs.DeviceID(7 downto 0);
						when IO_REG_DEVICE_ID1 =>
							TempDO := Inputs.DeviceID(15 downto 8);
						when IO_REG_DEVICE_ID2 =>
							TempDO := Inputs.DeviceID(23 downto 16);
						when IO_REG_DEVICE_ID3 =>
							TempDO := Inputs.DeviceID(31 downto 24);
						when IO_REG_DEVICE_ID4 =>
							TempDO := Inputs.DeviceID(39 downto 32);
						when IO_REG_DEVICE_ID5 =>
							TempDO := Inputs.DeviceID(47 downto 40);
						when IO_REG_DEVICE_ID6 =>
							TempDO := Inputs.DeviceID(55 downto 48);
						when IO_REG_DEVICE_ID_STATUS =>
							TempDO := "0000000" & to_stdulogic(Inputs.DeviceIDReady);
						when IO_REG_LFSR =>
							TempDO := "0000000" & Inputs.LFSRBit;
						when IO_REG_DEBUG_CTL =>
							TempDO := "000000" & to_stdulogic(Inputs.DebugBusy) & to_stdulogic(OBuf.DebugEnabled);
						when IO_REG_DEBUG_DATA =>
							TempDO := X"00";
						when IO_REG_ICAP_CTL =>
							TempDO := "0000000" & to_stdulogic(OBuf.ICAPStrobe or Inputs.ICAPBusy);
						when IO_REG_ICAP_LSB =>
							TempDO := OBuf.ICAPData(7 downto 0);
						when IO_REG_ICAP_MSB =>
							TempDO := OBuf.ICAPData(15 downto 8);
						when pavr_sreg_addr =>
							TempDO := std_ulogic_vector(pavr_iof_sreg_int);
						when pavr_sph_addr =>
							TempDO := std_ulogic_vector(pavr_iof_sph_int);
						when pavr_spl_addr =>
							TempDO := std_ulogic_vector(pavr_iof_spl_int);
						when pavr_rampx_addr =>
							TempDO := std_ulogic_vector(pavr_iof_rampx_int);
						when pavr_rampy_addr =>
							TempDO := std_ulogic_vector(pavr_iof_rampy_int);
						when pavr_rampz_addr =>
							TempDO := std_ulogic_vector(pavr_iof_rampz_int);
						when pavr_rampd_addr =>
							TempDO := std_ulogic_vector(pavr_iof_rampd_int);
						when pavr_eind_addr =>
							TempDO := std_ulogic_vector(pavr_iof_eind_int);
						when others =>
							null;
					end case;
					pavr_iof_do <= std_logic_vector(TempDO);

				-- Write byte | clear bit | set bit.
				when pavr_iof_opcode_wrbyte | pavr_iof_opcode_clrbit | pavr_iof_opcode_setbit =>
					case std_logic_vector_to_nat(pavr_iof_addr) is
						when IO_REG_LED_CTL =>
							RadioLEDLevel <= to_boolean(TempDI(7));
							if TempDI(6) = '1' then
								RadioLEDBlinkX <= not RadioLEDBlinkY;
							end if;
							OBuf.TestLEDsSoftware <= to_boolean(TempDI(5));
							OBuf.TestLEDsValue <= TempDI(4 downto 0);
						when IO_REG_POWER_CTL =>
							OBuf.PowerLaser <= to_boolean(TempDI(3));
							OBuf.PowerMotors <= to_boolean(TempDI(1));
							OBuf.PowerLogic <= to_boolean(TempDI(0));
						when IO_REG_TICKS =>
						when IO_REG_MOTOR_INDEX =>
							if to_integer(unsigned(TempDI)) <= 4 then
								MotorIndex <= to_integer(unsigned(TempDI));
							end if;
						when IO_REG_MOTOR_CTL =>
							for Index in 0 to 2 loop
								Temp2b := TempDI(Index * 2 + 3 downto Index * 2 + 2);
								case Temp2b is
									when "00" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= FLOAT;
									when "01" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= PWM;
									when "10" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= LOW;
									when "11" => OBuf.MotorsControl(MotorIndex).Phases(Index) <= HIGH;
									when others => OBuf.MotorsControl(MotorIndex).Phases(Index) <= FLOAT;
								end case;
							end loop;
							OBuf.MotorsControl(MotorIndex).AutoCommutate <= to_boolean(TempDI(1));
							OBuf.MotorsControl(MotorIndex).Direction <= to_boolean(TempDI(0));
						when IO_REG_MOTOR_STATUS =>
							if TempDI(1) = '1' then
								HallsStuckHighClear(MotorIndex) <= true;
							end if;
							if TempDI(0) = '1' then
								HallsStuckLowClear(MotorIndex) <= true;
							end if;
						when IO_REG_MOTOR_PWM =>
							OBuf.MotorsControl(MotorIndex).Power <= to_integer(unsigned(TempDI));
						when IO_REG_SIM_MAGIC =>
							OBuf.SimMagic <= TempDI;
						when IO_REG_ENCODER_LSB =>
							EncoderCountLatch <= std_ulogic_vector(to_unsigned(Inputs.EncodersCount(to_integer(unsigned(TempDI))), 16));
						when IO_REG_ENCODER_MSB =>
						when IO_REG_ENCODER_FAIL =>
						when IO_REG_ADC_LSB =>
							MCP3004Latch <= std_ulogic_vector(to_unsigned(Inputs.MCP3004Levels(to_integer(unsigned(TempDI))), 10));
						when IO_REG_ADC_MSB =>
						when IO_REG_CHICKER_CTL =>
							OBuf.Discharge <= to_boolean(TempDI(5));
							if TempDI(2) = '1' then
								OBuf.StartChip <= true;
							end if;
							if TempDI(1) = '1' then
								OBuf.StartKick <= true;
							end if;
							OBuf.Charge <= to_boolean(TempDI(0));
						when IO_REG_CHICKER_PULSE_LSB =>
							OBuf.KickPeriod <= to_integer(to_unsigned(OBuf.KickPeriod / 256, 8) & unsigned(TempDI));
						when IO_REG_CHICKER_PULSE_MSB =>
							OBuf.KickPeriod <= to_integer(unsigned(TempDI) & to_unsigned(OBuf.KickPeriod mod 256, 8));
						when IO_REG_FLASH_CTL =>
							OBuf.FlashCS <= TempDI(1);
						when IO_REG_FLASH_DATA =>
							OBuf.FlashDataWrite <= TempDI;
							OBuf.FlashStrobe <= true;
						when IO_REG_MRF_CTL =>
							OBuf.MRFWake <= TempDI(3);
							OBuf.MRFReset <= TempDI(2);
							OBuf.MRFCS <= TempDI(1);
						when IO_REG_MRF_DATA =>
							OBuf.MRFDataWrite <= TempDI;
							OBuf.MRFStrobe <= true;
						when IO_REG_LPS_CTL =>
							OBuf.LPSDrives <= TempDI(3 downto 0);
						when IO_REG_DEVICE_ID0 =>
						when IO_REG_DEVICE_ID1 =>
						when IO_REG_DEVICE_ID2 =>
						when IO_REG_DEVICE_ID3 =>
						when IO_REG_DEVICE_ID4 =>
						when IO_REG_DEVICE_ID5 =>
						when IO_REG_DEVICE_ID6 =>
						when IO_REG_DEVICE_ID_STATUS =>
						when IO_REG_LFSR =>
							OBuf.LFSRTick <= true;
						when IO_REG_DEBUG_CTL =>
							OBuf.DebugEnabled <= to_boolean(TempDI(0));
						when IO_REG_DEBUG_DATA =>
							OBuf.DebugData <= TempDI;
							OBuf.DebugStrobe <= true;
						when IO_REG_ICAP_CTL =>
						when IO_REG_ICAP_LSB =>
							OBuf.ICAPData(7 downto 0) <= TempDI;
							OBuf.ICAPStrobe <= true;
						when IO_REG_ICAP_MSB =>
							OBuf.ICAPData(15 downto 8) <= TempDI;
						when pavr_sreg_addr =>
							pavr_iof_sreg_int <= std_logic_vector(TempDI);
						when pavr_sph_addr =>
							pavr_iof_sph_int <= std_logic_vector(TempDI);
						when pavr_spl_addr =>
							pavr_iof_spl_int <= std_logic_vector(TempDI);
						when pavr_rampx_addr =>
							pavr_iof_rampx_int <= std_logic_vector(TempDI);
						when pavr_rampy_addr =>
							pavr_iof_rampy_int <= std_logic_vector(TempDI);
						when pavr_rampz_addr =>
							pavr_iof_rampz_int <= std_logic_vector(TempDI);
						when pavr_rampd_addr =>
							pavr_iof_rampd_int <= std_logic_vector(TempDI);
						when pavr_eind_addr =>
							pavr_iof_eind_int <= std_logic_vector(TempDI);
						when others =>
							null;
					end case;
				-- Load bit.
				when pavr_iof_opcode_ldbit =>
					pavr_iof_do <= pavr_iof_di;
					pavr_iof_do(std_logic_vector_to_nat(pavr_iof_bitaddr)) <= pavr_iof_sreg_int(6);
				-- Store bit.
				when pavr_iof_opcode_stbit =>
					pavr_iof_sreg_int(6) <= pavr_iof_di(std_logic_vector_to_nat(pavr_iof_bitaddr));
				-- pavr_iof_opcode_nop
				when others =>
					null;
			end case;

			-- Kernel registers ports --------------------------------------------
			-- Status register (SREG) port
			if (pavr_iof_sreg_wr = '1') then
				pavr_iof_sreg_int <= pavr_iof_sreg_di;
			end if;

			-- Stack pointer (SPH&SPL) ports
			if (pavr_iof_sph_wr = '1') then
				pavr_iof_sph_int <= pavr_iof_sph_di;
			end if;
			if (pavr_iof_spl_wr = '1') then
				pavr_iof_spl_int <= pavr_iof_spl_di;
			end if;

			-- Pointer registers X extension (RAMPX) port
			if (pavr_iof_rampx_wr = '1') then
				pavr_iof_rampx_int <= pavr_iof_rampx_di;
			end if;

			-- Pointer registers Y extension (RAMPY) port
			if (pavr_iof_rampy_wr = '1') then
				pavr_iof_rampy_int <= pavr_iof_rampy_di;
			end if;

			-- Pointer registers Z extension (RAMPZ) port
			if (pavr_iof_rampz_wr = '1') then
				pavr_iof_rampz_int <= pavr_iof_rampz_di;
			end if;

			-- Data Memory extension address (RAMPD) register
			if (pavr_iof_rampd_wr = '1') then
				pavr_iof_rampd_int <= pavr_iof_rampd_di;
			end if;

			-- Program Memory extension address (EIND) register
			if (pavr_iof_eind_wr = '1') then
				pavr_iof_eind_int <= pavr_iof_eind_di;
			end if;

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

			if pavr_iof_syncres = '1' then
				pavr_iof_sreg_int <= X"00";
				pavr_iof_sph_int <= X"00";
				pavr_iof_spl_int <= X"00";
				pavr_iof_rampx_int <= X"00";
				pavr_iof_rampy_int <= X"00";
				pavr_iof_rampz_int <= X"00";
				pavr_iof_rampd_int <= X"00";
				pavr_iof_eind_int <= X"00";
				OBuf <= OBufResetValues;
				RadioLEDLevel <= false;
				MotorIndex <= 0;
				HallsStuckHighClear <= (others => true);
				HallsStuckLowClear <= (others => true);
				EncoderCountLatch <= X"0000";
				MCP3004Latch <= std_ulogic_vector(int_to_std_logic_vector(0, 10));
			end if;
		end if;
	end process;

	-- Assign core register outputs from internal copies.
	pavr_iof_sreg  <= pavr_iof_sreg_int;
	pavr_iof_sph   <= pavr_iof_sph_int;
	pavr_iof_spl   <= pavr_iof_spl_int;
	pavr_iof_rampx <= pavr_iof_rampx_int;
	pavr_iof_rampy <= pavr_iof_rampy_int;
	pavr_iof_rampz <= pavr_iof_rampz_int;
	pavr_iof_rampd <= pavr_iof_rampd_int;
	pavr_iof_eind  <= pavr_iof_eind_int;

	process(pavr_iof_clk, RadioLEDLevel) is
		subtype ticks_t is natural range 0 to 9999999;
		variable Ticks : ticks_t := 0;
		variable Polarity : boolean := false;
	begin
		if rising_edge(pavr_iof_clk) then
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

		RadioLEDBlinkOut <= RadioLEDLevel and not Polarity;
	end process;

	process(pavr_iof_clk) is
	begin
		if rising_edge(pavr_iof_clk) then
			for Index in 0 to 4 loop
				HallsStuckHighLatch(Index) <= (HallsStuckHighLatch(Index) and not HallsStuckHighClear(Index)) or Inputs.HallsStuckHigh(Index);
				HallsStuckLowLatch(Index) <= (HallsStuckLowLatch(Index) and not HallsStuckLowClear(Index)) or Inputs.HallsStuckLow(Index);
			end loop;
		end if;
	end process;
end architecture pavr_iof_arch;
