library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.clock.all;
use work.pavr_constants.all;
use work.types.all;

entity CPUWrapper is
	port(
		Clocks : in work.clock.clocks_t;
		Reset : in boolean;
		Inputs : in work.types.cpu_inputs_t;
		Outputs : out work.types.cpu_outputs_t;
		DMAWrite : in boolean;
		DMAAddress : in natural range 0 to pavr_dm_len - 1;
		DMADataWrite : in std_ulogic_vector(7 downto 0);
		DMADataRead : out std_ulogic_vector(7 downto 0));
end entity CPUWrapper;

architecture Arch of CPUWrapper is
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

	signal PMem : program_memory_t := GenerateFakeRAMContents;
	signal PMemAddress : pmem_address_t;
	signal PMemAddressU : unsigned(21 downto 0);
	signal PMemData : std_ulogic_vector(15 downto 0);

	signal DMAWriteU : std_ulogic;
	signal DMAAddressU : unsigned(pavr_dm_addr_w - 1 downto 0);
begin
	DMAWriteU <= to_stdulogic(DMAWrite);
	DMAAddressU <= to_unsigned(DMAAddress, pavr_dm_addr_w);

	pavr : entity work.pavr(pavr_arch)
	port map(
		pavr_clk => Clocks.Clock40MHz,
		pavr_res => '0',
		pavr_syncres => to_stdulogic(Reset),
		unsigned(pavr_pm_addr) => PMemAddressU,
		pavr_pm_do => std_logic_vector(PMemData),
		pavr_pm_wr => open,
		pavr_dma_wr => std_logic(DMAWriteU),
		pavr_dma_addr => std_logic_vector(DMAAddressU),
		pavr_dma_di => std_logic_vector(DMADataWrite),
		std_ulogic_vector(pavr_dma_do) => DMADataRead,
		Inputs => Inputs,
		Outputs => Outputs,
		pavr_inc_instr_cnt => open);

	-- Provide the CPU with access to program memory
	PMemAddress <= to_integer(PMemAddressU);
	PMemData <= PMem(PMemAddress) when rising_edge(Clocks.Clock40MHz);
end architecture Arch;
