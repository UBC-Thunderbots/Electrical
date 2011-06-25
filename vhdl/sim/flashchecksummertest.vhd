library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.clock.all;

entity FlashChecksummerTest is
end entity;

architecture Behavioural of FlashChecksummerTest is
	signal Done : boolean := false;
	signal ClockHigh : std_ulogic := '0';
	signal Drive : boolean;
	signal CS : boolean;
	signal SPIClock : boolean;
	signal MOSI : std_ulogic;
	signal MISO : std_ulogic := '0';
	signal CRC : std_ulogic_vector(15 downto 0);

	signal EffectiveCS : boolean;
	signal USPIClock : std_ulogic;
begin
	UUT: entity work.FlashChecksummer(Behavioural)
	port map(
		ClockHigh => ClockHigh,
		Drive => Drive,
		CS => CS,
		SPIClock => SPIClock,
		MOSI => MOSI,
		MISO => MISO,
		CRC => CRC);

	EffectiveCS <= Drive and CS;
	USPIClock <= '1' when SPIClock else '0';

	process
	begin
		wait for (ClockHighTime * 5.0) * 1 sec;
		while not Done loop
			ClockHigh <= '1';
			wait for (ClockHighTime / 2.0) * 1 sec;
			ClockHigh <= '0';
			wait for (ClockHighTime / 2.0) * 1 sec;
		end loop;
		wait;
	end process;

	process
		variable Data : std_ulogic_vector(31 downto 0);
		variable Address : natural range 0 to 2 * 1024 * 1024 - 1;
		variable LineBuffer : line;
	begin
		while true loop
			-- Wait until CS asserted.
			wait until EffectiveCS;

			-- Receive next 32 bits, should be READ DATA from address 0 (0x03000000).
			for I in 31 downto 0 loop
				wait until rising_edge(USPIClock) or not EffectiveCS;
				assert EffectiveCS severity failure;
				Data(I) := MOSI;
			end loop;
			assert Data = X"03000000";

			-- Start piping out data.
			Address := 0;
			while EffectiveCS loop
				-- Compute the next 8 bits as a strange function of the address.
				Data := std_ulogic_vector(to_unsigned(Address * 7 + 1, 32));
				for I in 0 to (Address mod 4) - 1 loop
					Data := X"00" & Data(31 downto 8);
				end loop;

				-- Pipe out the 8 bits, each on a falling edge of SPI clock.
				for I in 7 downto 0 loop
					wait until falling_edge(USPIClock) or not EffectiveCS;
					if not EffectiveCS then
						exit;
					end if;
					MISO <= Data(I);
				end loop;

				-- Advance to next address.
				Address := (Address + 1) mod (2 * 1024 * 1024);

				-- Output the address if it's a multiple of 64kB.
				if (Address mod 65536) = 0 and Address /= 0 then
					write(LineBuffer, Address / 1024);
					write(LineBuffer, string'("kB of 2048 read"));
					writeline(output, LineBuffer);
				end if;
			end loop;
		end loop;
	end process;

	process
	begin
		wait for 800 ms;
		Done <= true;
		assert not Drive;
		assert CRC = X"2AA9";
		wait;
	end process;

	process
		variable DriveTime : time;
	begin
		if not Drive then
			wait until Drive;
		end if;
		assert not CS severity failure;
		DriveTime := now;
		wait until not Drive or CS;
		if CS then
			assert (now - DriveTime) >= 40 ns;
		end if;
		wait until not Drive;
	end process;

	process
		variable CSTime : time;
	begin
		assert not CS severity failure;
		wait until CS;
		assert not SPIClock severity failure;
		CSTime := now;
		wait until not CS or SPIClock;
		if SPIClock then
			assert (now - CSTime) >= 5 ns;
		end if;
		wait until not CS;
	end process;
end architecture Behavioural;
