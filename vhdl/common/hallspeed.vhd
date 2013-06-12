library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity HallSpeed is
	port(
		Clock : in std_ulogic;
		Reset : in boolean;
		Hall : in hall_t;
		Count : out hall_speed_t);
end entity HallSpeed;

architecture Arch of HallSpeed is
	signal CountInternal : hall_speed_t := 0;
	signal OldHall : hall_t := (others => false);

	pure function IsForward(signal Hall : in hall_t; signal OldHall : in hall_t) return boolean is
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
	process(Clock) is
	begin
		if rising_edge(Clock) then
			if Reset then
				CountInternal <= 0;
			elsif IsForward(Hall, OldHall) then
				CountInternal <= CountInternal + 1;
			end if;
			OldHall <= Hall;
		end if;
	end process;

	Count <= CountInternal;
end architecture Arch;
