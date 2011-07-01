package clock is
	constant ClockLowFrequency : natural := 1000000;
	constant ClockMidFrequency : natural := 8000000;
	constant ClockHighFrequency : natural := 12500000;
	constant ClockLowTime : real := (1.0 / real(ClockLowFrequency));
	constant ClockMidTime : real := (1.0 / real(ClockMidFrequency));
	constant ClockHighTime : real := (1.0 / real(ClockHighFrequency));
end package clock;
