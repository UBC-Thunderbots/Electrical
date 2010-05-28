library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity CPUTest is
end entity CPUTest;

architecture Behavioural of CPUTest is
	constant Code : ROMDataType := (
	--   OOOOAAAAAABBBBBB
		"0011000000000000", -- IN r0, 0
		"0011000001000001", -- IN r1, 1
		"0101000001000000", -- MUL r1, r0
		"0000000000000001", -- ADD r0, r1
		"0000000000000010", -- ADD r0, r2
		"0110000010000001", -- NEG r2, r1
		"1010000001000000", -- SHR32_2 r1, r0
		"0111000000001010", -- OUT 10, r0
		"0111000001001011", -- OUT 11, r1
		"0111000010001100", -- OUT 12, r2
		"0100000010000000", -- MOV r2, r0
		"0110000011000010", -- NEG r3, r2
		"0001000010000100", -- CLAMP r2, r4
		"0001000011000100", -- CLAMP r3, r4
		"0111000010001101", -- OUT 13, r2
		"0111000011001110", -- OUT 14, r3
		"0001000000000101", -- CLAMP r0, r5
		"0111000000001111", -- OUT 15, r0
		"0110000000000000", -- NEG r0, r0
		"0001000000000101", -- CLAMP r0, r5
		"0111000000010000", -- OUT 16, r0
		"1000000110000000", -- SEX r6, r0
		"0111000110010001", -- OUT 17, r6
		"0000001001000111", -- ADD r9, r7
		"1100001010001000", -- ADDC r10, r8
		"0111001001010010", -- OUT 18, r9
		"1101001011000000", -- SKIPZ r11
		"0100001010001011", -- MOV r10, r11
		"0111001010010011", -- OUT 19, r10
		"1110001011001000", -- SMAG r11, r8
		"0111001011010100", -- OUT 20, r11
		"1110001011000111", -- SMAG r11, r7
		"0111001011010101", -- OUT 21, r11
		"0010000000000000", -- HALT
		"0010000000000000", -- HALT
		others => "0000000000000000"
	);
	constant Regs : RAMDataType := (
		to_signed(0, 16),     -- r0
		to_signed(0, 16),     -- r1
		to_signed(31, 16),    -- r2
		to_signed(0, 16),     -- r3
		to_signed(10000, 16), -- r4
		to_signed(30000, 16), -- r5
		to_signed(0, 16),     -- r6
		X"ABCD",              -- r7
		X"0001",              -- r8
		X"ABCD",              -- r9
		X"1234",              -- r10
		to_signed(0, 16),     -- r11
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16)
	);
	constant InPorts : RAMDataType := (
		to_signed(27, 16),
		to_signed(4096, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(0, 16)
	);
	signal OutPorts : RAMDataType;
	signal Clock : std_ulogic := '0';
	signal Reset : std_ulogic := '1';
	signal IOAddress : unsigned(5 downto 0);
	signal IOInData : signed(15 downto 0);
	signal IOOutData : signed(15 downto 0);
	signal IOWrite : std_ulogic;
	signal Done : boolean := false;
	constant ClockPeriod : time := 10 ns;
	signal IOWriteCount : natural := 0;
begin
	UUT : entity work.CPU(Behavioural)
	generic map(
		InitROM => Code,
		InitRAM => Regs
	)
	port map(
		Clock => Clock,
		Reset => Reset,
		ResetAddress => to_unsigned(0, 10),
		IOAddress => IOAddress,
		IOInData => IOInData,
		IOOutData => IOOutData,
		IOWrite => IOWrite
	);

	IOInData <= InPorts(to_integer(IOAddress));

	process
	begin
		wait for ClockPeriod / 4;
		Clock <= '1';
		if IOWrite = '1' then
			IOWriteCount <= IOWriteCount + 1;
			OutPorts(to_integer(IOAddress)) <= IOOutData;
		end if;
		wait for ClockPeriod / 2;
		Clock <= '0';
		wait for ClockPeriod / 4;
		if Done then
			wait;
		end if;
	end process;

	process
	begin
		wait for ClockPeriod * 2;
		Reset <= '0';
		wait for ClockPeriod * 1000;

		assert IOWriteCount = 12;
		assert OutPorts(10) = to_signed(27656, 16);
		assert OutPorts(11) = to_signed(0, 16);
		assert OutPorts(12) = to_signed(-1, 16);
		assert OutPorts(13) = to_signed(10000, 16);
		assert OutPorts(14) = to_signed(-10000, 16);
		assert OutPorts(15) = to_signed(27656, 16);
		assert OutPorts(16) = to_signed(-27656, 16);
		assert OutPorts(17) = to_signed(-1, 16);
		assert OutPorts(18) = X"579A";
		assert OutPorts(19) = X"1236";
		assert OutPorts(20) = X"0001";
		assert OutPorts(21) = (X"5433" or X"8000");

		Done <= true;
		wait;
	end process;
end architecture Behavioural;
