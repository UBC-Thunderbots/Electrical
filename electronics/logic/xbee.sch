EESchema Schematic File Version 2  date 2010-04-01T16:15:12 PDT
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 5 8
Title ""
Date "1 apr 2010"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4200 4100 4550 4100
Wire Wire Line
	7800 4100 7150 4100
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
Wire Wire Line
	7150 3800 7800 3800
Text HLabel 4200 4100 0    60   Input ~ 0
RESET
Text HLabel 7800 3800 2    60   3State ~ 0
/EMERG_ERASE
Text HLabel 7800 4100 2    60   Input ~ 0
/RTS
Text HLabel 7800 3700 2    60   Output ~ 0
BOOTLOAD
NoConn ~ 7150 3900
NoConn ~ 7150 4000
NoConn ~ 7150 4200
NoConn ~ 7150 4300
NoConn ~ 7150 4400
NoConn ~ 7150 4500
NoConn ~ 7150 4600
$Comp
L GND #PWR058
U 1 1 4ABE98E5
P 4200 4600
F 0 "#PWR058" H 4200 4600 30  0001 C CNN
F 1 "GND" H 4200 4530 30  0001 C CNN
	1    4200 4600
	0    1    1    0   
$EndComp
NoConn ~ 4550 4500
NoConn ~ 4550 4400
NoConn ~ 4550 4300
NoConn ~ 4550 4200
NoConn ~ 4550 4000
Text HLabel 4200 3900 0    60   Input ~ 0
DIN
Text HLabel 4200 3800 0    60   Output ~ 0
DOUT
$Comp
L VCC #PWR059
U 1 1 4ABE98C2
P 4200 3700
F 0 "#PWR059" H 4200 3800 30  0001 C CNN
F 1 "VCC" H 4200 3800 30  0000 C CNN
	1    4200 3700
	0    -1   -1   0   
$EndComp
$Comp
L XBEE U8
U 1 1 4ABE98A8
P 5850 4150
F 0 "U8" H 5850 4100 60  0000 C CNN
F 1 "XBEE" H 5850 4200 60  0000 C CNN
F 2 "XBee" H 5850 4150 60  0001 C CNN
	1    5850 4150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
