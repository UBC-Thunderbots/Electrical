EESchema Schematic File Version 2  date Sat 12 Mar 2011 01:52:27 PM PST
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
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title ""
Date "12 mar 2011"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCP1415 U4
U 1 1 4D7BD74C
P 6500 6250
F 0 "U4" H 6500 6200 60  0000 C CNN
F 1 "MCP1415" H 6500 6300 60  0000 C CNN
	1    6500 6250
	1    0    0    -1  
$EndComp
$Comp
L MCP1415 U2
U 1 1 4D7BD56F
P 2350 6250
F 0 "U2" H 2350 6200 60  0000 C CNN
F 1 "MCP1415" H 2350 6300 60  0000 C CNN
	1    2350 6250
	1    0    0    -1  
$EndComp
$Comp
L MCP1415 U1
U 1 1 4D7BD568
P 1950 3500
F 0 "U1" H 1950 3450 60  0000 C CNN
F 1 "MCP1415" H 1950 3550 60  0000 C CNN
	1    1950 3500
	1    0    0    -1  
$EndComp
$Comp
L ADS7866IDBVT U3
U 1 1 4D2403D7
P 5650 3100
F 0 "U3" H 5900 2600 60  0000 C CNN
F 1 "ADS7866IDBVT" H 5700 3350 60  0000 C CNN
	1    5650 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 2800 1950 2900
Wire Wire Line
	2950 950  2850 950 
Wire Wire Line
	2100 900  2050 900 
Wire Wire Line
	2050 900  2050 950 
Wire Wire Line
	6450 3300 6250 3300
Wire Wire Line
	6450 3100 6250 3100
Wire Wire Line
	4100 1500 3950 1500
Connection ~ 7850 5650
Wire Wire Line
	7650 5650 7850 5650
Wire Wire Line
	8150 5950 7850 5950
Wire Wire Line
	3950 5950 3950 5300
Wire Wire Line
	3950 5950 3650 5950
Wire Wire Line
	3600 1300 4100 1300
Wire Wire Line
	4100 1750 3600 1750
Wire Wire Line
	1650 6250 1450 6250
Wire Wire Line
	7200 6250 7500 6250
Wire Wire Line
	3050 6250 3300 6250
Wire Wire Line
	5350 4900 5450 4900
Connection ~ 8000 6450
Wire Wire Line
	8000 6450 8000 6550
Connection ~ 3800 6450
Wire Wire Line
	3800 6450 3800 6550
Wire Wire Line
	3950 2000 3950 1950
Wire Wire Line
	3850 4300 3850 4400
Connection ~ 3150 3200
Wire Wire Line
	3150 3200 3300 3200
Wire Wire Line
	2650 3500 2850 3500
Wire Wire Line
	1100 3500 1250 3500
Wire Wire Line
	750  950  750  1850
Wire Wire Line
	1950 1250 2050 1250
Wire Wire Line
	1950 1050 2050 1050
Wire Wire Line
	1900 1450 2050 1450
Connection ~ 750  1750
Connection ~ 750  1550
Connection ~ 750  1350
Connection ~ 750  1150
Connection ~ 1550 1050
Connection ~ 1550 1450
Connection ~ 1550 1550
Connection ~ 1550 1650
Connection ~ 1550 1350
Connection ~ 1550 1250
Connection ~ 1550 1150
Wire Wire Line
	1550 1750 1550 850 
Connection ~ 750  1050
Connection ~ 750  1250
Connection ~ 750  1450
Connection ~ 750  1650
Wire Wire Line
	2050 950  2000 950 
Wire Wire Line
	2000 950  2000 900 
Wire Wire Line
	1950 1350 2050 1350
Wire Wire Line
	1950 1150 2050 1150
Wire Wire Line
	2850 1250 2950 1250
Wire Wire Line
	2850 1150 2950 1150
Wire Wire Line
	2950 1050 2850 1050
