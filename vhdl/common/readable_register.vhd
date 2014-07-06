library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity ReadableRegister is
	generic(
		Command : natural;
		Length : positive);
	port(
		Reset : in boolean;
		HostClock : in std_ulogic;
		SPIIn : in spi_input_t;
		SPIOut : buffer spi_output_t;
		Value : in byte_vector(0 to Length - 1));
end entity ReadableRegister;

architecture RTL of ReadableRegister is
	type state_t is (IDLE, RESPOND);
	signal State : state_t;
	signal Latch : byte_vector(0 to Value'high - 1);
	signal BytesLeft : natural range 0 to Length - 1;
begin
	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			SPIOut.WriteData <= X"00";
			SPIOut.WriteStrobe <= false;
			SPIOut.WriteCRC <= false;

			if Reset then
				State <= IDLE;
			elsif SPIIn.ReadStrobe and SPIIn.ReadFirst then
				if to_integer(unsigned(SPIIn.ReadData)) = Command then
					State <= RESPOND;
					SPIOut.WriteData <= Value(0);
					SPIOut.WriteStrobe <= true;
					Latch <= Value(1 to Value'high);
					BytesLeft <= Length - 1;
				else
					State <= IDLE;
				end if;
			elsif State = RESPOND and SPIIn.WriteReady then
				SPIOut.WriteStrobe <= true;
				if BytesLeft = 0 then
					SPIOut.WriteCRC <= true;
					State <= IDLE;
				else
					SPIOut.WriteData <= Latch(0);
					Latch(0 to Latch'high - 1) <= Latch(1 to Latch'high);
					BytesLeft <= BytesLeft - 1;
				end if;
			end if;
		end if;
	end process;
end architecture RTL;
