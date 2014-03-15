library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity SPISlave is
	generic(
		GENERATOR_POLYNOMIAL : natural := 16#07#; --Value of the generator polynomial in normal form
		RESET_VALUE : natural := 16#00#; --The value that the CRC should be reset to
		CRC_OK_VALUE : natural := 16#00#); --This is the value that the CRC when checked correct takes on.
	port(
		HostClock : in std_ulogic;
		BusClock : in std_ulogic;

		CSLine : in std_ulogic;
		
		Input : in SPIInput_t;
		Output : buffer SPIOutput_t;
		
		MOSIPin : in std_ulogic;
		MISOPin : buffer std_ulogic);
end entity SPISlave;

architecture RTL of SPISlave is
begin

	receive_unit : entity work.SPISlaveReceiver
		generic map (GENERATOR_POLYNOMIAL => GENERATOR_POLYNOMIAL, RESET_VALUE => RESET_VALUE, CRC_OK_VALUE => CRC_OK_VALUE)
		port map (HostClock => HostClock, BusClock => BusClock, CSLine => CSLine, Data => Output.ReadData,Strobe => Output.ReadStrobe,CRCOk => Output.ReadCRCOk,First => Output.ReadFirst, MOSIpin => MOSIpin);

	transmit_unit : entity work.SPISlaveTransmitter
		generic map (GENERATOR_POLYNOMIAL => GENERATOR_POLYNOMIAL, RESET_VALUE => RESET_VALUE, CRC_OK_VALUE => CRC_OK_VALUE)
		port map (HostClock => HostClock, BusClock => BusClock, CSLine => CSLine, Data => Input.WriteData,Strobe => Input.WriteStrobe,SendCRC => Input.WriteCRC,Ready => Output.WriteReady, MISOpin => MISOpin);
	
end architecture RTL;
