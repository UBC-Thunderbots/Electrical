library grlib;
library ieee;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.amba.all;
use work.types.all;

entity SD is
	generic(
		hindex : in natural;
		pindex : in natural;
		paddr : in natural range 0 to 16#FFF#;
		pmask : in natural range 0 to 16#FFF#);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		ahbmi : in grlib.amba.ahb_mst_in_type;
		ahbmo : buffer grlib.amba.ahb_mst_out_type;
		apbi : in grlib.amba.apb_slv_in_type;
		apbo : buffer grlib.amba.apb_slv_out_type;
		BusClock : in std_ulogic;
		PresentPin : in std_ulogic;
		CSPin : buffer std_ulogic;
		ClockOE : buffer boolean;
		MOSIPin : buffer std_ulogic;
		MISOPin : in std_ulogic);
end entity SD;

architecture RTL of SD is
	-- Signals between the AHB/APB module and the SPI module
	signal SPIStrobe, SPIBusy : boolean;
	signal SPIReadData, SPIWriteData : std_ulogic_vector(7 downto 0);

	-- Signals between the AHB/APB module and the CRC module
	signal CRCStrobe, CRCClear : boolean;
	signal CRCData : std_ulogic_vector(7 downto 0);
	signal CRC : std_ulogic_vector(15 downto 0);

	-- Signals used internally in the APB module.
	signal RegisterNumber : natural range 0 to 3;
	type dma_state_t is (IDLE, SEND_START_NOP, SEND_START_TOKEN, AHB_REQUEST, AHB_ADDRESS, AHB_DATA, SEND_DATA, SEND_CRC_MSB, SEND_CRC_LSB, SEND_DRT_NOP, RECEIVE_DRT, WAIT_BUSY);
	signal DMAState : dma_state_t;
	signal DMAAddress : unsigned(31 downto 0);
	signal DMALength : unsigned(9 downto 0);
	signal DMAMalformedDRT, DMAInternalError, DMACRCError, DMAAHBError : boolean;
	signal DMABuffer : std_ulogic_vector(7 downto 0);
