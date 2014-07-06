library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity WritableRegister is
	generic(
		Command : natural;
		Length : positive;
		ResetValue : byte_vector);
	port(
		Reset : in boolean;
		HostClock : in std_ulogic;
		SPIIn : in spi_input_t;
		Value : buffer byte_vector(0 to Length - 1));
end entity WritableRegister;

architecture RTL of WritableRegister is
	type state_t is (IDLE, ACCEPT);
	signal State : state_t;
	signal Shifter : byte_vector(0 to Length - 2);
	signal BytesLeftMinusOne : natural range 0 to Length - 1;
begin
	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			if Reset then
				State <= IDLE;
				Value <= ResetValue;
			elsif SPIIn.ReadStrobe and SPIIn.ReadFirst then
				if to_integer(unsigned(SPIIn.ReadData)) = Command then
					State <= ACCEPT;
					BytesLeftMinusOne <= Length - 1;
				else
					State <= IDLE;
				end if;
			elsif State = ACCEPT and SPIIn.ReadStrobe then
				if BytesLeftMinusOne = 0 then
					State <= IDLE;
					Value <= Shifter & SPIIn.ReadData;
				else
					Shifter <= Shifter(1 to Length - 2) & SPIIn.ReadData;
					BytesLeftMinusOne <= BytesLeftMinusOne - 1;
				end if;
			end if;
		end if;
	end process;
end architecture RTL;
