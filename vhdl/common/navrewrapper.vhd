library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity NavreWrapper is
	port(
		Clock : in std_ulogic;

		IOReadEnable : out boolean;
		IOWriteEnable : out boolean;
		IOAddress : out natural range 0 to 63;
		IODO : out std_ulogic_vector(7 downto 0);
		IODI : in std_ulogic_vector(7 downto 0));
end entity NavreWrapper;

architecture Arch of NavreWrapper is
	constant PMemAddressWidth : natural := 14;
	constant DMemAddressWidth : natural := 12;

	subtype pmem_address_t is natural range 0 to 2 ** PMemAddressWidth - 1;
	type program_memory_t is array(0 to pmem_address_t'high) of std_ulogic_vector(15 downto 0);
	subtype dmem_address_t is natural range 0 to 2 ** DMemAddressWidth - 1;
	type data_memory_t is array(0 to dmem_address_t'high) of std_ulogic_vector(7 downto 0);

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
	signal PMemClockEnable : boolean;
	signal PMemAddress : pmem_address_t;
	signal PMemAddressU : unsigned(PMemAddressWidth - 1 downto 0);
	signal PMemData : std_ulogic_vector(15 downto 0);

	signal DMem : data_memory_t := (others => X"00");
	signal DMemWriteEnable : boolean;
	signal DMemAddress : dmem_address_t;
	signal DMemAddressU : unsigned(DMemAddressWidth - 1 downto 0);
	signal DMemDI : std_ulogic_vector(7 downto 0);
	signal DMemDO : std_ulogic_vector(7 downto 0);

	signal IOAddressU : unsigned(5 downto 0);

	component navre
	generic(
		pmem_width : natural;
		dmem_width : natural);
	port(
		clk : in std_ulogic;
		rst : in std_ulogic;
		pmem_ce : out std_ulogic;
		pmem_a : out std_ulogic_vector(pmem_width - 1 downto 0);
		pmem_d : in std_ulogic_vector(15 downto 0);
		dmem_we : out std_ulogic;
		dmem_a : out std_ulogic_vector(dmem_width - 1 downto 0);
		dmem_di : in std_ulogic_vector(7 downto 0);
		dmem_do : out std_ulogic_vector(7 downto 0);
		io_re : out std_ulogic;
		io_we : out std_ulogic;
		io_a : out std_ulogic_vector(5 downto 0);
		io_do : out std_ulogic_vector(7 downto 0);
		io_di : in std_ulogic_vector(7 downto 0);
		irq : in std_ulogic_vector(7 downto 0);
		irq_ack : out std_ulogic_vector(7 downto 0);
		dbg_pc : out std_ulogic_vector(pmem_width - 1 downto 0));
	end component navre;
begin
	-- Instantiate the CPU
	NavreInstance : navre
	generic map(
		pmem_width => PMemAddressWidth,
		dmem_width => DMemAddressWidth)
	port map(
		clk => Clock,
		rst => Reset,
		to_boolean(pmem_ce) => PMemClockEnable,
		unsigned(pmem_a) => PMemAddressU,
		pmem_d => PMemData,
		to_boolean(dmem_we) => DMemWriteEnable,
		unsigned(dmem_a) => DMemAddressU,
		dmem_di => DMemDI,
		dmem_do => DMemDO,
		to_boolean(io_re) => IOReadEnable,
		to_boolean(io_we) => IOWriteEnable,
		unsigned(io_a) => IOAddressU,
		io_do => IODO,
		io_di => IODI,
		irq => X"00",
		irq_ack => open,
		dbg_pc => open);

	PMemAddress <= to_integer(PMemAddressU);
	DMemAddress <= to_integer(DMemAddressU);
	IOAddress <= to_integer(IOAddressU);

	-- Assert CPU reset for 16 clock cycles after startup, then release
	process(Clock) is
		variable ResetShifter : std_ulogic_vector(15 downto 0) := X"FFFF";
	begin
		if rising_edge(Clock) then
			ResetShifter := '0' & ResetShifter(15 downto 1);
		end if;
		Reset <= ResetShifter(0);
	end process;

	-- Provide the CPU with access to program memory
	process(Clock) is
	begin
		if rising_edge(Clock) then
			if PMemClockEnable then
				PMemData <= PMem(PMemAddress);
			end if;
		end if;
	end process;

	-- Provide the CPU with access to data memory
	process(Clock) is
	begin
		if rising_edge(Clock) then
			DMemDI <= DMem(DMemAddress);
			if DMemWriteEnable then
				DMem(DMemAddress) <= DMemDO;
			end if;
		end if;
	end process;
end architecture Arch;
