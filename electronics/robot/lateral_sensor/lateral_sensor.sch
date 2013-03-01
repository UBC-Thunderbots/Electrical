EESchema Schematic File Version 2  date Thu 28 Feb 2013 06:45:47 PM PST
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
LIBS:thunderbots-symbols
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "1 mar 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	1800 3350 1800 3300
Wire Wire Line
	9200 4850 9200 5200
Wire Wire Line
	1700 4250 2050 4250
Wire Wire Line
	2050 4250 2050 4950
Wire Wire Line
	2050 4950 4850 4950
Wire Wire Line
	2550 4800 2200 4800
Wire Wire Line
	2200 4800 2200 4150
Wire Wire Line
	2200 4050 2200 2450
Wire Wire Line
	2200 4050 1700 4050
Connection ~ 5000 3350
Wire Wire Line
	5000 3650 5000 3350
Wire Wire Line
	9350 3700 9350 3350
Wire Wire Line
	9350 3350 2600 3350
Wire Wire Line
	2600 3350 2600 3650
Wire Wire Line
	2600 3650 2700 3650
Wire Wire Line
	4350 4800 4350 4700
Wire Wire Line
	4350 4700 4300 4700
Connection ~ 6900 2150
Wire Wire Line
	6900 2150 6150 2150
Wire Wire Line
	6150 2150 6150 2550
Wire Wire Line
	6150 2550 4100 2550
Wire Wire Line
	6900 2100 6900 2250
Wire Wire Line
	3400 1750 3400 1900
Wire Wire Line
	3400 3000 3400 3150
Wire Wire Line
	4100 2350 4650 2350
Wire Wire Line
	4650 2350 4650 1400
Wire Wire Line
	4650 1400 2300 1400
Wire Wire Line
	2300 1400 2300 2450
Connection ~ 2300 2450
Wire Wire Line
	6900 1350 6900 1600
Wire Wire Line
	6900 2750 6900 2950
Connection ~ 5750 2550
Wire Wire Line
	4300 3650 4350 3650
Wire Wire Line
	4350 3650 4350 3750
Wire Wire Line
	2550 4300 2550 4200
Wire Wire Line
	2550 4200 2700 4200
Wire Wire Line
	2700 4200 2700 4700
Wire Wire Line
	6650 4800 6650 4700
Wire Wire Line
	6650 4700 6600 4700
Wire Wire Line
	6600 3650 6650 3650
Wire Wire Line
	6650 3650 6650 3750
Wire Wire Line
	4850 4300 4850 4200
Wire Wire Line
	4850 4200 5000 4200
Wire Wire Line
	5000 4200 5000 4700
Wire Wire Line
	8850 4750 8850 4650
Wire Wire Line
	8850 4650 8800 4650
Wire Wire Line
	8800 3600 8850 3600
Wire Wire Line
	8850 3600 8850 3700
Wire Wire Line
	7050 4250 7050 4150
Wire Wire Line
	7050 4150 7200 4150
Wire Wire Line
	7200 4150 7200 4650
Wire Wire Line
	11000 4850 11000 4750
Wire Wire Line
	11000 4750 10950 4750
Wire Wire Line
	10950 3700 11000 3700
Wire Wire Line
	11000 3700 11000 3800
Wire Wire Line
	9200 4350 9200 4250
Wire Wire Line
	9200 4250 9350 4250
Wire Wire Line
	9350 4250 9350 4750
Wire Wire Line
	2200 2450 2500 2450
Wire Wire Line
	7200 3600 7200 3350
Connection ~ 7200 3350
Wire Wire Line
	5750 2550 5750 3350
Connection ~ 5750 3350
Wire Wire Line
	4850 4950 4850 4800
Wire Wire Line
	1700 3850 1700 3650
Wire Wire Line
	1700 3650 1600 3650
Wire Wire Line
	1600 3650 1600 3700
Wire Wire Line
	1900 3750 1900 3950
Wire Wire Line
	1900 3950 1700 3950
Wire Wire Line
	2200 4150 1700 4150
Wire Wire Line
	7050 4750 7050 5100
