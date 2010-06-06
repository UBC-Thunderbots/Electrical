library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADC is
	port(
		Clock10 : in std_ulogic;

		SPICK : in std_ulogic;
		SPIDT : in std_ulogic;
		SPISS : in std_ulogic;

		VMon : out unsigned(9 downto 0) := to_unsigned(0, 10);
		Chicker0 : out boolean := true;
		Chicker110 : out boolean := false;
		Chicker150 : out boolean := false
	);
end entity ADC;

architecture Behavioural of ADC is
	signal Bits : std_ulogic_vector(12 downto 0);
	signal PrevSPICK : std_ulogic := '0';
begin
	process(Clock10)
	begin
		if rising_edge(Clock10) then
			if SPISS = '1' then
				VMon <= unsigned(Bits(VMon'high downto 0));
				Chicker0 <= Bits(VMon'high + 1) = '1';
				Chicker110 <= Bits(VMon'high + 2) = '1';
				Chicker150 <= Bits(VMon'high + 3) = '1';
			elsif SPICK = '1' and PrevSPICK = '0' then
				Bits <= Bits(Bits'high - 1 downto 0) & SPIDT;
			end if;
			PrevSPICK <= SPICK;
		end if;
	end process;
end architecture Behavioural;
