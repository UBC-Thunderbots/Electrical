library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialReceiver is
	port(
		Clock50M : in std_ulogic;

		Serial : in std_ulogic;

		Data : out std_ulogic_vector(7 downto 0);
		Good : out std_ulogic;
		FErr : out std_ulogic := '0'
	);
end entity SerialReceiver;

architecture Behavioural of SerialReceiver is
	signal DBuf : std_ulogic_vector(9 downto 0) := "0000000000";
	signal BitClocks : natural range 0 to 199 := 199;
	signal BitValue : signed(6 downto 0) := to_signed(0, 7);
	signal FErrBuf : std_ulogic := '0';
begin
	Data <= DBuf(8 downto 1);
	FErr <= FErrBuf;

	process(Clock50M)
		variable ResetBitClocks : boolean;
		variable ResetBitValue : boolean;
		variable BitValueDelta : signed(6 downto 0);
	begin
		if rising_edge(Clock50M) then
			ResetBitClocks := false;
			ResetBitValue := false;
			BitValueDelta := to_signed(0, 7);
			Good <= '0';
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
				if BitClocks > 131 then
					-- Too early in the bit to take a stable sample. Do nothing.
				elsif BitClocks > 68 then
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
					if BitValue >= 22 then
						-- Overwhelmingly high. Accept bit.
						DBuf <= '1' & DBuf(9 downto 1);
					elsif BitValue <= -22 then
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
						if FErrBuf = '0' and BitValue >= 22 then
							Good <= '1';
						else
							FErrBuf <= '1';
						end if;
					end if;
					-- Check if this is a false start bit.
					if DBuf = "1111111111" and BitValue > -22 then
						DBuf <= "0000000000";
					end if;
					ResetBitClocks := true;
					ResetBitValue := true;
				end if;
			end if;

			if ResetBitClocks then
				BitClocks <= 199;
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
end architecture Behavioural;
