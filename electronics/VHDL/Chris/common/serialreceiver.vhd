library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialReceiver is
	port(
		Clock1 : in std_ulogic;
		Clock100 : in std_ulogic;

		Serial : in std_ulogic;

		Data : out std_ulogic_vector(7 downto 0) := X"00";
		Strobe : out std_ulogic := '0';
		FErr : out std_ulogic := '0'
	);
end entity SerialReceiver;

architecture Behavioural of SerialReceiver is
	signal DBuf : std_ulogic_vector(9 downto 0) := "0000000000";
	signal BitClocks : natural range 0 to 399 := 399;
	signal BitValue : signed(6 downto 0) := to_signed(0, 7);
	signal High : boolean;
	signal Low : boolean;
	signal FErrBuf : std_ulogic := '0';

	signal DataBuffer : std_ulogic_vector(7 downto 0) := X"00";
	signal DataBufferPolarity1 : std_ulogic := '0';
	signal DataBufferPolarity100 : std_ulogic := '0';
begin
	FErr <= FErrBuf;
	High <= BitValue >= 22;
	Low <= BitValue <= -22;

	process(Clock100)
		variable ResetBitClocks : boolean;
		variable ResetBitValue : boolean;
		variable BitValueDelta : signed(6 downto 0);
	begin
		if rising_edge(Clock100) then
			ResetBitClocks := false;
			ResetBitValue := false;
			BitValueDelta := to_signed(0, 7);
			if DBuf(0) = '0' then
				-- Not receiving right now.
				if Serial = '0' then
					-- Start bit of new byte.
					FErrBuf <= '0';
					DBuf <= "1111111111";
				end if;
				ResetBitClocks := true;
				ResetBitValue := true;
			else
				-- Receive in progress. What do we do with the current bit?
				if BitClocks > 232 then
					-- Too early in the bit to take a stable sample. Do nothing.
				elsif BitClocks > 169 then
					-- Middle 63 clocks. Sample.
					if Serial = '1' then
						BitValueDelta := to_signed(1, 7);
					else
						BitValueDelta := to_signed(-1, 7);
					end if;
				elsif BitClocks > 0 then
					-- Too late in the bit to take a stable sample. Do nothing.
				else
					-- End of bit. See what our sampling achieved.
					if High then
						-- Overwhelmingly high. Accept bit.
						DBuf <= '1' & DBuf(9 downto 1);
					elsif Low then
						-- Overwhelmingly low. Accept bit.
						DBuf <= '0' & DBuf(9 downto 1);
					else
						-- Unstable. Reject whole byte.
						FErrBuf <= '1';
						-- Still need to push the shift register to keep things moving.
						DBuf <= '1' & DBuf(9 downto 1);
					end if;
					-- Note: DBuf is a signal, so reflects the **OLD** value, in
					-- which what is now DBuf(0) was then DBuf(1)!
					if DBuf(1) = '1' then
						-- We have more bits to receive.
					else
						-- We have finished receiving a full byte. Check polarity of stop bit.
						if FErrBuf = '0' and High then
							DataBuffer <= DBuf(9 downto 2);
							DataBufferPolarity100 <= not DataBufferPolarity100;
						else
							FErrBuf <= '1';
						end if;
					end if;
					-- Check if this is a false start bit.
					if DBuf = "1111111111" and not Low then
						DBuf <= "0000000000";
					end if;
					ResetBitClocks := true;
					ResetBitValue := true;
				end if;
			end if;

			if ResetBitClocks then
				BitClocks <= 399;
			else
				BitClocks <= BitClocks - 1;
			end if;

			if ResetBitValue then
				BitValue <= to_signed(0, 7);
			else
				BitValue <= BitValue + BitValueDelta;
			end if;
		end if;
	end process;

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			Data <= DataBuffer;
			Strobe <= DataBufferPolarity1 xor DataBufferPolarity100;
			DataBufferPolarity1 <= DataBufferPolarity100;
		end if;
	end process;
end architecture Behavioural;
