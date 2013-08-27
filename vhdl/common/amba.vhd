package amba is
	constant VENDOR_ID_THUNDERBOTS : natural := 16#FF#;

	constant DEVICE_ID_AHBROM : natural := 1;
	constant DEVICE_ID_DEBUGPORT : natural := 2;
	constant DEVICE_ID_SPIFLASH : natural := 3;
	constant DEVICE_ID_SYSCTL : natural := 4;
	constant DEVICE_ID_MRF : natural := 5;
	constant DEVICE_ID_MOTOR : natural := 6;
	constant DEVICE_ID_CHICKER : natural := 7;
	constant DEVICE_ID_SD : natural := 8;
end package amba;
