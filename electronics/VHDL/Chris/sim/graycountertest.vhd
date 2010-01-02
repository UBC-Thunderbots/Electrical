library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GrayCounterTest is
end entity GrayCounterTest;

architecture Behavioural of GrayCounterTest is
	component GrayCounter
		generic(
			Width : positive
		);
		port(
			Clock : in std_ulogic;

			A : in std_ulogic;
			B : in std_ulogic;

			Reset : in std_ulogic;
			Count : out signed(Width - 1 downto 0)
		);
	end component GrayCounter;

	constant ClockPeriod : time := 20 ns;
	constant Width : positive := 16;

	signal Clock : std_ulogic := '0';
	signal A : std_ulogic := '0';
	signal B : std_ulogic := '0';
	signal Reset : std_ulogic := '0';
	signal Count : signed(Width - 1 downto 0) := to_signed(0, Width);
	signal Done : std_ulogic := '0';
begin
	uut: GrayCounter
	generic map(
		Width => Width
	)
	port map(
		Clock => Clock,
		A => A,
		B => B,
		Reset => Reset,
		Count => Count
	);

	process
	begin
		Clock <= '1';
		wait for ClockPeriod / 2;
		Clock <= '0';
		wait for ClockPeriod / 2;
		if Done = '1' then
			wait;
		end if;
	end process;

	process
	begin
		wait for 50 ns;
		assert Count = to_signed(0, Width);
		A <= '1';
		wait for 50 ns;
		assert Count = to_signed(1, Width);
		B <= '1';
		wait for 50 ns;
		assert Count = to_signed(2, Width);
		A <= '0';
		wait for 50 ns;
		assert Count = to_signed(3, Width);
		B <= '0';
		wait for 50 ns;
		assert Count = to_signed(4, Width);
		B <= '1';
		Reset <= '1';
		wait for ClockPeriod;
		Reset <= '0';
		wait for 50 ns - ClockPeriod;
		assert Count = to_signed(-1, Width);
		A <= '1';
		wait for 50 ns;
		assert Count = to_signed(-2, Width);
		B <= '0';
		wait for 50 ns;
		assert Count = to_signed(-3, Width);
		A <= '0';
		wait for 50 ns;
		assert Count = to_signed(-4, Width);
		Done <= '1';
		wait;
	end process;
end architecture Behavioural;
