library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

--
-- A basic CPU. This CPU must be hooked up to some I/O ports to do anything
-- useful.
--
-- Generics:
--  InitROM
--   The list of instructions to store in the code ROM for this CPU to execute.
--  InitRAM
--   The initial contents of the register file for this CPU.
--
-- Ports:
--  Clock
--   The clock that runs the CPU.
--  Reset
--   Set to 1 to hold the CPU in reset.
--   Set to 0 to run code.
--  ResetAddress
--   When Reset=1, this address is loaded into the program counter.
--  IOAddress
--   The address of the I/O port currently being read or written.
--  IOInData
--   The data on the read half of the addressed I/O port.
--  IOOutData
--   The data to write to the write half of the addressed I/O port.
--  IOWrite
--   Set to 1 when writing to an I/O port.
--   Set to 0 when not writing.
--
-- Instruction Encoding:
--  Each instruction is 16 bits wide and encoded as follows:
--   6 bits - opcode (written as "O")
--   5 bits - register A (written as "RA")
--   5 bits - register B or constant (written as "RB" or "CB")
--
-- Register File:
--  The register file contains 32 registers, each 16 bits wide. All registers
--  are exactly equivalent in functionality.
--
-- Instruction Set:
--  ADDS RA RB (O=000000) - Add with Saturation
--   Adds the values of RA and RB. The result is clamped to the range +/-65535
--   and stored into RA.
--
--  CLAMP RA RB (O=000001) - Clamp to Interval
--   Clamps the value of RA to fall within +/-RB. The result is stored into RA.
--
--  HALT (O=000010) - Halt CPU
--   Stops executing instructions.
--
--  IN RA CB (O=000011) - Read from Input Port
--   Reads a value from external input port CB, storing the value into RA.
--
--  MOV RA RB (O=000100) - Move value between registers
--   Stores the value of RB into RA.
--
--  MUL RA RB (O=000101) - Multiply
--   Multiplies together the values of RA and RB, storing the high word of the
--   result in RA and the low word in RB.
--
--  NEG RA RB (O=000110) - Negate
--   Takes the two's-complement negation of RB, storing the result in RA.
--
--  OUT CB RA (O=000111) - Write to Output Port
--   Writes the value of RA to external output port CB.
--
--  SEX RA RB (O=001000) - Sign Extend
--   Copies the top bit of RB into all bits of RA, thus sign extending the
--   16-bit value in RB into a 32-bit value in RA:RB.
--
--  SHR32_1 RA RB (O=001001) - Shift Right 1 Bit
--   Shifts the 32-bit value whose high word is RA and whose low word is RB
--   right, with sign propagation, by 1 bit, storing the high word of the result
--   into RA and the low word of the result into RB.
--
--  SHR32_2 RA RB (O=001010) - Shift Right 2 Bits
--   Shifts the 32-bit value whose high word is RA and whose low word is RB
--   right, with sign propagation, by 2 bits, storing the high word of the
--   result into RA and the low word of the result into RB.
--
--  SHR32_4 RA RB (O=001011) - Shift Right 4 Bits
--   Shifts the 32-bit value whose high word is RA and whose low word is RB
--   right, with sign propagation, by 2 bits, storing the high word of the
--   result into RA and the low word of the result into RB.
--
entity CPU is
	generic(
		InitROM : ROMDataType;
		InitRAM : RAMDataType
	);
	port(
		Clock : in std_ulogic;

		Reset : in std_ulogic;
		ResetAddress : in unsigned(9 downto 0);

		IOAddress : out unsigned(4 downto 0);
		IOInData : in signed(15 downto 0);
		IOOutData : out signed(15 downto 0);
		IOWrite : out std_ulogic := '0'
	);
end entity CPU;

architecture Behavioural of CPU is
	type StateType is (Halted, Decoding, Executing);
	signal State : StateType := Halted;
	signal PC : unsigned(9 downto 0) := to_unsigned(0, 10);
	signal Instruction : std_ulogic_vector(15 downto 0) := "0000100000000000";
	signal ROMData : ROMDataType := InitROM;
	shared variable RAMData : RAMDataType := InitRAM;
	signal RA : signed(15 downto 0) := to_signed(0, 16);
	signal RB : signed(15 downto 0) := to_signed(0, 16);
	signal NewRA : signed(15 downto 0);
	signal NewRB : signed(15 downto 0);
	signal ALUIOWrite : std_ulogic;
	signal Halt : std_ulogic;
begin
	ALUInstance : entity work.ALU(Behavioural)
	port map(
		O => unsigned(Instruction(15 downto 10)),
		RA => RA,
		RB => RB,
		CB => unsigned(Instruction(4 downto 0)),
		NewRA => NewRA,
		NewRB => NewRB,
		IOAddress => IOAddress,
		IOInData => IOInData,
		IOOutData => IOOutData,
		IOWrite => ALUIOWrite,
		Halt => Halt
	);

	IOWrite <= '1' when ALUIOWrite = '1' and State = Executing else '0';

	process(Clock)
		variable LoadInstruction : boolean;
		variable ROMAddress : unsigned(9 downto 0);
	begin
		if rising_edge(Clock) then
			LoadInstruction := false;
			ROMAddress := to_unsigned(0, 10);
			if Reset = '1' then
				State <= Decoding;
				PC <= ResetAddress;
				LoadInstruction := true;
				ROMAddress := ResetAddress;
			elsif State = Decoding then
				State <= Executing;
				PC <= PC + 1;
			elsif State = Executing then
				if Halt = '1' then
					State <= Halted;
				else
					State <= Decoding;
				end if;
				LoadInstruction := true;
				ROMAddress := PC;
			end if;

			if LoadInstruction then
				Instruction <= ROMData(to_integer(ROMAddress));
			end if;
		end if;
	end process;

	process(Clock)
		variable Address : natural range 0 to 31;
		variable Enable : boolean;
		variable Write : boolean;
	begin
		if rising_edge(Clock) then
			Address := to_integer(unsigned(Instruction(9 downto 5)));
			Enable := false;
			Write := false;
			if State = Decoding then
				Enable := true;
			elsif State = Executing then
				Enable := true;
				Write := true;
			end if;

			if Enable then
				RA <= RAMData(Address);
				if Write then
					RAMData(Address) := NewRA;
				end if;
			end if;
		end if;
	end process;

	process(Clock)
		variable Address : natural range 0 to 31;
		variable OtherAddress : natural range 0 to 31;
		variable Enable : boolean;
		variable Write : boolean;
	begin
		if rising_edge(Clock) then
			Address := to_integer(unsigned(Instruction(4 downto 0)));
			OtherAddress := to_integer(unsigned(Instruction(9 downto 5)));
			Enable := false;
			Write := false;
			if State = Decoding then
				Enable := true;
			elsif State = Executing and Address /= OtherAddress then
				Enable := true;
				Write := true;
			end if;

			if Enable then
				RB <= RAMData(Address);
				if Write then
					RAMData(Address) := NewRB;
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
