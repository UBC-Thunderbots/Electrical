library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NavreWrapper is
	port(
		Clock : in std_ulogic;
		LEDs : out std_ulogic_vector(4 downto 0));
end entity NavreWrapper;

architecture Arch of NavreWrapper is
	signal Reset : std_ulogic;
	signal PMemClockEnable : std_ulogic;
	signal PMemAddress : unsigned(11 downto 0);
	signal PMemData : std_ulogic_vector(15 downto 0) := X"0000";
	signal DMemWriteEnable : std_ulogic;
	signal DMemAddress : unsigned(11 downto 0);
	signal DMemDI : std_ulogic_vector(7 downto 0) := X"00";
	signal DMemDO : std_ulogic_vector(7 downto 0);
	signal IOReadEnable : std_ulogic;
	signal IOWriteEnable : std_ulogic;
	signal IOAddress : unsigned(5 downto 0);
	signal IODO : std_ulogic_vector(7 downto 0);
	signal IODI : std_ulogic_vector(7 downto 0) := X"00";

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
		pmem_ce => PMemClockEnable,
		unsigned(pmem_a) => PMemAddress,
		pmem_d => PMemData,
		dmem_we => DMemWriteEnable,
		unsigned(dmem_a) => DMemAddress,
		dmem_di => DMemDI,
		dmem_do => DMemDO,
		io_re => IOReadEnable,
		io_we => IOWriteEnable,
		unsigned(io_a) => IOAddress,
		io_do => IODO,
		io_di => IODI,
		dbg_pc => open);

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
			if PMemClockEnable = '1' then
				PMemData(15 downto 12) <= PMem(3)(to_integer(PMemAddress));
				PMemData(11 downto 8) <= PMem(2)(to_integer(PMemAddress));
				PMemData(7 downto 4) <= PMem(1)(to_integer(PMemAddress));
				PMemData(3 downto 0) <= PMem(0)(to_integer(PMemAddress));
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
			DMemDI(7 downto 4) <= DMem(1)(to_integer(DMemAddress));
			DMemDI(3 downto 0) <= DMem(0)(to_integer(DMemAddress));
			if DMemWriteEnable = '1' then
				DMem(1)(to_integer(DMemAddress)) := DMemDO(7 downto 4);
				DMem(0)(to_integer(DMemAddress)) := DMemDO(3 downto 0);
			end if;
		end if;
	end process;

	-- Provide the CPU with access to I/O ports
	process(Clock) is
		variable TSC : unsigned(31 downto 0) := X"00000000";
	begin
		if rising_edge(Clock) then
			IODI <= X"00";
			if IOReadEnable = '1' then
				case to_integer(IOAddress) is
					when 0 =>
						IODI <= std_ulogic_vector(TSC(7 downto 0));
					when 1 =>
						IODI <= std_ulogic_vector(TSC(15 downto 8));
					when 2 =>
						IODI <= std_ulogic_vector(TSC(23 downto 16));
					when 3 =>
						IODI <= std_ulogic_vector(TSC(31 downto 24));
					when others =>
						null;
				end case;
			end if;

			if IOWriteEnable = '1' then
				case to_integer(IOAddress) is
					when 0 =>
						LEDs <= IODO(4 downto 0);
					when others =>
						null;
				end case;
			end if;

			TSC := TSC + 1;
		end if;
	end process;
end architecture Arch;
