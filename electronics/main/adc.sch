EESchema Schematic File Version 2  date 2012-03-20T22:29:00 PDT
LIBS:power
LIBS:device
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:contrib
LIBS:valves
LIBS:thunderbots-symbols
LIBS:main-cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 4 17
Title ""
Date "21 mar 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 4750 4700
Wire Wire Line
	4750 4750 4750 4700
Connection ~ 4750 4300
Connection ~ 4750 4150
Wire Wire Line
	4750 4300 4750 3850
Wire Wire Line
	3850 4450 3850 4500
Connection ~ 4750 4100
Wire Wire Line
	4750 4150 5150 4150
Connection ~ 4750 4000
Wire Wire Line
	4700 4000 4750 4000
Wire Wire Line
	4750 4100 4700 4100
Wire Wire Line
	4750 3950 4700 3950
Wire Wire Line
	5150 3950 5050 3950
Wire Wire Line
	5050 3950 5050 4250
Wire Wire Line
	6750 3850 6850 3850
Wire Wire Line
	6750 3650 6850 3650
Wire Wire Line
	5050 3650 5150 3650
Wire Wire Line
	5050 3450 5150 3450
Wire Wire Line
	5150 3550 5050 3550
Wire Wire Line
	5150 3750 5050 3750
Wire Wire Line
	6850 3750 6750 3750
Wire Wire Line
	6850 3950 6750 3950
Wire Wire Line
	5150 4050 5050 4050
Connection ~ 5050 4050
Wire Wire Line
	4700 4050 4750 4050
Connection ~ 4750 4050
Wire Wire Line
	4750 3850 5150 3850
Connection ~ 4750 3950
Wire Wire Line
	3850 4000 3900 4000
Wire Wire Line
	3850 4050 3850 3950
Connection ~ 3850 4000
Wire Wire Line
	4300 4300 4300 4350
Wire Wire Line
	4600 4300 4900 4300
Wire Wire Line
	4600 4700 4900 4700
$Comp
L GND #PWR?
U 1 1 4F619657
P 4750 4750
F 0 "#PWR?" H 4750 4750 30  0001 C CNN
F 1 "GND" H 4750 4680 30  0001 C CNN
	1    4750 4750
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 4F619636
P 4900 4500
F 0 "C?" H 4950 4600 50  0000 L CNN
F 1 "100nF" H 4950 4400 50  0000 L CNN
	1    4900 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 4F61951D
P 3850 4500
F 0 "#PWR?" H 3850 4500 30  0001 C CNN
F 1 "GND" H 3850 4430 30  0001 C CNN
	1    3850 4500
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 4F619511
P 4600 4500
F 0 "C?" H 4650 4600 50  0000 L CNN
F 1 "10uF" H 4650 4400 50  0000 L CNN
	1    4600 4500
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 4F61950F
P 3850 4250
F 0 "C?" H 3900 4350 50  0000 L CNN
F 1 "100nF" H 3900 4150 50  0000 L CNN
	1    3850 4250
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 4F6194AC
P 3850 3950
F 0 "#PWR?" H 3850 4040 20  0001 C CNN
F 1 "+5V" H 3850 4040 30  0000 C CNN
	1    3850 3950
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 4F6194A6
P 4300 4350
F 0 "#PWR?" H 4300 4350 30  0001 C CNN
F 1 "GND" H 4300 4280 30  0001 C CNN
	1    4300 4350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 4F619488
P 5050 4250
F 0 "#PWR?" H 5050 4250 30  0001 C CNN
F 1 "GND" H 5050 4180 30  0001 C CNN
	1    5050 4250
	1    0    0    -1  
$EndComp
$Comp
L LD1117D33 U?
U 1 1 4F619459
P 4300 4050
F 0 "U?" H 4450 3854 60  0000 C CNN
F 1 "LD1117D33" H 4300 4250 60  0000 C CNN
F 2 "SO8E" H 4300 3750 60  0001 C CNN
F 3 "497-7306-1-ND" H 4300 3650 60  0001 C CNN
	1    4300 4050
	1    0    0    -1  
$EndComp
Text HLabel 5050 3750 0    60   Input ~ 0
CH3
Text HLabel 5050 3650 0    60   Input ~ 0
CH2
Text HLabel 5050 3550 0    60   Input ~ 0
CH1
Text HLabel 5050 3450 0    60   Input ~ 0
CH0
Text HLabel 6850 3850 2    60   Output ~ 0
MISO
Text HLabel 6850 3950 2    60   Input ~ 0
CLK
Text HLabel 6850 3750 2    60   Input ~ 0
MOSI
Text HLabel 6850 3650 2    60   Input ~ 0
/CS
$Comp
L MCP3004 U?
U 1 1 4F618F15
P 5950 3800
F 0 "U?" H 5950 3750 60  0000 C CNN
F 1 "MCP3004" H 5950 3850 60  0000 C CNN
	1    5950 3800
	1    0    0    -1  
$EndComp
$EndSCHEMATC
