library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialReceiver is
	port(
		Clock : in std_logic;

		Serial : in std_logic;

		Data : out std_logic_vector(7 downto 0);
		Good : out std_logic;
		FErr : buffer std_logic := '0'
	);
end entity SerialReceiver;

architecture Behavioural of SerialReceiver is
	signal DBuf : std_logic_vector(9 downto 0) := "0000000000";
	signal BitClocks : unsigned(7 downto 0) := to_unsigned(0, 8);
	signal BitValue : signed(6 downto 0) := to_signed(0, 7);
begin
	Data <= DBuf(8 downto 1);

	process(Clock)
	begin
		if rising_edge(Clock) then
			Good <= '0';
			if DBuf(0) = '0' then
				-- Not receiving right now.
				if Serial = '0' then
					-- Start bit of new byte.
					FErr <= '0';
					DBuf <= "1111111111";
					BitClocks <= to_unsigned(199, 8);
					BitValue <= to_signed(0, 7);
				end if;
			else
				-- Receive in progress. What do we do with the current bit?
				if BitClocks > 131 then
					-- Too early in the bit to take a stable sample. Do nothing.
					BitClocks <= BitClocks - 1;
				elsif BitClocks > 68 then
					-- Middle 63 clocks. Sample.
					if Serial = '1' then
						BitValue <= BitValue + 1;
					else
						BitValue <= BitValue - 1;
					end if;
					BitClocks <= BitClocks - 1;
				elsif BitClocks > 0 then
					-- Too late in the bit to take a stable sample. Do nothing.
					BitClocks <= BitClocks - 1;
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
						FErr <= '1';
						-- Still need to push the shift register to keep things moving.
						DBuf <= '1' & DBuf(9 downto 1);
					end if;
					-- Note: DBuf is a signal, so reflects the **OLD** value, in
					-- which what is now DBuf(0) was then DBuf(1)!
					if DBuf(1) = '1' then
						-- We have more bits to receive. Set up the clock.
						BitClocks <= to_unsigned(199, 8);
						BitValue <= to_signed(0, 7);
					else
						-- We have finished receiving a full byte. Check polarity of stop bit.
						if FErr = '0' and BitValue >= 22 then
							Good <= '1';
						else
							FErr <= '1';
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
end architecture Behavioural;
