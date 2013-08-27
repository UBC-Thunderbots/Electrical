library grlib;
library ieee;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.amba.all;
use work.types.all;

entity MRF is
	generic(
		hindex : in natural;
		pindex : in natural;
		paddr : in natural range 0 to 16#FFF#;
		pmask : in natural range 0 to 16#FFF#);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		ahbmi : in grlib.amba.ahb_mst_in_type;
		ahbmo : out grlib.amba.ahb_mst_out_type;
		apbi : in grlib.amba.apb_slv_in_type;
		apbo : buffer grlib.amba.apb_slv_out_type;
		BusClock : in std_ulogic;
		CSPin : buffer std_ulogic;
		ClockOE : buffer boolean;
		MOSIPin : buffer std_ulogic;
		MISOPin : in std_ulogic;
		ResetPin : buffer std_ulogic;
		WakePin : buffer std_ulogic;
		InterruptPin : in std_ulogic);
end entity MRF;

architecture RTL of MRF is
	-- Signals between the APB module and the MRF module.
	signal Write, LongAddress : boolean;
	signal AddressLatch : unsigned(9 downto 0);
	signal WriteDataLatch : std_ulogic_vector(7 downto 0);
	signal MRFStrobe, MRFBusy : boolean;

	-- Signals between the MRF module and the SPI transceiver.
	signal SPIStrobe, SPIBusy : boolean;
	signal SPIWidth : positive range 1 to 24;
	signal SPIWriteData, SPIReadData : std_ulogic_vector(23 downto 0);

	-- Signals used internally in the APB module.
	signal RegisterNumber : natural range 0 to 7;
	type dma_state_t is (IDLE, MRF, AHB_REQUEST, AHB_ADDRESS, AHB_DATA);
	signal DMAState : dma_state_t;
	signal DMAError : boolean;
	signal DMAAddress : unsigned(31 downto 0);
	signal DMALength : unsigned(23 downto 0);
	signal DMABuffer : std_ulogic_vector(7 downto 0);

	-- Signals used internally in the MRF module.
	type mrf_state_t is (IDLE, ACTIVE);
	signal MRFState : mrf_state_t;
	signal CS, CSDelayed : boolean;
