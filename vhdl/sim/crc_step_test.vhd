library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.utils.all;
use work.types.all;

entity crc_step_test is
end entity;

architecture Behavioural of crc_step_test is

	type data_vector_t is array(0 to 15) of spi_word_t;
	constant CRCData : data_vector_t := (X"13", X"5E", X"00", X"32", X"5B", X"5A", X"A3", X"B0", X"7F", X"FF", X"FF", X"80", X"0A", X"80", X"00", X"1D");
	constant GEN_POLY : spi_word_t := x"07";

	function process_word(Previous : std_ulogic_vector; Poly : std_ulogic_vector; input : std_ulogic_vector) return std_ulogic_vector is
		variable carry_crc : std_ulogic_vector(Previous'range);
	begin
			carry_crc := Previous;
			for I in input'range loop
				carry_crc := crc_step(carry_crc,Poly,input(I));
			end loop;
			return carry_crc;
	end function;

begin

impl: process
				variable current_crc : spi_word_t;
				variable current_byte : spi_word_t;
				variable output : line;
			begin	
				current_crc := x"00";
				for I in data_vector_t'range loop
					current_crc := process_word(current_crc,GEN_POLY,CRCData(I));
					report integer'image(to_integer(unsigned(current_crc)));
				end loop;
				current_crc := process_word(current_crc,GEN_POLY,current_crc);
				report integer'image(to_integer(unsigned(current_crc)));
				assert current_crc = x"00";
				wait;
			end process;

end architecture Behavioural;
