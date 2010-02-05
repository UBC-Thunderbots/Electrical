library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port(
		O : in unsigned(5 downto 0);
		RA : in signed(15 downto 0);
		RB : in signed(15 downto 0);
		CB : in unsigned(4 downto 0);

		NewRA : out signed(15 downto 0);
		NewRB : out signed(15 downto 0);

		IOAddress : out unsigned(4 downto 0) := to_unsigned(0, 5);
		IOInData : in signed(15 downto 0);
		IOOutData : out signed(15 downto 0);
		IOWrite : out std_ulogic;

		Halt : out std_ulogic
	);
end entity ALU;

architecture Behavioural of ALU is
	type NewRegValuesType is array(15 downto 0) of signed(15 downto 0);
	signal NewRAValues : NewRegValuesType;
	signal NewRBValues : NewRegValuesType;

	signal Product : signed(31 downto 0);
	signal ShiftIn : signed(31 downto 0);
	signal Shifted1 : signed(31 downto 0);
	signal Shifted2 : signed(31 downto 0);
	signal Shifted4 : signed(31 downto 0);
begin
	--
	-- We set NewR{A,B}Values to the new values for RA and RB, indexed by the O
	-- field.
	--

	-- O=0 means ADD.
	NewRAValues(0) <= RA + RB;
	NewRBValues(0) <= RB;
	-- O=1 means CLAMP.
	NewRAValues(1) <= RB when RA > RB
		else -RB when RA < -RB
		else RA;
	NewRBValues(1) <= RB;
	-- O=2 means HALT.
	NewRAValues(2) <= RA;
	NewRBValueS(2) <= RB;
	-- O=3 means IN.
	NewRAValues(3) <= IOInData;
	NewRBValues(3) <= RB;
	-- O=4 means MOV.
	NewRAValues(4) <= RB;
	NewRBValues(4) <= RB;
	-- O=5 means MUL.
	Product <= RA * RB;
	NewRAValues(5) <= Product(31 downto 16);
	NewRBValues(5) <= Product(15 downto 0);
	-- O=6 means NEG.
	NewRAValues(6) <= -RB;
	NewRBValues(6) <= RB;
	-- O=7 means OUT.
	NewRAValues(7) <= RA;
	NewRBValues(7) <= RB;
	-- O=8 means SEX.
	NewRAValues(8) <= (15 downto 0 => RB(15));
	NewRBValues(8) <= RB;
	-- O=9 means SHR32_1.
	ShiftIn <= RA & RB;
	Shifted1 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(ShiftIn)) sra 1));
	NewRAValues(9) <= Shifted1(31 downto 16);
	NewRBValues(9) <= Shifted1(15 downto 0);
	-- O=10 means SHR32_2.
	Shifted2 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(ShiftIn)) sra 2));
	NewRAValues(10) <= Shifted2(31 downto 16);
	NewRBValues(10) <= Shifted2(15 downto 0);
	-- O=11 means SHR32_4.
	Shifted4 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(ShiftIn)) sra 4));
	NewRAValues(11) <= Shifted4(31 downto 16);
	NewRBValues(11) <= Shifted4(15 downto 0);

	-- Select the appropriate new values.
	NewRA <= NewRAValues(to_integer(O(3 downto 0)));
	NewRB <= NewRBValues(to_integer(O(3 downto 0)));



	-- IOAddress is CB for IN and OUT, irrelevant for others.
	IOAddress <= CB;
	-- IOOutData is RA for OUT, irrelevant for others.
	IOOutData <= RA;
	-- IOWrite is 1 for OUT, 0 for others.
	IOWrite <= '1' when O = 7 else '0';



	-- Halt when we see a HALT instruction.
	Halt <= '1' when O = 2 else '0';
end architecture Behavioural;
