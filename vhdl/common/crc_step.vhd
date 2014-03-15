library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CRCStep is 
	generic(
		BUS_WIDTH : positive := 8;
		GENERATOR_POLYNOMIAL : natural := 16#07#);
	port(
		PreviousCRC : in std_ulogic_vector(BUS_WIDTH-1 downto 0);
		Input : in std_ulogic;
		NextCRC : buffer std_ulogic_vector(BUS_WIDTH-1 downto 0)
		);
end entity CRCStep;

architecture RTL of CRCStep is
	subtype WORD is std_ulogic_vector(BUS_WIDTH-1 downto 0);
	constant GENERATOR_POLY : WORD := std_ulogic_vector(to_unsigned(GENERATOR_POLYNOMIAL,WORD'length));

	function CRC_STEP(Previous_CRC : WORD; Generator_Polynomial: WORD; Input : std_ulogic  ) return WORD is
		variable Next_CRC : WORD;
		variable CarryBit : std_ulogic := Input xor Previous_CRC(WORD'high);
	begin
		Bit_Loop : for I in WORD'range loop
			if I = WORD'low then 
				Next_CRC(I) := CarryBit;
			else
				Next_CRC(I) := Previous_CRC(I-1) xor (CarryBit and Generator_Polynomial(I));
			end if;
			end loop;
			return Next_CRC;
	end function;
begin

	NextCRC <= CRC_STEP(PreviousCRC, GENERATOR_POLY, Input);

end architecture;
