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
	signal Product : signed(31 downto 0);
	signal Shifted1 : signed(31 downto 0);
	signal Shifted2 : signed(31 downto 0);
	signal Shifted4 : signed(31 downto 0);
begin
	Product <= RA * RB;
	Shifted1 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(signed'(RA & RB))) sra 1));
	Shifted2 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(signed'(RA & RB))) sra 2));
	Shifted4 <= signed(to_stdulogicvector(to_bitvector(std_ulogic_vector(signed'(RA & RB))) sra 4));

	process(O, RA, RB, CB, IOInData, Product, Shifted1, Shifted2, Shifted4)
		variable Opcode : natural range 0 to 15;
	begin
		Opcode := to_integer(O(3 downto 0));
		NewRA <= RA;
		NewRB <= RB;
		IOAddress <= CB;
		IOOutData <= RA;
		IOWrite <= '0';
		Halt <= '0';
		if Opcode = 0 then
			-- ADD
			NewRA <= RA + RB;
		elsif Opcode = 1 then
			-- CLAMP
			if RA > RB then
				NewRA <= RB;
			elsif RA < -RB then
				NewRA <= -RB;
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
			NewRA <= -RB;
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
		end if;
	end process;
end architecture Behavioural;
