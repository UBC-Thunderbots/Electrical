library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.clock;
use work.pintypes;
use work.types;

entity Top is
	port(
		OscillatorPin : in std_ulogic;
		DCMResetPin : in std_ulogic;
		DCMLockedPin : out std_ulogic;
		ResetPin : in std_ulogic;
		ParbusDataPin : inout std_ulogic_vector(7 downto 0);
		ParbusReadPin : in std_ulogic;
		ParbusWritePin : in std_ulogic;
		LEDsPin : out std_ulogic_vector(3 downto 0);
		EncodersPin : in pintypes.encoders_t;
		MotorsPhasesPPin : out pintypes.motors_phases_t;
		MotorsPhasesNPin : out pintypes.motors_phases_t;
		HallsPin : in pintypes.halls_t;
		ChickerMISOPin : in std_ulogic;
		ChickerCLKPin : out std_ulogic;
		ChickerCSPin : out std_ulogic;
		ChickerChargePin : out std_ulogic;
		KickPin : out std_ulogic;
		ChipPin : out std_ulogic;
		ChickerPresentPin : in std_ulogic;
		VirtualGroundPin : out std_ulogic_vector(0 to 1);
		VirtualVDDPin : out std_ulogic_vector(0 to 3));
end entity Top;

architecture Behavioural of Top is
	signal ClockLow : std_ulogic;
	signal ClockMid : std_ulogic;
	signal ClockHigh : std_ulogic;
	signal Reset : boolean;
	signal ParbusDataIn : std_ulogic_vector(7 downto 0);
	signal ParbusDataOut : std_ulogic_vector(7 downto 0);
	signal ParbusRead : boolean;
	signal ParbusWrite : boolean;
	signal LEDs : types.leds_t;
	signal Encoders : types.encoders_t;
	signal MotorsPhases : types.motors_phases_t;
	signal Halls : types.halls_t;
	signal ChickerMISO : boolean;
	signal ChickerCLK : boolean;
	signal ChickerCS : boolean;
	signal ChickerCharge : boolean;
	signal Kick : boolean;
	signal Chip : boolean;
	signal ChickerPresent : boolean;
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
			ChickerMISO <= ChickerMISOPin = '1';
			ChickerPresent <= ChickerPresentPin = '1';
		end if;
	end process;
	process(ClockLow) is
	begin
		if rising_edge(ClockLow) then
			Reset <= ResetPin = '1';
		end if;
	end process;

	-- Drive all output paths and do signal conversion.
	ParbusDataPin <= ParbusDataOut when ParbusRead else (others => 'Z');
	GenerateLEDsPin: for I in 0 to 3 generate
		LEDsPin(I) <= '1' when LEDs(I) else '0';
	end generate;
	GenerateMotorsPhasesPin: for I in 1 to 5 generate
		GenerateMotorPhasesPin: for J in 0 to 2 generate
			-- Note inversion in level shifters!
			MotorsPhasesPPin(I)(J) <= '1' when MotorsPhases(I)(J) = types.HIGH else '0';
			MotorsPhasesNPin(I)(J) <= '0' when MotorsPhases(I)(J) = types.LOW else '1';
		end generate;
	end generate;
	ChickerCLKPin <= '0' when ChickerCLK else '1';
	ChickerCSPin <= '0' when ChickerCS else '1';
	ChickerChargePin <= '1' when ChickerCharge else '0';
	KickPin <= '1' when Kick else '0';
	ChipPin <= '1' when Chip else '0';
	VirtualGroundPin <= (others => '0');
	VirtualVDDPin <= (others => '1');

	-- Instantiate the main entity.
	Main: entity Main(Behavioural)
	port map(
		ClockLow => ClockLow,
		ClockMid => ClockMid,
		ClockHigh => ClockHigh,
		Reset => Reset,
		ParbusDataIn => ParbusDataIn,
		ParbusDataOut => ParbusDataOut,
		ParbusRead => ParbusRead,
		ParbusWrite => ParbusWrite,
		LEDs => LEDs,
		Encoders => Encoders,
		MotorsPhases => MotorsPhases,
		Halls => Halls,
		ChickerMISO => ChickerMISO,
		ChickerCLK => ChickerCLK,
		ChickerCS => ChickerCS,
		ChickerCharge => ChickerCharge,
		Kick => Kick,
		Chip => Chip,
		ChickerPresent => ChickerPresent);
end architecture Behavioural;
