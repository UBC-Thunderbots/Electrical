library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
-- Implements the control logic.
--
entity Controller is
	port(
		Clock1 : in std_ulogic;
		Clock10 : in std_ulogic;

		ControlledDriveFlag : in std_ulogic;

		Drive1 : in signed(10 downto 0);
		Drive2 : in signed(10 downto 0);
		Drive3 : in signed(10 downto 0);
		Drive4 : in signed(10 downto 0);

		Encoder1 : in signed(10 downto 0);
		Encoder2 : in signed(10 downto 0);
		Encoder3 : in signed(10 downto 0);
		Encoder4 : in signed(10 downto 0);
		EncoderReset : out std_ulogic;

		Motor1 : out signed(10 downto 0);
		Motor2 : out signed(10 downto 0);
		Motor3 : out signed(10 downto 0);
		Motor4 : out signed(10 downto 0)
	);
end entity Controller;

architecture Behavioural of Controller is
	signal PIDTicks : natural range 0 to 4999 := 0;
	signal ResetCPU : std_ulogic;
	signal ResetAddress : unsigned(9 downto 0);
	signal PIDSP1 : signed(15 downto 0);
	signal PIDSP2 : signed(15 downto 0);
	signal PIDSP3 : signed(15 downto 0);
	signal PIDSP4 : signed(15 downto 0);
	signal PIDEnc1 : signed(15 downto 0);
	signal PIDEnc2 : signed(15 downto 0);
	signal PIDEnc3 : signed(15 downto 0);
	signal PIDEnc4 : signed(15 downto 0);
	signal PIDPlant1 : signed(15 downto 0);
	signal PIDPlant2 : signed(15 downto 0);
	signal PIDPlant3 : signed(15 downto 0);
	signal PIDPlant4 : signed(15 downto 0);
begin
	-- Iterate the PID loops. All we really have to do here is advance the variables
	-- over a timestep; everything else is done "combinationally" as far as we are
	-- concerned (that is, sequentially but very fast).
	process(Clock1)
	begin
		if rising_edge(Clock1) then
			if PIDTicks = 0 then
				PIDEnc1 <= resize(Encoder1, PIDEnc1'length);
				PIDEnc2 <= resize(Encoder2, PIDEnc1'length);
				PIDEnc3 <= resize(Encoder3, PIDEnc1'length);
				PIDEnc4 <= resize(Encoder4, PIDEnc1'length);
			end if;
			PIDTicks <= (PIDTicks + 1) mod 5000;
		end if;
	end process;

	ResetCPU <= '1' when PIDTicks = 0 else '0';
	ResetAddress <= to_unsigned(512, 10) when ControlledDriveFlag = '0' else to_unsigned(0, 10);
	EncoderReset <= '1' when PIDTicks = 0 else '0';

	PIDSP1 <= resize(Drive1, PIDSP1'length);
	PIDSP2 <= resize(Drive2, PIDSP2'length);
	PIDSP3 <= resize(Drive3, PIDSP3'length);
	PIDSP4 <= resize(Drive4, PIDSP4'length);

	ControllerImplInstance : entity work.ControllerImpl(Behavioural)
	port map(
		Setpoint1 => PIDSP1,
		Setpoint2 => PIDSP2,
		Setpoint3 => PIDSP3,
		Setpoint4 => PIDSP4,
		Encoder1 => PIDEnc1,
		Encoder2 => PIDEnc2,
		Encoder3 => PIDEnc3,
		Encoder4 => PIDEnc4,
		Plant1 => PIDPlant1,
		Plant2 => PIDPlant2,
		Plant3 => PIDPlant3,
		Plant4 => PIDPlant4,
		Reset => ResetCPU,
		ResetAddress => ResetAddress,
		Clock => Clock10
	);

	process(ControlledDriveFlag, Drive1, Drive2, Drive3, Drive4, PIDPlant1, PIDPlant2, PIDPlant3, PIDPlant4)
	begin
		Motor1 <= resize(PIDPlant1, Motor1'length);
		Motor2 <= resize(PIDPlant2, Motor2'length);
		Motor3 <= resize(PIDPlant3, Motor3'length);
		Motor4 <= resize(PIDPlant4, Motor4'length);
	end process;
end architecture Behavioural;
