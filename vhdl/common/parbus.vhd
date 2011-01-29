library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ParbusTransceiver is
	port(
		Clock : in std_ulogic;

		ParbusDataIn : in std_ulogic_vector(7 downto 0);
		ParbusDataOut : out std_ulogic_vector(7 downto 0);
		ParbusRead : in boolean;
		ParbusWrite : in boolean;

		Address : out natural range 0 to 255;
		ReadData : in std_ulogic_vector(15 downto 0);
		WriteData : out std_ulogic_vector(15 downto 0);
		WriteStrobe : out boolean);
end entity ParbusTransceiver;

architecture Behavioural of ParbusTransceiver is
begin
	-- Handles reads of data from the FPGA to the microcontroller.
	process(Clock) is
		type read_state_t is (LSB, MSB);
		variable ReadState : read_state_t := LSB;
		variable Temp : std_ulogic_vector(15 downto 0);
		variable OldParbusRead : boolean := false;
	begin
		if rising_edge(Clock) then
			-- On the rising edge of the first (LSB) read cycle, grab the data.
			if ParbusRead and not OldParbusRead and ReadState = LSB then
				Temp := ReadData;
			end if;

			-- On the falling edge, switch the byte toggle.
			if OldParbusRead and not ParbusRead then
				case ReadState is
					when LSB => ReadState := MSB;
					when MSB => ReadState := LSB;
				end case;
			end if;

			-- Any write cycles on the bus clear the byte toggle to LSB.
			if ParbusWrite then
				ReadState := LSB;
			end if;

			OldParbusRead := ParbusRead;
		end if;

		-- Output whichever byte the byte toggle currently selects.
		case ReadState is
			when LSB => ParbusDataOut <= Temp(7 downto 0);
			when MSB => ParbusDataOut <= Temp(15 downto 8);
		end case;
	end process;

	-- Handles writes of data from the microcontroller to the FPGA.
	process(Clock, ParbusDataIn) is
		type write_state_t is (ADDR, LSB, MSB);
		variable WriteState : write_state_t := ADDR;
		variable OldParbusWrite : boolean := false;
	begin
		if rising_edge(Clock) then
			-- Write strobe is always clear except for one clock cycle when it should assert.
			WriteStrobe <= false;

			-- On the rising edge of a write cycle, grab and process the incoming data.
			if ParbusWrite and not OldParbusWrite then
				case WriteState is
					when ADDR =>
						Address <= to_integer(unsigned(ParbusDataIn));
						WriteState := LSB;

					when LSB =>
						WriteData(7 downto 0) <= ParbusDataIn;
						WriteState := MSB;

					when MSB =>
						WriteStrobe <= true;
						WriteState := ADDR;
				end case;
			end if;

			-- Any read cycles on the bus clear the state machine back to address mode.
			if ParbusRead then
				WriteState := ADDR;
			end if;

			OldParbusWrite := ParbusWrite;
		end if;

		-- This only needs to be valid when strobe is asserted.
		-- Strobe is only asserted during the MSB cycle.
		-- Therefore, whenever strobe is asserted, the input pins will hold the data MSB.
		-- Thus, it is not necessary to register this value.
		WriteData(15 downto 8) <= ParbusDataIn;
	end process;
end architecture Behavioural;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types;

entity ParbusRegisterMap is
	port(
		Clock : in std_ulogic;

		Address : in natural range 0 to 255;
		ReadData : out std_ulogic_vector(15 downto 0);
		WriteData : in std_ulogic_vector(15 downto 0);
		WriteStrobe : in boolean;

		EnableMotors : out boolean := false;
		EnableCharger : out boolean := false;
		MotorsDirection : out types.motors_direction_t := (others => false);
		MotorsPower : out types.motors_power_t := (others => 0);
		BatteryVoltage : out types.battery_voltage_t := 0;
		TestMode : out types.test_mode_t := types.NONE;
		TestIndex : out natural range 0 to 15 := 0;
		ChickStrobe : out boolean := false;
		ChickPower : out types.chicker_power_t := 0;
		EncodersStrobe : out boolean := false;

		ChickerPresent : in boolean;
		CapacitorVoltage : in types.capacitor_voltage_t;
		EncodersCount : in types.encoders_count_t);
end entity ParbusRegisterMap;

