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

		Halt : out std_ulogic;

		CarryIn : in std_ulogic;
		CarryOut : out std_ulogic
	);
end entity ALU;

architecture Behavioural of ALU is
	signal Product : signed(31 downto 0);
	signal Shifted1 : signed(31 downto 0);
	signal Shifted2 : signed(31 downto 0);
	signal Shifted4 : signed(31 downto 0);
	signal Addend1 : signed(15 downto 0) := to_signed(0, 16);
	signal Addend2 : signed(15 downto 0) := to_signed(0, 16);
	signal AddendC : natural range 0 to 1 := 0;
	signal Sum : std_ulogic_vector(16 downto 0);
begin
	Product <= RA * RB;
	Shifted1 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(signed'(RA & RB))) sra 1));
	Shifted2 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(signed'(RA & RB))) sra 2));
	Shifted4 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(signed'(RA & RB))) sra 4));
	Sum <= std_ulogic_vector(to_unsigned(to_integer(unsigned(std_ulogic_vector(Addend1))) + to_integer(unsigned(std_ulogic_vector(Addend2))) + AddendC, 17));

	process(O, RA, RB, CB, IOInData, CarryIn, Product, Shifted1, Shifted2, Shifted4, Sum)
		variable Opcode : natural range 0 to 15;
	begin
		Opcode := to_integer(O(3 downto 0));
		NewRA <= RA;
		NewRB <= RB;
		IOAddress <= CB;
		IOOutData <= RA;
		IOWrite <= '0';
		Halt <= '0';
		CarryOut <= CarryIn;
		Addend1 <= RA;
		Addend2 <= RB;
		AddendC <= 0;
		if Opcode = 0 then
			-- ADD
			NewRA <= signed(Sum(15 downto 0));
			CarryOut <= Sum(16);
		elsif Opcode = 1 then
			-- CLAMP
			Addend1 <= to_signed(1, 16);
			Addend2 <= not RB;
			if RA > RB then
				NewRA <= RB;
			elsif RA < signed(Sum(15 downto 0)) then
				NewRA <= signed(Sum(15 downto 0));
			end if;
		elsif Opcode = 2 then
			-- HALT
			Halt <= '1';
		elsif Opcode = 3 then
			-- IN
			NewRA <= IOInData;
		elsif Opcode = 4 then
			-- MOV
			NewRA <= RB;
		elsif Opcode = 5 then
			-- MUL
			NewRA <= Product(31 downto 16);
			NewRB <= Product(15 downto 0);
		elsif Opcode = 6 then
			-- NEG
			Addend1 <= to_signed(1, 16);
			Addend2 <= not RB;
			NewRA <= signed(Sum(15 downto 0));
		elsif Opcode = 7 then
			-- OUT
			IOWrite <= '1';
		elsif Opcode = 8 then
			-- SEX
			NewRA <= (15 downto 0 => RB(15));
		elsif Opcode = 9 then
			-- SHR32_1
			NewRA <= Shifted1(31 downto 16);
			NewRB <= Shifted1(15 downto 0);
		elsif Opcode = 10 then
			-- SHR32_2
			NewRA <= Shifted2(31 downto 16);
			NewRB <= Shifted2(15 downto 0);
		elsif Opcode = 11 then
			-- SHR32_4
			NewRA <= Shifted4(31 downto 16);
			NewRB <= Shifted4(15 downto 0);
		elsif Opcode = 12 then
			-- ADDC
			if CarryIn = '1' then
				AddendC <= 1;
			end if;
			NewRA <= signed(Sum(15 downto 0));
			CarryOut <= Sum(16);
		end if;
	end process;
end architecture Behavioural;
