library ieee;
use ieee.std_logic_1164.all;

package utils is
	function crc_step(PreviousCRC : std_ulogic_vector;GeneratorPolynomial: std_ulogic_vector; Input : std_ulogic) return std_ulogic_vector;

end package utils;

package body utils is
	function crc_step(PreviousCRC : std_ulogic_vector; GeneratorPolynomial: std_ulogic_vector; Input : std_ulogic  ) return std_ulogic_vector is
		variable Next_CRC : std_ulogic_vector(PreviousCRC'range);
		variable CarryBit : std_ulogic := Input xor PreviousCRC(PreviousCRC'high);
	begin
		Bit_Loop : for I in PreviousCRC'range loop
			if I = PreviousCRC'low then 
				Next_CRC(I) := CarryBit;
			else
				Next_CRC(I) := PreviousCRC(I-1) xor (CarryBit and GeneratorPolynomial(I));
			end if;
			end loop;
			return Next_CRC;
	end function;	
end package body utils;
