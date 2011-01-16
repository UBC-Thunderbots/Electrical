library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADC is
	port(
		Clock : in std_ulogic;
		Reset : in boolean;
		MISO : in boolean;
		CLK : buffer boolean;
		CS : buffer boolean;
		Level : out natural range 0 to 4095);
end entity ADC;

architecture Behavioural of ADC is
begin
	process(Clock) is
		subtype BitCountType is natural range 0 to 14;
		variable BitCount : BitCountType;
		variable Data : std_ulogic_vector(11 downto 0);
	begin
		if rising_edge(Clock) then
			if Reset then
				CLK <= true;
				CS <= false;
				Level <= 0;
				BitCount := 0;
			else
				if not CS then
					CS <= true;
				elsif CLK then
					CLK <= false;
				else
					CLK <= true;
					if MISO then
						Data := Data(10 downto 0) & '1';
					else
						Data := Data(10 downto 0) & '0';
					end if;
					if BitCount = BitCountType'high then
						BitCount := 0;
						CS <= false;
						Level <= to_integer(unsigned(Data(11 downto 0)));
					else
						BitCount := BitCount + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
