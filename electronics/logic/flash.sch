EESchema Schematic File Version 2  date 2009-10-17T23:53:27 PDT
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,./logic.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 6 7
Title ""
Date "17 oct 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	7050 4300 6600 4300
Wire Wire Line
	4450 4200 5100 4200
Wire Wire Line
	4450 4000 5100 4000
Connection ~ 6650 4000
Wire Wire Line
	6650 3950 6650 4100
Wire Wire Line
	6650 4100 6600 4100
Wire Wire Line
	6650 4000 6600 4000
Wire Wire Line
	5100 4300 5050 4300
Wire Wire Line
	5050 4300 5050 4350
Wire Wire Line
	4450 4100 5100 4100
Wire Wire Line
	6600 4200 7050 4200
Text HLabel 4450 4200 0    60   Input ~ 0
/WP
Text HLabel 4450 4100 0    60   Output ~ 0
DOUT
Text HLabel 4450 4000 0    60   Input ~ 0
CS
Text HLabel 7050 4300 2    60   Input ~ 0
DIN
Text HLabel 7050 4200 2    60   Input ~ 0
CLK
$Comp
L GND #PWR038
U 1 1 4ABE8D7B
P 5050 4350
F 0 "#PWR038" H 5050 4350 30  0001 C CNN
F 1 "GND" H 5050 4280 30  0001 C CNN
	1    5050 4350
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR039
U 1 1 4ABE8D6C
P 6650 3950
F 0 "#PWR039" H 6650 4050 30  0001 C CNN
F 1 "VCC" H 6650 4050 30  0000 C CNN
	1    6650 3950
	1    0    0    -1  
$EndComp
$Comp
L W25X16AVDAIZ U6
U 1 1 4ABE8D62
P 5850 4150
F 0 "U6" H 5850 4100 60  0000 C CNN
F 1 "W25X16AVDAIZ" H 5850 4450 60  0000 C CNN
F 2 "8dip300" H 5850 4150 60  0001 C CNN
	1    5850 4150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
