library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.commands.all;
use work.mrf_common.all;
use work.types.all;

--! \brief Provides direct register-level access to the radio over the ICB.
entity MRFDirectAccess is
	port(
		Reset : in boolean; --! The system reset signal.
		HostClock : in std_ulogic; --! The system clock.
		ICBIn : in spi_input_t; --! The ICB data input.
		ICBOut : buffer spi_output_t; --! The ICB data output.
		IRQ : buffer boolean; --! The ICB interrupt request.
		ArbRequest : buffer boolean; --! The request signal to the arbiter.
		ArbGrant : in boolean; --! The grant signal from the arbiter.
		LLControl : buffer low_level_control_t; --! The control lines to the low-level module.
		LLStatus : in low_level_status_t; --! The status lines from the low-level module.
		MRFIntPin : in std_ulogic; --! The interrupt wire from the MRF.
		MRFResetPin : buffer std_ulogic; --! The reset wire to the MRF.
		MRFWakePin : buffer std_ulogic); --! The wake wire to the MRF.
end entity MRFDirectAccess;

architecture RTL of MRFDirectAccess is
begin
	process(HostClock) is
		type state_t is (IDLE, ICB_ADDRESS_HIGH, ICB_ADDRESS_LOW, ICB_WRITE_DATA, MRF_WAIT_ARB, MRF_WAIT_BUSY, ICB_READ_DATA, ICB_READ_AUX);
		variable State : state_t;
		variable Command : natural range 0 to 255;
		variable AddressHigh : natural range 0 to 3;
		variable LastReadData : std_ulogic_vector(7 downto 0);
	begin
		if rising_edge(HostClock) then
			ICBOut.WriteData <= X"00";
			ICBOut.WriteStrobe <= false;
			ICBOut.WriteCRC <= false;
			IRQ <= false;
			LLControl.Strobe <= false;

			if Reset then
				State := IDLE;
				MRFResetPin <= '0';
				MRFWakePin <= '0';
			elsif ICBIn.ReadStrobe and ICBIn.ReadFirst then
				AddressHigh := 0;
				Command := to_integer(unsigned(ICBIn.ReadData));
				case Command is
					when COMMAND_MRF_DA_READ_SHORT =>
						LLControl.RegType <= SHORT;
						LLControl.OpType <= READ;
						State := ICB_ADDRESS_LOW;

					when COMMAND_MRF_DA_WRITE_SHORT =>
						LLControl.RegType <= SHORT;
						LLControl.OpType <= WRITE;
						State := ICB_ADDRESS_LOW;

					when COMMAND_MRF_DA_READ_LONG =>
						LLControl.RegType <= LONG;
						LLControl.OpType <= READ;
						State := ICB_ADDRESS_HIGH;

					when COMMAND_MRF_DA_WRITE_LONG =>
						LLControl.RegType <= LONG;
						LLControl.OpType <= WRITE;
						State := ICB_ADDRESS_HIGH;

					when COMMAND_MRF_DA_GET_DATA =>
						State := ICB_READ_DATA;
						ICBOut.WriteData <= LastReadData;
						ICBOut.WriteStrobe <= true;

					when COMMAND_MRF_DA_GET_INT =>
						State := ICB_READ_DATA;
						ICBOut.WriteData <= "0000000" & MRFIntPin;
						ICBOut.WriteStrobe <= true;

					when COMMAND_MRF_DA_SET_AUX =>
						State := ICB_READ_AUX;

					when others =>
						if State /= MRF_WAIT_ARB and State /= MRF_WAIT_BUSY then
							State := IDLE;
						end if;
				end case;
			else
				case State is
					when IDLE =>
						null;

					when ICB_ADDRESS_HIGH =>
						if ICBIn.ReadStrobe then
							AddressHigh := to_integer(unsigned(ICBIn.ReadData));
							State := ICB_ADDRESS_LOW;
						end if;

					when ICB_ADDRESS_LOW =>
						if ICBIn.ReadStrobe then
							LLControl.Address <= AddressHigh * 256 + to_integer(unsigned(ICBIn.ReadData));
							case LLControl.OpType is
								when READ =>
									State := MRF_WAIT_ARB;
								when WRITE =>
									State := ICB_WRITE_DATA;
							end case;
						end if;

					when ICB_WRITE_DATA =>
						if ICBIn.ReadStrobe then
							LLControl.WriteData <= ICBIn.ReadData;
							State := MRF_WAIT_ARB;
						end if;

					when MRF_WAIT_ARB =>
						if ArbGrant and not LLStatus.Busy then
							LLControl.Strobe <= true;
							State := MRF_WAIT_BUSY;
						end if;

					when MRF_WAIT_BUSY =>
						if not LLStatus.Busy then
							LastReadData := LLStatus.ReadData;
							State := IDLE;
							IRQ <= true;
						end if;

					when ICB_READ_DATA =>
						if ICBIn.WriteReady then
							ICBOut.WriteCRC <= true;
							ICBOut.WriteStrobe <= true;
							State := IDLE;
						end if;

					when ICB_READ_AUX =>
						if ICBIn.ReadStrobe then
							MRFResetPin <= ICBIn.ReadData(0);
							MRFWakePin <= ICBIn.ReadData(1);
							State := IDLE;
						end if;
				end case;
			end if;
		end if;

		case State is
			when IDLE => ArbRequest <= false;
			when ICB_ADDRESS_HIGH => ArbRequest <= true;
			when ICB_ADDRESS_LOW => ArbRequest <= true;
			when ICB_WRITE_DATA => ArbRequest <= true;
			when MRF_WAIT_ARB => ArbRequest <= true;
			when MRF_WAIT_BUSY => ArbRequest <= false;
			when ICB_READ_DATA => ArbRequest <= false;
			when ICB_READ_AUX => ArbRequest <= false;
		end case;
	end process;
end architecture RTL;