Wire Wire Line
	3950 1950 4100 1950
Connection ~ 1550 950 
Wire Wire Line
	3150 3700 3150 3850
Wire Wire Line
	3150 3100 3150 3300
Wire Wire Line
	3850 3700 3850 3800
Wire Wire Line
	3650 6450 3950 6450
Wire Wire Line
	7850 6450 8150 6450
Wire Wire Line
	4200 3200 3700 3200
Connection ~ 3850 3200
Wire Wire Line
	4400 4900 4500 4900
Wire Wire Line
	4300 6250 4300 6700
Wire Wire Line
	4300 6700 3300 6700
Wire Wire Line
	3300 6700 3300 6250
Wire Wire Line
	7500 6250 7500 6750
Wire Wire Line
	7500 6750 8500 6750
Wire Wire Line
	8500 6750 8500 6250
Wire Wire Line
	5600 6250 5800 6250
Wire Wire Line
	3600 1750 3600 850 
Wire Wire Line
	3600 850  4100 850 
Connection ~ 3600 1300
Wire Wire Line
	3950 5300 5750 5300
Connection ~ 4800 5300
Wire Wire Line
	4800 4500 7850 4500
Wire Wire Line
	7850 4500 7850 5950
Connection ~ 5750 4500
Wire Wire Line
	3750 5650 3950 5650
Connection ~ 3950 5650
Wire Wire Line
	3950 1050 4100 1050
Wire Wire Line
	3850 3750 4800 3750
Connection ~ 3850 3750
Wire Wire Line
	4800 3750 4800 3200
Wire Wire Line
	4800 3200 5100 3200
Wire Wire Line
	6450 3200 6250 3200
Wire Wire Line
	1700 950  1550 950 
Wire Wire Line
	2850 1350 3450 1350
Wire Wire Line
	5150 1450 5250 1450
Wire Wire Line
	1950 4100 1950 4200
$Comp
L RURG3060CC D3
U 1 1 4D018AF7
P 5750 4900
F 0 "D3" H 6200 4800 60  0000 C CNN
F 1 "RURG3060CC" H 6200 5000 60  0000 C CNN
F 2 "TO247" H 6100 4700 60  0000 C CNN
	1    5750 4900
	1    0    0    -1  
$EndComp
$Comp
L RURG3060CC D2
U 1 1 4D018AE0
P 4800 4900
F 0 "D2" H 5250 4800 60  0000 C CNN
F 1 "RURG3060CC" H 5250 5000 60  0000 C CNN
F 2 "TO247" H 5150 4700 60  0000 C CNN
	1    4800 4900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR01
U 1 1 4CEED33D
P 5250 1850
F 0 "#PWR01" H 5250 1850 30  0001 C CNN
F 1 "GND" H 5250 1780 30  0001 C CNN
	1    5250 1850
	1    0    0    -1  
$EndComp
Text Label 5150 1450 2    60   ~ 0
CAP+
$Comp
L CP C7
U 1 1 4CEED332
P 5250 1650
F 0 "C7" H 5300 1750 50  0000 L CNN
F 1 "10uF" H 5300 1550 50  0000 L CNN
	1    5250 1650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 4CEECDAD
P 7800 3200
F 0 "#PWR02" H 7800 3200 30  0001 C CNN
F 1 "GND" H 7800 3130 30  0001 C CNN
	1    7800 3200
	1    0    0    -1  
$EndComp
$Comp
L CP C6
U 1 1 4CEECDAA
P 7800 3000
F 0 "C6" H 7850 3100 50  0000 L CNN
F 1 "1mF" H 7850 2900 50  0000 L CNN
F 4 "493-1065-ND" H 7800 3000 60  0001 C CNN "Field1"
	1    7800 3000
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR03
U 1 1 4CEECDA5
P 7800 2800
F 0 "#PWR03" H 7800 2750 20  0001 C CNN
F 1 "+BATT" H 7800 2900 30  0000 C CNN
	1    7800 2800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 4CEE1E44
