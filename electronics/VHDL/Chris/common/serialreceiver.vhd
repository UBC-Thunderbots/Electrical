library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialReceiver is
	port(
		Clock1 : in std_ulogic;
		Clock10 : in std_ulogic;

		Serial : in std_ulogic;

		Data : out std_ulogic_vector(7 downto 0) := X"00";
		Strobe : out std_ulogic := '0';
		FErr : out std_ulogic := '0'
	);
end entity SerialReceiver;

architecture Behavioural of SerialReceiver is
	signal DBuf : std_ulogic_vector(8 downto 0) := "000000000";
	subtype BitClocksType is natural range 0 to 39;
	signal BitClocks : BitClocksType := BitClocksType'high;
	signal BitValue : signed(4 downto 0) := to_signed(0, 5);
	signal High : boolean;
	signal Low : boolean;
	signal FErrBuf : std_ulogic := '0';

	signal DataBuffer : std_ulogic_vector(7 downto 0) := X"00";
	signal DataBufferPolarity1 : std_ulogic := '0';
	signal DataBufferPolarity10 : std_ulogic := '0';
begin
	FErr <= FErrBuf;
	High <= BitValue >= 4;
	Low <= BitValue <= -4;

	process(Clock10)
		variable ResetBitClocks : boolean;
		variable ResetBitValue : boolean;
		variable BitValueDelta : signed(4 downto 0);
	begin
		if rising_edge(Clock10) then
			ResetBitClocks := false;
			ResetBitValue := false;
			BitValueDelta := to_signed(0, 5);
			if DBuf(0) = '0' then
				-- Not receiving right now.
				if Serial = '0' then
					-- Start bit of new byte.
					FErrBuf <= '0';
					DBuf <= "111111111";
				end if;
				ResetBitClocks := true;
				ResetBitValue := true;
			else
				-- Receive in progress. What do we do with the current bit?
				if BitClocks > 27 then
					-- Too early in the bit to take a stable sample. Do nothing.
				elsif BitClocks > 12 then
					-- Middle 15 clocks. Sample.
					if Serial = '1' then
						BitValueDelta := to_signed(1, 5);
					else
						BitValueDelta := to_signed(-1, 5);
					end if;
				elsif BitClocks > 0 then
					-- Too late in the bit to take a stable sample. Do nothing.
				else
					-- End of bit. See what our sampling achieved.
					if High then
						-- Overwhelmingly high. Accept bit.
						DBuf <= '1' & DBuf(8 downto 1);
					elsif Low then
						-- Overwhelmingly low. Accept bit.
						DBuf <= '0' & DBuf(8 downto 1);
					else
						-- Unstable. Reject whole byte.
						FErrBuf <= '1';
						-- Still need to push the shift register to keep things moving.
						DBuf <= '1' & DBuf(8 downto 1);
					end if;
					-- Note: DBuf is a signal, so reflects the **OLD** value, in
					-- which what is now DBuf(0) was then DBuf(1)!
					if DBuf(1) = '1' then
						-- We have more bits to receive.
					else
						-- We have finished receiving a full byte.
						if High then
							DataBuffer <= '1' & DBuf(8 downto 2);
						else
							DataBuffer <= '0' & DBuf(8 downto 2);
						end if;
						DataBufferPolarity10 <= not DataBufferPolarity10;
					end if;
					-- Check if this is a false start bit.
					if DBuf = "111111111" and not Low then
						DBuf <= "000000000";
					end if;
					ResetBitClocks := true;
					ResetBitValue := true;
				end if;
			end if;

			if ResetBitClocks then
				BitClocks <= BitClocksType'high;
			else
				BitClocks <= BitClocks - 1;
			end if;

			if ResetBitValue then
				BitValue <= to_signed(0, 5);
			else
				BitValue <= BitValue + BitValueDelta;
			end if;
		end if;
	end process;

	process(Clock1)
	begin
		if rising_edge(Clock1) then
			Data <= DataBuffer;
			Strobe <= DataBufferPolarity1 xor DataBufferPolarity10;
			DataBufferPolarity1 <= DataBufferPolarity10;
		end if;
	end process;
end architecture Behavioural;
