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
	signal Reset : std_ulogic;
	signal PMemClockEnable : boolean;
	signal PMemAddress : natural range 0 to 2 ** 12 - 1;
	signal PMemAddressU : unsigned(11 downto 0);
	signal PMemData : std_ulogic_vector(15 downto 0);
	signal DMemWriteEnable : boolean;
	signal DMemAddress : natural range 0 to 2 ** 12 - 1;
	signal DMemAddressU : unsigned(11 downto 0);
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
		dbg_pc : out std_ulogic_vector(pmem_width - 1 downto 0));
	end component navre;
begin
	-- Instantiate the CPU
	NavreInstance : navre
	generic map(
		pmem_width => 12,
		dmem_width => 12)
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
		type program_memory_lane_t is array(0 to 4095) of std_ulogic_vector(3 downto 0);
		type program_memory_t is array(3 downto 0) of program_memory_lane_t;
		variable PMem : program_memory_t := (0 => (others => X"1"), 1 => (others => X"2"), 2 => (others => X"3"), 3 => (others => X"4"));
	begin
		if rising_edge(Clock) then
			if PMemClockEnable then
				PMemData(15 downto 12) <= PMem(3)(PMemAddress);
				PMemData(11 downto 8) <= PMem(2)(PMemAddress);
				PMemData(7 downto 4) <= PMem(1)(PMemAddress);
				PMemData(3 downto 0) <= PMem(0)(PMemAddress);
			end if;
		end if;
	end process;

	-- Provide the CPU with access to data memory
	process(Clock) is
		type data_memory_lane_t is array(0 to 4095) of std_ulogic_vector(3 downto 0);
		type data_memory_t is array(1 downto 0) of data_memory_lane_t;
		variable DMem : data_memory_t;
	begin
		if rising_edge(Clock) then
			DMemDI(7 downto 4) <= DMem(1)(DMemAddress);
			DMemDI(3 downto 0) <= DMem(0)(DMemAddress);
			if DMemWriteEnable then
				DMem(1)(DMemAddress) := DMemDO(7 downto 4);
				DMem(0)(DMemAddress) := DMemDO(3 downto 0);
			end if;
		end if;
	end process;
end architecture Arch;