P 1950 1150
F 0 "#PWR04" H 1950 1150 30  0001 C CNN
F 1 "GND" H 1950 1080 30  0001 C CNN
	1    1950 1150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 4CEE1E3A
P 2950 1050
F 0 "#PWR05" H 2950 1050 30  0001 C CNN
F 1 "GND" H 2950 980 30  0001 C CNN
	1    2950 1050
	1    0    0    -1  
$EndComp
Text Label 2950 950  0    60   ~ 0
~CS
$Comp
L PWR_FLAG #FLG06
U 1 1 4CEE06B9
P 2100 900
F 0 "#FLG06" H 2100 1170 30  0001 C CNN
F 1 "PWR_FLAG" H 2100 1130 30  0000 C CNN
	1    2100 900 
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG07
U 1 1 4CEE06B2
P 1700 950
F 0 "#FLG07" H 1700 1220 30  0001 C CNN
F 1 "PWR_FLAG" H 1700 1180 30  0000 C CNN
	1    1700 950 
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 4CEDE442
P 6950 5550
F 0 "C5" H 7000 5650 50  0000 L CNN
F 1 "100nF" H 7000 5450 50  0000 L CNN
	1    6950 5550
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR08
U 1 1 4CEDE441
P 6950 5350
F 0 "#PWR08" H 6950 5300 20  0001 C CNN
F 1 "+BATT" H 6950 5450 30  0000 C CNN
	1    6950 5350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR09
U 1 1 4CEDE440
P 6950 5750
F 0 "#PWR09" H 6950 5750 30  0001 C CNN
F 1 "GND" H 6950 5680 30  0001 C CNN
	1    6950 5750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 4CEDE432
P 2700 5750
F 0 "#PWR010" H 2700 5750 30  0001 C CNN
F 1 "GND" H 2700 5680 30  0001 C CNN
	1    2700 5750
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR011
U 1 1 4CEDE42F
P 2700 5350
F 0 "#PWR011" H 2700 5300 20  0001 C CNN
F 1 "+BATT" H 2700 5450 30  0000 C CNN
	1    2700 5350
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 4CEDE42C
P 2700 5550
F 0 "C2" H 2750 5650 50  0000 L CNN
F 1 "100nF" H 2750 5450 50  0000 L CNN
	1    2700 5550
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR012
U 1 1 4CEDE40D
P 6450 2400
F 0 "#PWR012" H 6450 2360 30  0001 C CNN
F 1 "+3.3V" H 6450 2510 30  0000 C CNN
	1    6450 2400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR013
U 1 1 4CEDE40C
P 6450 2800
F 0 "#PWR013" H 6450 2800 30  0001 C CNN
F 1 "GND" H 6450 2730 30  0001 C CNN
	1    6450 2800
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 4CEDE409
P 6450 2600
F 0 "C4" H 6500 2700 50  0000 L CNN
F 1 "100nF" H 6500 2500 50  0000 L CNN
	1    6450 2600
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR014
U 1 1 4CEDE400
P 6100 2400
F 0 "#PWR014" H 6100 2360 30  0001 C CNN
F 1 "+3.3V" H 6100 2510 30  0000 C CNN
	1    6100 2400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR015
U 1 1 4CEDE3FD
P 6100 2800
F 0 "#PWR015" H 6100 2800 30  0001 C CNN
F 1 "GND" H 6100 2730 30  0001 C CNN
	1    6100 2800
	1    0    0    -1  
$EndComp
$Comp
L CP C3
U 1 1 4CEDE3F8
P 6100 2600
F 0 "C3" H 6150 2700 50  0000 L CNN
F 1 "10uF" H 6150 2500 50  0000 L CNN
	1    6100 2600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR016
