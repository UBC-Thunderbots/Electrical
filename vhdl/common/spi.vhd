library ieee;
library unisim;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use work.types.all;

entity SPI is
	port(
		HostClock : in std_ulogic;
		BusClock : in std_ulogic;
		BusClockI : in std_ulogic;
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
	signal ReadShifter : std_ulogic_vector(7 downto 0) := X"00";
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
		C0 => BusClock,
		C1 => BusClockI,
		CE => to_stdulogic(ClockEnable),
		R => '0',
		S => '0',
		Q => ClockPin);

	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			if Strobe then
				DataWriteStrobeX <= not DataWriteStrobeY;
			end if;
		end if;
	end process;

	process(BusClock) is
		variable ReadBitCount : natural range 0 to 7 := 0;
		variable WriteBitCount : natural range 0 to 7 := 0;
	begin
		if rising_edge(BusClock) then
			if ReadBitCount /= 0 then
				ReadShifter <= ReadShifter(6 downto 0) & MISOPin;
				ReadBitCount := ReadBitCount - 1;
			end if;
			if DataWriteStrobeY /= DataWriteStrobeZ then
				ReadBitCount := 7;
				DataWriteStrobeZ <= DataWriteStrobeY;
				ReadShifter <= ReadShifter(6 downto 0) & MISOPin;
			end if;
		end if;
		if falling_edge(BusClock) then
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
	Busy <= Strobe or (DataWriteStrobeX /= DataWriteStrobeY) or (DataWriteStrobeX /= DataWriteStrobeZ) or ClockEnable;
	ReadData <= ReadShifter;
end architecture Arch;
