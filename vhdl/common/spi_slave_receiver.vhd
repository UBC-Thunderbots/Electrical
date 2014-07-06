library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;
use work.utils.all;

--! \brief Receiver SubModule for the SPI Slave
entity SPISlaveReceiver is
	generic(
		--! \brief Generator Polynomial for internal CRC
		GENERATOR_POLYNOMIAL : natural := 16#07#;

		--! \brief Value which the CRC shall be reset to.
		RESET_VALUE : natural := 16#00#;

		--! \brief CRC check value
		--!
		--! Value which the CRC register takes on upon reception of the data stream including the CRC itself
		CRC_OK_VALUE : natural := 16#00#);
	port(
		--! \brief FPGA System clock
		HostClock : in std_ulogic;

		--! \brief SPI Bus Clock
		BusClock : in std_ulogic;

		--! \brief SPI Chip Select line
		CSLine : in std_ulogic;
	
		--! \brief Received Data Word
		Data : buffer spi_word_t;

		--! \brief Receive Strobe
		--!
		--! Strobe word reception
		Strobe : buffer boolean;

		--! \brief CRC Check Ok
		--! 
		--! Asserted when the internal CRC register equals CRC_OK_VALUE
		CRCOk : buffer boolean;

		--! \brief First Word Flag
		--!
		--! Asserted when the word is the first received after the assertion of 
		--! chip select. Data is valid on the same clock as strobe.
		First : buffer boolean;

		--! \brief CRC Error IRQ
		--!
		--! Pulsed when received data has an incorrect CRC.
		CRCErrorIRQ : buffer boolean;

		--! \brief SPI MOSI pin
		MOSIPin : in std_ulogic);
end entity SPISlaveReceiver;


architecture RTL of SPISlaveReceiver is
	constant counter_reset : natural := spi_word_t'length-1;
	constant CRC_COMPARE : spi_word_t := std_ulogic_vector(to_unsigned(CRC_OK_VALUE,spi_word_t'length));
	constant GEN_POLY : spi_word_t := std_ulogic_vector(to_unsigned(GENERATOR_POLYNOMIAL, spi_word_t'length));

	--HostClock domain
	signal host_toggle_buffer : boolean;
	signal host_toggle_old : boolean;
	signal host_crc_ok : boolean;

	--BusClock domain
	signal current_crc : spi_word_t := std_ulogic_vector(to_unsigned(RESET_VALUE, spi_word_t'length));
	signal crc_input : std_ulogic;

	signal counter : natural := counter_reset;
	signal receive_buffer : spi_word_t;
	signal shifter : spi_word_t;
	signal is_first_word : boolean := true;
	signal first_buffer : boolean;
	signal crc_ok : boolean;
	signal bus_toggle : boolean := false;

	signal crc_cs_delay : std_ulogic_vector(3 downto 0);
	signal crc_error_reported : boolean := false;
Begin
	
	process(CSLine,BusClock)
		variable crc_temp_val : spi_word_t;
	begin
		if(CSLine='1') then
			current_crc <= std_ulogic_vector(to_unsigned(RESET_VALUE,spi_word_t'length));
			counter <= counter_reset;
			is_first_word <= true;

		elsif(rising_edge(BusClock)) then

		--Receive section
			if(counter = natural'low) then
				counter <= counter_reset;
				receive_buffer <= shifter(spi_word_t'length-2 downto 0)&MOSIpin;
				first_buffer <= is_first_word;
				is_first_word <= false;
				bus_toggle <= not bus_toggle;
			else
				counter <= counter-1;
				shifter <= shifter(spi_word_t'length-2 downto 0)&MOSIpin;
			end if;
			
			crc_temp_val := crc_step(current_crc,GEN_POLY,MOSIpin);
			current_crc <= crc_temp_val;
			crc_ok <= (crc_temp_val = CRC_COMPARE);

		end if;
	end process;
	

	process(HostClock)
	begin
		--Receive signal clock domain crossing
		if(rising_edge(HostClock)) then
			host_toggle_buffer <= bus_toggle;
			host_toggle_old <= host_toggle_buffer;
			Strobe <= false;
			if(host_toggle_old /= host_toggle_buffer) then
				Data <= receive_buffer;
				host_crc_ok <= crc_ok;
				First <= first_buffer;
				Strobe <= true;
			end if;
		end if;
	end process;

	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			CRCErrorIRQ <= false;
			if crc_cs_delay(0) = '1' and not host_crc_ok and not crc_error_reported then
				CRCErrorIRQ <= true;
				crc_error_reported <= true;
			elsif crc_cs_delay(0) = '0' then
				crc_error_reported <= false;
			end if;
			crc_cs_delay <= CSLine & crc_cs_delay(crc_cs_delay'high downto 1);
		end if;
	end process;
end architecture;
