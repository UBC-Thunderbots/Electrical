library ieee;
use ieee.std_logic_1164.all;

package crc16 is
	subtype crc16_t is std_ulogic_vector(15 downto 0);

	function CRC16(OldCRC : crc16_t; Data : std_ulogic_vector(7 downto 0)) return crc16_t;
end package crc16;

package body crc16 is
	function CRC16(OldCRC : crc16_t; Data : std_ulogic_vector(7 downto 0)) return crc16_t is
		variable C : std_ulogic_vector(15 downto 0);
		variable D : std_ulogic_vector(7 downto 0);
	begin
		C := OldCRC;
		D := Data;
		--data ^= crc;
		D := D xor C(7 downto 0);
		--data ^= data << 4;
		D := D xor (D(3 downto 0) & X"0");
		--crc = crc >> 8;
		C := X"00" & C(15 downto 8);
		--crc |= data << 8;
		C := C or (D & X"00");
		--crc ^= data << 3;
		C := C xor ("00000" & D & "000");
		--crc ^= data >> 4;
		C := C xor (X"000" & D(7 downto 4));
		return C;
	end function CRC16;
end package body crc16;
