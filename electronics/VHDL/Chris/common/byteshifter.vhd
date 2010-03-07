library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
-- Implements the equivalent of a shift register but that shifts whole bytes
-- instead of bits. The number of bytes in the register is given by a generic
-- parameter. At any point in time, OutData holds the topmost byte in the shift
-- register. Raising Strobe high causes the shift register to shift, with the
-- data presented on InData becoming the new bottom bytes of the register.
--
entity ByteShifter is
	generic(
		NumBytes : positive
	);
	port(
		Clock : in std_ulogic;

		InData : in std_ulogic_vector(7 downto 0);
		OutData : out std_ulogic_vector(7 downto 0);
		Strobe : in std_ulogic
	);
end entity ByteShifter;

architecture Behavioural of ByteShifter is
	type DataType is array(7 downto 0) of std_ulogic_vector(NumBytes - 1 downto 0);
	signal Data : DataType;
begin
	BitwiseCode : for I in 0 to 7 generate
	begin
		OutData(I) <= Data(I)(Data(I)'high);

		process(Clock)
		begin
			if rising_edge(Clock) then
				if Strobe = '1' then
					Data(I) <= Data(I)(Data(I)'high - 1 downto 0) & InData(I);
				end if;
			end if;
		end process;
	end generate;
end architecture Behavioural;
