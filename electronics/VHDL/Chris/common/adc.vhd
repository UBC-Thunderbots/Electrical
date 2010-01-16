library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADC is
	port(
		Clock10 : in std_ulogic;

		SPICK : in std_ulogic;
		SPIDT : in std_ulogic;
		SPISS : in std_ulogic;

		VMon : out unsigned(9 downto 0) := to_unsigned(0, 10)
	);
end entity ADC;

architecture Behavioural of ADC is
	type StateType is (Idle, ReadingVMon);
	signal State : StateType := Idle;
	signal Bits : std_ulogic_vector(8 downto 0);
	signal BitsLeft : natural range 0 to 15;
	signal PrevSPICK : std_ulogic := '0';
begin
	process(Clock10)
		variable OK : boolean;
	begin
		if rising_edge(Clock10) then
			OK := SPICK = '1' and PrevSPICK = '0';
			PrevSPICK <= SPICK;
			if SPISS = '1' then
				State <= Idle;
			elsif State = Idle then
				State <= ReadingVMon;
				BitsLeft <= 15;
			elsif OK then
				if BitsLeft = 0 then
					if State = ReadingVMon then
						State <= Idle;
						VMon <= unsigned(Bits(8 downto 0) & SPIDT);
					end if;
					BitsLeft <= 15;
				else
					BitsLeft <= BitsLeft - 1;
				end if;
				Bits <= Bits(7 downto 0) & SPIDT;
			end if;
		end if;
	end process;
end architecture Behavioural;
