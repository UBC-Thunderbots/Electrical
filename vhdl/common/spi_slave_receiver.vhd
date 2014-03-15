library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity SPISlaveReceiver is
	generic(
		GENERATOR_POLYNOMIAL : natural := 16#07#; --Value of the generator polynomial in normal form
		RESET_VALUE : natural := 16#00#; --The value that the CRC should be reset to
		CRC_OK_VALUE : natural := 16#00#); --This is the value that the CRC when checked correct takes on.
	port(
		HostClock : in std_ulogic; --Clock used by consumers of the host data
		BusClock : in std_ulogic; --Clock provided by the SPI host

		CSLine : in std_ulogic; -- Chip Select line from the SPI bus
	
		Data : buffer WORD;
		Strobe : buffer boolean;
		CRCOk : buffer boolean;
		First : buffer boolean;

		MOSIPin : in std_ulogic);
end entity SPISlaveReceiver;


architecture RTL of SPISlaveReceiver is
	constant counter_reset : natural := WORD'length-1;
	constant CRC_COMPARE : WORD := std_ulogic_vector(to_unsigned(CRC_OK_VALUE,WORD'length));


	--HostClock domain
	signal host_toggle_buffer : boolean;
	signal host_toggle_old : boolean;

	--BusClock domain
	signal current_crc : WORD;
	signal previous_crc : WORD;
	signal crc_input : std_ulogic;

	signal counter : natural;
	signal receive_buffer : WORD;
	signal shifter : WORD;
	signal is_first_word : boolean;
	signal first_buffer : boolean;
	signal crc_ok : boolean;
	signal bus_toggle : boolean := false;

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
			is_first_word <= true;

		elsif(falling_edge(BusClock)) then

		--Receive section
			if(counter = natural'low) then
				counter <= counter_reset;
				receive_buffer <= shifter(WORD'length-2 downto 0)&MOSIpin;
				first_buffer <= is_first_word;
				is_first_word <= false;
				bus_toggle <= not bus_toggle;
			else
				counter <= counter-1;
				shifter <= shifter(WORD'length-2 downto 0)&MOSIpin;
			end if;
			
			previous_crc <= current_crc;
			crc_input <= MOSIpin;

		end if;
	end process;
	
	crc_ok <= (current_crc = CRC_COMPARE);

	process(HostClock)
	variable toggle_buffer : boolean; 
	begin
		--Receive signal clock domain crossing
		if(rising_edge(HostClock)) then
			host_toggle_buffer <= bus_toggle;
			host_toggle_old <= host_toggle_buffer;
			Strobe <= false;
			if(host_toggle_old /= host_toggle_buffer) then
				Data <= receive_buffer;
				CRCOk <= crc_ok;
				First <= first_buffer;
				Strobe <= true;
			end if;
		end if;
	end process;

end architecture;
