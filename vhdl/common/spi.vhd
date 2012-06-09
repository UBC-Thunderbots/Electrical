library ieee;
library unisim;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use work.types.all;

entity SPI is
	port(
		Clock : in std_ulogic;
		ClockI : in std_ulogic;
		WriteData : in std_ulogic_vector(7 downto 0);
		ReadData : out std_ulogic_vector(7 downto 0);
		Strobe : in boolean;
		Busy : out boolean;
		ClockPin : out std_ulogic;
		MOSIPin : out std_ulogic;
		MISOPin : in std_ulogic);
end entity SPI;

architecture Arch of SPI is
	signal ClockEnable : boolean := false;
	signal DataRead : std_ulogic_vector(7 downto 0) := X"00";
	signal WriteShifter : std_ulogic_vector(7 downto 0) := X"00";
	signal DataWriteStrobeX : boolean := false;
	signal DataWriteStrobeY : boolean := false;
	signal DataWriteStrobeZ : boolean := false;
begin
	ClockODDR2 : ODDR2
	generic map(
		DDR_ALIGNMENT => "NONE",
		INIT => '0',
		SRTYPE => "SYNC")
	port map(
		D0 => '1',
		D1 => '0',
		C0 => Clock,
		C1 => ClockI,
		CE => to_stdulogic(ClockEnable),
		R => '0',
		S => '0',
		Q => ClockPin);

	process(Clock) is
	begin
		if rising_edge(Clock) then
			if Strobe then
				DataWriteStrobeX <= not DataWriteStrobeY;
			end if;
		end if;
	end process;

	process(Clock, DataWriteStrobeX) is
		variable ReadBitCount : natural range 0 to 7 := 0;
		variable WriteBitCount : natural range 0 to 7 := 0;
	begin
		if rising_edge(Clock) then
			if ReadBitCount /= 0 then
				DataRead <= DataRead(6 downto 0) & MISOPin;
				ReadBitCount := ReadBitCount - 1;
			end if;
			if DataWriteStrobeX /= DataWriteStrobeZ then
				ReadBitCount := 7;
				DataWriteStrobeZ <= DataWriteStrobeX;
				DataRead <= DataRead(6 downto 0) & MISOPin;
			end if;
		end if;
		if falling_edge(Clock) then
			if WriteBitCount /= 0 then
				WriteShifter <= WriteShifter(6 downto 0) & '0';
				WriteBitCount := WriteBitCount - 1;
			else
				ClockEnable <= false;
			end if;
			if DataWriteStrobeX /= DataWriteStrobeY then
				WriteShifter <= WriteData;
				WriteBitCount := 7;
				DataWriteStrobeY <= DataWriteStrobeX;
				ClockEnable <= true;
			end if;
		end if;
	end process;
	MOSIPin <= WriteShifter(7);
	Busy <= (DataWriteStrobeX /= DataWriteStrobeY) or (DataWriteStrobeX /= DataWriteStrobeZ) or ClockEnable;
	ReadData <= DataRead;
end architecture Arch;
