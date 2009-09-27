EESchema Schematic File Version 1
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,./fpga-prototype.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 7
Title ""
Date "27 sep 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 4300 5250
Wire Wire Line
	4600 5250 4300 5250
Connection ~ 8700 4650
Wire Wire Line
	8700 4650 7050 4650
Wire Wire Line
	7050 4650 7050 5550
Wire Wire Line
	7050 5550 6150 5550
Wire Wire Line
	8500 4350 8700 4350
Wire Wire Line
	8700 4350 8700 5250
Wire Wire Line
	8700 5250 8250 5250
Wire Wire Line
	7150 4450 6950 4450
Wire Wire Line
	6950 4450 6950 5350
Wire Wire Line
	6950 5350 6150 5350
Wire Wire Line
	6150 5150 6750 5150
Wire Wire Line
	6750 5150 6750 4250
Wire Wire Line
	6750 4250 7150 4250
Connection ~ 6550 3850
Wire Wire Line
	6550 3850 6550 4850
Wire Wire Line
	6550 4850 6150 4850
Wire Wire Line
	6150 4650 6350 4650
Connection ~ 6350 3750
Wire Wire Line
	6350 4650 6350 3750
Wire Wire Line
	7150 3850 5800 3850
Wire Wire Line
	5800 3650 7150 3650
Wire Bus Line
	5950 2600 6750 2600
Wire Bus Line
	6750 2600 6750 3350
Wire Bus Line
	6750 3350 7150 3350
Wire Wire Line
	4600 4950 4200 4950
Wire Wire Line
	4200 4950 4200 2400
Wire Wire Line
	4200 2400 4600 2400
Wire Wire Line
	4600 4750 4400 4750
Wire Wire Line
	4400 4750 4400 2600
Wire Wire Line
	4400 2600 4600 2600
Wire Wire Line
	4600 4550 4500 4550
Wire Wire Line
	4500 4550 4500 3300
Wire Wire Line
	4500 3300 4750 3300
Wire Wire Line
	4600 2500 4300 2500
Wire Wire Line
	4300 2500 4300 4850
Wire Wire Line
	4300 4850 4600 4850
Wire Bus Line
	4600 2300 4100 2300
Wire Bus Line
	4100 2300 4100 5050
Wire Bus Line
	4100 5050 4600 5050
Wire Wire Line
	5800 3550 7150 3550
Wire Wire Line
	7150 3750 5800 3750
Wire Wire Line
	6250 3550 6250 4550
Connection ~ 6250 3550
Wire Wire Line
	6450 3650 6450 4750
Connection ~ 6450 3650
Wire Wire Line
	6250 4550 6150 4550
Wire Wire Line
	6450 4750 6150 4750
Wire Wire Line
	6150 4950 6650 4950
Wire Wire Line
	6650 4950 6650 3950
Wire Wire Line
	6650 3950 7150 3950
Wire Wire Line
	6150 5250 6850 5250
Wire Wire Line
	6850 5250 6850 4350
Wire Wire Line
	6850 4350 7150 4350
Wire Wire Line
	8250 5150 8600 5150
Wire Wire Line
	8600 5150 8600 4450
Wire Wire Line
	8600 4450 8500 4450
Wire Wire Line
	6150 5850 7450 5850
Wire Wire Line
	6150 5650 7150 5650
Wire Wire Line
	7150 5650 7150 4750
Wire Wire Line
	7150 4750 8600 4750
Connection ~ 8600 4750
$Sheet
S 4600 2250 1350 450 
F0 "connectors" 60
F1 "connectors.sch" 60
F2 "ADC[0..12]" O L 4600 2300 60 
F3 "GPIO[0..39]" B R 5950 2600 60 
F4 "PGC" O L 4600 2400 60 
F5 "PGD" B L 4600 2500 60 
F6 "MCLR" O L 4600 2600 60 
$EndSheet
$Sheet
S 7450 5100 800  800 
F0 "xbee" 60
F1 "xbee.sch" 60
F2 "BOOTLOAD" O L 7450 5850 60 
F3 "DIN" I R 8250 5250 60 
F4 "DOUT" O R 8250 5150 60 
$EndSheet
$Sheet
S 4600 4500 1550 1400
F0 "pic" 60
F1 "pic.sch" 60
F2 "PGC" I L 4600 4950 60 
F3 "PGD" B L 4600 4850 60 
F4 "BOOTLOAD" I R 6150 5850 60 
F5 "FPGA_SS" O R 6150 4950 60 
F6 "FLASH_SS" T R 6150 4850 60 
F7 "ADC[0..12]" I L 4600 5050 60 
F8 "DONE" I R 6150 5350 60 
F9 "RX" I R 6150 5650 60 
F10 "PROG_B" O R 6150 5150 60 
F11 "INIT_B" I R 6150 5250 60 
F12 "SPIIN" I R 6150 4650 60 
F13 "SPICK" B R 6150 4550 60 
F14 "MCLR" I L 4600 4750 60 
F15 "/WP" O L 4600 4550 60 
F16 "TX" B R 6150 5550 60 
F17 "SPIOUT" B R 6150 4750 60 
F18 "BRAKE" T L 4600 5250 60 
$EndSheet
$Sheet
S 4750 3250 1050 950 
F0 "flash" 60
F1 "flash.sch" 60
F2 "/WP" I L 4750 3300 60 
F3 "DOUT" O R 5800 3750 60 
F4 "CS" I R 5800 3850 60 
F5 "DIN" I R 5800 3650 60 
F6 "CLK" I R 5800 3550 60 
$EndSheet
$Sheet
S 7150 2100 950  850 
F0 "power" 60
F1 "power.sch" 60
$EndSheet
$Sheet
S 7150 3300 1350 1200
F0 "fpga" 60
F1 "fpga.sch" 60
F2 "CSO_B" B L 7150 3850 60 
F3 "PROG_B" I L 7150 4250 60 
F4 "DONE" B L 7150 4450 60 
F5 "INIT_B" B L 7150 4350 60 
F6 "CCLK" O L 7150 3550 60 
F7 "GPIO[0..39]" B L 7150 3350 60 
F8 "XBEERX" I R 8500 4450 60 
F9 "COUT/APPIN'" B L 7150 3650 60 
F10 "CIN/APPOUT" B L 7150 3750 60 
F11 "APPSS" I L 7150 3950 60 
F12 "XBEETX" B R 8500 4350 60 
$EndSheet
$EndSCHEMATC
