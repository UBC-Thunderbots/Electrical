EESchema Schematic File Version 2  date 11/25/2010 12:29:41 AM
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
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 18 18
Title ""
Date "25 nov 2010"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L V7805-1000 U12
U 1 1 4CD667A4
P 4400 3550
F 0 "U12" H 4550 3354 60  0000 C CNN
F 1 "V7805-1000" H 4400 3750 60  0000 C CNN
	1    4400 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 4000 3950 4100
Connection ~ 3950 3500
Wire Wire Line
	3550 4000 3550 4100
Wire Wire Line
	5050 3600 5050 3500
Connection ~ 3550 4100
Wire Wire Line
	4000 3500 3000 3500
Wire Wire Line
	2750 3650 3000 3650
Wire Wire Line
	3000 3650 3000 3500
Connection ~ 7450 4100
Wire Wire Line
	8150 4000 8150 4100
Wire Wire Line
	6750 3600 6750 3400
Wire Wire Line
	4400 4200 4400 3800
Wire Wire Line
	7450 4100 7450 3800
Connection ~ 6750 3500
Connection ~ 6100 4100
Wire Wire Line
	5500 4100 5500 4000
Wire Wire Line
	5700 3500 4800 3500
Connection ~ 5050 4100
Connection ~ 5050 3500
Connection ~ 4400 4100
Wire Wire Line
	5500 3600 5500 3500
Connection ~ 5500 3500
Wire Wire Line
	6100 4100 6100 3800
Connection ~ 5500 4100
Wire Wire Line
	7050 3500 6500 3500
Wire Wire Line
	8150 3500 7850 3500
Wire Wire Line
	5300 3400 5300 3500
Connection ~ 5300 3500
Wire Wire Line
	6750 4000 6750 4100
Connection ~ 6750 4100
Wire Wire Line
	8150 3600 8150 3400
Connection ~ 8150 3500
Wire Wire Line
	3000 3850 3000 4100
Wire Wire Line
	3000 3850 2750 3850
Connection ~ 3950 4100
Wire Wire Line
	3000 4100 8150 4100
Wire Wire Line
	5050 4000 5050 4100
Wire Wire Line
	3550 3600 3550 3500
Connection ~ 3550 3500
Wire Wire Line
	3950 3600 3950 3450
$Comp
L C C22
U 1 1 4CC478AC
P 5050 3800
F 0 "C22" H 5100 3900 50  0000 L CNN
F 1 "10uF" H 5100 3700 50  0000 L CNN
F 4 "" H 5050 3800 60  0001 C CNN "Digikey Part"
	1    5050 3800
	1    0    0    -1  
$EndComp
$Comp
L C C21
U 1 1 4CC4781A
P 3550 3800
F 0 "C21" H 3600 3900 50  0000 L CNN
F 1 "10uF" H 3600 3700 50  0000 L CNN
F 4 "" H 3550 3800 60  0001 C CNN "Digikey Part"
	1    3550 3800
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P7
U 1 1 4CC474AD
P 2400 3750
F 0 "P7" V 2350 3750 40  0000 C CNN
F 1 "CONN_2" V 2450 3750 40  0000 C CNN
F 2 "643226-1" H 2400 3750 60  0001 C CNN
F 4 "A25213-ND" H 2400 3750 60  0001 C CNN "Field1"
	1    2400 3750
	-1   0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG0126
U 1 1 4CC474AA
P 3000 3500
F 0 "#FLG0126" H 3000 3770 30  0001 C CNN
F 1 "PWR_FLAG" H 3000 3730 30  0000 C CNN
	1    3000 3500
	-1   0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG0127
U 1 1 4CC474A9
P 3000 4100
F 0 "#FLG0127" H 3000 4370 30  0001 C CNN
F 1 "PWR_FLAG" H 3000 4330 30  0000 C CNN
	1    3000 4100
	1    0    0    1   
$EndComp
$Comp
L CP C14
U 1 1 4ABF00CA
P 3950 3800
F 0 "C14" H 4000 3900 50  0000 L CNN
F 1 "100uF" H 4000 3700 50  0000 L CNN
	1    3950 3800
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 4ABE8225
P 8150 3800
F 0 "C5" H 8200 3900 50  0000 L CNN
F 1 "1uF" H 8200 3700 50  0000 L CNN
F 4 "" H 8150 3800 60  0001 C CNN "Digikey Part"
	1    8150 3800
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 4ABE8044
P 6750 3800
F 0 "C3" H 6800 3900 50  0000 L CNN
F 1 "10uF" H 6800 3700 50  0000 L CNN
F 4 "" H 6750 3800 60  0001 C CNN "Digikey Part"
	1    6750 3800
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR0128
U 1 1 4CC361C8
P 6750 3400
F 0 "#PWR0128" H 6750 3360 30  0001 C CNN
F 1 "+3.3V" H 6750 3510 30  0000 C CNN
	1    6750 3400
	1    0    0    -1  
$EndComp
$Comp
L MCP1827S-1202E/AB U5
U 1 1 4B5A15B3
P 7450 3550
F 0 "U5" H 7600 3354 60  0000 C CNN
F 1 "MCP1827S-1202E/AB" H 7450 3750 60  0000 C CNN
F 2 "TO220_VERT" H 7500 3254 60  0001 C CNN
	1    7450 3550
	1    0    0    -1  
$EndComp
$Comp
L LD1117V33C U4
U 1 1 4B5A15A3
P 6100 3550
F 0 "U4" H 6250 3354 60  0000 C CNN
F 1 "LD1117V33C" H 6100 3750 60  0000 C CNN
F 2 "TO220_VERT" H 6150 3254 60  0001 C CNN
	1    6100 3550
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR0129
U 1 1 4ADACEE2
P 5300 3400
F 0 "#PWR0129" H 5300 3490 20  0001 C CNN
F 1 "+5V" H 5300 3490 30  0000 C CNN
	1    5300 3400
	1    0    0    -1  
$EndComp
$Comp
L +1.2V #PWR0130
U 1 1 4ABE8237
P 8150 3400
F 0 "#PWR0130" H 8150 3540 20  0001 C CNN
F 1 "+1.2V" H 8150 3510 30  0000 C CNN
	1    8150 3400
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 4ABE8019
P 5500 3800
F 0 "C1" H 5550 3900 50  0000 L CNN
F 1 "100nF" H 5550 3700 50  0000 L CNN
	1    5500 3800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0131
U 1 1 4ABE7E4F
P 4400 4200
F 0 "#PWR0131" H 4400 4200 30  0001 C CNN
F 1 "GND" H 4400 4130 30  0001 C CNN
	1    4400 4200
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR0132
U 1 1 4ABE7E3F
P 3950 3450
F 0 "#PWR0132" H 3950 3400 20  0001 C CNN
F 1 "+BATT" H 3950 3550 30  0000 C CNN
	1    3950 3450
	1    0    0    -1  
$EndComp
$EndSCHEMATC
