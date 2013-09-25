EESchema Schematic File Version 2  date 2013-09-25T12:44:19 PDT
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
Sheet 7 14
Title ""
Date "25 sep 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Bus Line
	5100 4350 5100 3550
Wire Bus Line
	5100 3550 4800 3550
Wire Wire Line
	5550 3850 5200 3850
Wire Wire Line
	5550 3750 5200 3750
Wire Wire Line
	5500 4250 5550 4250
Wire Wire Line
	5500 4050 5550 4050
Wire Wire Line
	6350 4400 6350 4350
Wire Wire Line
	5500 4550 5550 4550
Wire Wire Line
	6350 3950 6350 3900
Wire Wire Line
	5550 3950 4800 3950
Wire Wire Line
	4800 4150 5550 4150
Wire Wire Line
	4800 4650 5550 4650
Wire Wire Line
	5200 4350 5550 4350
Wire Wire Line
	5200 4450 5550 4450
Text HLabel 4800 3550 0    60   BiDi ~ 0
SD_D[0..3]
Entry Wire Line
	5100 4350 5200 4450
Entry Wire Line
	5100 4250 5200 4350
Entry Wire Line
	5100 3750 5200 3850
Entry Wire Line
	5100 3750 5200 3850
Entry Wire Line
	5100 3650 5200 3750
Text Label 5250 4450 0    60   ~ 0
SD_D1
Text Label 5250 4350 0    60   ~ 0
SD_D0
$Comp
L GND #PWR90
U 1 1 524331E5
P 5500 4250
F 0 "#PWR90" H 5500 4250 30  0001 C CNN
F 1 "GND" H 5500 4180 30  0001 C CNN
	1    5500 4250
	0    1    1    0   
$EndComp
Text HLabel 4800 4150 0    60   Input ~ 0
SD_CK
$Comp
L +3.3V #PWR89
U 1 1 524331F5
P 5500 4050
F 0 "#PWR89" H 5500 4010 30  0001 C CNN
F 1 "+3.3V" H 5500 4160 30  0000 C CNN
	1    5500 4050
	0    -1   -1   0   
$EndComp
Text HLabel 4800 3950 0    60   BiDi ~ 0
SD_CMD
Text Label 5250 3750 0    60   ~ 0
SD_D2
Text Label 5250 3850 0    60   ~ 0
SD_D3
$Comp
L GND #PWR93
U 1 1 52420F7F
P 6350 4400
F 0 "#PWR93" H 6350 4400 30  0001 C CNN
F 1 "GND" H 6350 4330 30  0001 C CNN
	1    6350 4400
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR92
U 1 1 507B4D54
P 6350 3900
F 0 "#PWR92" H 6350 3860 30  0001 C CNN
F 1 "+3.3V" H 6350 4010 30  0000 C CNN
	1    6350 3900
	1    0    0    -1  
$EndComp
$Comp
L C C49
U 1 1 507B4D55
P 6350 4150
F 0 "C49" H 6400 4250 50  0000 L CNN
F 1 "100nF" H 6400 4050 50  0000 L CNN
	1    6350 4150
	1    0    0    -1  
$EndComp
Text HLabel 4800 4650 0    60   Output ~ 0
SD_CD
$Comp
L +3.3V #PWR91
U 1 1 506E24B6
P 5500 4550
F 0 "#PWR91" H 5500 4510 30  0001 C CNN
F 1 "+3.3V" H 5500 4660 30  0000 C CNN
	1    5500 4550
	0    -1   -1   0   
$EndComp
$Comp
L CONN_10 P1
U 1 1 506E24B8
P 5900 4200
F 0 "P1" V 5850 4200 60  0000 C CNN
F 1 "CONN_10" V 5950 4200 60  0000 C CNN
F 4 "114-00841-68-1-ND" V 5900 4200 60  0001 C CNN "Digi-Key Part"
	1    5900 4200
	1    0    0    -1  
$EndComp
$EndSCHEMATC
