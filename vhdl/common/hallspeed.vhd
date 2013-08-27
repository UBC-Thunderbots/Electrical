library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity HallSpeed is
	port(
		clk : in std_ulogic;
		Hall : in work.types.hall_t;
		Value : buffer work.types.motor_position_t);
end entity HallSpeed;

architecture RTL of HallSpeed is
	signal CountInternal : work.types.motor_position_t;
	signal OldHall : work.types.hall_t;

	pure function IsForward(constant Hall : work.types.hall_t; constant OldHall : work.types.hall_t) return boolean is
		variable HallBits : std_ulogic_vector(5 downto 0);
	begin
		for I in 0 to 2 loop
			HallBits(I) := to_stdulogic(Hall(I));
			HallBits(I + 3) := to_stdulogic(OldHall(I));
		end loop;
		if HallBits = "100110" then
			return true;
		elsif HallBits = "110010" then
			return true;
		elsif HallBits = "010011" then
			return true;
		elsif HallBits = "011001" then
			return true;
		elsif HallBits = "001101" then
			return true;
		elsif HallBits = "101100" then
			return true;
		else
			return false;
		end if;
	end function IsForward;
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			if Hall /= OldHall then
				if IsForward(Hall, OldHall) then
					Value <= Value + 1;
				else
					Value <= Value - 1;
				end if;
			end if;
			OldHall <= Hall;
		end if;
	end process;
end architecture RTL;