begin
	-- Handle AHB constants
	ahbmo.hlock <= '0';
	ahbmo.hwrite <= '0';
	ahbmo.hsize <= "000";
	ahbmo.hburst <= "000";
	ahbmo.hprot <= "1101";
	ahbmo.hirq <= (others => '0');
	ahbmo.hconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_SD, 0, 0, 0),
		others => X"00000000");

	-- Handle APB constants
	apbo.pconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_SD, 0, 0, 0),
		1 => grlib.amba.apb_iobar(paddr, pmask));
	apbo.pindex <= pindex;
	apbo.pirq <= (others => '0');

	-- Decode a register number from an APB address
	RegisterNumber <= to_integer(unsigned(apbi.paddr(3 downto 2)));

	-- Handle APB reads
	process(RegisterNumber, SPIBusy, PresentPin, CSPin, DMACRCError, DMAInternalError, DMAMalformedDRT, DMAAHBError, DMAState, SPIReadData, DMAAddress, DMALength) is
	begin
		apbo.prdata <= X"00000000";
		case RegisterNumber is
			when 0 =>
				apbo.prdata(0) <= to_stdulogic(SPIBusy);
				apbo.prdata(1) <= PresentPin;
				apbo.prdata(2) <= CSPin;
				apbo.prdata(3) <= to_stdulogic(DMACRCError);
				apbo.prdata(4) <= to_stdulogic(DMAInternalError);
				apbo.prdata(5) <= to_stdulogic(DMAMalformedDRT);
				apbo.prdata(6) <= to_stdulogic(DMAAHBError);
				apbo.prdata(7) <= to_stdulogic(DMAState /= IDLE);

			when 1 =>
				apbo.prdata(7 downto 0) <= std_logic_vector(SPIReadData);

			when 2 =>
				apbo.prdata <= std_logic_vector(DMAAddress);

			when 3 =>
				apbo.prdata <= std_logic_vector(resize(DMALength, 32));
		end case;
	end process;

	-- Handle APB writes and DMA operations
	process(clk) is
	begin
		if rising_edge(clk) then
			-- Handle APB writes
			SPIStrobe <= false;
			CRCClear <= false;
			CRCStrobe <= false;
			if rst = '0' then
				DMAState <= IDLE;
			else
				if apbi.penable = '1' and apbi.psel(pindex) = '1' and apbi.pwrite = '1' then
					case RegisterNumber is
						when 0 =>
							CSPin <= apbi.pwdata(2);
							if apbi.pwdata(7) = '1' then
								DMAMalformedDRT <= false;
								DMAInternalError <= false;
								DMACRCError <= false;
								DMAAHBError <= false;
								CRCClear <= true;
								if DMALength = 512 then
									DMAState <= SEND_START_NOP;
								else
									DMAAHBError <= true;
									DMAState <= IDLE;
								end if;
							else
								DMAState <= IDLE;
							end if;

						when 1 =>
							SPIWriteData <= std_ulogic_vector(apbi.pwdata(7 downto 0));
							SPIStrobe <= true;

						when 2 =>
							DMAAddress <= unsigned(apbi.pwdata);

						when 3 =>
							DMALength <= resize(unsigned(apbi.pwdata), DMALength'length);
					end case;
				end if;
			end if;

			-- Handle DMA operations
			if rst = '0' then
				null;
			else
				case DMAState is
					when IDLE =>
						null;

					when SEND_START_NOP =>
						if not SPIBusy then
							SPIWriteData <= X"FF";
							SPIStrobe <= true;
							DMAState <= SEND_START_TOKEN;
						end if;

					when SEND_START_TOKEN =>
						if not SPIBusy then
							SPIWriteData <= "11111100";
							SPIStrobe <= true;
							DMAState <= AHB_REQUEST;
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
									DMAState <= SEND_DATA;

								when "01" => -- ERROR
									DMAState <= IDLE;
									DMAAHBError <= true;

								when others => -- RETRY, SPLIT
									DMAState <= AHB_REQUEST;
							end case;
						end if;

					when SEND_DATA =>
						if not SPIBusy then
							SPIWriteData <= DMABuffer;
							SPIStrobe <= true;
							CRCStrobe <= true;
							if DMALength = 0 then
								DMAState <= SEND_CRC_MSB;
							else
								DMAState <= AHB_REQUEST;
							end if;
						end if;

					when SEND_CRC_MSB =>
						if not SPIBusy then
							SPIWriteData <= CRC(15 downto 8);
							SPIStrobe <= true;
							DMAState <= SEND_CRC_LSB;
						end if;

					when SEND_CRC_LSB =>
						if not SPIBusy then
							SPIWriteData <= CRC(7 downto 0);
							SPIStrobe <= true;
							DMAState <= SEND_DRT_NOP;
						end if;

					when SEND_DRT_NOP =>
						if not SPIBusy then
							SPIWriteData <= X"FF";
							SPIStrobe <= true;
							DMAState <= RECEIVE_DRT;
						end if;

					when RECEIVE_DRT =>
						if not SPIBusy then
							if SPIReadData /= X"FF" then
								case SPIReadData(4 downto 0) is
									when "00101" =>
										null; -- Data accepted
									when "01011" =>
										DMACRCError <= true;
									when "01101" =>
										DMAInternalError <= true;
									when others =>
										DMAMalformedDRT <= true;
								end case;
								DMAState <= WAIT_BUSY;
							end if;
							-- Always send 0xFF; either it will be used for another try receiving a DRT, or it will be used to wait for non-busy state.
							SPIWriteData <= X"FF";
							SPIStrobe <= true;
						end if;

					when WAIT_BUSY =>
						if not SPIBusy then
							if SPIReadData = X"00" then
								SPIWriteData <= X"FF";
								SPIStrobe <= true;
							else
								DMAState <= IDLE;
							end if;
						end if;
				end case;
			end if;
		end if;
	end process;
	CRCData <= DMABuffer;
	ahbmo.hbusreq <= '1' when DMAState = AHB_REQUEST else '0';
	ahbmo.haddr <= std_logic_vector(DMAAddress);
	ahbmo.htrans <= "10" when DMAState = AHB_ADDRESS else "00";

	-- CRC generator
	CRC16 : entity work.CRC16(RTL)
	port map(
		Clock => clk,
		Data => CRCData,
		Clear => CRCClear,
		Enable => CRCStrobe,
		Checksum => CRC);

	-- SPI transceiver
	SPI : entity work.SPI(RTL)
	generic map(
		MaxWidth => 8)
	port map(
		rst => rst,
		HostClock => clk,
		BusClock => BusClock,
		Strobe => SPIStrobe,
		Width => 8,
		WriteData => SPIWriteData,
		ReadData => SPIReadData,
		Busy => SPIBusy,
		ClockOE => ClockOE,
		MOSIPin => MOSIPin,
		MISOPin => MISOPin);
end architecture RTL;
