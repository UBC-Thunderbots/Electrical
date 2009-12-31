library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialTransmitter is
	port(
		Clock : in std_logic;

		Data : in std_logic_vector(7 downto 0);
		Load : in std_logic;
		Busy : out std_logic;

		Serial : out std_logic
	);
end entity SerialTransmitter;

architecture Behavioural of SerialTransmitter is
	signal DBuf : std_logic_vector(8 downto 0) := "111111111";
	signal Bits : natural range 0 to 10 := 0;
	signal BitClocks : natural range 0 to 199 := 0;
begin
	Serial <= DBuf(0);
	Busy <= '1' when Bits /= 0 else '0';

	process(Clock)
	begin
		if rising_edge(Clock) then
			if Load = '1' then
				DBuf <= Data & "0";
				Bits <= 10;
				BitClocks <= 199;
			else
				if BitClocks /= 0 then
					BitClocks <= BitClocks - 1;
				elsif Bits /= 0 then
					Bits <= Bits - 1;
					BitClocks <= 199;
					DBuf <= "1" & DBuf(8 downto 1);
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
