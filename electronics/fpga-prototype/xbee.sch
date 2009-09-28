EESchema Schematic File Version 1
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,./fpga-prototype.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 4 7
Title ""
Date "28 sep 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	7800 3700 7150 3700
Wire Wire Line
	4200 3900 4550 3900
Wire Wire Line
	4200 3700 4550 3700
Wire Wire Line
	4550 3800 4200 3800
Wire Wire Line
	4550 4600 4200 4600
Text GLabel 7800 3700 2    60   Output
BOOTLOAD
NoConn ~ 7150 3800
NoConn ~ 7150 3900
NoConn ~ 7150 4000
NoConn ~ 7150 4100
NoConn ~ 7150 4200
NoConn ~ 7150 4300
NoConn ~ 7150 4400
NoConn ~ 7150 4500
NoConn ~ 7150 4600
$Comp
L GND #PWR023
U 1 1 4ABE98E5
P 4200 4600
F 0 "#PWR023" H 4200 4600 30  0001 C C
F 1 "GND" H 4200 4530 30  0001 C C
	1    4200 4600
	0    1    1    0   
$EndComp
NoConn ~ 4550 4500
NoConn ~ 4550 4400
NoConn ~ 4550 4300
NoConn ~ 4550 4200
NoConn ~ 4550 4100
NoConn ~ 4550 4000
Text GLabel 4200 3900 0    60   Input
DIN
Text GLabel 4200 3800 0    60   Output
DOUT
$Comp
L VCC #PWR024
U 1 1 4ABE98C2
P 4200 3700
F 0 "#PWR024" H 4200 3800 30  0001 C C
F 1 "VCC" H 4200 3800 30  0000 C C
	1    4200 3700
	0    -1   -1   0   
$EndComp
$Comp
L XBEE U8
U 1 1 4ABE98A8
P 5850 4150
F 0 "U8" H 5850 4100 60  0000 C C
F 1 "XBEE" H 5850 4200 60  0000 C C
	1    5850 4150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
