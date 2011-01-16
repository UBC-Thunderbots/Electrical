package clock is
	constant LowFrequency : natural := 1000000;
	constant MidFrequency : natural := 8000000;
	constant HighFrequency : natural := 128000000;
	constant LowTime : time := (1.0 / real(LowFrequency)) * 1 sec;
	constant MidTime : time := (1.0 / real(MidFrequency)) * 1 sec;
	constant HighTime : time := (1.0 / real(HighFrequency)) * 1 sec;
end package clock;
