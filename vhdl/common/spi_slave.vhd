library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;


--! \brief top level entity for SPI Slave
--!
--! Implements and SPI slave transceiver with correct clock crossings
--! and CRC checking. Out going data is latched on the last bus clock
--! of the previous byte. It is therefore impossible to send anything
--! other than zero for the first word.
entity SPISlave is
	generic(
		
		--! \brief CRC Generator Polynomial
		--!
		--! Generator polynomial for the CRC unit, value should be in normal form
		GENERATOR_POLYNOMIAL : natural := 16#07#;
		
		--! \brief CRC reset value
		RESET_VALUE : natural := 16#00#;

		--! \brief CRC check value
		--! 
		--! Value which the CRC will take on upon reception of the data stream including the CRC itself
		CRC_OK_VALUE : natural := 16#00#);
	port(
		--! \brief FPGA system clock
		HostClock : in std_ulogic;

		--! \brief SPI bus clock
		BusClock : in std_ulogic;

		--! \brief SPI chip select line
		CSLine : in std_ulogic;
		
		--! \brief outputs from spi module
		--!
		--! Record for the data coming from the SPI module into the FPGA
		--! the input convention is with respect the the FPGA as a whole
		Input : buffer spi_input_t;

		--! \brief data inputs SPI module
		--!
		--! Record for the data entering the SPI modules from FPGA perhipherals
		--! the output convention is with respect to the FPGA itself
		Output : in spi_output_t;

		--! \brief CRC Error Interrupt
		--!
		--! Asserted for one host clock cycle when an incoming transaction ends with a bad CRC.
		CRCErrorIRQ : buffer boolean;
		
		--! \brief SPI MOSI Pin
		MOSIPin : in std_ulogic;

		--! \brief SPI MISO Pin
		MISOPin : buffer std_ulogic);
end entity SPISlave;

architecture RTL of SPISlave is
begin

	receive_unit : entity work.SPISlaveReceiver
		generic map (GENERATOR_POLYNOMIAL => GENERATOR_POLYNOMIAL, RESET_VALUE => RESET_VALUE, CRC_OK_VALUE => CRC_OK_VALUE)
		port map (HostClock => HostClock, BusClock => BusClock, CSLine => CSLine, Data => Input.ReadData,Strobe => Input.ReadStrobe,First => Input.ReadFirst, CRCErrorIRQ => CRCErrorIRQ, MOSIpin => MOSIpin);

	transmit_unit : entity work.SPISlaveTransmitter
		generic map (GENERATOR_POLYNOMIAL => GENERATOR_POLYNOMIAL, RESET_VALUE => RESET_VALUE)
		port map (HostClock => HostClock, BusClock => BusClock, CSLine => CSLine, Data => Output.WriteData,Strobe => Output.WriteStrobe,SendCRC => Output.WriteCRC,Ready => Input.WriteReady, MISOpin => MISOpin);
	
end architecture RTL;