U 1 1 4CEDE3E9
P 2200 3000
F 0 "#PWR016" H 2200 3000 30  0001 C CNN
F 1 "GND" H 2200 2930 30  0001 C CNN
	1    2200 3000
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 4CEDE3E6
P 2200 2800
F 0 "C1" H 2250 2900 50  0000 L CNN
F 1 "100nF" H 2250 2700 50  0000 L CNN
	1    2200 2800
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR017
U 1 1 4CEDE3E3
P 2200 2600
F 0 "#PWR017" H 2200 2550 20  0001 C CNN
F 1 "+BATT" H 2200 2700 30  0000 C CNN
	1    2200 2600
	1    0    0    -1  
$EndComp
Text Label 6450 3300 0    60   ~ 0
CLK
Text Label 6450 3200 0    60   ~ 0
MISO
Text Label 6450 3100 0    60   ~ 0
~CS
$Comp
L GND #PWR018
U 1 1 4CEDE369
P 5650 3850
F 0 "#PWR018" H 5650 3850 30  0001 C CNN
F 1 "GND" H 5650 3780 30  0001 C CNN
	1    5650 3850
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR019
U 1 1 4CEDE359
P 5650 2600
F 0 "#PWR019" H 5650 2560 30  0001 C CNN
F 1 "+3.3V" H 5650 2710 30  0000 C CNN
	1    5650 2600
	1    0    0    -1  
$EndComp
Text Label 3950 1500 2    60   ~ 0
KICK-
Text Label 7650 5650 2    60   ~ 0
KICK-
Text Label 3750 5650 2    60   ~ 0
CHIP-
Text Label 5600 6250 2    60   ~ 0
KICK
Text Label 1450 6250 2    60   ~ 0
CHIP
$Comp
L GND #PWR020
U 1 1 4CEDC077
P 6500 6850
F 0 "#PWR020" H 6500 6850 30  0001 C CNN
F 1 "GND" H 6500 6780 30  0001 C CNN
	1    6500 6850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR021
U 1 1 4CEDC076
P 2350 6850
F 0 "#PWR021" H 2350 6850 30  0001 C CNN
F 1 "GND" H 2350 6780 30  0001 C CNN
	1    2350 6850
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR022
U 1 1 4CEDC06F
P 6500 5650
F 0 "#PWR022" H 6500 5600 20  0001 C CNN
F 1 "+BATT" H 6500 5750 30  0000 C CNN
	1    6500 5650
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR023
U 1 1 4CEDC06C
P 2350 5650
F 0 "#PWR023" H 2350 5600 20  0001 C CNN
F 1 "+BATT" H 2350 5750 30  0000 C CNN
	1    2350 5650
	1    0    0    -1  
$EndComp
Text Label 4400 4900 2    60   ~ 0
CAP+
Text Label 5350 4900 2    60   ~ 0
CAP+
Text Label 4200 3200 0    60   ~ 0
CAP+
$Comp
L GND #PWR024
U 1 1 4CEDBFD3
P 8000 6550
F 0 "#PWR024" H 8000 6550 30  0001 C CNN
F 1 "GND" H 8000 6480 30  0001 C CNN
	1    8000 6550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR025
U 1 1 4CEDBFD0
P 3800 6550
F 0 "#PWR025" H 3800 6550 30  0001 C CNN
F 1 "GND" H 3800 6480 30  0001 C CNN
	1    3800 6550
	1    0    0    -1  
$EndComp
$Comp
L IGBT_N Q5
U 1 1 4CEDBF99
P 8250 6200
F 0 "Q5" H 8400 6200 50  0000 C CNN
F 1 "IGBT_N" H 8100 6350 50  0000 C CNN
F 4 "FGA180N33ATDTU-ND" H 8250 6200 60  0001 C CNN "Field1"
	1    8250 6200
	-1   0    0    -1  
$EndComp
$Comp
L IGBT_N Q4
U 1 1 4CEDBF96
P 7750 6200
F 0 "Q4" H 7900 6200 50  0000 C CNN
F 1 "IGBT_N" H 7600 6350 50  0000 C CNN
F 4 "FGA180N33ATDTU-ND" H 7750 6200 60  0001 C CNN "Field1"
	1    7750 6200
	1    0    0    -1  
