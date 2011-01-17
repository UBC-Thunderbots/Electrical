library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types;

entity Parbus is
	port(
		Clock : in std_ulogic;
		Reset : in boolean;

		ParbusDataIn : in std_ulogic_vector(7 downto 0);
		ParbusDataOut : out std_ulogic_vector(7 downto 0);
		ParbusRead : in boolean;
		ParbusWrite : in boolean;

		EnableMotors : out boolean;
		EnableCharger : out boolean;
		MotorsDirection : out types.motors_direction_t;
		MotorsPower : out types.motors_power_t;
		BatteryVoltage : out types.battery_voltage_t;

		ChickerPresent : in boolean;
		CapacitorVoltage : in types.capacitor_voltage_t;
		EncodersCount : in types.encoders_count_t);
end entity Parbus;

architecture Behavioural of Parbus is
begin
	-- Handle packets from the microcontroller
	process(Clock) is
		type data_t is array(0 to 7) of std_ulogic_vector(7 downto 0);
		subtype byte_count_t is natural range data_t'range;
		variable WriteData : data_t;
		variable WriteByteCount : byte_count_t;
		variable OldParbusWrite : boolean;
	begin
		if rising_edge(Clock) then
			if Reset then
				EnableMotors <= false;
				EnableCharger <= false;
				MotorsDirection <= (others => false);
				MotorsPower <= (others => 0);
				WriteByteCount := 0;
			elsif ParbusWrite and not OldParbusWrite then
				WriteData(WriteByteCount) := ParbusDataIn;
				if WriteByteCount = byte_count_t'high then
					WriteByteCount := 0;
					EnableMotors <= WriteData(0)(7) = '1';
					EnableCharger <= WriteData(0)(6) = '1';
					for I in 1 to 5 loop
						MotorsDirection(I) <= WriteData(0)(I - 1) = '1';
					end loop;
					for I in 1 to 5 loop
						MotorsPower(I) <= to_integer(unsigned(WriteData(1 + (I - 1))));
					end loop;
					BatteryVoltage <= to_integer(unsigned(std_ulogic_vector'(WriteData(7) & WriteData(6))));
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
		subtype byte_count_t is natural range data_t'range;
		variable ReadData : data_t;
		variable ReadByteCount : byte_count_t;
		variable OldParbusRead : boolean;
	begin
		if rising_edge(Clock) then
			if Reset then
				ParbusDataOut <= X"00";
				ReadByteCount := 0;
			elsif OldParbusRead and not ParbusRead then
				if ReadByteCount = byte_count_t'high then
					ReadByteCount := 0;
				else
					ReadByteCount := ReadByteCount + 1;
				end if;
			elsif not ParbusRead and ReadByteCount = 0 then
				ReadData(0) := X"00";
				if ChickerPresent then
					ReadData(0)(0) := '1';
				end if;
				ReadData(1) := std_ulogic_vector(to_unsigned(CapacitorVoltage, 16)(7 downto 0));
				ReadData(2) := std_ulogic_vector(to_unsigned(CapacitorVoltage, 16)(15 downto 8));
				for I in 1 to 4 loop
					ReadData(3 + (I - 1) * 2 + 0) := std_ulogic_vector(to_unsigned(EncodersCount(I), 16)(7 downto 0));
					ReadData(3 + (I - 1) * 2 + 1) := std_ulogic_vector(to_unsigned(EncodersCount(I), 16)(15 downto 8));
				end loop;
			end if;

			OldParbusRead := ParbusRead;
		end if;

		ParbusDataOut <= ReadData(ReadByteCount);
	end process;
end architecture Behavioural;
