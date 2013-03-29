library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.clock.all;
use work.types.all;

entity CPUIOCodec is
	port(
		Clocks : in work.clock.clocks_t;
		Inputs : in work.types.cpu_inputs_t;
		Outputs : out work.types.cpu_outputs_t);
end entity CPUIOCodec;

architecture Arch of CPUIOCodec is
	constant PMemAddressWidth : natural := 14;

	subtype pmem_address_t is natural range 0 to 2 ** PMemAddressWidth - 1;
	type program_memory_t is array(0 to pmem_address_t'high) of std_ulogic_vector(15 downto 0);

	-- If a read-only RAM contains all zeroes, XST will delete it before Bitgen has a chance to copy the ELF section into it.
	-- This function generates a pile of crap to fill the RAM with so that it will NOT contain all zeroes and will not be optimized away.
	-- This function implements a basic linear congruential random number generator that should spew enough unpredictable bits around that none of the BRAMs are all-zero or all-one.
	function GenerateFakeRAMContents return program_memory_t is
		variable Result : program_memory_t;
		variable Address : natural range program_memory_t'range;
		variable Temp : natural range 0 to 65535 := 65521;
	begin
		for Address in program_memory_t'range loop
			Result(Address) := std_ulogic_vector(to_unsigned(Temp, 16));
			Temp := (Temp * 509 + 1021) mod 65536;
		end loop;
		return Result;
	end function GenerateFakeRAMContents;

	signal Reset : std_ulogic;

	signal PMem : program_memory_t := GenerateFakeRAMContents;
	signal PMemAddress : pmem_address_t;
	signal PMemAddressU : unsigned(21 downto 0);
	signal PMemData : std_ulogic_vector(15 downto 0);
begin
	pavr : entity work.pavr(pavr_arch)
	port map(
		pavr_clk => Clocks.Clock40MHz,
		pavr_res => '0',
		pavr_syncres => Reset,
		unsigned(pavr_pm_addr) => PMemAddressU,
		pavr_pm_do => std_logic_vector(PMemData),
		pavr_pm_wr => open,
		Inputs => Inputs,
		Outputs => Outputs,
		pavr_inc_instr_cnt => open);

	PMemAddress <= to_integer(PMemAddressU);

	-- Assert CPU reset for 16 clock cycles after startup, then release
	process(Clocks.Clock40MHz) is
		variable ResetShifter : std_ulogic_vector(15 downto 0) := X"FFFF";
	begin
		if rising_edge(Clocks.Clock40MHz) then
			ResetShifter := '0' & ResetShifter(15 downto 1);
		end if;
		Reset <= ResetShifter(0);
	end process;

	-- Provide the CPU with access to program memory
	process(Clocks.Clock40MHz) is
	begin
		if rising_edge(Clocks.Clock40MHz) then
			PMemData <= PMem(PMemAddress);
		end if;
	end process;
end architecture Arch;
