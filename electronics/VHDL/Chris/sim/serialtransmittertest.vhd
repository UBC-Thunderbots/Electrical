library ieee;
use ieee.std_logic_1164.all;

entity SerialTransmitterTest is
end entity SerialTransmitterTest;

architecture Behavioural of SerialTransmitterTest is
	constant ClockPeriod : time := 20 ns;
	constant BitTicks : positive := 4 us / ClockPeriod;

	signal Clock : std_ulogic := '0';
	signal Data : std_ulogic_vector(7 downto 0) := "00000000";
	signal Load : std_ulogic := '0';
	signal Serial : std_ulogic;
	signal Busy : std_ulogic;
begin
	uut : entity work.SerialTransmitter(Behavioural)
	port map(
		Clock => Clock,
		Data => Data,
		Load => Load,
		Busy => Busy,
		Serial => Serial
	);

	process
		procedure Tick is
		begin
			wait for ClockPeriod / 2;
			Clock <= '1';
			wait for ClockPeriod / 2;
			Clock <= '0';
		end procedure Tick;

		procedure TickBit is
		begin
			for i in BitTicks - 1 downto 0 loop
				Tick;
			end loop;
		end procedure TickBit;
	begin
		Tick;
		assert Busy = '0';
		assert Serial = '1';

		Data <= "10101010";
		Load <= '1';
		Tick;
		Load <= '0';
		assert Busy = '1';
		assert Serial = '0';
		TickBit;
		assert Busy = '1';
		assert Serial = '0';
		TickBit;
		assert Busy = '1';
		assert Serial = '1';
		TickBit;
		assert Busy = '1';
		assert Serial = '0';
		TickBit;
		assert Busy = '1';
		assert Serial = '1';
		TickBit;
		assert Busy = '1';
		assert Serial = '0';
		TickBit;
		assert Busy = '1';
		assert Serial = '1';
		TickBit;
		assert Busy = '1';
		assert Serial = '0';
		TickBit;
		assert Busy = '1';
		assert Serial = '1';
		TickBit;
		assert Busy = '1';
		assert Serial = '1';
		TickBit;
		assert Busy = '1';
		assert Serial = '1';
		TickBit;
		assert Busy = '0';
		assert Serial = '1';

		wait;
	end process;
end architecture Behavioural;
