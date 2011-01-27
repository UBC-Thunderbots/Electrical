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
		ChickSequence : out boolean;
		MotorsDirection : out types.motors_direction_t := (others => false);
		MotorsPower : out types.motors_power_t := (others => 0);
		BatteryVoltage : out types.battery_voltage_t;
		TestMode : out types.test_mode_t;
		TestIndex : out natural range 0 to 15;
		ChickPower : out types.chicker_power_t;

		ChickerPresent : in boolean;
		CapacitorVoltage : in types.capacitor_voltage_t;
		EncodersCount : in types.encoders_count_t);
end entity Parbus;

architecture Behavioural of Parbus is
begin
	-- Handle packets from the microcontroller
	process(Clock) is
		type data_t is array(0 to 10) of std_ulogic_vector(7 downto 0);
		subtype byte_count_t is natural range data_t'range;
		variable WriteData : data_t;
		variable WriteByteCount : byte_count_t := 0;
		variable OldParbusWrite : boolean;
	begin
		if rising_edge(Clock) then
			if ParbusWrite and not OldParbusWrite then
				WriteData(WriteByteCount) := ParbusDataIn;
				if WriteByteCount = byte_count_t'high then
					WriteByteCount := 0;
					EnableMotors <= WriteData(0)(7) = '1';
					EnableCharger <= WriteData(0)(6) = '1';
					ChickSequence <= WriteData(0)(5) = '1';
					for I in 1 to 5 loop
						MotorsDirection(I) <= WriteData(0)(I - 1) = '0'; -- Inverted because motors are mounted so "positive" direction is backwards
					end loop;
					for I in 1 to 5 loop
						MotorsPower(I) <= to_integer(unsigned(WriteData(1 + (I - 1))));
					end loop;
					BatteryVoltage <= to_integer(unsigned(std_ulogic_vector'(WriteData(7) & WriteData(6))));
					case WriteData(8)(7 downto 4) is
						when "0001" => TestMode <= types.LAMPTEST;
						when "0010" => TestMode <= types.HALL;
						when "0011" => TestMode <= types.ENCODER_LINES;
						when "0100" => TestMode <= types.ENCODER_COUNT;
						when "0101" => TestMode <= types.BOOSTCONVERTER;
						when others => TestMode <= types.NONE;
					end case;
					TestIndex <= to_integer(unsigned(WriteData(8)(3 downto 0)));
					ChickPower <= to_integer(unsigned(std_ulogic_vector'(WriteData(10) & WriteData(9))));
				else
					WriteByteCount := WriteByteCount + 1;
				end if;
			end if;

			OldParbusWrite := ParbusWrite;
		end if;
	end process;

	-- Handle packets to the microcontroller
	process(Clock) is
		type data_t is array(0 to 10) of std_ulogic_vector(7 downto 0);
		subtype byte_count_t is natural range 0 to data_t'high + 1; -- +1 because the PIC does a dummy read at the end of each packet
		variable ReadData : data_t;
		variable ReadByteCount : byte_count_t := 0;
		variable OldParbusRead : boolean;
		variable OldEncodersCount : types.encoders_count_t := (others => 0);
		variable Diff : signed(15 downto 0);
	begin
		if rising_edge(Clock) then
			if ParbusRead and not OldParbusRead and ReadByteCount = 0 then
				OldEncodersCount := EncodersCount;
			elsif OldParbusRead and not ParbusRead then
				if ReadByteCount = byte_count_t'high then
					ReadByteCount := 0;
				else
					ReadByteCount := ReadByteCount + 1;
				end if;
			elsif not ParbusRead and ReadByteCount = 0 then
				ReadData(0) := X"01";
				if ChickerPresent then
					ReadData(0)(1) := '1';
				end if;
				ReadData(1) := std_ulogic_vector(to_unsigned(CapacitorVoltage, 16)(7 downto 0));
				ReadData(2) := std_ulogic_vector(to_unsigned(CapacitorVoltage, 16)(15 downto 8));
				for I in 1 to 4 loop
					Diff := resize(signed(to_unsigned(OldEncodersCount(I), 11) - to_unsigned(EncodersCount(I), 11)), 16); -- Negated because encoders are mounted so "positive" direction is backwards
					ReadData(3 + (I - 1) * 2 + 0) := std_ulogic_vector(Diff(7 downto 0));
					ReadData(3 + (I - 1) * 2 + 1) := std_ulogic_vector(Diff(15 downto 8));
				end loop;
			end if;

			OldParbusRead := ParbusRead;
		end if;

		ParbusDataOut <= ReadData(ReadByteCount);
	end process;
end architecture Behavioural;
