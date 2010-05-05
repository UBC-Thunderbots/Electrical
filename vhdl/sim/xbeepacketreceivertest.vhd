library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XBeePacketReceiverTest is
end entity XBeePacketReceiverTest;

architecture Behavioural of XBeePacketReceiverTest is
	signal Clock1 : std_ulogic := '0';
	signal Clock100 : std_ulogic := '0';
	signal Done : boolean := false;
	constant ReceiveHeaderLength : positive := 1 + 8 + 1 + 1;
	constant RunDataLength : positive := 9;
	constant PayloadLength : positive := ReceiveHeaderLength + RunDataLength;
	type PayloadType is array(0 to PayloadLength - 1) of std_ulogic_vector(7 downto 0);
	constant Payload : PayloadType := (
		X"80", -- API ID
		X"01", X"23", X"45", X"67", X"89", X"AB", X"CD", X"EF", -- Source address
		X"28", -- RSSI
		X"00", -- Options
		X"81", -- Flags
		X"AA", X"AA", X"AA", X"AA", X"AB", X"AC", X"AA", X"AA" -- Speeds and chicker power
	);
	type StateType is (SendSOP, SendLengthMSB, SendLengthLSB, SendPayload, SendChecksum, Idle);
	signal State : StateType := SendSOP;
	signal PayloadIndex : natural range 0 to PayloadLength - 1 := 0;
	signal ByteData : std_ulogic_vector(7 downto 0) := X"00";
	signal ByteStrobe : std_ulogic := '0';
	signal ByteSOP : std_ulogic := '0';
	signal Strobe : std_ulogic;
	signal StrobeCount : natural := 0;
	signal RSSI : std_ulogic_vector(7 downto 0);
	signal FeedbackFlag : std_ulogic;
	signal DirectDriveFlag : std_ulogic;
	signal ControlledDriveFlag : std_ulogic;
	signal ChickerEnableFlag : std_ulogic;
	signal Drive1 : signed(10 downto 0);
	signal Drive2 : signed(10 downto 0);
	signal Drive3 : signed(10 downto 0);
	signal Drive4 : signed(10 downto 0);
	signal Dribble : signed(10 downto 0);
begin
	uut : entity work.XBeePacketReceiver(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock100 => Clock100,
		ByteData => ByteData,
		ByteStrobe => ByteStrobe,
		ByteSOP => ByteSOP,
		Strobe => Strobe,
		AddressByte => open,
		AddressStrobe => open,
		RSSI => RSSI,
		FeedbackFlag => FeedbackFlag,
		DirectDriveFlag => DirectDriveFlag,
		ControlledDriveFlag => ControlledDriveFlag,
		ChickerEnableFlag => ChickerEnableFlag,
		Drive1 => Drive1,
		Drive2 => Drive2,
		Drive3 => Drive3,
		Drive4 => Drive4,
		Dribble => Dribble
	);

	process
	begin
		Clock1 <= '1';
		wait for 1 us / 2;
		Clock1 <= '0';
		wait for 1 us / 2;
		if Done then
			wait;
		end if;
	end process;

	process
	begin
		Clock100 <= '1';
		wait for 10 ns / 2;
		Clock100 <= '0';
		wait for 10 ns / 2;
		if Done then
			wait;
		end if;
	end process;

	process
		variable I : natural;
		variable Checksum : unsigned(7 downto 0);
	begin
		wait until rising_edge(Clock1);

		case State is
			when SendSOP =>
				ByteSOP <= '1';
				ByteStrobe <= '1';
				State <= SendLengthMSB;

			when SendLengthMSB =>
				ByteData <= X"00";
				ByteStrobe <= '1';
				State <= SendLengthLSB;

			when SendLengthLSB =>
				ByteData <= std_ulogic_vector(to_unsigned(PayloadLength, 8));
				ByteStrobe <= '1';
				State <= SendPayload;

			when SendPayload =>
				ByteData <= Payload(PayloadIndex);
				ByteStrobe <= '1';
				if PayloadIndex = PayloadLength - 1 then
					State <= SendChecksum;
				else
					PayloadIndex <= PayloadIndex + 1;
				end if;

			when SendChecksum =>
				Checksum := X"FF";
				for I in 0 to PayloadLength - 1 loop
					Checksum := Checksum - unsigned(Payload(I));
				end loop;
				ByteData <= std_ulogic_vector(Checksum);
				ByteStrobe <= '1';
				State <= Idle;

			when Idle =>
				wait;
		end case;

		wait until rising_edge(Clock1);

		ByteData <= X"00";
		ByteStrobe <= '0';
		ByteSOP <= '0';

		wait until rising_edge(Clock1);
		wait until rising_edge(Clock1);
		wait until rising_edge(Clock1);
	end process;

	process(Clock1)
	begin
		if rising_edge(Clock1) and Strobe = '1' then
			StrobeCount <= StrobeCount + 1;
			assert RSSI = X"28";
			assert FeedbackFlag = '0';
			assert DirectDriveFlag = '1';
			assert ControlledDriveFlag = '0';
			assert ChickerEnableFlag = '0';
			assert to_integer(Drive1) = 682;
			assert to_integer(Drive2) = -683;
			assert to_integer(Drive3) = -342;
			assert to_integer(Drive4) = -427;
			assert to_integer(Dribble) = 682;
		end if;
	end process;

	process
	begin
		wait until State = Idle;
		wait for 10 us;
		assert StrobeCount = 1;
		Done <= true;
		wait;
	end process;
end architecture Behavioural;

