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
	OutData(0) <= Data(0)(Data(0)'high);
	OutData(1) <= Data(1)(Data(1)'high);
	OutData(2) <= Data(2)(Data(2)'high);
	OutData(3) <= Data(3)(Data(3)'high);
	OutData(4) <= Data(4)(Data(4)'high);
	OutData(5) <= Data(5)(Data(5)'high);
	OutData(6) <= Data(6)(Data(6)'high);
	OutData(7) <= Data(7)(Data(7)'high);

	process(Clock)
	begin
		if rising_edge(Clock) then
			if Strobe = '1' then
				Data(0) <= Data(0)(Data(0)'high - 1 downto 0) & InData(0);
				Data(1) <= Data(1)(Data(1)'high - 1 downto 0) & InData(1);
				Data(2) <= Data(2)(Data(2)'high - 1 downto 0) & InData(2);
				Data(3) <= Data(3)(Data(3)'high - 1 downto 0) & InData(3);
				Data(4) <= Data(4)(Data(4)'high - 1 downto 0) & InData(4);
				Data(5) <= Data(5)(Data(5)'high - 1 downto 0) & InData(5);
				Data(6) <= Data(6)(Data(6)'high - 1 downto 0) & InData(6);
				Data(7) <= Data(7)(Data(7)'high - 1 downto 0) & InData(7);
			end if;
		end if;
	end process;
end architecture Behavioural;
