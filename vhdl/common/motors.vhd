library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.commands.all;
use work.motor_common.all;
use work.types.all;

--! Ties all the motors together and provides an ICB interface.
entity Motors is
	port(
		Reset : in boolean; --! The system reset signal.
		HostClock : in std_ulogic; --! The system clock.
		PWMClock : in std_ulogic; --! The PWM timebase clock.
		ICBIn : in spi_input_t; --! The ICB data input.
		ICBOut : buffer spi_output_t; --! The ICB data output.
		Interlock : in boolean; --! Whether to apply safety interlocks.
		HallsPin : in halls_pin_t; --! The wires from the Hall sensors.
		PhasesHPin : buffer motors_phases_pin_t; --! The wires to the high-side motor phase drivers.
		PhasesLPin : buffer motors_phases_pin_t); --! The wires to the low-side motor phase drivers.
end entity Motors;

architecture RTL of Motors is
	signal StuckLow, StuckLowLatch, StuckHigh, StuckHighLatch : boolean_vector(0 to 4);
	signal FlushStuckLow, FlushStuckHigh : boolean;
	signal DriveModes : motor_drive_mode_vector(0 to 4);
	signal HallCounts : hall_count_vector(DriveModes'range);
begin
	process(HostClock) is
		type state_t is (IDLE, ICB_RECEIVE_SETTINGS, ICB_SEND_DATA, ICB_SEND_STUCK_HIGH, ICB_SEND_CRC);
		variable State : state_t;
		variable Command : natural range 0 to 255;
		variable DataBuffer : byte_vector(0 to DriveModes'length * 2 - 1);
		variable ByteIndex : natural range DataBuffer'range; -- For receiving, index of next byte to receive; for sending, index of last byte sent
		variable ModeByte : std_ulogic_vector(7 downto 0);
		variable ModePhaseBits : std_ulogic_vector(1 downto 0);
	begin
		if rising_edge(HostClock) then
			ICBOut.WriteData <= X"00";
			ICBOut.WriteCRC <= false;
			ICBOut.WriteStrobe <= false;
			FlushStuckLow <= false;
			FlushStuckHigh <= false;

			if Reset then
				State := IDLE;
				for I in DriveModes'range loop
					DriveModes(I).DataSource <= MCU;
					for J in DriveModes(I).Phases'range loop
						DriveModes(I).Phases(J) <= FLOAT;
					end loop;
				end loop;
			elsif ICBIn.ReadStrobe and ICBIn.ReadFirst then
				Command := to_integer(unsigned(ICBIn.ReadData));
				case Command is
					when COMMAND_MOTORS_SET =>
						ByteIndex := 0;
						State := ICB_RECEIVE_SETTINGS;

					when COMMAND_MOTORS_GET_HALL_COUNT =>
						for I in HallCounts'range loop
							DataBuffer(I * 2) := std_ulogic_vector(HallCounts(I)(7 downto 0));
							DataBuffer(I * 2 + 1) := std_ulogic_vector(HallCounts(I)(15 downto 8));
						end loop;
						ByteIndex := 0;
						ICBOut.WriteData <= std_ulogic_vector(DataBuffer(0));
						ICBOut.WriteStrobe <= true;
						State := ICB_SEND_DATA;

					when COMMAND_MOTORS_GET_CLEAR_STUCK_HALLS =>
						for I in StuckLowLatch'range loop
							ICBOut.WriteData(I) <= to_stdulogic(StuckLowLatch(I));
						end loop;
						ICBOut.WriteStrobe <= true;
						FlushStuckLow <= true;
						State := ICB_SEND_STUCK_HIGH;

					when others =>
						null;
				end case;
			else
				case State is
					when IDLE =>
						null;

					when ICB_RECEIVE_SETTINGS =>
						if ICBIn.ReadStrobe then
							DataBuffer(ByteIndex) := ICBIn.ReadData;
							if ByteIndex = DataBuffer'right then
								for I in DriveModes'range loop
									ModeByte := DataBuffer(I * 2);
									if ModeByte(7) = '1' then
										DriveModes(I).DataSource <= HALL;
									else
										DriveModes(I).DataSource <= MCU;
									end if;
									if ModeByte(6) = '1' then
										DriveModes(I).Direction <= REVERSE;
									else
										DriveModes(I).Direction <= FORWARD;
									end if;
									for J in DriveModes(I).Phases'range loop
										ModePhaseBits := ModeByte(J * 2 + 1 downto J * 2);
										case ModePhaseBits is
											when "00"   => DriveModes(I).Phases(J) <= FLOAT;
											when "01"   => DriveModes(I).Phases(J) <= PWM;
											when "10"   => DriveModes(I).Phases(J) <= LOW;
											when others => DriveModes(I).Phases(J) <= HIGH;
										end case;
									end loop;
									DriveModes(I).DutyCycle <= to_integer(unsigned(DataBuffer(I * 2 + 1)));
								end loop;
								State := IDLE;
							else
								ByteIndex := ByteIndex + 1;
							end if;
						end if;

					when ICB_SEND_DATA =>
						if ICBIn.WriteReady then
							if ByteIndex = DataBuffer'right then
								ICBOut.WriteCRC <= true;
								ICBOut.WriteStrobe <= true;
								State := IDLE;
							else
								ByteIndex := ByteIndex + 1;
								ICBOut.WriteData <= DataBuffer(ByteIndex);
								ICBOut.WriteStrobe <= true;
							end if;
						end if;

					when ICB_SEND_STUCK_HIGH =>
						if ICBIn.WriteReady then
							for I in StuckHighLatch'range loop
								ICBOut.WriteData(I) <= to_stdulogic(StuckHighLatch(I));
							end loop;
							ICBOut.WriteStrobe <= true;
							FlushStuckHigh <= true;
							State := ICB_SEND_CRC;
						end if;

					when ICB_SEND_CRC =>
						if ICBIn.WriteReady then
							ICBOut.WriteCRC <= true;
							ICBOut.WriteStrobe <= true;
							State := IDLE;
						end if;
				end case;
			end if;
		end if;
	end process;

	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			if Reset or FlushStuckLow then
				StuckLowLatch <= (others => false);
			else
				for I in StuckLow'range loop
					StuckLowLatch(I) <= StuckLowLatch(I) or StuckLow(I);
				end loop;
			end if;
			if Reset or FlushStuckHigh then
				StuckHighLatch <= (others => false);
			else
				for I in StuckHigh'range loop
					StuckHighLatch(I) <= StuckHighLatch(I) or StuckHigh(I);
				end loop;
			end if;
		end if;
	end process;

	Motors : for I in DriveModes'range generate
		Motor : entity work.Motor(RTL)
		generic map(
			PWMPhase => I * 255 / 5)
		port map(
			Reset => Reset,
			HostClock => HostClock,
			PWMClock => PWMClock,
			Interlock => Interlock,
			DriveMode => DriveModes(I),
			HallCount => HallCounts(I),
			StuckLow => StuckLow(I),
			StuckHigh => StuckHigh(I),
			HallPin => HallsPin(I),
			PhasesHPin => PhasesHPin(I),
			PhasesLPin => PhasesLPin(I));
	end generate;
end architecture RTL;
