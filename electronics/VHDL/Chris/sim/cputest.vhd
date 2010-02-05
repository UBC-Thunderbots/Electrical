library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity CPUTest is
end entity CPUTest;

architecture Behavioural of CPUTest is
	constant Code : ROMDataType := (
	--   OOOOOOAAAAABBBBB
		"0000110000000000", -- IN r0, 0
		"0000110000100001", -- IN r1, 1
		"0001010000100000", -- MUL r1, r0
		"0000000000000001", -- ADD r0, r1
		"0000000000000010", -- ADD r0, r2
		"0001100001000001", -- NEG r2, r1
		"0010100000100000", -- SHR32_2 r1, r0
		"0001110000001010", -- OUT 10, r0
		"0001110000101011", -- OUT 11, r1
		"0001110001001100", -- OUT 12, r2
		"0001000001000000", -- MOV r2, r0
		"0001100001100010", -- NEG r3, r2
		"0000010001000100", -- CLAMP r2, r4
		"0000010001100100", -- CLAMP r3, r4
		"0001110001001101", -- OUT 13, r2
		"0001110001101110", -- OUT 14, r3
		"0000010000000101", -- CLAMP r0, r5
		"0001110000001111", -- OUT 15, r0
		"0001100000000000", -- NEG r0, r0
		"0000010000000101", -- CLAMP r0, r5
		"0001110000010000", -- OUT 16, r0
		"0010000011000000", -- SEX r6, r0
		"0001110011010001", -- OUT 17, r6
		"0000100000000000", -- HALT
		"0000100000000000", -- HALT
		others => "0000000000000000"
	);
	constant Regs : RAMDataType := (
		to_signed(0, 16),
		to_signed(0, 16),
		to_signed(31, 16),
		to_signed(0, 16),
		to_signed(10000, 16),
		to_signed(30000, 16),
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
		to_signed(0, 16)
	);
	signal OutPorts : RAMDataType;
	signal Clock : std_ulogic := '0';
	signal Reset : std_ulogic := '1';
	signal IOAddress : unsigned(4 downto 0);
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

		assert IOWriteCount = 8;
		assert OutPorts(10) = to_signed(27656, 16);
		assert OutPorts(11) = to_signed(0, 16);
		assert OutPorts(12) = to_signed(-1, 16);
		assert OutPorts(13) = to_signed(10000, 16);
		assert OutPorts(14) = to_signed(-10000, 16);
		assert OutPorts(15) = to_signed(27656, 16);
		assert OutPorts(16) = to_signed(-27656, 16);
		assert OutPorts(17) = to_signed(-1, 16);

		Done <= true;
		wait;
	end process;
end architecture Behavioural;
