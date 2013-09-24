EESchema Schematic File Version 2  date 2013-09-24T15:17:21 PDT
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
Date "24 sep 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5100 3750 5150 3750
Wire Wire Line
	5150 3850 5100 3850
Wire Wire Line
	5150 3950 5050 3950
Connection ~ 4750 4400
Wire Wire Line
	4750 4600 4750 4250
Wire Wire Line
	4750 4400 4550 4400
Wire Wire Line
	4750 4250 5150 4250
Connection ~ 5050 4450
Wire Wire Line
	5150 4450 5050 4450
Wire Wire Line
	6850 4150 6750 4150
Wire Wire Line
	6850 3950 6750 3950
Wire Wire Line
	5150 3550 5050 3550
Wire Wire Line
	5050 3450 5150 3450
Wire Wire Line
	5050 4050 5150 4050
Wire Wire Line
	6750 3850 6850 3850
Wire Wire Line
	6750 4050 6850 4050
Wire Wire Line
	5050 4650 5050 4350
Wire Wire Line
	5050 4350 5150 4350
Wire Wire Line
	4750 4550 5150 4550
Connection ~ 4750 4550
Wire Wire Line
	4600 4350 4600 4400
Connection ~ 4600 4400
Wire Wire Line
	4750 5050 4750 5000
Wire Wire Line
	5050 4150 5150 4150
Wire Wire Line
	5100 3650 5150 3650
$Comp
L GND #PWR115
U 1 1 512817DF
P 5100 3850
F 0 "#PWR115" H 5100 3850 30  0001 C CNN
F 1 "GND" H 5100 3780 30  0001 C CNN
	1    5100 3850
	0    1    1    0   
$EndComp
$Comp
L GND #PWR114
U 1 1 512817F6
P 5100 3750
F 0 "#PWR114" H 5100 3750 30  0001 C CNN
F 1 "GND" H 5100 3680 30  0001 C CNN
	1    5100 3750
	0    1    1    0   
$EndComp
$Comp
L GND #PWR113
U 1 1 512817F7
P 5100 3650
F 0 "#PWR113" H 5100 3650 30  0001 C CNN
F 1 "GND" H 5100 3580 30  0001 C CNN
	1    5100 3650
	0    1    1    0   
$EndComp
Text HLabel 5050 3950 0    60   Input ~ 0
THERM
$Comp
L MCP3008 U49
U 1 1 512814D3
P 5950 4000
F 0 "U49" H 5950 3950 60  0000 C CNN
F 1 "MCP3008" H 5950 4050 60  0000 C CNN
F 4 "MCP3008-I/SL-ND" H 5950 4000 60  0001 C CNN "Digi-Key Part"
	1    5950 4000
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR110
U 1 1 50E52949
P 4600 4350
F 0 "#PWR110" H 4600 4310 30  0001 C CNN
F 1 "+3.3V" H 4600 4460 30  0000 C CNN
	1    4600 4350
	1    0    0    -1  
$EndComp
Text HLabel 4550 4400 0    60   Output ~ 0
VREF
$Comp
L GND #PWR111
U 1 1 4F619657
P 4750 5050
F 0 "#PWR111" H 4750 5050 30  0001 C CNN
F 1 "GND" H 4750 4980 30  0001 C CNN
	1    4750 5050
	1    0    0    -1  
$EndComp
$Comp
L C C60
U 1 1 4F619636
P 4750 4800
F 0 "C60" H 4800 4900 50  0000 L CNN
F 1 "1uF" H 4800 4700 50  0000 L CNN
	1    4750 4800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR112
U 1 1 4F619488
P 5050 4650
F 0 "#PWR112" H 5050 4650 30  0001 C CNN
F 1 "GND" H 5050 4580 30  0001 C CNN
	1    5050 4650
	1    0    0    -1  
$EndComp
Text HLabel 5050 4150 0    60   Input ~ 0
BB
Text HLabel 5050 4050 0    60   Input ~ 0
LPS
Text HLabel 5050 3550 0    60   Input ~ 0
BATT
Text HLabel 5050 3450 0    60   Input ~ 0
CAPS
Text HLabel 6850 4050 2    60   Output ~ 0
MISO
Text HLabel 6850 4150 2    60   Input ~ 0
CLK
Text HLabel 6850 3950 2    60   Input ~ 0
MOSI
Text HLabel 6850 3850 2    60   Input ~ 0
/CS
$EndSCHEMATC
