library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity crc16test is
end entity;

architecture Behavioural of crc16test is
	constant ClockTime : time := 250 ns;

	signal done : boolean := false;
	signal data_in : STD_LOGIC_VECTOR (7 downto 0);
	signal clock : STD_LOGIC;
	signal clear : STD_LOGIC;
	signal enable : STD_LOGIC;
	signal checksum : STD_LOGIC_VECTOR (15 downto 0);

begin
	
	UUT: entity work.crc16(Behav)
	port map(
		data_in => data_in,
		clock => clock,
		clear => clear,
		enable => enable,
		checksum => checksum);
	process
	begin
		clock <= '1';
		wait for ClockTime / 2.0;
		clock <= '0';
		wait for ClockTime / 2.0;

		if done then
			wait;
		end if;
	end process;

	process
		-- variable data : STD_LOGIC_VECTOR(7 downto 0);
	variable count: integer range 0 to 512;
	variable l: line;
	variable progress : line;
	begin
		-- clearing
		clear <= '1';
		count := 512;
		wait for ClockTime * 2.0;
		
		-- clocking in 512 bytes of 0xFF
		clear <= '0';
		enable <= '1';
		while (count > 0) loop
			
			data_in <= "11111111";
			wait for ClockTime * 1.0;
			count := count -1;
			write( progress, bit_vector'(to_bitvector(data_in)));
		end loop;
		-- this prints out the data being clocked in
		--writeline(output, progress);

		--data_in <= "00000000";
		--wait for ClockTime * 1.0;

		--data_in <= "00000000";
		--wait for ClockTime * 1.0;
		
		-- this prints out check sum result
		write(l, bit_vector'(to_bitvector(checksum)));
		writeline(output, l);
		
		-- Datasheet say 512 bytes of 0xFF should produce 0x7FA1
		assert checksum = x"7FA1" severity failure;

		done <= true;
		wait;
	end process;
end architecture Behavioural;
