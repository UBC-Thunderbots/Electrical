EESchema Schematic File Version 1
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,./fpga-prototype.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 6 7
Title ""
Date "27 sep 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 7150 2650
Wire Wire Line
	7150 2550 7150 2750
Wire Wire Line
	7150 2650 6850 2650
Wire Wire Line
	6050 2650 5500 2650
Connection ~ 4500 3250
Wire Wire Line
	5100 3250 5100 2950
Connection ~ 4500 2650
Wire Wire Line
	4500 2750 4500 2650
Connection ~ 3400 3250
Wire Wire Line
	3400 3250 3400 2950
Wire Wire Line
	4050 2650 4050 2750
Connection ~ 2750 2650
Wire Wire Line
	2750 2650 3000 2650
Wire Wire Line
	2750 2550 2750 2750
Wire Wire Line
	2750 3150 2750 3350
Wire Wire Line
	4050 3250 4050 3150
Connection ~ 2750 3250
Connection ~ 4050 2650
Connection ~ 4050 3250
Wire Wire Line
	4700 2650 3800 2650
Wire Wire Line
	4500 3250 4500 3150
Wire Wire Line
	5750 3250 5750 3150
Connection ~ 5100 3250
Wire Wire Line
	5750 2750 5750 2550
Connection ~ 5750 2650
Wire Wire Line
	6450 3250 6450 2950
Connection ~ 5750 3250
Wire Wire Line
	2750 3250 7150 3250
Wire Wire Line
	7150 3250 7150 3150
Connection ~ 6450 3250
$Comp
L +1.2V #PWR017
U 1 1 4ABE8237
P 7150 2550
F 0 "#PWR017" H 7150 2690 20  0001 C C
F 1 "+1.2V" H 7150 2660 30  0000 C C
	1    7150 2550
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 4ABE8225
P 7150 2950
F 0 "C5" H 7200 3050 50  0000 L C
F 1 "1uF" H 7200 2850 50  0000 L C
	1    7150 2950
	1    0    0    -1  
$EndComp
$Comp
L MCP1827S-1202E/AB U5
U 1 1 4ABE820F
P 6450 2700
F 0 "U5" H 6600 2504 60  0000 C C
F 1 "MCP1827S-1202E/AB" H 6450 2900 60  0000 C C
	1    6450 2700
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR018
U 1 1 4ABE8056
P 5750 2550
F 0 "#PWR018" H 5750 2650 30  0001 C C
F 1 "VCC" H 5750 2650 30  0000 C C
	1    5750 2550
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 4ABE8044
P 5750 2950
F 0 "C3" H 5800 3050 50  0000 L C
F 1 "10uF" H 5800 2850 50  0000 L C
	1    5750 2950
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 4ABE8019
P 4500 2950
F 0 "C1" H 4550 3050 50  0000 L C
F 1 "100nF" H 4550 2850 50  0000 L C
	1    4500 2950
	1    0    0    -1  
$EndComp
$Comp
L LD1117V33C U4
U 1 1 4ABE7FD2
P 5100 2700
F 0 "U4" H 5250 2504 60  0000 C C
F 1 "LD1117V33C" H 5100 2900 60  0000 C C
	1    5100 2700
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 4ABE7EE7
P 4050 2950
F 0 "C2" H 4100 3050 50  0000 L C
F 1 "100uF" H 4100 2850 50  0000 L C
	1    4050 2950
	1    0    0    -1  
$EndComp
$Comp
L 7805 U3
U 1 1 4ABE7E71
P 3400 2700
F 0 "U3" H 3550 2504 60  0000 C C
F 1 "7805" H 3400 2900 60  0000 C C
	1    3400 2700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR019
U 1 1 4ABE7E4F
P 2750 3350
F 0 "#PWR019" H 2750 3350 30  0001 C C
F 1 "GND" H 2750 3280 30  0001 C C
	1    2750 3350
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 4ABE7E49
P 2750 2950
F 0 "C4" H 2800 3050 50  0000 L C
F 1 "1uF" H 2800 2850 50  0000 L C
	1    2750 2950
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR020
U 1 1 4ABE7E3F
P 2750 2550
F 0 "#PWR020" H 2750 2500 20  0001 C C
F 1 "+BATT" H 2750 2650 30  0000 C C
	1    2750 2550
	1    0    0    -1  
$EndComp
$EndSCHEMATC
