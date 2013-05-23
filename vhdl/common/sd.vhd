library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity SD is
	port(
		HostClock : in std_ulogic;
		BusClock : in std_ulogic;
		BusClockI : in std_ulogic;
		PIOWriteData : in std_ulogic_vector(7 downto 0);
		PIOReadData : out std_ulogic_vector(7 downto 0);
		PIOStrobe : in boolean;
		Busy : out boolean;
		DRTCRCError : out boolean := false;
		DRTWriteError : out boolean := false;
		DRTUnknownError : out boolean := false;
		ClockPin : out std_ulogic;
		MOSIPin : out std_ulogic;
		MISOPin : in std_ulogic;
		DMAReadRequest : out dmar_request_t := (Consumed => false);
		DMAReadResponse : in dmar_response_t);
end entity SD;

architecture Arch of SD is
	type state_t is (IDLE, SEND_START_NOP, SEND_START_TOKEN, SEND_DATA, SEND_CRC_MSB, SEND_CRC_LSB, SEND_FIRST_NOP_FOR_DRT, RECEIVE_DRT, SEND_FIRST_NOP_FOR_BUSY, WAIT_BUSY, WAIT_PIO);
	signal State : state_t := IDLE;
	signal DataIndex : natural range 0 to 511;

	signal SPIWriteData : std_ulogic_vector(7 downto 0);
	signal SPIReadData : std_ulogic_vector(7 downto 0);
	signal SPIStrobe : boolean := false;
	signal SPIBusy : boolean;
begin
	SPI : entity work.SPI(Arch)
	port map(
		HostClock => HostClock,
		BusClock => BusClock,
		BusClockI => BusClockI,
		WriteData => SPIWriteData,
		ReadData => SPIReadData,
		Strobe => SPIStrobe,
		Busy => SPIBusy,
		ClockPin => ClockPin,
		MOSIPin => MOSIPin,
		MISOPin => MISOPin);

	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			SPIStrobe <= false;
			DMAReadRequest.Consumed <= false;

			if not SPIBusy then
				case State is
					when IDLE =>
						if PIOStrobe then
							SPIWriteData <= PIOWriteData;
							SPIStrobe <= true;
							State <= WAIT_PIO;
						elsif DMAReadResponse.Valid then
							State <= SEND_START_NOP;
						end if;

					when SEND_START_NOP =>
						SPIWriteData <= X"FF";
						SPIStrobe <= true;
						State <= SEND_START_TOKEN;

					when SEND_START_TOKEN =>
						SPIWriteData <= "11111100";
						SPIStrobe <= true;
						State <= SEND_DATA;
						DataIndex <= 511;

					when SEND_DATA =>
						if DMAReadResponse.Valid then
							SPIWriteData <= DMAReadResponse.Data;
							SPIStrobe <= true;
							DMAReadRequest.Consumed <= true;
							if DataIndex = 0 then
								State <= SEND_CRC_MSB;
							else
								DataIndex <= DataIndex - 1;
							end if;
						end if;

					when SEND_CRC_MSB =>
						SPIWriteData <= X"00";
						SPIStrobe <= true;
						State <= SEND_CRC_LSB;

					when SEND_CRC_LSB =>
						SPIWriteData <= X"00";
						SPIStrobe <= true;
						State <= SEND_FIRST_NOP_FOR_DRT;

					when SEND_FIRST_NOP_FOR_DRT =>
						SPIWriteData <= X"FF";
						SPIStrobe <= true;
						State <= RECEIVE_DRT;

					when RECEIVE_DRT =>
						if SPIReadData = X"FF" then
							SPIWriteData <= X"FF";
							SPIStrobe <= true;
						else
							case SPIReadData(4 downto 0) is
								when "00101" => -- Data accepted
								when "01011" => -- CRC error
									DRTCRCError <= true;
								when "01101" => -- Write error
									DRTWriteError <= true;
								when others =>
									DRTUnknownError <= true;
							end case;
							State <= SEND_FIRST_NOP_FOR_BUSY;
						end if;

					when SEND_FIRST_NOP_FOR_BUSY =>
						SPIWriteData <= X"FF";
						SPIStrobe <= true;
						State <= WAIT_BUSY;

					when WAIT_BUSY =>
						if SPIReadData = X"00" then
							SPIWriteData <= X"FF";
							SPIStrobe <= true;
						else
							State <= IDLE;
						end if;

					when WAIT_PIO =>
						State <= IDLE;
				end case;
			end if;
		end if;
	end process;

	PIOReadData <= SPIReadData;
	Busy <= State /= IDLE or SPIBusy or PIOStrobe;
end architecture Arch;