$EndComp
$Comp
L IGBT_N Q3
U 1 1 4CEDBF93
P 4050 6200
F 0 "Q3" H 4200 6200 50  0000 C CNN
F 1 "IGBT_N" H 3900 6350 50  0000 C CNN
F 4 "FGA180N33ATDTU-ND" H 4050 6200 60  0001 C CNN "Field1"
	1    4050 6200
	-1   0    0    -1  
$EndComp
$Comp
L IGBT_N Q2
U 1 1 4CEDBD14
P 3550 6200
F 0 "Q2" H 3700 6200 50  0000 C CNN
F 1 "IGBT_N" H 3400 6350 50  0000 C CNN
F 4 "FGA180N33ATDTU-ND" H 3550 6200 60  0001 C CNN "Field1"
	1    3550 6200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR026
U 1 1 4CE86E2E
P 3950 2000
F 0 "#PWR026" H 3950 2000 30  0001 C CNN
F 1 "GND" H 3950 1930 30  0001 C CNN
	1    3950 2000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR027
U 1 1 4CE86E12
P 3850 4400
F 0 "#PWR027" H 3850 4400 30  0001 C CNN
F 1 "GND" H 3850 4330 30  0001 C CNN
	1    3850 4400
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 4CE86DF9
P 3850 4050
F 0 "R2" V 3930 4050 50  0000 C CNN
F 1 "2.2KR" V 3850 4050 50  0000 C CNN
F 4 "541-2.20KTCT-ND" H 3850 4050 60  0001 C CNN "Field1"
	1    3850 4050
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4CE86DF3
P 3850 3450
F 0 "R1" V 3930 3450 50  0000 C CNN
F 1 "220KR" V 3850 3450 50  0000 C CNN
F 4 "RHM220KAECT-ND" H 3850 3450 60  0001 C CNN "Field1"
	1    3850 3450
	1    0    0    -1  
$EndComp
$Comp
L DIODE D1
U 1 1 4CE86DE7
P 3500 3200
F 0 "D1" H 3500 3300 40  0000 C CNN
F 1 "DIODE" H 3500 3100 40  0000 C CNN
F 4 "497-7575-1-ND" H 3500 3200 60  0001 C CNN "Field1"
	1    3500 3200
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR028
U 1 1 4CE86DC4
P 3150 2500
F 0 "#PWR028" H 3150 2450 20  0001 C CNN
F 1 "+BATT" H 3150 2600 30  0000 C CNN
	1    3150 2500
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR L1
U 1 1 4CE86DAF
P 3150 2800
F 0 "L1" V 3100 2800 40  0000 C CNN
F 1 "22uH" V 3250 2800 40  0000 C CNN
F 4 "chicker-charge-inductor" H 3150 2800 60  0001 C CNN "Field1"
	1    3150 2800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR029
U 1 1 4CE86D89
P 3150 3850
F 0 "#PWR029" H 3150 3850 30  0001 C CNN
F 1 "GND" H 3150 3780 30  0001 C CNN
	1    3150 3850
	1    0    0    -1  
$EndComp
$Comp
L MOS_N Q1
U 1 1 4CE86D82
P 3050 3500
F 0 "Q1" H 3060 3670 60  0000 R CNN
F 1 "MOS_N" H 3060 3350 60  0000 R CNN
F 4 "497-4323-1-ND" H 3050 3500 60  0001 C CNN "Field1"
	1    3050 3500
	1    0    0    -1  
