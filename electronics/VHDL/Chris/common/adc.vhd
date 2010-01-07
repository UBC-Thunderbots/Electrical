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
	type StateType is (Idle, Channel0, Channel1, Channel2, Channel3, Channel4, Channel5, Channel6, Channel7, Channel8, Channel9, Channel10, Channel11, Channel12);
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
				State <= Channel0;
				BitsLeft <= 15;
			elsif OK then
				if BitsLeft = 0 then
					if State = Channel0 then
						State <= Channel1;
					elsif State = Channel1 then
						State <= Channel2;
					elsif State = Channel2 then
						State <= Channel3;
					elsif State = Channel3 then
						State <= Channel4;
					elsif State = Channel4 then
						State <= Channel5;
					elsif State = Channel5 then
						State <= Channel6;
					elsif State = Channel6 then
						State <= Channel7;
					elsif State = Channel7 then
						State <= Channel8;
					elsif State = Channel8 then
						State <= Channel9;
					elsif State = Channel9 then
						State <= Channel10;
					elsif State = Channel10 then
						State <= Channel11;
					elsif State = Channel11 then
						State <= Channel12;
					elsif State = Channel12 then
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
