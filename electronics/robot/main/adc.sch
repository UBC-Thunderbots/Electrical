EESchema Schematic File Version 2  date 2012-10-15T00:42:56 PDT
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
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 8 15
Title ""
Date "15 oct 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4750 4650 4750 4600
Connection ~ 4600 4000
Wire Wire Line
	4600 3950 4600 4000
Connection ~ 4750 4150
Wire Wire Line
	4750 4150 5150 4150
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
	5150 3850 4750 3850
Wire Wire Line
	4750 4000 4550 4000
Wire Wire Line
	4750 3850 4750 4200
Connection ~ 4750 4000
$Comp
L +3.3V #PWR090
U 1 1 00000000
P 4600 3950
F 0 "#PWR090" H 4600 3910 30  0001 C CNN
F 1 "+3.3V" H 4600 4060 30  0000 C CNN
	1    4600 3950
	1    0    0    -1  
$EndComp
Text HLabel 4550 4000 0    60   Output ~ 0
VREF
$Comp
L GND #PWR091
U 1 1 4F619657
P 4750 4650
F 0 "#PWR091" H 4750 4650 30  0001 C CNN
F 1 "GND" H 4750 4580 30  0001 C CNN
	1    4750 4650
	1    0    0    -1  
$EndComp
$Comp
L C C60
U 1 1 4F619636
P 4750 4400
F 0 "C60" H 4800 4500 50  0000 L CNN
F 1 "1uF" H 4800 4300 50  0000 L CNN
	1    4750 4400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR092
U 1 1 4F619488
P 5050 4250
F 0 "#PWR092" H 5050 4250 30  0001 C CNN
F 1 "GND" H 5050 4180 30  0001 C CNN
	1    5050 4250
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
L MCP3004 U49
U 1 1 4F618F15
P 5950 3800
F 0 "U49" H 5950 3750 60  0000 C CNN
F 1 "MCP3004" H 5950 3850 60  0000 C CNN
F 2 "SO14E" H 5950 3800 60  0001 C CNN
F 4 "MCP3004-I/SL-ND" H 5950 3800 60  0001 C CNN "Field1"
	1    5950 3800
	1    0    0    -1  
$EndComp
$EndSCHEMATC