begin
	-- Handle AHB constants
	ahbmo.hlock <= '0';
	ahbmo.hsize <= "000";
	ahbmo.hburst <= "000";
	ahbmo.hprot <= "1101";
	ahbmo.hirq <= (others => '0');
	ahbmo.hconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_MRF, 0, 0, 0),
		others => X"00000000");
	ahbmo.hindex <= hindex;

	-- Handle APB constants
	apbo.pconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_MRF, 0, 0, 0),
		1 => grlib.amba.apb_iobar(paddr, pmask));
	apbo.pindex <= pindex;
	apbo.pirq <= (others => '0');

	-- Decode a register number from an APB address
	RegisterNumber <= to_integer(unsigned(apbi.paddr(4 downto 2)));

	-- Handle APB reads
	process(RegisterNumber, ResetPin, WakePin, InterruptPin, MRFBusy, Write, LongAddress, DMAState, DMAError, SPIReadData, AddressLatch, DMAAddress, DMALength) is
	begin
		apbo.prdata <= X"00000000";
		case RegisterNumber is
			when 0 =>
				apbo.prdata(0) <= not ResetPin;
				apbo.prdata(1) <= WakePin;
				apbo.prdata(2) <= InterruptPin;
				apbo.prdata(3) <= to_stdulogic(MRFBusy);
				apbo.prdata(4) <= to_stdulogic(Write);
				apbo.prdata(5) <= to_stdulogic(LongAddress);
				apbo.prdata(6) <= to_stdulogic(DMAState /= IDLE);
				apbo.prdata(7) <= to_stdulogic(DMAError);

			when 1 =>
				apbo.prdata(7 downto 0) <= std_logic_vector(SPIReadData(7 downto 0));

			when 2 =>
				apbo.prdata(AddressLatch'range) <= std_logic_vector(AddressLatch);

			when 3 =>
				apbo.prdata <= std_logic_vector(DMAAddress);

			when 4 =>
				apbo.prdata <= std_logic_vector(resize(DMALength, 32));

			when others =>
				null;
		end case;
	end process;

	-- Handle APB writes and DMA operations
	process(clk) is
	begin
		if rising_edge(clk) then
			-- Handle APB writes
			MRFStrobe <= false;
			if rst = '0' then
				ResetPin <= '1';
				WakePin <= '0';
				DMAState <= IDLE;
				DMAError <= false;
			else
				if apbi.penable = '1' and apbi.psel(pindex) = '1' and apbi.pwrite = '1' then
					case RegisterNumber is
						when 0 =>
							ResetPin <= not apbi.pwdata(0);
							WakePin <= apbi.pwdata(1);
							MRFStrobe <= to_boolean(apbi.pwdata(3));
							Write <= to_boolean(apbi.pwdata(4));
							LongAddress <= to_boolean(apbi.pwdata(5));
							if apbi.pwdata(6) = '1' and DMALength /= 0 then
								if apbi.pwdata(4) = '1' then
									-- Write operations start by reading on the AHB, then write on the MRF.
									DMAState <= AHB_REQUEST;
									-- While doing an AHB read, we expect AddressLatch to be one less than the byte being read from the AHB, for pipelining.
									AddressLatch <= AddressLatch - 1;
								else
									-- Read operations start by reading on the MRF, then write on the AHB.
									DMAState <= MRF;
									MRFStrobe <= true;
								end if;
								DMAError <= false;
							end if;

						when 1 =>
							WriteDataLatch <= std_ulogic_vector(apbi.pwdata(7 downto 0));

						when 2 =>
							AddressLatch <= unsigned(apbi.pwdata(AddressLatch'range));

						when 3 =>
							DMAAddress <= unsigned(apbi.pwdata);

						when 4 =>
							DMALength <= resize(unsigned(apbi.pwdata), DMALength'length);

						when others =>
							null;
					end case;
				end if;
			end if;

			-- Handle DMA operations
			if rst = '0' then
				null;
			elsif Write then
				case DMAState is
					when IDLE =>
						null;

					when AHB_REQUEST =>
						if ahbmi.hgrant(hindex) = '1' and ahbmi.hready = '1' then
							DMAState <= AHB_ADDRESS;
						end if;

					when AHB_ADDRESS =>
						if ahbmi.hready = '1' then
							DMAState <= AHB_DATA;
						end if;

					when AHB_DATA =>
						case DMAAddress(1 downto 0) is
							when "00" => DMABuffer <= std_ulogic_vector(ahbmi.hrdata(31 downto 24));
							when "01" => DMABuffer <= std_ulogic_vector(ahbmi.hrdata(23 downto 16));
							when "10" => DMABuffer <= std_ulogic_vector(ahbmi.hrdata(15 downto 8));
							when "11" => DMABuffer <= std_ulogic_vector(ahbmi.hrdata(7 downto 0));
							when others => null;
						end case;
						if ahbmi.hready = '1' then
							case ahbmi.hresp is
								when "00" => -- OKAY
									DMAAddress <= DMAAddress + 1;
									DMALength <= DMALength - 1;
									DMAState <= MRF;

								when "01" => -- ERROR
									DMAState <= IDLE;
									DMAError <= true;

								when others => -- RETRY, SPLIT
									DMAState <= AHB_REQUEST;
							end case;
						end if;

					when MRF =>
						-- We might or might not still be doing MRF business for byte DMAAddress - 2.
						-- The byte we just read from the AHB was at DMAAddress - 1.
						-- DMALength has been updated to match DMAAddress.
						-- AddressLatch and WriteDataLatch are appropriate for DMAAddress - 2, in case operation was still ongoing.
						if not MRFBusy then
							-- The MRF has finished with byte DMAAddress - 2, so set everything MRF-side up to run byte DMAAddress - 1.
							AddressLatch <= AddressLatch + 1;
							WriteDataLatch <= DMABuffer;
							MRFStrobe <= true;
							if DMALength = 0 then
								DMAState <= IDLE;
							else
								DMAState <= AHB_REQUEST;
							end if;
						end if;
				end case;
			else
				case DMAState is
					when IDLE =>
						null;

					when MRF =>
						if not MRFBusy then
							DMAState <= AHB_REQUEST;
							-- If we will need any more bytes after this one, might as well get started early!
							if DMALength /= 1 then
								MRFStrobe <= true;
								AddressLatch <= AddressLatch + 1;
							end if;
							DMABuffer <= SPIReadData(7 downto 0);
						end if;

					when AHB_REQUEST =>
						if ahbmi.hgrant(hindex) = '1' and ahbmi.hready = '1' then
							DMAState <= AHB_ADDRESS;
						end if;

					when AHB_ADDRESS =>
						if ahbmi.hready = '1' then
							DMAState <= AHB_DATA;
						end if;

					when AHB_DATA =>
						if ahbmi.hready = '1' then
							case ahbmi.hresp is
								when "00" => -- OKAY
									if DMALength = to_unsigned(1, DMALength'length) then
										DMAState <= IDLE;
									else
										DMAState <= MRF;
									end if;
									DMAAddress <= DMAAddress + 1;
									DMALength <= DMALength - 1;

								when "01" => -- ERROR
									DMAState <= IDLE;
									DMAError <= true;

								when others => -- RETRY, SPLIT
									DMAState <= AHB_REQUEST;
							end case;
						end if;
				end case;
			end if;
		end if;
	end process;
	ahbmo.hbusreq <= '1' when DMAState = AHB_REQUEST else '0';
	ahbmo.haddr <= std_logic_vector(DMAAddress);
	ahbmo.htrans <= "10" when DMAState = AHB_ADDRESS else "00";
	ahbmo.hwrite <= '0' when Write else '1'; -- This is inverted because Write refers to the MRF sense, which is the opposite of the AHB sense.
	ahbmo.hwdata <= std_logic_vector(DMABuffer & DMABuffer & DMABuffer & DMABuffer);

	-- MRF module
	process(clk) is
	begin
		if rising_edge(clk) then
			SPIStrobe <= false;

			if rst = '0' then
				MRFState <= IDLE;
				CS <= false;
			elsif not SPIBusy and CS = CSDelayed then
				case MRFState is
					when IDLE =>
						if MRFStrobe then
							CS <= true;
						elsif CS then
							SPIStrobe <= true;
							if LongAddress then
								SPIWriteData <= '1' & std_ulogic_vector(AddressLatch) & to_stdulogic(Write) & "0000" & WriteDataLatch;
							else
								SPIWriteData <= '0' & std_ulogic_vector(AddressLatch(5 downto 0)) & to_stdulogic(Write) & WriteDataLatch & X"00";
							end if;
							MRFState <= ACTIVE;
						end if;

					when ACTIVE =>
						CS <= false;
						MRFState <= IDLE;
				end case;
			end if;
		end if;
	end process;
	SPIWidth <= 24 when LongAddress else 16;
	-- Generate a two-bus-clock-delayed version of CS, explained below.
	process(BusClock) is
		variable Temp : boolean := false;
	begin
		if rising_edge(BusClock) then
			CSDelayed <= Temp;
			Temp := CS;
		end if;
	end process;
	-- On asserting edge, state machine asserts CS, pin asserts immediately, CSDelayed holds off state machine for chip setup time.
	-- On deasserting edge, state machine deasserts CS, pin deassertion is delayed for chip hold time.
	CSPin <= '0' when (CS or CSDelayed) else '1';
	MRFBusy <= SPIBusy or MRFState /= IDLE or CS or CSDelayed or MRFStrobe;

	-- SPI transceiver
	SPI : entity work.SPI(RTL)
	generic map(
		MaxWidth => 24)
	port map(
		rst => rst,
		HostClock => clk,
		BusClock => BusClock,
		Strobe => SPIStrobe,
		Width => SPIWidth,
		WriteData => SPIWriteData,
		ReadData => SPIReadData,
		Busy => SPIBusy,
		ClockOE => ClockOE,
		MOSIPin => MOSIPin,
		MISOPin => MISOPin);
end architecture RTL;
