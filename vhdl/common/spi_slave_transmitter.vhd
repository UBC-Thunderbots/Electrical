library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity SpiSlaveTransmitter is
	generic(
		GENERATOR_POLYNOMIAL : natural := 16#07#; --Value of the generator polynomial in normal form
		RESET_VALUE : natural := 16#00#; --The value that the CRC should be reset to
		CRC_OK_VALUE : natural := 16#00#); --This is the value that the CRC when checked correct takes on.
	port(
		HostClock : in std_ulogic;
		BusClock : in std_ulogic;

		CSLine : in std_ulogic;

		Data : in WORD;
		Strobe : in boolean;
		SendCRC : in boolean;	
		Ready : buffer boolean;
		
		MISOPin : buffer std_ulogic
);	
end entity SPISlaveTransmitter;

architecture RTL of SPISlaveTransmitter is
	constant counter_reset : natural := WORD'length-1;
	constant GENERATOR_POLY : WORD := std_ulogic_vector(to_unsigned(GENERATOR_POLYNOMIAL,WORD'length));


	--host clock domain
	signal host_data : WORD;
	signal bus_toggle_buffer : boolean;
	signal bus_toggle_buffer_old : boolean;
	signal host_toggle_ready : boolean;
	signal host_send_crc : boolean;
	signal host_toggle : boolean;

	--Bus Clock domain
	signal data_falling_latch : WORD;
	signal shifter : WORD;
	signal counter : natural;
	signal previous_crc : WORD;
	signal current_crc : WORD;
	signal crc_input : std_ulogic;
	signal bus_toggle : boolean;
Begin
	
crc_unit:	entity work.CRCStep
		generic map (
			GENERATOR_POLYNOMIAL => GENERATOR_POLYNOMIAL
		)
		port map (
			PreviousCRC => previous_crc,
			Input => crc_input,
			NextCRC => current_crc
		);


	process(CSLine,BusClock)
		variable crc_check_val : WORD;
		variable crc_ok_temp : boolean;
	begin
		if(CSLine='1') then
			previous_crc <= std_ulogic_vector(to_unsigned(RESET_VALUE,WORD'length));
			counter <= counter_reset;
			
		elsif(rising_edge(BusClock)) then
			--Xmit section
			if(counter = natural'low) then
				MISOpin <= data_falling_latch(WORD'length-1);
				crc_input <= data_falling_latch(WORD'length-1);
				shifter <= data_falling_latch(WORD'length-2 downto 0)&'0';
				counter <= counter_reset;
			else
				MISOpin <= shifter(WORD'length-1);
				crc_input <= shifter(WORD'length-1);
				shifter <= shifter(WORD'length-2 downto 0)&'0';
				counter <= counter-1;
			end if;
				previous_crc <= current_crc;
		elsif(falling_edge(BusClock) AND counter = natural'low) then
			if(bus_toggle /= host_toggle) then
				bus_toggle <= host_toggle;
				if(host_send_crc) then
					data_falling_latch <= current_crc;
				else
					data_falling_latch <= host_data;
				end if;
			else
				data_falling_latch <= (others => '0');
			end if;
		end if;
	end process;



	process(HostClock)
	begin
		if(rising_edge(HostClock)) then
			host_toggle_ready <= false;

			--Inital Clock crossing for bus_toggle
			bus_toggle_buffer <= bus_toggle;
			
			--One shot to reset write ready 
			bus_toggle_buffer_old <= bus_toggle_buffer;
			if(bus_toggle_buffer /= bus_toggle_buffer_old) then
				Ready <= true;
			end if;

			if(Strobe AND Ready) then
				host_data <= Data;
				host_send_crc <= SendCRC;
				Ready <= false;
				host_toggle_ready <= true;
			end if;

			if(host_toggle_ready = true) then
				host_toggle <= not host_toggle;
			end if;
				
		end if;
	end process;

end architecture;
