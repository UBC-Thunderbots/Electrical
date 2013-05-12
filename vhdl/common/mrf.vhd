library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity MRF is
	port(
		HostClock : in std_ulogic;
		BusClock : in std_ulogic;
		BusClockI : in std_ulogic;
		WriteData : in std_ulogic_vector(7 downto 0);
		ReadData : out std_ulogic_vector(7 downto 0);
		Address : in std_ulogic_vector(9 downto 0);
		StrobeAddress : in boolean;
		StrobeShortRead : in boolean;
		StrobeLongRead : in boolean;
		StrobeShortWrite : in boolean;
		StrobeLongWrite : in boolean;
		Busy : out boolean;
		CSPin : out std_ulogic;
		ClockPin : out std_ulogic;
		MOSIPin : out std_ulogic;
		MISOPin : in std_ulogic;
		DMAWriteRequest : out dmaw_request_t := (Write => false, Data => X"00");
		DMAWriteResponse : in dmaw_response_t);
end entity MRF;

architecture Arch of MRF is
	type state_t is (IDLE, ADDR_MSB, ADDR_LSB, ADDR_SHORT, DATA, POST_DATA);
	signal State : state_t := IDLE;
	signal Write : boolean;

	signal AddressLatch : std_ulogic_vector(9 downto 0);
	signal CS : boolean := false;
	signal CSDelayed : boolean := false;
	signal SPIStrobe : boolean := false;
	signal SPIBusy : boolean;
	signal SPIReadData : std_ulogic_vector(7 downto 0);
	signal SPIWriteData : std_ulogic_vector(7 downto 0);
begin
	process(HostClock) is
	begin
		if rising_edge(HostClock) then
			SPIStrobe <= false;
			DMAWriteRequest.Write <= false;

			if StrobeAddress then
				AddressLatch <= Address;
			end if;

			if not SPIBusy and CS = CSDelayed then
				case State is
					when IDLE =>
						if StrobeShortRead or StrobeLongRead or StrobeShortWrite or StrobeLongWrite or DMAWriteResponse.Ready then
							CS <= true;
							if StrobeShortRead or StrobeShortWrite then
								State <= ADDR_SHORT;
							else
								State <= ADDR_MSB;
							end if;
							Write <= StrobeShortWrite or StrobeLongWrite;
						end if;

					when ADDR_MSB =>
						SPIStrobe <= true;
						SPIWriteData <= '1' & AddressLatch(9 downto 3);
						State <= ADDR_LSB;

					when ADDR_LSB =>
						SPIStrobe <= true;
						SPIWriteData <= AddressLatch(2 downto 0) & to_stdulogic(Write) & "0000";
						State <= DATA;

					when ADDR_SHORT =>
						SPIStrobe <= true;
						SPIWriteData <= "0" & AddressLatch(5 downto 0) & to_stdulogic(Write);
						State <= DATA;

					when DATA =>
						SPIStrobe <= true;
						SPIWriteData <= WriteData;
						State <= POST_DATA;

					when POST_DATA =>
						CS <= false;
						ReadData <= SPIReadData;
						DMAWriteRequest.Data <= SPIReadData;
						DMAWriteRequest.Write <= DMAWriteResponse.Ready;
						State <= IDLE;
						AddressLatch <= std_ulogic_vector(unsigned(AddressLatch) + 1);
				end case;
			end if;
		end if;
	end process;

	SPI : entity work.SPI(Arch)
	port map(
		HostClock => HostClock,
		BusClock => BusClock,
		BusClockI => BusClockI,
		WriteData => SPIWriteData,
		ReadData => SPIReadData,
		Strobe => SPIStrobe,
		Busy => SPIBusy,
		ClockPin => ClockPin,
		MOSIPin => MOSIPin,
		MISOPin => MISOPin);

	Busy <= SPIBusy or State /= IDLE or CS /= CSDelayed or StrobeShortRead or StrobeLongRead or StrobeShortWrite or StrobeLongWrite;

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
end architecture Arch;