architecture Behavioural of ParbusRegisterMap is
begin
	-- Combinationally construct the readable register map for data transfer from FPGA to microcontroller.
	ReadData <=
		-- Address 0 has a magic signature.
		X"468D" when Address = 0 else

		-- Address 1 has general operational flags.
		(0 => '1', 1 => types.to_stdulogic(ChickerPresent), others => '0') when Address = 1 else

		-- Addresses 2 through 5 have encoders 1 through 4 deltas.
		std_ulogic_vector(to_signed(EncodersCount(Address - 1), 16)) when Address = 2 or Address = 3 or Address = 4 or Address = 5 else

		-- Address 6 has capacitr voltage.
		std_ulogic_vector(to_unsigned(CapacitorVoltage, 16)) when Address = 6 else

		-- Remaining addresses are unimplemented.
		X"0000";

	process(Clock) is
	begin
		if rising_edge(Clock) then
			-- Strobes are always clear except for one clock cycle when they should assert.
			ChickStrobe <= false;
			EncodersStrobe <= false;

			-- If a register is written to, handle the effects.
			if WriteStrobe then
				case Address is
					-- Address 0 has general subsystem enable flags.
					when 0 =>
						EnableMotors <= types.to_boolean(WriteData(0));
						EnableCharger <= types.to_boolean(WriteData(1));

					-- Addresses 1 through 5 have motor N direction and power.
					when 1 | 2 | 3 | 4 | 5 =>
						MotorsDirection(Address) <= types.to_boolean(WriteData(8));
						MotorsPower(Address) <= to_integer(unsigned(WriteData(7 downto 0)));

					-- Address 6 has test mode controls.
					when 6 =>
						case to_integer(unsigned(WriteData(7 downto 4))) is
							when 1 => TestMode <= types.LAMPTEST;
							when 2 => TestMode <= types.HALL;
							when 3 => TestMode <= types.ENCODER_LINES;
							when 4 => TestMode <= types.ENCODER_COUNT;
							when 5 => TestMode <= types.BOOSTCONVERTER;
							when others => TestMode <= types.NONE;
						end case;
						TestIndex <= to_integer(unsigned(WriteData(3 downto 0)));

					-- Address 7 has chicker firing control.
					when 7 =>
						ChickPower <= to_integer(unsigned(WriteData(11 downto 0)));
						ChickStrobe <= true;

					-- Address 8 has battery voltage.
					when 8 =>
						BatteryVoltage <= to_integer(unsigned(WriteData(9 downto 0)));

					-- Address 9 latches and resets the encoder counts.
					when 9 =>
						EncodersStrobe <= true;

					-- Remaining addresses are unimplemented.
					when others =>
						null;
				end case;
			end if;
		end if;
	end process;
end architecture Behavioural;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types;

entity Parbus is
	port(
		Clock : in std_ulogic;

		ParbusDataIn : in std_ulogic_vector(7 downto 0);
		ParbusDataOut : out std_ulogic_vector(7 downto 0);
		ParbusRead : in boolean;
		ParbusWrite : in boolean;

		EnableMotors : out boolean := false;
		EnableCharger : out boolean := false;
		MotorsDirection : out types.motors_direction_t := (others => false);
		MotorsPower : out types.motors_power_t := (others => 0);
		BatteryVoltage : out types.battery_voltage_t;
		TestMode : out types.test_mode_t;
		TestIndex : out natural range 0 to 15;
		ChickStrobe : out boolean;
		ChickPower : out types.chicker_power_t;
		EncodersStrobe : out boolean;

		ChickerPresent : in boolean;
		CapacitorVoltage : in types.capacitor_voltage_t;
		EncodersCount : in types.encoders_count_t);
end entity Parbus;

architecture Behavioural of Parbus is
	signal Address : natural range 0 to 255;
	signal ReadData : std_ulogic_vector(15 downto 0);
	signal WriteData : std_ulogic_vector(15 downto 0);
	signal WriteStrobe : boolean;
begin
	Transceiver: entity work.ParbusTransceiver(Behavioural)
	port map(
		Clock => Clock,
		ParbusDataIn => ParbusDataIn,
		ParbusDataOut => ParbusDataOut,
		ParbusRead => ParbusRead,
		ParbusWrite => ParbusWrite,
		Address => Address,
		ReadData => ReadData,
		WriteData => WriteData,
		WriteStrobe => WriteStrobe);

	RegisterMap: entity work.ParbusRegisterMap(Behavioural)
	port map(
		Clock => Clock,
		Address => Address,
		ReadData => ReadData,
		WriteData => WriteData,
		WriteStrobe => WriteStrobe,
		EnableMotors => EnableMotors,
		EnableCharger => EnableCharger,
		MotorsDirection => MotorsDirection,
		MotorsPower => MotorsPower,
		BatteryVoltage => BatteryVoltage,
		TestMode => TestMode,
		TestIndex => TestIndex,
		ChickStrobe => ChickStrobe,
		ChickPower => ChickPower,
		EncodersStrobe => EncodersStrobe,
		ChickerPresent => ChickerPresent,
		CapacitorVoltage => CapacitorVoltage,
		EncodersCount => EncodersCount);
end architecture Behavioural;