Wire Wire Line
	7050 5100 1900 5100
Wire Wire Line
	1900 5100 1900 4350
Wire Wire Line
	1900 4350 1700 4350
Wire Wire Line
	9200 5200 1750 5200
Wire Wire Line
	1750 5200 1750 4450
Wire Wire Line
	1750 4450 1700 4450
$Comp
L GND #PWR01
U 1 1 5095767D
P 1800 3350
F 0 "#PWR01" H 1800 3350 30  0001 C CNN
F 1 "GND" H 1800 3280 30  0001 C CNN
	1    1800 3350
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR02
U 1 1 5095767A
P 1800 2900
F 0 "#PWR02" H 1800 3000 30  0001 C CNN
F 1 "VCC" H 1800 3000 30  0000 C CNN
	1    1800 2900
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 50957676
P 1800 3100
F 0 "C1" H 1850 3200 50  0000 L CNN
F 1 "10uF" H 1850 3000 50  0000 L CNN
	1    1800 3100
	1    0    0    -1  
$EndComp
$Comp
L CONN_7 P1
U 1 1 509574B0
P 1350 4150
F 0 "P1" V 1320 4150 60  0000 C CNN
F 1 "CONN_7" V 1420 4150 60  0000 C CNN
F 4 "WM7625CT-ND" V 1350 4150 60  0001 C CNN "Digi-Key Part"
	1    1350 4150
	-1   0    0    1   
$EndComp
$Comp
L VCC #PWR03
U 1 1 5095749B
P 1900 3750
F 0 "#PWR03" H 1900 3850 30  0001 C CNN
F 1 "VCC" H 1900 3850 30  0000 C CNN
	1    1900 3750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 4B1F4585
P 1600 3700
F 0 "#PWR04" H 1600 3700 30  0001 C CNN
F 1 "GND" H 1600 3630 30  0001 C CNN
	1    1600 3700
	1    0    0    -1  
$EndComp
$Comp
L R R6
U 1 1 4B27D7CB
P 9200 4600
F 0 "R6" V 9280 4600 50  0000 C CNN
F 1 "100R" V 9200 4600 50  0000 C CNN
	1    9200 4600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 4B27D7CA
P 11000 4850
F 0 "#PWR05" H 11000 4850 30  0001 C CNN
F 1 "GND" H 11000 4780 30  0001 C CNN
	1    11000 4850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 4B27D7C9
P 11000 3800
F 0 "#PWR06" H 11000 3800 30  0001 C CNN
F 1 "GND" H 11000 3730 30  0001 C CNN
	1    11000 3800
	1    0    0    -1  
$EndComp
$Comp
L OPB733TR U9
U 1 1 4B27D7C7
P 10200 4250
F 0 "U9" H 10200 4300 60  0000 C CNN
F 1 "OPB733TR" H 10200 4200 60  0000 C CNN
F 4 "365-1510-1-ND" H 10200 4250 60  0001 C CNN "Digi-Key Part"
	1    10200 4250
	-1   0    0    1   
$EndComp
$Comp
L R R5
U 1 1 4B27D7BC
P 7050 4500
F 0 "R5" V 7130 4500 50  0000 C CNN
F 1 "100R" V 7050 4500 50  0000 C CNN
	1    7050 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 4B27D7BB
P 8850 4750
F 0 "#PWR07" H 8850 4750 30  0001 C CNN
F 1 "GND" H 8850 4680 30  0001 C CNN
	1    8850 4750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 4B27D7BA
P 8850 3700
F 0 "#PWR08" H 8850 3700 30  0001 C CNN
F 1 "GND" H 8850 3630 30  0001 C CNN
	1    8850 3700
	1    0    0    -1  
$EndComp
$Comp
L OPB733TR U7
U 1 1 4B27D7B8
P 8050 4150
F 0 "U7" H 8050 4200 60  0000 C CNN
F 1 "OPB733TR" H 8050 4100 60  0000 C CNN
F 4 "365-1510-1-ND" H 8050 4150 60  0001 C CNN "Digi-Key Part"
	1    8050 4150
	-1   0    0    1   
