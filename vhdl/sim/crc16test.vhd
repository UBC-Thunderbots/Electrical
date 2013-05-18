library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity CRC16Test is
end entity;

architecture Behavioural of CRC16Test is
	constant ClockTime : time := 250 ns;

	signal Done : boolean := false;
	signal Clock : std_ulogic;
	signal Data : std_ulogic_vector(7 downto 0);
	signal Clear : boolean;
	signal Enable : boolean;
	signal Checksum : std_ulogic_vector(15 downto 0);
begin
	UUT : entity work.CRC16(Arch)
	port map(
		Clock => Clock,
		Data => Data,
		Clear => Clear,
		Enable => Enable,
		Checksum => Checksum);

	process
	begin
		Clock <= '1';
		wait for ClockTime / 2.0;
		Clock <= '0';
		wait for ClockTime / 2.0;

		if Done then
			wait;
		end if;
	end process;

	process
		-- variable data : STD_LOGIC_VECTOR(7 downto 0);
		variable Count : integer range 0 to 512;
		variable L : line;
		variable Progress : line;
	begin
		-- clearing
		Clear <= true;
		Count := 512;
		wait for ClockTime * 2.0;
		
		-- clocking in 512 bytes of 0xFF
		Clear <= false;
		Enable <= true;
		while Count > 0 loop
			Data <= "11111111";
			wait for ClockTime * 1.0;
			Count := Count - 1;
			write(Progress, bit_vector'(to_bitvector(Data)));
		end loop;
		-- this prints out the data being clocked in
		--writeline(output, progress);

		--data_in <= "00000000";
		--wait for ClockTime * 1.0;

		--data_in <= "00000000";
		--wait for ClockTime * 1.0;
		
		-- this prints out check sum result
		write(L, bit_vector'(to_bitvector(Checksum)));
		writeline(output, L);
		
		-- Datasheet say 512 bytes of 0xFF should produce 0x7FA1
		assert Checksum = x"7FA1" severity failure;

		Done <= true;
		wait;
	end process;
end architecture Behavioural;
