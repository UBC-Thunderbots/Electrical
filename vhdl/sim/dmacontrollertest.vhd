library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pavr_constants.all;
use work.types.all;

entity DMAControllerTest is
end entity DMAControllerTest;

architecture Arch of DMAControllerTest is
	constant ClockTime : time := 25 ns;
	constant ClockTimeSecs : real := real(ClockTime / 1 ns) * 1.0e9;

	signal Done : boolean := false;
	signal Clock : std_ulogic := '0';
	signal Reset : boolean := false;

	signal CPUInputs : cpu_input_dma_infos_t;
	signal CPUOutputs : cpu_output_dma_infos_t := (
		others => (
			Value => X"00",
			StrobePointerLow => false,
			StrobePointerHigh => false,
			StrobeCount => false,
			StrobeEnable => false));

	signal ReadRequests : dmar_requests_t := (others => (Consumed => false));
	signal ReadResponses : dmar_responses_t;

	signal WriteRequests : dmaw_requests_t := (others => (Write => false, Data => X"00"));
	signal WriteResponses : dmaw_responses_t;

	signal DMAWrite : boolean;
	signal DMAAddress : natural range 0 to pavr_dm_len - 1;
	signal DMADataWrite : std_ulogic_vector(7 downto 0);
	signal DMADataRead : std_ulogic_vector(7 downto 0);

	type ram_t is array(0 to pavr_dm_len - 1) of std_ulogic_vector(7 downto 0);
	signal RAM : ram_t := (others => X"00");
	signal ClearRAM : boolean := false;

	constant Reader1Channel : natural := 0;
	signal Reader1WaitStates : natural := 0;
	type reader_expected_t is array(0 to 255) of std_ulogic_vector(7 downto 0);
	signal Reader1Expected : reader_expected_t := (others => X"00");
	signal Reader1ExpectedIndex : natural := 0;
	signal Reader1ExpectedLength : natural := 0;

	constant Writer1Channel : natural := DMAReadChannels;
	signal Writer1WaitStates : natural := 0;
	signal Writer1NextValue : natural range 0 to 255 := 0;

	constant Writer2Channel : natural := Writer1Channel + 1;
	signal Writer2WaitStates : natural := 0;
	signal Writer2NextValue : natural range 0 to 255 := 128;

	procedure DoReset(signal Reset : out boolean) is
	begin
		wait until rising_edge(Clock);
		Reset <= true;
		wait for ClockTime * 10;
		wait until rising_edge(Clock);
		Reset <= false;
		wait until rising_edge(Clock);
	end procedure DoReset;

	procedure DoSetupDMA(constant Channel : natural; constant Address : natural; constant Length : natural; signal Control : out cpu_output_dma_info_t) is
	begin
		wait until rising_edge(Clock);
		Control.Value <= std_ulogic_vector(to_unsigned(Address mod 256, 8));
		Control.StrobePointerLow <= true;
		wait until rising_edge(Clock);
		Control.Value <= std_ulogic_vector(to_unsigned(Address / 256, 8));
		Control.StrobePointerLow <= false;
		Control.StrobePointerHigh <= true;
		wait until rising_edge(Clock);
		Control.Value <= std_ulogic_vector(to_unsigned(Length, 8));
		Control.StrobePointerHigh <= false;
		Control.StrobeCount <= true;
		wait until rising_edge(Clock);
		Control.StrobeCount <= false;
		Control.StrobeEnable <= true;
		wait until rising_edge(Clock);
		Control.StrobeEnable <= false;
	end procedure DoSetupDMA;