$EndComp
Text Label 1100 3500 2    60   ~ 0
CHARGE
$Comp
L GND #PWR030
U 1 1 4CE86D14
P 1950 4200
F 0 "#PWR030" H 1950 4200 30  0001 C CNN
F 1 "GND" H 1950 4130 30  0001 C CNN
	1    1950 4200
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR031
U 1 1 4CE86D10
P 1950 2800
F 0 "#PWR031" H 1950 2750 20  0001 C CNN
F 1 "+BATT" H 1950 2900 30  0000 C CNN
	1    1950 2800
	1    0    0    -1  
$EndComp
$Comp
L CONN_9X2 P1
U 1 1 4CE869A3
P 1150 1300
F 0 "P1" H 1150 1750 60  0000 C CNN
F 1 "CONN_9X2" V 1150 1300 50  0000 C CNN
F 4 "chicker-header" H 1150 1300 60  0001 C CNN "Field1"
	1    1150 1300
	1    0    0    -1  
$EndComp
Text Label 3950 1050 2    60   ~ 0
CHIP-
Text Label 3950 1750 2    60   ~ 0
CAP+
$Comp
L CONN_2 P5
U 1 1 4CE85EA5
P 4450 1850
F 0 "P5" V 4400 1850 40  0000 C CNN
F 1 "CONN_2" V 4500 1850 40  0000 C CNN
F 4 "WM4300-ND" H 4450 1850 60  0001 C CNN "Field1"
	1    4450 1850
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P4
U 1 1 4CE85EA2
P 4450 1400
F 0 "P4" V 4400 1400 40  0000 C CNN
F 1 "CONN_2" V 4500 1400 40  0000 C CNN
F 4 "WM4300-ND" H 4450 1400 60  0001 C CNN "Field1"
	1    4450 1400
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P3
U 1 1 4CE85E9F
P 4450 950
F 0 "P3" V 4400 950 40  0000 C CNN
F 1 "CONN_2" V 4500 950 40  0000 C CNN
F 4 "WM4300-ND" H 4450 950 60  0001 C CNN "Field1"
	1    4450 950 
	1    0    0    -1  
$EndComp
$Comp
L CONN_6X2 P2
U 1 1 4CE85D0A
P 2450 1200
F 0 "P2" H 2450 1550 60  0000 C CNN
F 1 "CONN_6X2" V 2450 1200 60  0000 C CNN
F 4 "chicker-header" H 2450 1200 60  0001 C CNN "Field1"
	1    2450 1200
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR032
U 1 1 4CE84BC1
P 3450 1350
F 0 "#PWR032" H 3450 1310 30  0001 C CNN
F 1 "+3.3V" H 3450 1460 30  0000 C CNN
	1    3450 1350
	1    0    0    -1  
$EndComp
Text Label 2950 1250 0    60   ~ 0
KICK
Text Label 2950 1150 0    60   ~ 0
MISO
Text Label 1950 1050 2    60   ~ 0
CLK
Text Label 1950 1250 2    60   ~ 0
CHARGE
Text Label 1950 1350 2    60   ~ 0
CHIP
$Comp
L +BATT #PWR033
U 1 1 4CE84AEC
P 1900 1450
F 0 "#PWR033" H 1900 1400 20  0001 C CNN
F 1 "+BATT" H 1900 1550 30  0000 C CNN
	1    1900 1450
	0    -1   -1   0   
$EndComp
$Comp
L +3.3V #PWR034
U 1 1 4CE84ADB
P 2000 900
F 0 "#PWR034" H 2000 860 30  0001 C CNN
F 1 "+3.3V" H 2000 1010 30  0000 C CNN
	1    2000 900 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR035
U 1 1 4CE84A86
P 750 1850
F 0 "#PWR035" H 750 1850 30  0001 C CNN
F 1 "GND" H 750 1780 30  0001 C CNN
	1    750  1850
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR036
U 1 1 4CE84A5C
P 1550 850
F 0 "#PWR036" H 1550 800 20  0001 C CNN
F 1 "+BATT" H 1550 950 30  0000 C CNN
	1    1550 850 
	1    0    0    -1  
$EndComp
$EndSCHEMATC
