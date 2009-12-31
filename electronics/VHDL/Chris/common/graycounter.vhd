library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GrayCounter is
	generic (
		Width : positive
	);
	port (
		Clock : in std_logic;

		A : in std_logic;
		B : in std_logic;

		Reset : in std_logic;
		Count : out signed(Width - 1 downto 0)
	);
end entity GrayCounter;

architecture Behavioural of GrayCounter is
	signal OldA : std_logic := '0';
	signal OldB : std_logic := '0';
	signal NewA : std_logic := '0';
	signal NewB : std_logic := '0';
	signal Acc : signed(Width - 1 downto 0) := to_signed(0, Width);
	signal State : std_logic_vector(3 downto 0) := "0000";
	signal NewCount : signed(Width - 1 downto 0) := to_signed(0, Width);
	signal NewAcc : signed(Width - 1 downto 0) := to_signed(0, Width);
begin
	State <= OldA & OldB & NewA & NewB;
	
	NewCount <=
		     Acc + 1 when State = "0010"
		else Acc + 1 when State = "1011"
		else Acc + 1 when State = "1101"
		else Acc + 1 when State = "0100"
		else Acc - 1 when State = "0001"
		else Acc - 1 when State = "0111"
		else Acc - 1 when State = "1110"
		else Acc - 1 when State = "1000"
		else Acc;
		
	Count <= NewCount;
	
	NewAcc <= to_signed(0, Width) when Reset = '1' else NewCount;
	
	process(Clock)
	begin
		if rising_edge(Clock) then
			Acc <= NewAcc;
			OldA <= NewA;
			OldB <= NewB;
			NewA <= A;
			NewB <= B;
		end if;
	end process;
end architecture Behavioural;
