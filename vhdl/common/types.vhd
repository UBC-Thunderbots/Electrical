library ieee;
use ieee.std_logic_1164.all;

package types is
	type boolean_vector is array(integer range<>) of boolean;

	type byte_vector is array(integer range<>) of std_ulogic_vector(7 downto 0);
	
	subtype spi_word_t is std_ulogic_vector(7 downto 0);

	type spi_input_t is record
		ReadData : spi_word_t;
		ReadStrobe : boolean;
		ReadFirst : boolean;
		WriteReady : boolean;
	end record spi_input_t;

	type spi_output_t is record
		WriteData : spi_word_t;
		WriteStrobe : boolean;
		WriteCRC : boolean;
	end record spi_output_t;

	type spi_outputs_t is array(integer range<>) of spi_output_t;

	type encoders_pin_t is array(0 to 3) of std_ulogic_vector(0 to 1);

	type halls_pin_t is array(0 to 4) of std_ulogic_vector(0 to 2);

	type motors_phases_pin_t is array(0 to 4) of std_ulogic_vector(0 to 2);

	function spi_output_combine(Outputs : spi_outputs_t) return spi_output_t;

	function to_boolean(X : std_ulogic) return boolean;

	function to_stdulogic(X : boolean) return std_ulogic;
end package types;

package body types is
	function spi_output_combine(Outputs : spi_outputs_t) return spi_output_t is
		variable I : integer;
		variable Result : spi_output_t;
	begin
		Result.WriteData := X"00";
		Result.WriteStrobe := false;
		Result.WriteCRC := false;
		for I in Outputs'range loop
			if Outputs(I).WriteStrobe then
				Result.WriteData := Result.WriteData or Outputs(I).WriteData;
				Result.WriteStrobe := Result.WriteStrobe or Outputs(I).WriteStrobe;
				Result.WriteCRC := Result.WriteCRC or Outputs(I).WriteCRC;
			end if;
		end loop;
		return Result;
	end function spi_output_combine;

	function to_boolean(X : std_ulogic) return boolean is
	begin
		return X = '1';
	end function to_boolean;

	function to_stdulogic(X : boolean) return std_ulogic is
	begin
		if X then
			return '1';
		else
			return '0';
		end if;
	end function to_stdulogic;
end package body types;
