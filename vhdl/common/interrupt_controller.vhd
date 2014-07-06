library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.commands.all;
use work.types.all;

--! \brief A simple interrupt controller that aggregates interrupts and reports them over the ICB.
entity InterruptController is
	generic(
		Count : natural); --! The number of interrupt requests in the system.
	port(
		Reset : in boolean; --! The system reset signal.
		HostClock : in std_ulogic; --! The system clock.
		SPIIn : in spi_input_t; --! The ICB data input.
		SPIOut : buffer spi_output_t; --! The ICB data output.
		InterruptPin : buffer std_ulogic; --! The ICB interrupt pin.

		--! \brief The interrupt requests.
		--!
		--! These are all pulse-sensitive.
		--! For an IRQ to be accepted, the driving peripheral must hold the IRQ line at \c true for at least one clock cycle.
		--! The line should be deasserted back to \c false within a few cycles.
		IRQs : in boolean_vector(0 to Count - 1));
end entity InterruptController;

architecture RTL of InterruptController is
	signal LatchForPin : boolean_vector(0 to Count - 1);
begin
	process(HostClock) is
		constant ByteCount : natural := (Count + 7) / 8;
		type state_t is (IDLE, RESPOND);
		variable State : state_t;
		variable Latch : boolean_vector(0 to Count - 1);
		variable NextByte : natural range 0 to ByteCount;
		variable IRQIndex : natural range 0 to Count - 1;
	begin
		if rising_edge(HostClock) then
			-- Default idle state for SPI outputs.
			SPIOut.WriteData <= X"00";
			SPIOut.WriteStrobe <= false;
			SPIOut.WriteCRC <= false;

			-- Latch IRQs.
			for I in 0 to Count - 1 loop
				Latch(I) := Latch(I) or IRQs(I);
			end loop;

			-- Handle reset and start of transaction.
			if Reset then
				State := IDLE;
				for I in 0 to Count - 1 loop
					Latch(I) := false;
				end loop;
			elsif SPIIn.ReadStrobe and SPIIn.ReadFirst and to_integer(unsigned(SPIIn.ReadData)) = COMMAND_GET_CLEAR_IRQS then
				State := RESPOND;
				NextByte := 0;
			end if;

			-- Send out response data, clearing edge-sensitive IRQs as we go.
			if State = RESPOND and SPIIn.WriteReady then
				if NextByte = ByteCount then
					SPIOut.WriteCRC <= true;
					SPIOut.WriteStrobe <= true;
					State := IDLE;
				else
					for BitIndex in 0 to 7 loop
						IRQIndex := BitIndex + NextByte * 8;
						if IRQIndex < Count then
							SPIOut.WriteData(BitIndex) <= to_stdulogic(Latch(IRQIndex));
							Latch(IRQIndex) := false;
						else
							SPIOut.WriteData(BitIndex) <= '0';
						end if;
					end loop;
					SPIOut.WriteStrobe <= true;
					NextByte := NextByte + 1;
				end if;
			end if;
		end if;

		LatchForPin <= Latch;
	end process;

	-- Control the output pin.
	process(LatchForPin) is
	begin
		InterruptPin <= '0';
		for I in 0 to Count - 1 loop
			if LatchForPin(I) then
				InterruptPin <= '1';
			end if;
		end loop;
	end process;
end architecture RTL;
