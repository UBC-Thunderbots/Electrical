library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity MCP3008 is
	port(
		rst : in std_ulogic;
		BusClock : in std_ulogic;
		CSPin : buffer std_ulogic;
		ClockOE : buffer boolean;
		MOSIPin : buffer std_ulogic;
		MISOPin : in std_ulogic;
		Levels : buffer mcp3008s_t);
end entity MCP3008;

architecture RTL of MCP3008 is
	type channel_sequence_t is array(natural range <>) of natural;
	constant ChannelSequence : channel_sequence_t := (0, 1, 7, 5, 6, 7);

	-- Signals between the scheduler and the SPI transceiver
	signal SPIStrobe, SPIBusy : boolean;
	signal SPIReadData, SPIWriteData : std_ulogic_vector(16 downto 0);

	-- Signals used internally in the scheduler
	signal ChannelSequenceIndex : natural range ChannelSequence'range;
begin
	process(BusClock) is
	begin
		if rising_edge(BusClock) then
			SPIStrobe <= false;
			for I in Levels'range loop
				Levels(I).Strobe <= false;
			end loop;
			if rst = '0' then
				CSPin <= '1';
				ChannelSequenceIndex <= 0;
				Levels <= (others => (Value => 0, Strobe => false));
			elsif CSPin = '1' then
				CSPin <= '0';
				SPIStrobe <= true;
			elsif not SPIBusy then
				Levels(ChannelSequence(ChannelSequenceIndex)).Value <= to_integer(unsigned(SPIReadData(9 downto 0)));
				Levels(ChannelSequence(ChannelSequenceIndex)).Strobe <= true;
				ChannelSequenceIndex <= (ChannelSequenceIndex + 1) mod (ChannelSequence'high + 1);
				CSPin <= '1';
			end if;
		end if;
	end process;
	SPIWriteData(16) <= '1'; -- Start bit
	SPIWriteData(15) <= '1'; -- Single-ended mode
	SPIWriteData(14 downto 12) <= std_ulogic_vector(to_unsigned(ChannelSequence(ChannelSequenceIndex), 3)); -- Channel number
	SPIWriteData(11 downto 10) <= "00"; -- Sampling time plus null bit
	SPIWriteData(9 downto 0) <= "0000000000"; -- ADC reading bits

	SPI : entity work.SPI(RTL)
	generic map(
		MaxWidth => 17)
	port map(
		rst => rst,
		HostClock => BusClock,
		BusClock => BusClock,
		Strobe => SPIStrobe,
		Width => 17,
		WriteData => SPIWriteData,
		ReadData => SPIReadData,
		Busy => SPIBusy,
		ClockOE => ClockOE,
		MOSIPin => MOSIPin,
		MISOPin => MISOPin);
--	process(Clocks.Clock4MHz) is
--		variable Subtick : boolean := false;
--		subtype bit_count_t is natural range 0 to 16;
--		variable CLKInternal : boolean := false;
--		variable CSInternal : boolean := false;
--		variable BitCount : bit_count_t := 0;
--		variable MISOLatch : std_ulogic := '0';
--		variable DataOut : std_ulogic_vector(4 downto 0);
--		variable DataIn : std_ulogic_vector(9 downto 0);
--		variable ChannelSequenceIndex : natural range ChannelSequence'range := 0;
--	begin
--		if rising_edge(Clocks.Clock4MHz) then
--			for I in Levels'range loop
--				Levels(I).Strobe <= false;
--			end loop;
--			if Subtick then
--				if not CSInternal then
--					CSInternal := true;
--					DataOut := "11" & std_ulogic_vector(to_unsigned(ChannelSequence(ChannelSequenceIndex), 3));
--				elsif not CLKInternal then
--					CLKInternal := true;
--					MISOLatch := MISO;
--				else
--					CLKInternal := false;
--					DataIn := DataIn(8 downto 0) & MISOLatch;
--					DataOut := DataOut(3 downto 0) & '0';
--					if BitCount = bit_count_t'high then
--						BitCount := 0;
--						CSInternal := false;
--						Levels(ChannelSequence(ChannelSequenceIndex)).Value <= to_integer(unsigned(DataIn));
--						Levels(ChannelSequence(ChannelSequenceIndex)).Strobe <= true;
--						ChannelSequenceIndex := (ChannelSequenceIndex + 1) mod ChannelSequence'length;
--					else
--						BitCount := BitCount + 1;
--					end if;
--				end if;
--			end if;
--			Subtick := not Subtick;
--		end if;
--
--		CS <= to_stdulogic(not CSInternal);
--		CLK <= to_stdulogic(CLKInternal);
--		MOSI <= DataOut(4);
--	end process;
end architecture RTL;
