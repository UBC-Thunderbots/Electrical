library grlib;
library ieee;
use grlib.amba;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.amba.all;
use work.types.all;

entity SPIFlash is
	generic(
		hindex : in natural;
		hmaddr : in natural range 0 to 16#FFF#;
		hmmask : in natural range 0 to 16#FFF#;
		hiaddr : in natural range 0 to 16#FFF#;
		himask : in natural range 0 to 16#FFF#);
	port(
		rst : in std_ulogic;
		clk : in std_ulogic;
		ahbsi : in grlib.amba.ahb_slv_in_type;
		ahbso : buffer grlib.amba.ahb_slv_out_type;
		CS : buffer boolean;
		ClockOE : buffer boolean;
		MOSIIn : in std_ulogic;
		MOSIOut : buffer std_ulogic;
		MOSIOE : buffer boolean;
		MISOIn : in std_ulogic;
		MISOOut : buffer std_ulogic;
		MISOOE : buffer boolean);
end entity SPIFlash;

architecture RTL of SPIFlash is
	-- Signals between the AHB module and the ROM module.
	type rom_req_t is record
		Active : boolean;
		Address : unsigned(20 downto 0);
		Size : std_ulogic_vector(2 downto 0);
	end record;
	type rom_resp_t is record
		WordAddress : unsigned(20 downto 2);
		ByteLanes : std_ulogic_vector(3 downto 0);
		Data : std_ulogic_vector(31 downto 0);
	end record;
	signal ROMReq : rom_req_t;
	signal ROMResp : rom_resp_t;

	-- Signals from the AHB module to the arbiter, used in user mode.
	signal UserCS, UserStrobe, UserMOSIOE, UserMISOOE : boolean;
	signal UserWriteData : std_ulogic_vector(7 downto 0);

	-- Signals from the ROM module to the arbiter, used in ROM mode.
	signal ROMCS, ROMStrobe, ROMMOSIOE, ROMMISOOE : boolean;
	signal ROMWriteData : std_ulogic_vector(7 downto 0);

	-- Signals from the arbiter to the SPI transceiver.
	signal Strobe : boolean;
	signal WriteData : std_ulogic_vector(7 downto 0);

	-- Configuration signals.
	signal DualSpeed, ROMMode : boolean;

	-- Status signals.
	signal Busy : boolean;

	-- Signals used internally in the AHB module.
	signal WasWriteControl, WasWriteData, WasExtraCycle : boolean;

	-- Signals used internally in the ROM module.
	type rom_state_t is (
		SEND_ADDRESS_MIDDLE,
		SEND_ADDRESS_LOWER,
		SEND_MODE,
		START_DATA_PUMP,
		RECEIVE_DATA);
	signal ROMState : rom_state_t;
	signal ROMRxAddress : unsigned(20 downto 0);

	-- Signals used internally in the SPI transceiver, plus the data output from the SPI transceiver to the AHB and ROM modules.
	signal Shifter : std_ulogic_vector(7 downto 0);
	signal ShiftCount : natural range 0 to 8;
	signal ShifterInputBufferMOSI, ShifterInputBufferMISO : std_ulogic;

	-- Returns the byte lane for an address.
	subtype byte_lane_t is natural range 0 to 3;
	pure function ByteLane(constant Address : in unsigned(20 downto 0)) return byte_lane_t is
	begin
		return 3 - to_integer(Address(1 downto 0));
	end function ByteLane;

	-- Returns the word address for a byte address.
	subtype word_address_t is unsigned(20 downto 2);
	pure function WordAddress(constant Address : in unsigned(20 downto 0)) return word_address_t is
	begin
		return Address(20 downto 2);
	end function WordAddress;

	-- Checks whether all bytes needed for an AHB transfer are ready in the ROM fetched data record.
	pure function ROMDone(constant Req : in rom_req_t; constant Resp : in rom_resp_t) return boolean is
		variable ReqByteLanes : std_ulogic_vector(3 downto 0);
	begin
		ReqByteLanes := "0000";
		case Req.Size is
			when "000" => ReqByteLanes(ByteLane(Req.Address)) := '1';
			when "001" => ReqByteLanes(ByteLane(Req.Address) downto ByteLane(Req.Address) - 1) := "11";
			when others => ReqByteLanes := "1111";
		end case;
		return Resp.WordAddress = WordAddress(Req.Address) and ((ReqByteLanes and Resp.ByteLanes) = ReqByteLanes);
	end function ROMDone;
begin
	-- AHB module
	ahbso.hsplit <= (others => '0');
	ahbso.hirq <= (others => '0');
	ahbso.hconfig <= (
		0 => grlib.amba.ahb_device_reg(VENDOR_ID_THUNDERBOTS, DEVICE_ID_SPIFLASH, 0, 0, 0),
		4 => grlib.amba.ahb_membar(hmaddr, '1', '1', hmmask),
		5 => grlib.amba.ahb_iobar(hiaddr, himask),
		others => (others => '0'));
	ahbso.hindex <= hindex;
	process(clk) is
		variable NewROMReq : rom_req_t;
		variable RegisterNumber : natural range 0 to 1;
	begin
		if rising_edge(clk) then
			if not WasExtraCycle then
				ahbso.hresp <= "00";
			end if;
			ahbso.hready <= '1';
			ahbso.hrdata <= X"00000000";
			UserStrobe <= false;
			WasWriteControl <= false;
			WasWriteData <= false;
			WasExtraCycle <= false;
			if rst = '0' then
				ROMReq.Active <= false;
				UserCS <= false;
				UserMOSIOE <= false;
				UserMISOOE <= false;
				DualSpeed <= false;
				ROMMode <= false;
			else
				if WasWriteControl then
					UserCS <= to_boolean(ahbsi.hwdata(0));
					UserMOSIOE <= to_boolean(ahbsi.hwdata(1));
					UserMISOOE <= to_boolean(ahbsi.hwdata(2));
					DualSpeed <= to_boolean(ahbsi.hwdata(3));
					ROMMode <= to_boolean(ahbsi.hwdata(4));
				elsif WasWriteData then
					UserWriteData <= std_ulogic_vector(ahbsi.hwdata(7 downto 0));
					UserStrobe <= true;
				elsif ROMReq.Active then
					if ROMDone(ROMReq, ROMResp) then
						ahbso.hrdata <= std_logic_vector(ROMResp.Data);
						ROMReq.Active <= false;
					else
						ahbso.hready <= '0';
					end if;
				else
					if ahbsi.hsel(hindex) = '1' and ahbsi.hready = '1' and ahbsi.htrans(1) = '1' then
						if ahbsi.hmbsel(0) = '1' then
							-- Access to ROM area
							if ROMMode and ahbsi.hwrite = '0' then
								if ahbsi.hsize = "000" or ahbsi.hsize = "001" or ahbsi.hsize = "010" then
									NewROMReq.Active := true;
									NewROMReq.Address := unsigned(ahbsi.haddr(20 downto 0));
									NewROMReq.Size := std_ulogic_vector(ahbsi.hsize);
									ROMReq <= NewROMReq;
									if ROMDone(NewROMReq, ROMResp) then
										ahbso.hrdata <= std_logic_vector(ROMResp.Data);
										ROMReq.Active <= false;
									else
										ahbso.hready <= '0';
									end if;
								else
									ahbso.hresp <= "01";
									ahbso.hready <= '0';
									WasExtraCycle <= true;
								end if;
							else
								ahbso.hresp <= "01";
								ahbso.hready <= '0';
								WasExtraCycle <= true;
							end if;
						else
							-- Access to control registers
							RegisterNumber := to_integer(unsigned(ahbsi.haddr(2 downto 2)));
							if RegisterNumber = 0 then
								ahbso.hrdata <= (others => '0');
								ahbso.hrdata(0) <= to_stdulogic(UserCS);
								ahbso.hrdata(1) <= to_stdulogic(UserMOSIOE);
								ahbso.hrdata(2) <= to_stdulogic(UserMISOOE);
								ahbso.hrdata(3) <= to_stdulogic(DualSpeed);
								ahbso.hrdata(4) <= to_stdulogic(ROMMode);
								ahbso.hrdata(5) <= to_stdulogic(Busy);
								if ahbsi.hwrite = '1' then
									WasWriteControl <= true;
								end if;
							elsif RegisterNumber = 1 then
								if ROMMode then
									ahbso.hresp <= "01";
									ahbso.hready <= '0';
									WasExtraCycle <= true;
								else
									ahbso.hrdata <= (others => '0');
									ahbso.hrdata(7 downto 0) <= std_logic_vector(Shifter);
									if ahbsi.hwrite = '1' then
										WasWriteData <= true;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	-- ROM module
	process(clk) is
		variable PredictedAddress : unsigned(20 downto 0);
		variable NewTransaction : boolean;
	begin
		if rising_edge(clk) then
			ROMStrobe <= false;
			ROMWriteData <= X"00";
			if not ROMMode then
				ROMResp.ByteLanes <= "0000";
				ROMCS <= false;
			else
				if not Busy then
					if not ROMCS then
						if ROMReq.Active and not ROMDone(ROMReq, ROMResp) then
							ROMCS <= true;
							ROMResp.WordAddress <= WordAddress(ROMReq.Address);
							ROMResp.ByteLanes <= "0000";
							ROMRxAddress <= ROMReq.Address;
							ROMStrobe <= true;
							ROMWriteData <= "000" & std_ulogic_vector(ROMReq.Address(20 downto 16));
							ROMState <= SEND_ADDRESS_MIDDLE;
						end if;
					else
						ROMStrobe <= true;
						case ROMState is
							when SEND_ADDRESS_MIDDLE =>
								ROMWriteData <= std_ulogic_vector(ROMRxAddress(15 downto 8));
								ROMState <= SEND_ADDRESS_LOWER;
							when SEND_ADDRESS_LOWER =>
								ROMWriteData <= std_ulogic_vector(ROMRxAddress(7 downto 0));
								ROMState <= SEND_MODE;
							when SEND_MODE =>
								ROMWriteData <= X"A0";
								ROMState <= START_DATA_PUMP;
							when START_DATA_PUMP =>
								ROMState <= RECEIVE_DATA;
							when RECEIVE_DATA =>
								-- Make a prediction on the next address to be requested after the current one.
								-- Based on spatial locality, assume the next access will immediately follow this one.
								-- Assume it will increment by the size of the most recent request.
								case ROMReq.Size is
									when "000" => PredictedAddress := ROMReq.Address + 1;
									when "001" => PredictedAddress := ROMReq.Address + 2;
									when others => PredictedAddress := ROMReq.Address + 4;
								end case;

								-- Decide what to do with the data just received from the transceiver.
								if WordAddress(ROMRxAddress) = ROMResp.WordAddress then
									-- The data we just received adds to the current word.
									-- There is no possible harm in presenting it immediately.
									-- It will just complete more byte lanes.
									ROMResp.ByteLanes(ByteLane(ROMRxAddress)) <= '1';
									ROMResp.Data(ByteLane(ROMRxAddress) * 8 + 7 downto ByteLane(ROMRxAddress) * 8) <= Shifter;
									ROMRxAddress <= ROMRxAddress + 1;
								elsif WordAddress(ROMRxAddress) = WordAddress(PredictedAddress) or ROMReq.Active then
									-- One of two cases is true:
									--
									-- Case 1:
									-- The data we just received contributes to the request we predict will be next.
									-- However, it is not part of the currently requested word.
									-- Is it safe to destroy the current response and start a new one?
									-- Yes.
									-- The instant the response had enough data in it to satisfy the request, on the next clock edge, the AHB module would have grabbed the data.
									-- By the time we get here, there is no way the AHB module still needs the data in the request.
									-- So, we can safely destroy it and replace it with prefetched data.
									--
									-- Case 2:
									-- A request is currently outstanding.
									-- If it were the first request that started a transaction, no problem, we would take the first conditional branch above.
									-- However, maybe it's a subsequent request, and it wasn't satisfied yet.
									-- However, maybe we decided below that it wasn't appropriate to start a new transaction.
									-- In that case, we should run full speed ahead trying to catch up to the request.
									-- If we have to throw away the current word, so be it: the goal is to reach the requested data ASAP.
									ROMResp.WordAddress <= WordAddress(ROMRxAddress);
									ROMResp.ByteLanes <= "0000";
									ROMResp.ByteLanes(ByteLane(ROMRxAddress)) <= '1';
									ROMResp.Data(ByteLane(ROMRxAddress) * 8 + 7 downto ByteLane(ROMRxAddress) * 8) <= Shifter;
									ROMRxAddress <= ROMRxAddress + 1;
								else
									-- The data we just received contributes to nothing useful.
									-- We should stall the bus here.
									-- Otherwise we'll just charge off into the middle of nowhere prefetching, which does nobody any good.
									ROMStrobe <= false;
								end if;

								-- Decide if we need to start a new transaction.
								if ROMReq.Active then
									NewTransaction := false;
									if WordAddress(ROMReq.Address) < ROMResp.WordAddress then
										-- Requested address is in a lower word than where we are.
										-- There's no way to go backwards, so we need a new transaction.
										NewTransaction := true;
									elsif WordAddress(ROMReq.Address) = ROMResp.WordAddress then
										-- Requested address is in the current word.
										-- However, byte lanes could be an issue.
										-- Specifically, the current word might be missing a byte we need, and never going to get it.
										if ROMResp.ByteLanes(ByteLane(ROMReq.Address)) = '0' then
											-- The byte lane for the requested address has not yet been filled...
											if ROMReq.Address < ROMRxAddress then
												-- ... but we have passed the requested address.
												-- We will never go back there, so we're stuck.
												NewTransaction := true;
											end if;
										end if;
									elsif WordAddress(ROMReq.Address) = ROMResp.WordAddress + 1 then
										-- Requested address is in the next word.
										-- Toggling chip select and clocking out new address and mode bytes would waste a lot of cycles.
										-- Instead, just run forward in memory until we get to the place we want.
										null;
									else
										-- Requested address is significantly higher.
										-- Here, starting a new transaction starts being more efficient again.
										NewTransaction := true;
									end if;
									if NewTransaction then
										ROMCS <= false;
										ROMStrobe <= false;
									end if;
								end if;
						end case;
					end if;
				end if;
			end if;
		end if;
	end process;
	-- ROMState leads the transceiver, so when ROMState = START_DATA_PUMP the transceiver is still sending the mode byte and so lines must be driven.
	ROMMOSIOE <= ROMState /= RECEIVE_DATA;
	ROMMISOOE <= ROMState /= RECEIVE_DATA;

	-- Arbiter module
	CS <= ROMCS when ROMMode else UserCS;
	MOSIOE <= ROMMOSIOE when ROMMode else UserMOSIOE;
	MISOOE <= ROMMISOOE when ROMMode else UserMISOOE;
	Strobe <= ROMStrobe when ROMMode else UserStrobe;
	WriteData <= ROMWriteData when ROMMode else UserWriteData;

	-- SPI transceiver
	process(clk) is
	begin
		if falling_edge(clk) then
			if rst = '0' then
				ShiftCount <= 0;
			elsif Strobe then
				if DualSpeed then
					ShiftCount <= 4;
				else
					ShiftCount <= 8;
				end if;
				Shifter <= WriteData;
			elsif ShiftCount /= 0 then
				ShiftCount <= ShiftCount - 1;
				if DualSpeed then
					Shifter <= Shifter(5 downto 0) & ShifterInputBufferMISO & ShifterInputBufferMOSI;
				else
					Shifter <= Shifter(6 downto 0) & ShifterInputBufferMISO;
				end if;
			end if;
		end if;
		if rising_edge(clk) then
			ShifterInputBufferMISO <= MISOIn;
			ShifterInputBufferMOSI <= MOSIIn;
		end if;
	end process;
	ClockOE <= ShiftCount /= 0;
	Busy <= ShiftCount /= 0;
	MOSIOut <= Shifter(6) when DualSpeed else Shifter(7);
	MISOOut <= Shifter(7);
end architecture RTL;
