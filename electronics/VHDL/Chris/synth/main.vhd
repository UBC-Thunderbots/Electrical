library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity Main is
	port(
		-- The 50MHz canned oscillator.
		Oscillator : in std_ulogic;

		-- Serial lines to and from the XBee.
		XBeeRX : in std_ulogic;
		XBeeTX : out std_ulogic;

		-- SPI lines to and from the PIC.
		AppSS : in std_ulogic;
		AppOut : out std_ulogic;
		AppIn : in std_ulogic;
		AppClk : in std_ulogic;

		-- Control lines to and from the motor controllers.
		BrakeDrive : out std_ulogic;
		BrakeDribbler : out std_ulogic;
		PWM1 : out std_ulogic;
		PWM2 : out std_ulogic;
		PWM3 : out std_ulogic;
		PWM4 : out std_ulogic;
		PWMD : out std_ulogic;
		Dir1 : out std_ulogic;
		Dir2 : out std_ulogic;
		Dir3 : out std_ulogic;
		Dir4 : out std_ulogic;
		DirD : out std_ulogic;
		Fault1 : in std_ulogic;
		Fault2 : in std_ulogic;
		Fault3 : in std_ulogic;
		Fault4 : in std_ulogic;
		FaultD : in std_ulogic;
		DSense : in std_ulogic;

		-- Optical encoder phase lines.
		Encoder1A : in std_ulogic;
		Encoder1B : in std_ulogic;
		Encoder2A : in std_ulogic;
		Encoder2B : in std_ulogic;
		Encoder3A : in std_ulogic;
		Encoder3B : in std_ulogic;
		Encoder4A : in std_ulogic;
		Encoder4B : in std_ulogic
	);
end entity Main;

architecture Behavioural of Main is
	-- The clocks generated by the DCM from Oscillator.
	signal Clock1 : std_ulogic;
	signal Clock10 : std_ulogic;
	signal Clock100 : std_ulogic;

	-- Latched versions of all input pins other than Oscillator.
	signal XBeeRXL : std_ulogic := '1';
	signal AppSSL : std_ulogic := '1';
	signal AppInL : std_ulogic := '0';
	signal AppClkL : std_ulogic := '0';
	signal Fault1L : std_ulogic := '0';
	signal Fault2L : std_ulogic := '0';
	signal Fault3L : std_ulogic := '0';
	signal Fault4L : std_ulogic := '0';
	signal FaultDL : std_ulogic := '0';
	signal DSenseL : std_ulogic := '0';
	signal Encoder1AL : std_ulogic := '0';
	signal Encoder1BL : std_ulogic := '0';
	signal Encoder2AL : std_ulogic := '0';
	signal Encoder2BL : std_ulogic := '0';
	signal Encoder3AL : std_ulogic := '0';
	signal Encoder3BL : std_ulogic := '0';
	signal Encoder4AL : std_ulogic := '0';
	signal Encoder4BL : std_ulogic := '0';

	-- Mode flags from the XBee.
	signal DirectDriveFlag : std_ulogic;
	signal ControlledDriveFlag : std_ulogic;
	signal DribbleFlag : std_ulogic;
	signal RXTimeout : std_ulogic;

	-- Drive levels from the XBee.
	signal Drive1 : signed(10 downto 0);
	signal Drive2 : signed(10 downto 0);
	signal Drive3 : signed(10 downto 0);
	signal Drive4 : signed(10 downto 0);

	-- Encoder counts from the Gray counters.
	signal Encoder1Count : signed(10 downto 0);
	signal Encoder2Count : signed(10 downto 0);
	signal Encoder3Count : signed(10 downto 0);
	signal Encoder4Count : signed(10 downto 0);
	signal EncoderReset : std_ulogic;

	-- Controller outputs.
	signal ControlM1 : signed(10 downto 0);
	signal ControlM2 : signed(10 downto 0);
	signal ControlM3 : signed(10 downto 0);
	signal ControlM4 : signed(10 downto 0);

	-- Motor powers from the controller or direct drive.
	signal Motor1 : signed(10 downto 0);
	signal Motor2 : signed(10 downto 0);
	signal Motor3 : signed(10 downto 0);
	signal Motor4 : signed(10 downto 0);

	-- Duty cycles from the sign-magnitude converters.
	signal DutyCycle1 : unsigned(9 downto 0);
	signal DutyCycle2 : unsigned(9 downto 0);
	signal DutyCycle3 : unsigned(9 downto 0);
	signal DutyCycle4 : unsigned(9 downto 0);

	-- Directions from the sign-magnitude converters.
	signal Dir1T : std_ulogic := '0';
	signal Dir2T : std_ulogic := '0';
	signal Dir3T : std_ulogic := '0';
	signal Dir4T : std_ulogic := '0';

	-- Dribbler stuff.
	signal Dribble : signed(10 downto 0);
	signal DutyCycleD : unsigned(9 downto 0);
	signal DirDT : std_ulogic := '0';

	-- Battery voltage.
	signal VMon : unsigned(9 downto 0);
