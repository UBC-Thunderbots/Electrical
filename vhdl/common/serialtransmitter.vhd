library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialTransmitter is
	port(
		Clock1 : in std_ulogic;

		Data : in std_ulogic_vector(7 downto 0);
		Load : in std_ulogic;
		Busy : out std_ulogic;

		Serial : out std_ulogic
	);
end entity SerialTransmitter;

architecture Behavioural of SerialTransmitter is
	signal DBuf : std_ulogic_vector(9 downto 0) := "1111111111";
	signal BitsRing : std_ulogic_vector(11 downto 0) := "000000000001";
	signal BitClocksRing : std_ulogic_vector(3 downto 0) := "0001";
begin
	Serial <= DBuf(0);
	Busy <= '1' when Load = '1' or BitsRing(0) = '0' else '0';

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if Load = '1' then
				DBuf <= Data & "01";
			elsif BitClocksRing(0) = '1' then
				DBuf <= "1" & DBuf(9 downto 1);
			end if;
			if Load = '1' or (BitClocksRing(0) = '1' and BitsRing(0) = '0') then
				BitsRing <= std_ulogic_vector(unsigned(BitsRing) rol 1);
			end if;
			BitClocksRing <= std_ulogic_vector(unsigned(BitClocksRing) rol 1);
		end if;
	end process;
end architecture Behavioural;