begin
	UUT : entity work.DMAController(Arch)
	port map(
		Clock => Clock,
		Reset => Reset,
		CPUInputs => CPUInputs,
		CPUOutputs => CPUOutputs,
		ReadRequests => ReadRequests,
		ReadResponses => ReadResponses,
		WriteRequests => WriteRequests,
		WriteResponses => WriteResponses,
		DMAWrite => DMAWrite,
		DMAAddress => DMAAddress,
		DMADataWrite => DMADataWrite,
		DMADataRead => DMADataRead);

	process
	begin
		Clock <= '1';
		wait for ClockTime / 2.0;
		Clock <= '0';
		wait for ClockTime / 2.0;
		
		if Done then
			wait;
		end if;
	end process;

	process(Clock) is
	begin
		if rising_edge(Clock) then
			DMADataRead <= RAM(DMAAddress);
			if DMAWrite then
				RAM(DMAAddress) <= DMADataWrite;
			end if;
			if Reset then
				RAM <= (others => X"00");
			end if;
		end if;
	end process;

	process is
	begin
		while true loop
			wait until rising_edge(Clock);
			if Reset then
				Reader1ExpectedIndex <= 0;
			end if;
			ReadRequests(Reader1Channel).Consumed <= false;
			if ReadResponses(Reader1Channel).Valid then
				assert Reader1ExpectedIndex < Reader1ExpectedLength severity failure;
				assert ReadResponses(Reader1Channel).Data = Reader1Expected(Reader1ExpectedIndex);
				for I in 1 to Reader1WaitStates loop
					wait until rising_edge(Clock);
					assert ReadResponses(Reader1Channel).Data = Reader1Expected(Reader1ExpectedIndex);
				end loop;
				ReadRequests(Reader1Channel).Consumed <= true;
				Reader1ExpectedIndex <= Reader1ExpectedIndex + 1;
			end if;
		end loop;
	end process;

	process(Clock) is
		variable Delay : natural := 0;
	begin
		if rising_edge(Clock) then
			WriteRequests(Writer1Channel).Write <= false;
			if Reset then
				Delay := 0;
				WriteRequests(Writer1Channel).Write <= false;
				WriteRequests(Writer1Channel).Data <= X"00";
				Writer1NextValue <= 0;
			else
				if Delay = 0 then
					if WriteResponses(Writer1Channel).Ready then
						WriteRequests(Writer1Channel).Write <= true;
						WriteRequests(Writer1Channel).Data <= std_ulogic_vector(to_unsigned(Writer1NextValue, 8));
						Writer1NextValue <= (Writer1NextValue + 1) mod 256;
						Delay := Writer1WaitStates;
					end if;
				else
					Delay := Delay - 1;
				end if;
			end if;
		end if;
	end process;

	process(Clock) is
		variable Delay : natural := 0;
	begin
		if rising_edge(Clock) then
			WriteRequests(Writer2Channel).Write <= false;
			if Reset then
				Delay := 0;
				WriteRequests(Writer2Channel).Write <= false;
				WriteRequests(Writer2Channel).Data <= X"00";
				Writer2NextValue <= 128;
			else
				if Delay = 0 then
					if WriteResponses(Writer2Channel).Ready then
						WriteRequests(Writer2Channel).Write <= true;
						WriteRequests(Writer2Channel).Data <= std_ulogic_vector(to_unsigned(Writer2NextValue, 8));
						Writer2NextValue <= (Writer2NextValue + 1) mod 256;
						Delay := Writer2WaitStates;
					end if;
				else
					Delay := Delay - 1;
				end if;
			end if;
		end if;
	end process;

	process
		variable ExpectedRAM : ram_t;
	begin
		DoReset(Reset);
		DoSetupDMA(Writer1Channel, 27, 5, CPUOutputs(Writer1Channel));
		while CPUInputs(Writer1Channel).Enabled loop
			wait until rising_edge(Clock);
		end loop;
		ExpectedRAM := (27 => X"00", 28 => X"01", 29 => X"02", 30 => X"03", 31 => X"04", others => X"00");
		assert RAM = ExpectedRAM severity failure;

		DoReset(Reset);
		DoSetupDMA(Writer1Channel, 28, 3, CPUOutputs(Writer1Channel));
		DoSetupDMA(Writer2Channel, 32, 2, CPUOutputs(Writer2Channel));
		while CPUInputs(Writer1Channel).Enabled or CPUInputs(Writer2Channel).Enabled loop
			wait until rising_edge(Clock);
		end loop;
		ExpectedRAM := (28 => X"00", 29 => X"01", 30 => X"02", 32 => X"80", 33 => X"81", others => X"00");
		assert RAM = ExpectedRAM severity failure;

		Reader1Expected <= (X"00", X"00", X"01", X"02", X"00", X"80", X"81", X"00", others => X"00");
		Reader1ExpectedLength <= 8;
		DoSetupDMA(Reader1Channel, 27, 8, CPUOutputs(Reader1Channel));
		while CPUInputs(Reader1Channel).Enabled loop
			wait until rising_edge(Clock);
		end loop;
		assert Reader1ExpectedIndex = Reader1ExpectedLength severity failure;

		Reader1WaitStates <= 4;
		Writer1WaitStates <= 5;
		Writer2WaitStates <= 7;

		DoReset(Reset);
		DoSetupDMA(Writer1Channel, 27, 5, CPUOutputs(Writer1Channel));
		while CPUInputs(Writer1Channel).Enabled loop
			wait until rising_edge(Clock);
		end loop;
		ExpectedRAM := (27 => X"00", 28 => X"01", 29 => X"02", 30 => X"03", 31 => X"04", others => X"00");
		assert RAM = ExpectedRAM severity failure;

		DoReset(Reset);
		DoSetupDMA(Writer1Channel, 28, 3, CPUOutputs(Writer1Channel));
		DoSetupDMA(Writer2Channel, 32, 2, CPUOutputs(Writer2Channel));
		while CPUInputs(Writer1Channel).Enabled or CPUInputs(Writer2Channel).Enabled loop
			wait until rising_edge(Clock);
		end loop;
		ExpectedRAM := (28 => X"00", 29 => X"01", 30 => X"02", 32 => X"80", 33 => X"81", others => X"00");
		assert RAM = ExpectedRAM severity failure;

		Reader1Expected <= (X"00", X"00", X"01", X"02", X"00", X"80", X"81", X"00", others => X"00");
		Reader1ExpectedLength <= 8;
		DoSetupDMA(Reader1Channel, 27, 8, CPUOutputs(Reader1Channel));
		while CPUInputs(Reader1Channel).Enabled loop
			wait until rising_edge(Clock);
		end loop;
		assert Reader1ExpectedIndex = Reader1ExpectedLength severity failure;

		Done <= true;
		wait;
	end process;
end architecture Arch;
