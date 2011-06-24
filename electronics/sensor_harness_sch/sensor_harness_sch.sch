EESchema Schematic File Version 2  date Thu 23 Jun 2011 05:48:35 PM PDT
LIBS:power
LIBS:device
LIBS:transistors
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
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:main-cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title "noname.sch"
Date "24 jun 2011"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	2250 5550 2250 5450
Wire Wire Line
	2250 4750 2050 4750
Wire Wire Line
	4000 4750 4000 4650
Wire Wire Line
	4000 4650 2050 4650
Wire Wire Line
	3100 4550 2900 4550
Wire Wire Line
	2200 4450 2200 4400
Wire Wire Line
	3750 4550 3500 4550
Wire Wire Line
	2400 4550 2050 4550
Wire Wire Line
	2050 4450 3800 4450
Wire Wire Line
	3800 4450 3800 4150
Wire Wire Line
	3800 4150 4000 4150
Connection ~ 2200 4450
Wire Wire Line
	4000 5250 4000 5150
Wire Wire Line
	2050 4950 2250 4950
$Comp
L GND #PWR?
U 1 1 4E03DE2B
P 2250 5550
F 0 "#PWR?" H 2250 5550 30  0001 C CNN
F 1 "GND" H 2250 5480 30  0001 C CNN
	1    2250 5550
	1    0    0    -1  
$EndComp
$Comp
L THERMISTOR TH?
U 1 1 4E03DE1E
P 2250 5200
F 0 "TH?" V 2350 5250 50  0000 C CNN
F 1 "THERMISTOR" V 2150 5200 50  0000 C CNN
	1    2250 5200
	1    0    0    -1  
$EndComp
NoConn ~ 2050 4850
$Comp
L GND #PWR?
U 1 1 4E03DDBA
P 2250 4750
F 0 "#PWR?" H 2250 4750 30  0001 C CNN
F 1 "GND" H 2250 4680 30  0001 C CNN
	1    2250 4750
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 4E03DDA9
P 4000 5250
F 0 "#PWR?" H 4000 5250 30  0001 C CNN
F 1 "GND" H 4000 5180 30  0001 C CNN
	1    4000 5250
	1    0    0    -1  
$EndComp
$Comp
L NPN Q?
U 1 1 4E03DD91
P 3900 4950
F 0 "Q?" H 3900 4800 50  0000 R CNN
F 1 "PHOTOTRANSISTOR" H 3900 5100 50  0000 R CNN
	1    3900 4950
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 4E03DD64
P 4000 4400
F 0 "R?" V 4080 4400 50  0000 C CNN
F 1 "220R" V 4000 4400 50  0000 C CNN
	1    4000 4400
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR?
U 1 1 4E03DD04
P 3750 4550
F 0 "#PWR?" H 3750 4550 30  0001 C CNN
F 1 "GND" H 3750 4480 30  0001 C CNN
	1    3750 4550
	0    -1   -1   0   
$EndComp
$Comp
L LED D?
U 1 1 4E03DCF1
P 3300 4550
F 0 "D?" H 3300 4650 50  0000 C CNN
F 1 "LED" H 3300 4450 50  0000 C CNN
	1    3300 4550
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 4E03DC90
P 2650 4550
F 0 "R?" V 2730 4550 50  0000 C CNN
F 1 "470R" V 2650 4550 50  0000 C CNN
	1    2650 4550
	0    1    1    0   
$EndComp
$Comp
L +3.3V #PWR?
U 1 1 4E03DBA0
P 2200 4400
F 0 "#PWR?" H 2200 4360 30  0001 C CNN
F 1 "+3.3V" H 2200 4510 30  0000 C CNN
	1    2200 4400
	1    0    0    -1  
$EndComp
$Comp
L CONN_6 P?
U 1 1 4E03DB7E
P 1700 4700
F 0 "P?" V 1650 4700 60  0000 C CNN
F 1 "CONN_6" V 1750 4700 60  0000 C CNN
	1    1700 4700
	-1   0    0    1   
$EndComp
$EndSCHEMATC
