library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.clock.all;
use work.pintypes.all;
use work.types.all;

entity Top is
	port(
		OscillatorPin : in std_ulogic;
		DCMResetPin : in std_ulogic;
		DCMLockedPin : out std_ulogic;
		ResetPin : in std_ulogic;
		ParbusDataPin : inout std_ulogic_vector(7 downto 0);
		ParbusReadPin : in std_ulogic;
		ParbusWritePin : in std_ulogic;
		FlashCSPin : inout std_ulogic;
		FlashClockPin : inout std_ulogic;
		FlashMOSIPin : inout std_ulogic;
		FlashMISOPin : in std_ulogic;
		LEDsPin : out std_ulogic_vector(3 downto 0);
		EncodersPin : in encoders_pin_t;
		MotorsPhasesPPin : out motors_phases_pin_t;
		MotorsPhasesNPin : out motors_phases_pin_t;
		HallsPin : in halls_pin_t;
		KickerMISOPin : in std_ulogic;
		KickerCLKPin : out std_ulogic;
		KickerCSPin : out std_ulogic;
		KickerChargePin : out std_ulogic;
		KickLeftPin : out std_ulogic;
		KickRightPin : out std_ulogic;
		KickerPresentPin : in std_ulogic;
		VirtualGroundPin : out std_ulogic_vector(0 to 1);
		VirtualVDDPin : out std_ulogic_vector(0 to 3));
end entity Top;

architecture Behavioural of Top is
	signal ShiftedReset : std_ulogic;
	signal ClockLow : std_ulogic;
	signal ClockMid : std_ulogic;
	signal ClockHigh : std_ulogic;
	signal ParbusDataIn : std_ulogic_vector(7 downto 0);
	signal ParbusDataOut : std_ulogic_vector(7 downto 0);
	signal ParbusRead : boolean;
	signal ParbusWrite : boolean;
	signal FlashDrive : boolean;
	signal FlashCS : boolean;
	signal FlashClock : boolean;
	signal FlashMOSI : std_ulogic;
	signal FlashMISO : std_ulogic;
	signal LEDs : leds_t;
	signal Encoders : encoders_t;
	signal MotorsPhases : motors_phases_t;
	signal Halls : halls_t;
	signal KickerMISO : boolean;
	signal KickerCLK : boolean;
	signal KickerCS : boolean;
	signal KickerCharge : boolean;
	signal KickLeft : boolean;
	signal KickRight : boolean;
	signal KickerPresent : boolean;
begin
	-- Feed the external oscillator into a clock generator to produce our three system clocks.
	ClockGen: entity ClockGen(Behavioural)
	port map(
		Oscillator => OscillatorPin,
		Reset => DCMResetPin,
		Locked => DCMLockedPin,
		ClockLow => ClockLow,
		ClockMid => ClockMid,
		ClockHigh => ClockHigh);

	-- Feed the external reset into a properly-clocked shift register and then the GSR line.
	-- Note that SRL16s are *NOT* affected by GSR, though they do have an initial value loaded from the configuration bitstream.
	ResetShifter: SRL16
	generic map(
		INIT => X"FFFF")
	port map(
		CLK => ClockLow,
		D => ResetPin,
		A3 => '1',
		A2 => '1',
		A1 => '1',
		A0 => '1',
		Q => ShiftedReset);
	Startup: STARTUP_SPARTAN3A
	port map(
		GSR => ShiftedReset);

	-- Add registers to all input paths and do signal conversion.
	process(ClockHigh) is
	begin
		if rising_edge(ClockHigh) then
			ParbusDataIn <= ParbusDataPin;
			ParbusRead <= ParbusReadPin = '1';
			ParbusWrite <= ParbusWritePin = '1';
			for I in 1 to 4 loop
				for J in 0 to 1 loop
					Encoders(I)(J) <= EncodersPin(I)(J) = '1';
				end loop;
			end loop;
			for I in 1 to 5 loop
				for J in 0 to 2 loop
					Halls(I)(J) <= HallsPin(I)(J) = '1';
				end loop;
			end loop;
			KickerMISO <= KickerMISOPin = '1';
			KickerPresent <= KickerPresentPin = '1';
		end if;
	end process;

	-- FlashMISO is special, it is not registered here due to high speed.
	FlashMISO <= FlashMISOPin;

	-- Drive all output paths and do signal conversion.
	ParbusDataPin <= ParbusDataOut when ParbusRead else (others => 'Z');
	FlashCSPin <= 'Z' when not FlashDrive else '0' when FlashCS else '1';
	FlashClockPin <= 'Z' when not FlashDrive else '1' when FlashClock else '0';
	FlashMOSIPin <= 'Z' when not FlashDrive else FlashMOSI;
	GenerateLEDsPin: for I in 0 to 3 generate
		LEDsPin(I) <= '1' when LEDs(I) else '0';
	end generate;
	GenerateMotorsPhasesPin: for I in 1 to 5 generate
		GenerateMotorPhasesPin: for J in 0 to 2 generate
			-- Note inversion in level shifters!
			MotorsPhasesPPin(I)(J) <= '1' when MotorsPhases(I)(J) = HIGH else '0';
			MotorsPhasesNPin(I)(J) <= '0' when MotorsPhases(I)(J) = LOW else '1';
		end generate;
	end generate;
	KickerCLKPin <= '0' when KickerCLK else '1';
	KickerCSPin <= '0' when KickerCS else '1';
	KickerChargePin <= '1' when KickerCharge else '0';
	KickLeftPin <= '1' when KickLeft else '0';
	KickRightPin <= '1' when KickRight else '0';
	VirtualGroundPin <= (others => '0');
	VirtualVDDPin <= (others => '1');

	-- Instantiate the main entity.
	Main: entity Main(Behavioural)
	port map(
		ClockLow => ClockLow,
		ClockMid => ClockMid,
		ClockHigh => ClockHigh,
		ParbusDataIn => ParbusDataIn,
		ParbusDataOut => ParbusDataOut,
		ParbusRead => ParbusRead,
		ParbusWrite => ParbusWrite,
		FlashDrive => FlashDrive,
		FlashCS => FlashCS,
		FlashClock => FlashClock,
		FlashMOSI => FlashMOSI,
		FlashMISO => FlashMISO,
		LEDs => LEDs,
		Encoders => Encoders,
		MotorsPhases => MotorsPhases,
		Halls => Halls,
		KickerMISO => KickerMISO,
		KickerCLK => KickerCLK,
		KickerCS => KickerCS,
		KickerCharge => KickerCharge,
		KickLeft => KickLeft,
		KickRight => KickRight,
		KickerPresent => KickerPresent);
end architecture Behavioural;
