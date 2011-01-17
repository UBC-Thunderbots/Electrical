library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types;

entity ADC is
	port(
		Clock : in std_ulogic;
		Reset : in boolean;
		MISO : in boolean;
		CLK : out boolean;
		CS : out boolean;
		Level : out types.capacitor_voltage_t);
end entity ADC;

architecture Behavioural of ADC is
begin
	process(Clock) is
		subtype BitCountType is natural range 0 to 14;
		variable CLKTemp : boolean;
		variable CSTemp : boolean;
		variable BitCount : BitCountType;
		variable Data : std_ulogic_vector(11 downto 0);
	begin
		if rising_edge(Clock) then
			if Reset then
				CLKTemp := false;
				CSTemp := false;
				Level <= 0;
				BitCount := 0;
			else
				if not CSTemp then
					CSTemp := true;
				elsif not CLKTemp then
					CLKTemp := true;
				else
					CLKTemp := false;
					if MISO then
						Data := Data(10 downto 0) & '1';
					else
						Data := Data(10 downto 0) & '0';
					end if;
					if BitCount = BitCountType'high then
						BitCount := 0;
						CSTemp := false;
						Level <= to_integer(unsigned(Data));
					else
						BitCount := BitCount + 1;
					end if;
				end if;
			end if;
		end if;

		CLK <= CLKTemp;
		CS <= CSTemp;
	end process;
end architecture Behavioural;
