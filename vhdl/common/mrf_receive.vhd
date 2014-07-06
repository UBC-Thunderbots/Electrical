library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.commands.all;
use work.mrf_common.all;
use work.types.all;

--! \brief Provides an engine for receiving frames from the radio and passing them over the ICB.
entity MRFReceiveOffload is
	port(
		Reset : in boolean; --! The system reset signal.
		HostClock : in std_ulogic; --! The system clock.
		ICBIn : in spi_input_t; --! The ICB data input.
		ICBOut : buffer spi_output_t; --! The ICB data output.
		ReceiveIRQ : buffer boolean; --! The ICB interrupt request for frame received.
		FCSFailIRQ : buffer boolean; --! The ICB interrupt request for frame received with bad FCS.
		ArbRequest : buffer boolean; --! The request signal to the arbiter.
		ArbGrant : in boolean; --! The grant signal from the arbiter.
		LLControl : buffer low_level_control_t; --! The control lines to the low-level module.
		LLStatus : in low_level_status_t; --! The status lines from the low-level module.
		ReceiveInt : in boolean); --! The receive complete interrupt strobe from the MRF interrupt offload engine.
end entity MRFReceiveOffload;

architecture RTL of MRFReceiveOffload is
	constant FCS_FAIL_RETRY_COUNT : natural := 8;

	signal EnableEngine : boolean;
	signal FramePending : boolean;
	signal PendingFrameLength : positive range 1 to 255;
	signal FlushFrame : boolean;

	type frame_buffer_port is record
		Strobe : boolean;
		Address : natural range 0 to 255;
		Data : std_ulogic_vector(7 downto 0);
	end record frame_buffer_port;

	signal FrameBufferReadPort : frame_buffer_port := (Strobe => true, Address => 0, Data => X"00");
	signal FrameBufferWritePort : frame_buffer_port;

	signal CRCReset : boolean;
	signal CRCData : std_ulogic_vector(7 downto 0);
	signal CRCStrobe : boolean;
	signal CRCResult : std_ulogic_vector(15 downto 0);
	signal CRCBusy : boolean;
	signal CRCZeroTwoBytesAgo : boolean;
