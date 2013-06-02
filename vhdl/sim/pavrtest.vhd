library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity PAVRTest is
end entity;

architecture Behavioural of PAVRTest is
	constant ClockTime : time := 1 us;
	constant ClockTimeSecs : real := real(ClockTime / 1 ns) * 1.0e-9;

	constant InputsInitial : work.types.cpu_inputs_t := (
		Ticks => 0,
		InterlockOverride => false,
		BreakoutPresent => false,
		HallsStuckHigh => (others => false),
		HallsStuckLow => (others => false),
		EncodersCount => (others => 0),
		EncodersFail => (others => false),
		MCP3008 => (others => (Value => 0, Strobe => false)),
		LaserDiff => 0,
		ChickerPresent => false,
		ChargeDone => false,
		ChargeTimeout => false,
		KickActive => false,
		ChipActive => false,
		FlashBusy => false,
		FlashDataRead => X"00",
		MRFInterrupt => '1',
		MRFBusy => false,
		MRFDataRead => X"00",
		SDBusy =>  false,
		SDPresent => false,
		SDDataRead => X"00",
		SDDRTCRCError => false,
		SDDRTWriteError => false,
		SDDRTUnknownError => false,
		DeviceID => (others => '0'),
		DeviceIDReady => true,
		LFSRBit => '0',
		DebugBusy => false,
		ICAPBusy => false,
		DMA => (others => (Pointer => 0, Count => 0, Enabled => false)));

	signal Done : boolean := false;
	signal Clock : std_ulogic := '1';
	signal Reset : std_ulogic := '0';
	signal PMAddressU : std_ulogic_vector(21 downto 0) := (others => '0');
	subtype pm_address_t is natural range 0 to 2 ** 14 - 1;
	signal PMData : std_ulogic_vector(15 downto 0) := X"0000";
	signal DMAWrite : std_ulogic := '0';
	signal DMAAddress : std_ulogic_vector(11 downto 0) := X"000";
	signal DMADataWrite : std_ulogic_vector(7 downto 0) := X"00";
	signal DMADataRead : std_ulogic_vector(7 downto 0);
	signal Inputs : work.types.cpu_inputs_t;
	signal Outputs : work.types.cpu_outputs_t;

	type program_memory_t is array(pm_address_t'low to pm_address_t'high) of std_ulogic_vector(15 downto 0);
	signal ProgramMemory : program_memory_t := (others => X"0000");

	procedure RunTestCase(constant TestCase : in natural; constant Ticks : in natural; signal Reset : out std_ulogic; variable AnyFailed : inout boolean) is
	begin
		Reset <= '1';
		wait for 4 * ClockTime;
		assert Outputs.SimMagic = X"00" report "Magic port not properly reset." severity failure;
		Reset <= '0';
		wait for Ticks * ClockTime;
		if Outputs.SimMagic /= X"5A" then
			report "Test case " & natural'image(TestCase) & " failed, expected 90, got " & natural'image(to_integer(unsigned(Outputs.SimMagic))) & "." severity error;
			AnyFailed := true;
		end if;
	end procedure RunTestCase;
