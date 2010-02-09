library ieee;
use IEEE.STD_LOGIC_1164.ALL;


entity LFSR_10bit is
    Port ( Reset	 : in STD_LOGIC;
	   CLK		: in STD_LOGIC;
	   Value_out : out  STD_LOGIC
	);	  
end LFSR_10bit;

architecture Behavioral of LFSR_10bit is
begin

	count_process: process(Reset,CLK)
		variable State : STD_LOGIC_VECTOR(9 downto 0) := "1111111111";
	begin
		if rising_edge(CLK) then
			if Reset = '1' then
				State := "1111111111";
			else
				State := (State(3) XOR State(0))&State(9 downto 1);
			end if;
		end if;
		
		Value_out <= State(0);
	end process;
end Behavioral;

