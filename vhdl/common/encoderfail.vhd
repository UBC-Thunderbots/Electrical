library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.types.all;

entity EncoderFail is
	port(
		Clock : in std_ulogic;
		Encoder : in encoder_t;
		Hall : in hall_t;
		Fail : out boolean := false);
end entity EncoderFail;

architecture Arch of EncoderFail is
	type seen_encoders_t is array(0 to 3) of boolean;
	signal SeenEncoders : seen_encoders_t := (others => false);
	type seen_halls_t is array(0 to 7) of boolean;
	signal SeenHalls : seen_halls_t := (others => false);
begin
	process(Clock) is
		variable EncoderIndex : unsigned(1 downto 0);
		variable HallIndex : unsigned(2 downto 0);
	begin
		if rising_edge(Clock) then
			-- Turn the current optical encoder and Hall sensor values into integers.
			for I in EncoderIndex'range loop
				EncoderIndex(I) := to_stdulogic(Encoder(I));
			end loop;
			for I in HallIndex'range loop
				HallIndex(I) := to_stdulogic(Hall(I));
			end loop;

			-- Set the current values as seen.
			SeenEncoders(to_integer(EncoderIndex)) <= true;
			SeenHalls(to_integer(HallIndex)) <= true;

			-- If we have seen all encoder values, then clear everything and start over because encoders are OK for now.
			if SeenEncoders(0) and SeenEncoders(1) and SeenEncoders(2) and SeenEncoders(3) then
				SeenEncoders <= (others => false);
				SeenHalls <= (others => false);
			end if;

			-- If we have seen all *LEGAL* Hall values (all with 1 or 2 set bits), then we have a failure.
			if SeenHalls(1) and SeenHalls(2) and SeenHalls(4) and SeenHalls(3) and SeenHalls(6) and SeenHalls(5) then
				Fail <= true;
			end if;
		end if;
	end process;
end architecture Arch;