begin
	-- Instantiate the pAVR.
	UUT: entity work.pavr(pavr_arch)
	port map(
		pavr_clk => Clock,
		pavr_res => Reset,
		pavr_syncres => Reset,
		std_ulogic_vector(pavr_pm_addr) => PMAddressU,
		pavr_pm_do => std_logic_vector(PMData),
		pavr_pm_wr => open,
		pavr_dma_wr => DMAWrite,
		pavr_dma_addr => std_logic_vector(DMAAddress),
		pavr_dma_di => std_logic_vector(DMADataWrite),
		std_ulogic_vector(pavr_dma_do) => DMADataRead,
		Inputs => Inputs,
		Outputs => Outputs,
		pavr_inc_instr_cnt => open);

	-- Generate a clock.
	process is
	begin
		Clock <= '1';
		wait for ClockTime / 2.0;
		Clock <= '0';
		wait for ClockTime / 2.0;
		
		if Done then
			wait;
		end if;
	end process;

	-- Handle program memory.
	process(Clock) is
	begin
		if rising_edge(Clock) then
			PMData <= ProgramMemory(to_integer(unsigned(PMAddressU)));
		end if;
	end process;

	-- Run the tests.
	process is
		variable AnyFailed : boolean := false;
	begin
		-- Wait a clock cycle before asserting reset.
		wait until rising_edge(Clock);

		-- The idea behind these test cases is simple:
		-- 1. Load some code into ProgramMemory.
		-- 2. Hold the CPU in reset for 4 clock cycles.
		-- 3. Release reset and run the CPU for a specified number of clock cycles.
		-- 4. The code should have, through some more or less convoluted means, ended up writing the value 0x5A into I/O port number 7.

		-- Test #1
		-- Load a literal into a register, write it to an I/O port, and die.
		-- Include enough NOPs that the register file is used directly by the OUT.
		ProgramMemory <= (
			X"E50A", -- LDI r16, 0x5A
			X"0000", -- NOP
			X"0000", -- NOP
			X"0000", -- NOP
			X"0000", -- NOP
			X"0000", -- NOP
			X"B907", -- OUT 0x07, r16
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(1, 40, Reset, AnyFailed);

		-- Test #2
		-- Load a literal into a register, write it to an I/O port, and die.
		-- Do the OUT immediately so the bypass unit must be used to forward the register value.
		ProgramMemory <= (
			X"E50A", -- LDI r16, 0x5A
			X"B907", -- OUT 0x07, r16
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(2, 40, Reset, AnyFailed);

		-- Test #3
		-- Use SBI to hit the I/O port, and die.
		ProgramMemory <= (
			X"9A39", -- SBI 0x07, 1
			X"9A3B", -- SBI 0x07, 3
			X"9A3C", -- SBI 0x07, 4
			X"9A3E", -- SBI 0x07, 6
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(3, 40, Reset, AnyFailed);

		-- Test #4
		-- Use LPM to read a byte from program memory, then send it to the I/O port, and die.
		ProgramMemory <= (
			X"E0F0", -- LDI r31, 0x00
			X"E1E3", -- LDI r30, 0x13
			X"9024", -- LPM r2, Z
			X"0000", -- NOP
			X"0000", -- NOP
			X"0000", -- NOP
			X"0000", -- NOP
			X"B827", -- OUT 0x07, r2
			X"CFFF", -- RJMP .-2
			X"5A00", -- .word 0x5A00
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(4, 40, Reset, AnyFailed);

		-- Test #5
		-- Same as test #4, but with NOPs removed so the LPM result is used from the bypass unit.
		ProgramMemory <= (
			X"E0F0", -- LDI r31, 0x00
			X"E0EB", -- LDI r30, 0x0B
			X"9024", -- LPM r2, Z
			X"B827", -- OUT 0x07, r2
			X"CFFF", -- RJMP .-2
			X"5A00", -- .word 0x5A00
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(5, 40, Reset, AnyFailed);

		-- Test #6
		-- Use postincrementing LPM for its side effect of modifying r30 to the magic value we want to see.
		ProgramMemory <= (
			X"E5E9", -- LDI r30, 0x59
			X"9025", -- LPM r2, Z+
			X"0000", -- NOP
			X"0000", -- NOP
			X"0000", -- NOP
			X"0000", -- NOP
			X"B9E7", -- OUT 0x07, r30
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(6, 40, Reset, AnyFailed);

		-- Test #7
		-- Same as test #6, but with NOPs removed so the modified Z is used from the bypass unit.
		ProgramMemory <= (
			X"E5E9", -- LDI r30, 0x59
			X"9025", -- LPM r2, Z+
			X"B9E7", -- OUT 0x07, r30
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(7, 40, Reset, AnyFailed);

		-- Test #8
		-- Do a pair of LPMs, the first of which postincrements Z and the second of which reads the byte we care about.
		ProgramMemory <= (
			X"E0F0", -- LDI r31, 0x00
			X"E0EC", -- LDI r30, 0x0C
			X"9005", -- LPM r0, Z+
			X"9004", -- LPM r0, Z
			X"B807", -- OUT 0x07, r0
			X"CFFF", -- RJMP .-2
			X"5A00", -- .word 0x5A00
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(8, 40, Reset, AnyFailed);

		-- Test #9
		-- Same as test #8, but with the postincrement straddling a word boundary.
		ProgramMemory <= (
			X"E0F0", -- LDI r31, 0x00
			X"E0EB", -- LDI r30, 0x0B
			X"9005", -- LPM r0, Z+
			X"9004", -- LPM r0, Z
			X"B807", -- OUT 0x07, r0
			X"CFFF", -- RJMP .-2
			X"005A", -- .word 0x005A
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(9, 40, Reset, AnyFailed);

		-- Test #10
		-- Do an LD Rd, -Z, which predecrements Z to the value we care about.
		ProgramMemory <= (
			X"E5EB", -- LDI r30, 0x5B
			X"9002", -- LD r0, -Z
			X"B9E7", -- OUT 0x07, r30
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(10, 40, Reset, AnyFailed);

		-- Test #11
		-- Do an RCALL .+0; PUSH which is used to adjust the stack pointer sometimes.
		ProgramMemory <= (
			X"E500", -- ldi	r16, 0x50	; 80
			X"BF0E", -- out	0x3e, r16	; 62
			X"E00E", -- ldi	r16, 0x0E	; 14
			X"BF0D", -- out	0x3d, r16	; 61
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"D000", -- rcall	.+0      	;  0x14
			X"920F", -- push	r0
			X"B7ED", -- in	r30, 0x3d	; 61
			X"B7FE", -- in	r31, 0x3e	; 62
			X"27EF", -- eor	r30, r31
			X"B9E7", -- out	0x07, r30	; 7
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		RunTestCase(11, 40, Reset, AnyFailed);

		-- Test #12
		-- Test skipping SBIC followed by STS
		ProgramMemory <= (
			X"ea05", -- ldi	r16, 0xA5	; 0
			X"9300", -- sts 0x0100, r16
			X"0100", -- <second half of 16-bit insn>
			X"e000", -- ldi	r16, 0x00	; 0
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"99c7", -- sbic	0x18, 7	; 24
			X"650a", -- ori	r16, 0x5A	; 90
			X"99c6", -- sbic	0x18, 6	; 24
			X"6f0f", -- ori	r16, 0xFF	; 255
			X"9300", -- sts 0x0100, r16
			X"0100", -- <second half of 16-bit insn>
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"9130", -- lds r19, 0x0100
			X"0100", -- <second half of 16-bit insn>
			X"b937", -- out 0x07, r19	; 7
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		Inputs.DeviceID(7 downto 0) <= X"80";
		RunTestCase(12, 40, Reset, AnyFailed);

		-- Test #13
		-- Test skipping SBIC followed by MOV
		ProgramMemory <= (
			X"e50a", -- ldi	r16, 0x5A	; 90
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"99c0", -- sbic	0x18, 0	; 24
			X"6f0f", -- ori	r16, 0xFF	; 255
			X"2f10", -- mov	r17, r16
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"b917", -- out	0x07, r17	; 7
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		Inputs.DeviceID(7 downto 0) <= X"80";
		RunTestCase(13, 40, Reset, AnyFailed);

		-- Test #14
		-- Test skipping SBIC followed by a sled of INCs to ensure no instruction is being duplicated
		ProgramMemory <= (
			X"e506", -- ldi	r16, 0x56	; 86
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"99c0", -- sbic	0x18, 0	; 24
			X"6f0f", -- ori	r16, 0xFF	; 255
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"b907", -- out	0x07, r16	; 7
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		Inputs.DeviceID(7 downto 0) <= X"80";
		RunTestCase(14, 40, Reset, AnyFailed);

		-- Test #15
		-- Test skipping SBIC jumping over a 32-bit STS, making sure it does not accidentally execute the second half of the skipped instruction and DOES execute all and only those following
		ProgramMemory <= (
			X"e506", -- ldi	r16, 0x56	; 88
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"99c0", -- sbic	0x18, 0	; 24
			X"9300", -- sts	0xE000, r16
			X"e000", -- second half of sts, which if executed would be ldi r16, 0x00
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"b907", -- out	0x07, r16	; 7
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		Inputs.DeviceID(7 downto 0) <= X"80";
		RunTestCase(15, 40, Reset, AnyFailed);

		-- Test #16
		-- Test skipping SBRC jumping over a 32-bit STS, making sure it does not accidentally execute the second half of the skipped instruction and DOES execute all and only those following
		ProgramMemory <= (
			X"e506", -- ldi	r16, 0x56	; 88
			X"e010", -- ldi	r17, 0x00	; 0
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"fd10", -- sbrc	r17, 0
			X"9300", -- sts	0xE000, r16
			X"e000", -- second half of sts, which if executed would be ldi r16, 0x00
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"9503", -- inc	r16
			X"b907", -- out	0x07, r16	; 7
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		Inputs.DeviceID(7 downto 0) <= X"80";
		RunTestCase(16, 40, Reset, AnyFailed);

		-- Test #17
		-- Test that skipping an instruction does not affect a following instruction when they both write to the same register
		ProgramMemory <= (
			X"e50a", -- ldi	r16, 0x5A	; 165
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"99c6", -- sbic	0x18, 6	; 24
			X"6f0f", -- ori	r16, 0xFF	; 255
			X"6000", -- ori	r16, 0x00	; 0
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"0000", -- nop
			X"b907", -- out	0x07, r16	; 7
			X"CFFF", -- RJMP .-2
			others => X"0000");
		Inputs <= InputsInitial;
		Inputs.DeviceID(7 downto 0) <= X"80";
		RunTestCase(17, 40, Reset, AnyFailed);

		-- Finished all tests.
		assert not AnyFailed report "At least one test case failed." severity failure;
		Done <= true;
		wait;
	end process;
end architecture Behavioural;