begin
	process(HostClock) is
		type frame_buffer_t is array(0 to 255) of std_ulogic_vector(7 downto 0);
		variable FrameBuffer : frame_buffer_t;
	begin
		if rising_edge(HostClock) then
			if FrameBufferReadPort.Strobe then
				FrameBufferReadPort.Data <= FrameBuffer(FrameBufferReadPort.Address);
			end if;
			if FrameBufferWritePort.Strobe then
				FrameBuffer(FrameBufferWritePort.Address) := FrameBufferWritePort.Data;
			end if;
		end if;
	end process;

	process(HostClock) is
		type state_t is (IDLE, SEND_DATA, SEND_CRC);
		variable State : state_t;
		variable Command : natural range 0 to 255;
	begin
		if rising_edge(HostClock) then
			ICBOut.WriteData <= X"00";
			ICBOut.WriteStrobe <= false;
			ICBOut.WriteCRC <= false;
			FlushFrame <= false;

			if Reset then
				State := IDLE;
				EnableEngine <= false;
			elsif ICBIn.ReadStrobe and ICBIn.ReadFirst then
				Command := to_integer(unsigned(ICBIn.ReadData));
				case Command is
					when COMMAND_MRF_OFFLOAD =>
						EnableEngine <= true;

					when COMMAND_MRF_RX_GET_SIZE =>
						if FramePending then
							ICBOut.WriteData <= std_ulogic_vector(to_unsigned(PendingFrameLength, 8));
						else
							ICBOut.WriteData <= X"00";
						end if;
						ICBOut.WriteStrobe <= true;
						State := SEND_CRC;

					when COMMAND_MRF_RX_READ =>
						-- PendingFrameLength will never be 1 so no need to check for that and jump directly to SEND_CRC.
						if FramePending then
							ICBOut.WriteData <= FrameBufferReadPort.Data;
							ICBOut.WriteStrobe <= true;
							State := SEND_DATA;
							FrameBufferReadPort.Address <= 1;
						else
							State := IDLE;
						end if;

					when COMMAND_MRF_OFFLOAD_DISABLE =>
						State := IDLE;
						EnableEngine <= false;

					when others =>
						State := IDLE;
				end case;
			else
				case State is
					when IDLE =>
						FrameBufferReadPort.Address <= 0;

					when SEND_DATA =>
						if ICBIn.WriteReady then
							ICBOut.WriteData <= FrameBufferReadPort.Data;
							ICBOut.WriteStrobe <= true;
							if FrameBufferReadPort.Address + 1 = PendingFrameLength then
								State := SEND_CRC;
								FlushFrame <= true;
							end if;
							FrameBufferReadPort.Address <= FrameBufferReadPort.Address + 1;
						end if;

					when SEND_CRC =>
						if ICBIn.WriteReady then
							ICBOut.WriteCRC <= true;
							ICBOut.WriteStrobe <= true;
							State := IDLE;
						end if;
				end case;
			end if;
		end if;
	end process;

	process(HostClock) is
		type state_t is (WAIT_INT, WAIT_ARB, SET_RXDECINV, READ_LENGTH, READ_DATA);
		variable State : state_t;
		variable ReceiveIntLatch : boolean;
		variable ReadOffset : natural range 0 to 255;
		variable TriesLeft : natural range 0 to FCS_FAIL_RETRY_COUNT - 1;
	begin
		if rising_edge(HostClock) then
			ReceiveIRQ <= false;
			FCSFailIRQ <= false;
			LLControl.Strobe <= false;
			FrameBufferWritePort.Strobe <= false;
			CRCReset <= false;
			CRCStrobe <= false;
			CRCData <= LLStatus.ReadData;

			if not EnableEngine then
				State := WAIT_INT;
				ReceiveIntLatch := false;
				FramePending <= false;
			else
				if ReceiveInt then
					ReceiveIntLatch := true;
				end if;

				if FlushFrame then
					FramePending <= false;
				end if;

				case State is
					when WAIT_INT =>
						if ReceiveIntLatch and not FramePending then
							State := WAIT_ARB;
							ReceiveIntLatch := false;
							TriesLeft := FCS_FAIL_RETRY_COUNT - 1;
						end if;

					when WAIT_ARB =>
						if ArbGrant and not LLStatus.Busy then
							LLControl.Strobe <= true;
							LLControl.RegType <= SHORT;
							LLControl.OpType <= WRITE;
							LLControl.Address <= 16#39#; -- BBREG1
							LLControl.WriteData <= "00000100"; -- RXDECINV = 1
							State := SET_RXDECINV;
						end if;

					when SET_RXDECINV =>
						if not LLStatus.Busy then
							LLControl.Strobe <= true;
							LLControl.RegType <= LONG;
							LLControl.OpType <= READ;
							LLControl.Address <= 16#300#;
							State := READ_LENGTH;
						end if;

					when READ_LENGTH =>
						CRCReset <= true;
						if not LLStatus.Busy then
							PendingFrameLength <= to_integer(unsigned(LLStatus.ReadData)) + 2; -- LQI(1) + RSSI(1)
							LLControl.Strobe <= true;
							LLControl.RegType <= LONG;
							LLControl.OpType <= READ;
							LLControl.Address <= 16#301#;
							ReadOffset := 0;
							State := READ_DATA;
						end if;

					when READ_DATA =>
						if not LLStatus.Busy then
							FrameBufferWritePort.Strobe <= true;
							FrameBufferWritePort.Address <= ReadOffset;
							FrameBufferWritePort.Data <= LLStatus.ReadData;
							ReadOffset := ReadOffset + 1;
							if ReadOffset = PendingFrameLength then
								if CRCZeroTwoBytesAgo then
									ReceiveIRQ <= true;
									FramePending <= true;
									LLControl.Strobe <= true;
									LLControl.RegType <= SHORT;
									LLControl.OpType <= WRITE;
									LLControl.Address <= 16#39#; -- BBREG1
									LLControl.WriteData <= "00000000"; -- RXDECINV = 0
									State := WAIT_INT;
								elsif TriesLeft /= 0 then
									TriesLeft := TriesLeft - 1;
									LLControl.Strobe <= true;
									LLControl.RegType <= LONG;
									LLControl.OpType <= READ;
									LLControl.Address <= 16#300#;
									State := READ_LENGTH;
								else
									FCSFailIRQ <= true;
									LLControl.Strobe <= true;
									LLControl.RegType <= SHORT;
									LLControl.OpType <= WRITE;
									LLControl.Address <= 16#39#; -- BBREG1
									LLControl.WriteData <= "00000000"; -- RXDECINV = 0
									State := WAIT_INT;
								end if;
							else
								LLControl.Strobe <= true;
								LLControl.RegType <= LONG;
								LLControl.OpType <= READ;
								LLControl.Address <= 16#301# + ReadOffset;
							end if;
							-- This is two bytes ago, because:
							-- This byte we have only just received and strobed into the CRC module.
							-- The last byte has just appeared in CRCResult and is now being written into CRCZeroTwoBytesAgo.
							-- So when *reading* CRCZeroTwoBytesAgo in this process, we see its value before the write, which was two bytes ago.
							CRCZeroTwoBytesAgo <= CRCResult = X"0000";
							CRCStrobe <= true;
						end if;
				end case;
			end if;
		end if;

		case State is
			when WAIT_INT => ArbRequest <= false;
			when WAIT_ARB => ArbRequest <= true;
			when SET_RXDECINV => ArbRequest <= true;
			when READ_LENGTH => ArbRequest <= true;
			when READ_DATA => ArbRequest <= true;
		end case;
	end process;

	CRC : entity work.MRFCRC(RTL)
	port map(
		Reset => CRCReset,
		Clock => HostClock,
		Data => CRCData,
		Strobe => CRCStrobe,
		CRC => CRCResult,
		Busy => CRCBusy);
end architecture RTL;
