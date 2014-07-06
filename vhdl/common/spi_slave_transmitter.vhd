library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;
use work.utils.all;

--! \brief SPI Transmitter SubModule
entity SpiSlaveTransmitter is
	generic(
		--! \brief Generator Polynomial for CRC Unit
		GENERATOR_POLYNOMIAL : natural := 16#07#;
		
		--! \brief CRC Reset Value
		RESET_VALUE : natural := 16#00#);
	port(
		
		--! \brief FPGA System Clock
		HostClock : in std_ulogic;

		--! \brief SPI Bus Clock
		BusClock : in std_ulogic;

		--! \brief SPI Bus Chip Select line
		CSLine : in std_ulogic;

		--! \brief Data word to Xmit
		Data : in spi_word_t;
		
		--! \brief Data Write Stobe
		--!
		--! Assert to have the transmitter capture presented data
		Strobe : in boolean;

		--! \brief Send CRC
		--!
		--! Assert to have the transmitter send the currently stored CRC value instead of the provided data.
		--! Must be strobed
		SendCRC : in boolean;

		--! \brief Ready for Strobe
		--!
		--! asserted if the transmitter allows a write strobe. Only assert strobe if Ready is asserted.
		Ready : buffer boolean;
		
		--! \brief SPI MISO Pin
		MISOPin : buffer std_ulogic
);	
end entity SPISlaveTransmitter;

architecture RTL of SPISlaveTransmitter is
	constant counter_reset : natural := spi_word_t'length-1;
	constant GEN_POLY : spi_word_t := std_ulogic_vector(to_unsigned(GENERATOR_POLYNOMIAL,spi_word_t'length));


	--host clock domain
	signal host_data : spi_word_t := (others => '0');
	signal transmitter_ready : boolean := false;
	signal bus_toggle_buffer : boolean;
	signal host_toggle_ready : boolean := false;
	signal host_send_crc : boolean := false;
	signal host_toggle : boolean := false;

	--Bus Clock domain
	signal shifter : spi_word_t := (others => '0');
	signal counter : natural := counter_reset;
	signal current_crc : spi_word_t := std_ulogic_vector(to_unsigned(RESET_VALUE, spi_word_t'length));
	signal bus_toggle : boolean := false;
Begin
	-- Traditionally, one thinks of SPI buses as sampling an incoming bit on rising edge of clock, and shifting out the next outgoing bit on falling edge.
	-- However, at our speeds, without any deskew technologies in the clock path, it is very difficult to achieve the necessary setup time for the receiver in that configuration.
	-- Instead, we exhibit a new output bit on rising edge of clock, giving us a whole extra half-period to propagate the bit out onto the I/O pin.
	-- Because time travel does not exist, this is still safe; we cannot possibly exhibit the new output bit before the SPI master has sent its rising edge of clock!
	-- The hold time requirement for the master receiver is 2.5 nanoseconds; we ensure to meet this requirement by means of the VALID constraint in the UCF.
	-- If necessary, that constraint ought to add delay to the output path in order to not send out the new bit too early.
	process(CSLine, host_toggle, BusClock)
		variable transmitted_bit : std_ulogic;
		variable data_falling_latch : spi_word_t;
	begin
		if(CSLine='1') then
			current_crc <= std_ulogic_vector(to_unsigned(RESET_VALUE,spi_word_t'length));
			counter <= counter_reset;
			shifter <= (others => '0');
			MISOpin <= '0';
			bus_toggle <= false;
		elsif(rising_edge(BusClock)) then
			--Xmit section
			if(counter = natural'low) then
				if(bus_toggle /= host_toggle) then
					bus_toggle <= host_toggle;
					if(host_send_crc) then
						data_falling_latch := current_crc;
					else
						data_falling_latch := host_data;
					end if;
				else
					data_falling_latch := (others => '0');
				end if;
				counter <= counter_reset;
				
				transmitted_bit := data_falling_latch(spi_word_t'length-1);
				shifter <= data_falling_latch(spi_word_t'length-2 downto 0)&'0';
				counter <= counter_reset;
				bus_toggle <= host_toggle;
			else
				transmitted_bit := shifter(spi_word_t'length-1);
				shifter <= shifter(spi_word_t'length-2 downto 0)&'0';
				counter <= counter-1;
			end if;
			MISOpin <= transmitted_bit;
			current_crc <= crc_step(current_crc,GEN_POLY,transmitted_bit);
		end if;
	end process;

	process(HostClock, CSLine)
	begin
		if(CSLine='1') then
			host_toggle_ready <= false;
			transmitter_ready <= false;
			host_data <= (others => '0');
			host_send_crc <= false;
			host_toggle <= false;
		elsif(rising_edge(HostClock)) then
			host_toggle_ready <= false;

			--Inital Clock crossing for bus_toggle
			bus_toggle_buffer <= bus_toggle;
			
			if(Strobe AND transmitter_ready) then
				host_data <= Data;
				host_send_crc <= SendCRC;
				transmitter_ready <= false;
				host_toggle_ready <= true;
			elsif (bus_toggle_buffer = host_toggle AND NOT host_toggle_ready) then
				transmitter_ready <= true;
			end if;

			if(host_toggle_ready = true) then
				host_toggle <= not host_toggle;
			end if;
				
		end if;
	end process;

	Ready <= transmitter_ready AND NOT Strobe;

end architecture;
