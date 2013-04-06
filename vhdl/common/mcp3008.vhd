library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.clock.all;
use work.types.all;

entity MCP3008 is
	port(
		Clocks : in clocks_t;
		MOSI : out std_ulogic := '0';
		MISO : in std_ulogic;
		CLK : out std_ulogic := '0';
		CS : out std_ulogic := '1';
		Levels : out mcp3008s_t := (others => 0));
end entity MCP3008;

architecture Arch of MCP3008 is
	type channel_sequence_t is array(natural range <>) of natural;
	constant ChannelSequence : channel_sequence_t := (0, 1, 5, 6, 7);
begin
	process(Clocks.Clock4MHz) is
		variable Subtick : boolean := false;
		subtype bit_count_t is natural range 0 to 16;
		variable CLKInternal : boolean := false;
		variable CSInternal : boolean := false;
		variable BitCount : bit_count_t := 0;
		variable MISOLatch : std_ulogic := '0';
		variable DataOut : std_ulogic_vector(4 downto 0);
		variable DataIn : std_ulogic_vector(9 downto 0);
		variable ChannelSequenceIndex : natural range ChannelSequence'range := 0;
	begin
		if rising_edge(Clocks.Clock4MHz) then
			if Subtick then
				if not CSInternal then
					CSInternal := true;
					DataOut := "11" & std_ulogic_vector(to_unsigned(ChannelSequence(ChannelSequenceIndex), 3));
				elsif not CLKInternal then
					CLKInternal := true;
					MISOLatch := MISO;
				else
					CLKInternal := false;
					DataIn := DataIn(8 downto 0) & MISOLatch;
					DataOut := DataOut(3 downto 0) & '0';
					if BitCount = bit_count_t'high then
						BitCount := 0;
						CSInternal := false;
						Levels(ChannelSequence(ChannelSequenceIndex)) <= to_integer(unsigned(DataIn));
						ChannelSequenceIndex := (ChannelSequenceIndex + 1) mod ChannelSequence'length;
					else
						BitCount := BitCount + 1;
					end if;
				end if;
			end if;
			Subtick := not Subtick;
		end if;

		CS <= to_stdulogic(not CSInternal);
		CLK <= to_stdulogic(CLKInternal);
		MOSI <= DataOut(4);
	end process;
end architecture Arch;