$EndComp
$Comp
L R R4
U 1 1 4B27D7A9
P 4850 4550
F 0 "R4" V 4930 4550 50  0000 C CNN
F 1 "100R" V 4850 4550 50  0000 C CNN
	1    4850 4550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR09
U 1 1 4B27D7A8
P 6650 4800
F 0 "#PWR09" H 6650 4800 30  0001 C CNN
F 1 "GND" H 6650 4730 30  0001 C CNN
	1    6650 4800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 4B27D7A7
P 6650 3750
F 0 "#PWR010" H 6650 3750 30  0001 C CNN
F 1 "GND" H 6650 3680 30  0001 C CNN
	1    6650 3750
	1    0    0    -1  
$EndComp
$Comp
L OPB733TR U5
U 1 1 4B27D7A5
P 5850 4200
F 0 "U5" H 5850 4250 60  0000 C CNN
F 1 "OPB733TR" H 5850 4150 60  0000 C CNN
F 4 "365-1510-1-ND" H 5850 4200 60  0001 C CNN "Digi-Key Part"
	1    5850 4200
	-1   0    0    1   
$EndComp
$Comp
L R R3
U 1 1 4B27D75C
P 2550 4550
F 0 "R3" V 2630 4550 50  0000 C CNN
F 1 "100R" V 2550 4550 50  0000 C CNN
	1    2550 4550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR011
U 1 1 4B27D745
P 4350 4800
F 0 "#PWR011" H 4350 4800 30  0001 C CNN
F 1 "GND" H 4350 4730 30  0001 C CNN
	1    4350 4800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR012
U 1 1 4B27D740
P 4350 3750
F 0 "#PWR012" H 4350 3750 30  0001 C CNN
F 1 "GND" H 4350 3680 30  0001 C CNN
	1    4350 3750
	1    0    0    -1  
$EndComp
$Comp
L OPB733TR U3
U 1 1 4B27D6A6
P 3550 4200
F 0 "U3" H 3550 4250 60  0000 C CNN
F 1 "OPB733TR" H 3550 4150 60  0000 C CNN
F 4 "365-1510-1-ND" H 3550 4200 60  0001 C CNN "Digi-Key Part"
	1    3550 4200
	-1   0    0    1   
$EndComp
$Comp
L VCC #PWR013
U 1 1 4B1F4757
P 6900 1350
F 0 "#PWR013" H 6900 1450 30  0001 C CNN
F 1 "VCC" H 6900 1450 30  0000 C CNN
	1    6900 1350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR014
U 1 1 4B1F4752
P 6900 2950
F 0 "#PWR014" H 6900 2950 30  0001 C CNN
F 1 "GND" H 6900 2880 30  0001 C CNN
	1    6900 2950
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 4B1F474B
P 6900 2500
F 0 "R2" V 6980 2500 50  0000 C CNN
F 1 "5R" V 6900 2500 50  0000 C CNN
	1    6900 2500
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4B1F4749
P 6900 1850
F 0 "R1" V 6980 1850 50  0000 C CNN
F 1 "88R" V 6900 1850 50  0000 C CNN
	1    6900 1850
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR015
U 1 1 4B1F4722
P 3400 1750
F 0 "#PWR015" H 3400 1850 30  0001 C CNN
F 1 "VCC" H 3400 1850 30  0000 C CNN
	1    3400 1750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR016
U 1 1 4B1F471D
P 3400 3150
F 0 "#PWR016" H 3400 3150 30  0001 C CNN
F 1 "GND" H 3400 3080 30  0001 C CNN
	1    3400 3150
	1    0    0    -1  
$EndComp
$Comp
L MIC7300 U1
U 1 1 4B1F46E6
P 3300 2450
F 0 "U1" H 3300 2500 60  0000 C CNN
F 1 "MIC7300" H 3300 2400 60  0000 C CNN
F 4 "576-1319-1-ND" H 3300 2450 60  0001 C CNN "Digi-Key Part"
	1    3300 2450
	-1   0    0    -1  
$EndComp
$EndSCHEMATC
