library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketTransmitter is
	port(
		Clock : in std_ulogic;

		Start : in std_ulogic;
		Busy : out std_ulogic := '0';

		Address : in std_ulogic_vector(63 downto 0);
		RSSI : in std_ulogic_vector(7 downto 0);
		DribblerSpeed : in unsigned(15 downto 0);
		BatteryLevel : in unsigned(15 downto 0);
		Fault1 : in std_ulogic;
		Fault2 : in std_ulogic;
		Fault3 : in std_ulogic;
		Fault4 : in std_ulogic;
		Fault5 : in std_ulogic;
		CommandAck : in std_ulogic_vector(7 downto 0);

		ByteData : out std_ulogic_vector(7 downto 0) := X"00";
		ByteLoad : out std_ulogic := '0';
		ByteSOP : out std_ulogic := '0';
		ByteBusy : in std_ulogic
	);
end entity XBeePacketTransmitter;

architecture Behavioural of XBeePacketTransmitter is
	type StateType is (Idle, SendSOP, SendLengthMSB, SendLengthLSB, SendData, SendChecksum, PostSend);
	signal State : StateType := Idle;
	signal FaultCount1 : unsigned(3 downto 0) := to_unsigned(0, 4);
	signal FaultCount2 : unsigned(3 downto 0) := to_unsigned(0, 4);
	signal FaultCount3 : unsigned(3 downto 0) := to_unsigned(0, 4);
	signal FaultCount4 : unsigned(3 downto 0) := to_unsigned(0, 4);
	signal FaultCount5 : unsigned(3 downto 0) := to_unsigned(0, 4);
	signal DataLeft : natural range 1 to 21;
	signal Data : std_ulogic_vector(167 downto 0);
	signal Checksum : unsigned(7 downto 0);
begin
	Busy <= '0' when State = Idle and ByteBusy = '0' else '1';

	process(Clock)
		variable AddressByte : natural range 0 to 7;
	begin
		if rising_edge(Clock) then
			-- Clear these in case they aren't assigned later.
			ByteLoad <= '0';
			ByteSOP <= '0';

			if ByteBusy = '0' then
				if State = Idle then
					if Start = '1' then
						State <= SendSOP;
						if Fault1 = '1' then FaultCount1 <= FaultCount1 + 1; end if;
						if Fault2 = '1' then FaultCount2 <= FaultCount2 + 1; end if;
						if Fault3 = '1' then FaultCount3 <= FaultCount3 + 1; end if;
						if Fault4 = '1' then FaultCount4 <= FaultCount4 + 1; end if;
						if Fault5 = '1' then FaultCount5 <= FaultCount5 + 1; end if;
						DataLeft <= 21;
						Data(7 downto 0) <= X"00";
						Data(15 downto 8) <= X"00";
						Data(23 downto 16) <= Address(63 downto 56);
						Data(31 downto 24) <= Address(55 downto 48);
						Data(39 downto 32) <= Address(47 downto 40);
						Data(47 downto 40) <= Address(39 downto 32);
						Data(55 downto 48) <= Address(31 downto 24);
						Data(63 downto 56) <= Address(23 downto 16);
						Data(71 downto 64) <= Address(15 downto 8);
						Data(79 downto 72) <= Address(7 downto 0);
						Data(87 downto 80) <= X"00";
						Data(95 downto 88) <= X"80";
						Data(103 downto 96) <= RSSI;
						Data(119 downto 104) <= std_ulogic_vector(DribblerSpeed);
						Data(135 downto 120) <= std_ulogic_vector(BatteryLevel);
						-- Fault counters are done below.
						Data(167 downto 160) <= CommandAck;
						Checksum <= X"FF";
					end if;
				elsif State = SendSOP then
					State <= SendLengthMSB;
					-- Do these here instead of earlier so we get the new values of these signals.
					Data(139 downto 136) <= std_ulogic_vector(FaultCount1);
					Data(143 downto 140) <= std_ulogic_vector(FaultCount2);
					Data(147 downto 144) <= std_ulogic_vector(FaultCount3);
					Data(151 downto 148) <= std_ulogic_vector(FaultCount4);
					Data(155 downto 152) <= std_ulogic_vector(FaultCount5);
					Data(159 downto 156) <= X"0";
					ByteSOP <= '1';
				elsif State = SendLengthMSB then
					State <= SendLengthLSB;
					ByteData <= X"00";
					ByteLoad <= '1';
				elsif State = SendLengthLSB then
					State <= SendData;
					ByteData <= X"15";
					ByteLoad <= '1';
				elsif State = SendData then
					ByteData <= Data(7 downto 0);
					ByteLoad <= '1';
					Checksum <= Checksum - unsigned(Data(7 downto 0));
					Data <= X"00" & Data(167 downto 8);
					if DataLeft = 1 then
						State <= SendChecksum;
					end if;
					DataLeft <= DataLeft - 1;
				elsif State = SendChecksum then
					ByteData <= std_ulogic_vector(Checksum);
					ByteLoad <= '1';
					State <= PostSend;
				elsif State = PostSend then
					-- This is here to prevent a one-cycle low pulse in Busy.
					State <= Idle;
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
