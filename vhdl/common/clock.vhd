package clock is
	constant ClockLowFrequency : natural := 1000000;
	constant ClockMidFrequency : natural := 8000000;
	constant ClockHighFrequency : natural := 128000000;
	constant ClockLowTime : time := (1.0 / real(ClockLowFrequency)) * 1 sec;
	constant ClockMidTime : time := (1.0 / real(ClockMidFrequency)) * 1 sec;
	constant ClockHighTime : time := (1.0 / real(ClockHighFrequency)) * 1 sec;
end package clock;
