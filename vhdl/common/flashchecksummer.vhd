library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.clock.all;
use work.crc16.all;

entity FlashChecksummer is
	port(
		ClockHigh : in std_ulogic;
		Drive : out boolean := true;
		CS : out boolean;
		SPIClock : out boolean;
		MOSI : out std_ulogic;
		MISO : in std_ulogic;
		CRC : out std_ulogic_vector(15 downto 0));
end entity;

architecture Behavioural of FlashChecksummer is
	type strobed_bit_t is record
		Strobe : boolean;
		Value : std_ulogic;
	end record;

	type strobed_byte_t is record
		Strobe : boolean;
		Value : std_ulogic_vector(7 downto 0);
	end record;

	constant ClocksHighPerSPIClock : natural := 2;
	constant SPIClockMidCount : natural := ClocksHighPerSPIClock / 2;
	constant ROMSize : natural := 2 * 1024 * 1024;

	signal TransceiverEnable : boolean := false;
	signal TransceiverToIgnorer : strobed_bit_t := (Strobe => false, Value => '0');
	signal IgnorerToAccumulator : strobed_bit_t := (Strobe => false, Value => '0');
	signal AccumulatorToLimiter : strobed_byte_t := (Strobe => false, Value => X"00");
	signal LimiterToCRC : strobed_byte_t := (Strobe => false, Value => X"00");
begin
	process(ClockHigh) is
		subtype counter_t is natural range 0 to 4 * ClocksHighPerSPIClock - 1;
		variable Counter : counter_t := counter_t'high;
	begin
		if rising_edge(ClockHigh) then
			if Counter /= 0 then
				Counter := Counter - 1;
			end if;
		end if;

		CS <= Counter < ClocksHighPerSPIClock;
		TransceiverEnable <= Counter = 0;
	end process;

	process(ClockHigh) is
		subtype clock_count_t is natural range 0 to ClocksHighPerSPIClock - 1;
		variable ClockCount : clock_count_t := 0;
		variable OutputShifter : std_ulogic_vector(7 downto 0) := X"03"; -- Need to send another 3 bytes for address, but they're all zeroes
	begin
		if rising_edge(ClockHigh) and TransceiverEnable then
			TransceiverToIgnorer.Strobe <= ClockCount = clock_count_t'high / 2;
			TransceiverToIgnorer.Value <= MISO;
			if ClockCount = clock_count_t'high then
				OutputShifter := OutputShifter(6 downto 0) & '0';
			end if;
			ClockCount := (ClockCount + 1) mod (clock_count_t'high + 1);
		end if;

		SPIClock <= ClockCount > clock_count_t'high / 2;
		MOSI <= OutputShifter(7);
	end process;

	process(ClockHigh, TransceiverToIgnorer) is
		subtype ignore_count_t is natural range 0 to 32;
		variable IgnoreCount : ignore_count_t := ignore_count_t'high;
	begin
		if rising_edge(ClockHigh) then
			if TransceiverToIgnorer.Strobe and IgnoreCount /= 0 then
				IgnoreCount := IgnoreCount - 1;
			end if;
		end if;

		IgnorerToAccumulator.Strobe <= TransceiverToIgnorer.Strobe and IgnoreCount = 0;
		IgnorerToAccumulator.Value <= TransceiverToIgnorer.Value;
	end process;

	process(ClockHigh) is
		variable BitCount : natural range 0 to 7 := 0;
	begin
		if rising_edge(ClockHigh) then
			AccumulatorToLimiter.Strobe <= false;
			if IgnorerToAccumulator.Strobe then
				AccumulatorToLimiter.Value <= AccumulatorToLimiter.Value(6 downto 0) & IgnorerToAccumulator.Value;
				if BitCount = 7 then
					AccumulatorToLimiter.Strobe <= true;
				end if;
				BitCount := (BitCount + 1) mod 8;
			end if;
		end if;
	end process;

	process(ClockHigh, AccumulatorToLimiter) is
		variable ByteCount : natural range 0 to ROMSize := ROMSize;
	begin
		if rising_edge(ClockHigh) and AccumulatorToLimiter.Strobe and ByteCount /= 0 then
			ByteCount := ByteCount - 1;
		end if;

		Drive <= ByteCount /= 0;
		LimiterToCRC.Strobe <= AccumulatorToLimiter.Strobe and ByteCount /= 0;
		LimiterToCRC.Value <= AccumulatorToLimiter.Value;
	end process;

	process(ClockHigh) is
		variable CRCBuffer : std_ulogic_vector(15 downto 0) := X"FFFF";
	begin
		if rising_edge(ClockHigh) and LimiterToCRC.Strobe then
			CRCBuffer := CRC16(CRCBuffer, LimiterToCRC.Value);
		end if;

		CRC <= CRCBuffer;
	end process;
end architecture Behavioural;
