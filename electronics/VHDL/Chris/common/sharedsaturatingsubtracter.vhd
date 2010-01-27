library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SharedSaturatingSubtracter is
	generic(
		Width : positive
	);
	port(
		Clock : in std_ulogic;
		X1 : in signed(Width - 1 downto 0);
		X2 : in signed(Width - 1 downto 0);
		X3 : in signed(Width - 1 downto 0);
		X4 : in signed(Width - 1 downto 0);
		Y1 : in signed(Width - 1 downto 0);
		Y2 : in signed(Width - 1 downto 0);
		Y3 : in signed(Width - 1 downto 0);
		Y4 : in signed(Width - 1 downto 0);
		Difference1 : out signed(Width - 1 downto 0);
		Difference2 : out signed(Width - 1 downto 0);
		Difference3 : out signed(Width - 1 downto 0);
		Difference4 : out signed(Width - 1 downto 0)
	);
end entity SharedSaturatingSubtracter;

architecture Behavioural of SharedSaturatingSubtracter is
	signal X : signed(Width - 1 downto 0);
	signal Y : signed(Width - 1 downto 0);
	signal Difference : signed(Width - 1 downto 0);
	signal Calculating : natural range 0 to 3 := 0;
begin
	process(X1, X2, X3, X4, Calculating)
	begin
		case Calculating is
			when 0 => X <= X1;
			when 1 => X <= X2;
			when 2 => X <= X3;
			when 3 => X <= X4;
		end case;
	end process;

	process(Y1, Y2, Y3, Y4, Calculating)
	begin
		case Calculating is
			when 0 => Y <= Y1;
			when 1 => Y <= Y2;
			when 2 => Y <= Y3;
			when 3 => Y <= Y4;
		end case;
	end process;

	process(Clock)
	begin
		if rising_edge(Clock) then
			case Calculating is
				when 0 => Difference1 <= Difference;
				when 1 => Difference2 <= Difference;
				when 2 => Difference3 <= Difference;
				when 3 => Difference4 <= Difference;
			end case;
			Calculating <= (Calculating + 1) mod 4;
		end if;
	end process;

	Impl : entity work.SaturatingSubtracter(Behavioural)
	generic map(
		Width => Width
	)
	port map(
		X => X,
		Y => Y,
		Difference => Difference
	);
end architecture Behavioural;
