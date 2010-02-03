library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignMagnitudeTest is
end entity SignMagnitudeTest;

architecture Behavioural of SignMagnitudeTest is
	signal Value : signed(9 downto 0) := to_signed(0, 10);
	signal Absolute : unsigned(8 downto 0);
	signal Sign : std_ulogic;
begin
	UUT : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 10
	)
	port map(
		Value => Value,
		Absolute => Absolute,
		Sign => Sign
	);

	process
	begin
		Value <= to_signed(27, 10);
		wait for 1 ps;
		assert Absolute = to_unsigned(27, 9);
		assert Sign = '0';

		Value <= to_signed(-27, 10);
		wait for 1 ps;
		assert Absolute = to_unsigned(27, 9);
		assert Sign = '1';

		Value <= to_signed(511, 10);
		wait for 1 ps;
		assert Absolute = to_unsigned(511, 9);
		assert Sign = '0';

		Value <= to_signed(-511, 10);
		wait for 1 ps;
		assert Absolute = to_unsigned(511, 9);
		assert Sign = '1';
		wait;
	end process;
end architecture Behavioural;