begin
	-- Pass the Oscillator pin through a DCM to get the final clocks.
	ClockGenInstance : entity work.ClockGen(Behavioural)
	port map(
		Oscillator => Oscillator,
		Clock100 => Clock100,
		Clock10 => Clock10,
		Clock1 => Clock1
	);

	-- Latch the inputs into the local signals.
	process(Clock1)
	begin
		if rising_edge(Clock1) then
			Fault1L <= Fault1;
			Fault2L <= Fault2;
			Fault3L <= Fault3;
			Fault4L <= Fault4;
			FaultDL <= FaultD;
			DSenseL <= DSense;
			Encoder1AL <= Encoder1A;
			Encoder1BL <= Encoder1B;
			Encoder2AL <= Encoder2A;
			Encoder2BL <= Encoder2B;
			Encoder3AL <= Encoder3A;
			Encoder3BL <= Encoder3B;
			Encoder4AL <= Encoder4A;
			Encoder4BL <= Encoder4B;
		end if;
	end process;
	process(Clock10)
	begin
		if rising_edge(Clock10) then
			AppSSL <= AppSS;
			AppInL <= AppIn;
			AppClkL <= AppClk;
			XBeeRXL <= XBeeRX;
		end if;
	end process;

	-- Serial communication hardware.
	XBeeInstance : entity work.XBee(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock10 => Clock10,
		DirectDriveFlag => DirectDriveFlag,
		ControlledDriveFlag => ControlledDriveFlag,
		DribbleFlag => DribbleFlag,
		Drive1 => Drive1,
		Drive2 => Drive2,
		Drive3 => Drive3,
		Drive4 => Drive4,
		Dribble => Dribble,
		Timeout => RXTimeout,
		DribblerSpeed => to_signed(0, 11),
		VMon => VMon,
		Fault1 => Fault1L,
		Fault2 => Fault2L,
		Fault3 => Fault3L,
		Fault4 => Fault4L,
		FaultD => FaultDL,
		SerialIn => XBeeRXL,
		SerialOut => XBeeTX
	);

	-- Braking stuff.
	BrakeDrive <= '0' when (DirectDriveFlag = '1' or ControlledDriveFlag = '1') and RXTimeout = '0' else '1';
	BrakeDribbler <= '0' when DribbleFlag = '1' and RXTimeout = '0' else '1';

	-- Wheel stuff.
	GrayCounterInstance1 : entity work.GrayCounter(Behavioural)
	generic map(
		Width => 11,
		Sign => -1
	)
	port map(
		Clock1 => Clock1,
		A => Encoder1AL,
		B => Encoder1BL,
		Reset => EncoderReset,
		Count => Encoder1Count
	);
	GrayCounterInstance2 : entity work.GrayCounter(Behavioural)
	generic map(
		Width => 11,
		Sign => -1
	)
	port map(
		Clock1 => Clock1,
		A => Encoder2AL,
		B => Encoder2BL,
		Reset => EncoderReset,
		Count => Encoder2Count
	);
	GrayCounterInstance3 : entity work.GrayCounter(Behavioural)
	generic map(
		Width => 11,
		Sign => -1
	)
	port map(
		Clock1 => Clock1,
		A => Encoder3AL,
		B => Encoder3BL,
		Reset => EncoderReset,
		Count => Encoder3Count
	);
	GrayCounterInstance4 : entity work.GrayCounter(Behavioural)
	generic map(
		Width => 11,
		Sign => -1
	)
	port map(
		Clock1 => Clock1,
		A => Encoder4AL,
		B => Encoder4BL,
		Reset => EncoderReset,
		Count => Encoder4Count
	);
	ControllerInstance : entity work.Controller(Behavioural)
	port map(
		Clock1 => Clock1,
		Clock10 => Clock10,
		ControlledDriveFlag => ControlledDriveFlag,
		Drive1 => Drive1,
		Drive2 => Drive2,
		Drive3 => Drive3,
		Drive4 => Drive4,
		Encoder1 => Encoder1Count,
		Encoder2 => Encoder2Count,
		Encoder3 => Encoder3Count,
		Encoder4 => Encoder4Count,
		EncoderReset => EncoderReset,
		Motor1 => ControlM1,
		Motor2 => ControlM2,
		Motor3 => ControlM3,
		Motor4 => ControlM4
	);
	process(DirectDriveFlag, ControlledDriveFlag, ControlM1, ControlM2, ControlM3, ControlM4, Drive1, Drive2, Drive3, Drive4)
	begin
		if DirectDriveFlag = '1' then
			Motor1 <= Drive1;
			Motor2 <= Drive2;
			Motor3 <= Drive3;
			Motor4 <= Drive4;
		elsif ControlledDriveFlag = '1' then
			Motor1 <= ControlM1;
			Motor2 <= ControlM2;
			Motor3 <= ControlM3;
			Motor4 <= ControlM4;
		else
			Motor1 <= to_signed(0, 11);
			Motor2 <= to_signed(0, 11);
			Motor3 <= to_signed(0, 11);
			Motor4 <= to_signed(0, 11);
		end if;
	end process;
	SignMagnitude1Instance : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => Motor1,
		Absolute => DutyCycle1,
		Sign => Dir1T
	);
	PWM1Instance : entity work.PWM(Behavioural)
	generic map(
		Width => 10,
		Modulus => 1023,
		Invert => true
	)
	port map(
		Clock100 => Clock100,
		DutyCycle => DutyCycle1,
		PWM => PWM1
	);
	SignMagnitude2Instance : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => Motor2,
		Absolute => DutyCycle2,
		Sign => Dir2T
	);
	PWM2Instance : entity work.PWM(Behavioural)
	generic map(
		Width => 10,
		Modulus => 1023,
		Invert => true
	)
	port map(
		Clock100 => Clock100,
		DutyCycle => DutyCycle2,
		PWM => PWM2
	);
	SignMagnitude3Instance : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => Motor3,
		Absolute => DutyCycle3,
		Sign => Dir3T
	);
	PWM3Instance : entity work.PWM(Behavioural)
	generic map(
		Width => 10,
		Modulus => 1023,
		Invert => true
	)
	port map(
		Clock100 => Clock100,
		DutyCycle => DutyCycle3,
		PWM => PWM3
	);
	SignMagnitude4Instance : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => Motor4,
		Absolute => DutyCycle4,
		Sign => Dir4T
	);
	PWM4Instance : entity work.PWM(Behavioural)
	generic map(
		Width => 10,
		Modulus => 1023,
		Invert => true
	)
	port map(
		Clock100 => Clock100,
		DutyCycle => DutyCycle4,
		PWM => PWM4
	);
	Dir1 <= '0' when Dir1T = '1' else 'Z';
	Dir2 <= 'Z' when Dir2T = '1' else '0';
	Dir3 <= 'Z' when Dir3T = '1' else '0';
	Dir4 <= 'Z' when Dir4T = '1' else '0';

	-- Dribbler stuff.
	SMDInstance : entity work.SignMagnitude(Behavioural)
	generic map(
		Width => 11
	)
	port map(
		Value => Dribble,
		Absolute => DutyCycleD,
		Sign => DirDT
	);
	PWMDInstance : entity work.PWM(Behavioural)
	generic map(
		Width => 10,
		Modulus => 1023,
		Invert => true
	)
	port map(
		Clock100 => Clock100,
		DutyCycle => DutyCycleD,
		PWM => PWMD
	);
	DirD <= 'Z' when DirDT = '1' else '0';

	-- The SPI receiver for the analogue to digital converters.
	ADCInstance : entity work.ADC(Behavioural)
	port map(
		Clock10 => Clock10,
		SPICK => AppClkL,
		SPIDT => AppInL,
		SPISS => AppSSL,
		VMon => VMon
	);

	AppOut <= '0';
end architecture Behavioural;
