EESchema Schematic File Version 2  date 2012-05-22T00:49:02 PDT
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
Date "22 may 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_1 M5
U 1 1 4FB9F54F
P 9750 3850
F 0 "M5" H 9830 3850 40  0000 L CNN
F 1 "CONN_1" H 9750 3905 30  0001 C CNN
F 4 "M3_MOUNT" H 9750 3850 60  0001 C CNN "Field1"
	1    9750 3850
	1    0    0    -1  
$EndComp
Connection ~ 5600 5450
Wire Wire Line
	6050 5450 5600 5450
Wire Wire Line
	8350 5350 8350 5750
Wire Wire Line
	3150 2150 3150 2500
Connection ~ 1850 1150
Wire Wire Line
	1850 1450 1850 950 
Wire Wire Line
	1850 950  1550 950 
Connection ~ 2450 1450
Wire Wire Line
	2450 1500 2450 1350
Connection ~ 1550 1450
Wire Wire Line
	1550 1500 1550 1350
Connection ~ 950  1150
Wire Wire Line
	950  1450 950  1150
Wire Wire Line
	8350 1550 8550 1550
Wire Wire Line
	4800 3750 4800 3600
Wire Wire Line
	8350 2150 8550 2150
Wire Wire Line
	8350 1950 8550 1950
Wire Wire Line
	8350 1750 8550 1750
Wire Wire Line
	8350 1350 8550 1350
Wire Wire Line
	8350 1150 8550 1150
Wire Wire Line
	4300 1600 4300 1400
Connection ~ 4600 1450
Wire Wire Line
	4300 1450 5200 1450
Wire Wire Line
	4900 1450 4900 1400
Wire Wire Line
	5200 1450 5200 1400
Connection ~ 4600 950 
Wire Wire Line
	4900 950  4900 1000
Wire Wire Line
	4300 900  4300 1000
Wire Wire Line
	5550 2400 5550 2550
Wire Wire Line
	9600 4850 9600 5050
Wire Wire Line
	9250 6350 9050 6350
Wire Wire Line
	7450 6350 7650 6350
Wire Wire Line
	6950 4950 6650 4950
Connection ~ 6950 5350
Wire Wire Line
	6350 5350 6950 5350
Wire Wire Line
	6950 5250 6950 6050
Wire Wire Line
	1950 4100 1950 4200
Wire Wire Line
	7200 3150 7000 3150
Wire Wire Line
	5550 3150 5850 3150
Wire Wire Line
	4700 6350 4900 6350
Wire Wire Line
	3150 3100 3150 3300
Wire Wire Line
	3150 3700 3150 3850
Wire Wire Line
	1100 3500 1250 3500
Wire Wire Line
	2650 3500 2850 3500
Connection ~ 3150 3200
Wire Wire Line
	6600 6350 6300 6350
Wire Wire Line
	7200 3050 7000 3050
Wire Wire Line
	7200 3250 7000 3250
Wire Wire Line
	1950 2800 1950 2900
Wire Wire Line
	6950 6800 6950 6550
Wire Wire Line
	6950 4800 6950 5050
Connection ~ 6950 4950
Wire Wire Line
	9600 6750 9600 6550
Wire Wire Line
	9600 5250 9600 6050
Wire Wire Line
	9600 5400 8500 5400
Connection ~ 9600 5400
Wire Wire Line
	8500 5400 8500 4550
Wire Wire Line
	8500 4550 6350 4550
Wire Wire Line
	5550 3050 5550 3250
Connection ~ 5550 3150
Wire Wire Line
	5550 3800 5550 3750
Wire Wire Line
	4800 3200 3150 3200
Wire Wire Line
	4600 950  4600 1000
Connection ~ 4300 950 
Wire Wire Line
	4300 950  5200 950 
Wire Wire Line
	5200 950  5200 1000
Connection ~ 4900 950 
Wire Wire Line
	4600 1450 4600 1400
Connection ~ 4900 1450
Connection ~ 4300 1450
Wire Wire Line
	8400 950  8550 950 
Wire Wire Line
	8350 1250 8550 1250
Wire Wire Line
	8400 1050 8550 1050
Wire Wire Line
	8350 1450 8550 1450
Wire Wire Line
	8350 1650 8550 1650
Wire Wire Line
	8350 1850 8550 1850
Wire Wire Line
	8350 2050 8550 2050
Wire Wire Line
	8350 2250 8550 2250
Wire Wire Line
	600  1150 1250 1150
Wire Wire Line
	1550 1450 1450 1450
Wire Wire Line
	2450 1450 2350 1450
Wire Wire Line
	1850 1150 2150 1150
Wire Wire Line
	2450 950  2800 950 
Wire Wire Line
	5600 5750 5600 5350
Wire Wire Line
	7950 5000 7950 5400
Text Label 7950 5000 3    60   ~ 0
SW_PWR
Text Label 8350 5350 3    60   ~ 0
SW_PWR
Text Label 5600 5350 3    60   ~ 0
SW_PWR
Text Label 3150 2150 3    60   ~ 0
SW_PWR
Text Label 2800 950  2    60   ~ 0
SW_PWR
$Comp
L R R4
U 1 1 4FB97215
P 2100 1450
F 0 "R4" V 2180 1450 50  0000 C CNN
F 1 "10kR" V 2100 1450 50  0000 C CNN
	1    2100 1450
	0    1    1    0   
$EndComp
$Comp
L MOSFET_P Q6
U 1 1 4FB97204
P 2350 1150
F 0 "Q6" H 2350 1340 60  0000 R CNN
F 1 "MOSFET_P" H 2350 970 60  0000 R CNN
F 2 "SO8E-IRF9310" H 2350 1150 60  0001 C CNN
F 4 "IRF9310TRPBFCT-ND" H 2350 1150 60  0001 C CNN "Field1"
	1    2350 1150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR01
U 1 1 4FB97199
P 1550 1500
F 0 "#PWR01" H 1550 1500 30  0001 C CNN
F 1 "GND" H 1550 1430 30  0001 C CNN
	1    1550 1500
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 4FB9718A
P 1200 1450
F 0 "R3" V 1280 1450 50  0000 C CNN
F 1 "10kR" V 1200 1450 50  0000 C CNN
	1    1200 1450
	0    1    1    0   
$EndComp
$Comp
L MOSFET_N Q5
U 1 1 4FB97180
P 1450 1150
F 0 "Q5" H 1460 1320 60  0000 R CNN
F 1 "MOSFET_N" H 1460 1000 60  0000 R CNN
F 2 "SOT23_3GDS" H 1450 1150 60  0001 C CNN
F 4 "568-5818-1-ND" H 1450 1150 60  0001 C CNN "Field1"
	1    1450 1150
	1    0    0    -1  
$EndComp
Text Label 600  1150 0    60   ~ 0
POWER_CTL
$Comp
L +BATT #PWR02
U 1 1 4FB97099
P 2450 1500
F 0 "#PWR02" H 2450 1450 20  0001 C CNN
F 1 "+BATT" H 2450 1600 30  0000 C CNN
	1    2450 1500
	-1   0    0    1   
$EndComp
Text Label 8350 1550 2    60   ~ 0
POWER_CTL
Text Label 4800 3750 2    60   ~ 0
CAP+
$Comp
L DIODE D1
U 1 1 4E90D0ED
P 4800 3400
F 0 "D1" H 4800 3500 40  0000 C CNN
F 1 "DIODE" H 4800 3300 40  0000 C CNN
F 4 "497-7575-1-ND" H 4800 3400 60  0001 C CNN "Field1"
	1    4800 3400
	0    1    1    0   
$EndComp
Text Label 3300 3200 0    60   ~ 0
CHARGE_MOSFET_DRAIN
Text Notes 6550 1200 0    60   ~ 0
Header for mechanical support
$Comp
L CONN_2 P5
U 1 1 4E878E18
P 7350 1400
F 0 "P5" V 7300 1400 40  0000 C CNN
F 1 "CONN_2" V 7400 1400 40  0000 C CNN
F 4 "long-pin-male-header2" H 7350 1400 60  0001 C CNN "Field1"
	1    7350 1400
	1    0    0    -1  
$EndComp
Text Notes 9550 3400 0    60   ~ 0
M3 Bolts
$Comp
L CONN_1 M3
U 1 1 4E878B2A
P 9750 3650
F 0 "M3" H 9830 3650 40  0000 L CNN
F 1 "CONN_1" H 9750 3705 30  0001 C CNN
F 4 "M3_MOUNT" H 9750 3650 60  0001 C CNN "Field1"
	1    9750 3650
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 M4
U 1 1 4E878B29
P 9750 3750
F 0 "M4" H 9830 3750 40  0000 L CNN
F 1 "CONN_1" H 9750 3805 30  0001 C CNN
F 4 "M3_MOUNT" H 9750 3750 60  0001 C CNN "Field1"
	1    9750 3750
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 M2
U 1 1 4E878B28
P 9750 3550
F 0 "M2" H 9830 3550 40  0000 L CNN
F 1 "CONN_1" H 9750 3605 30  0001 C CNN
F 4 "M3_MOUNT" H 9750 3550 60  0001 C CNN "Field1"
	1    9750 3550
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 M1
U 1 1 4E878B24
P 9750 3450
F 0 "M1" H 9830 3450 40  0000 L CNN
F 1 "CONN_1" H 9750 3505 30  0001 C CNN
F 4 "M3_MOUNT" H 9750 3450 60  0001 C CNN "Field1"
	1    9750 3450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 4E62AE18
P 8350 2250
F 0 "#PWR03" H 8350 2250 30  0001 C CNN
F 1 "GND" H 8350 2180 30  0001 C CNN
	1    8350 2250
	0    1    1    0   
$EndComp
$Comp
L +3.3V #PWR04
U 1 1 4E62AE12
P 8350 2150
F 0 "#PWR04" H 8350 2110 30  0001 C CNN
F 1 "+3.3V" H 8350 2260 30  0000 C CNN
	1    8350 2150
	0    -1   -1   0   
$EndComp
Text Label 8350 1450 2    60   ~ 0
CHIP
Text Label 8350 1650 2    60   ~ 0
KICK
Text Label 8350 1350 2    60   ~ 0
CHARGE
$Comp
L GND #PWR05
U 1 1 4E62ADAA
P 8350 1750
F 0 "#PWR05" H 8350 1750 30  0001 C CNN
F 1 "GND" H 8350 1680 30  0001 C CNN
	1    8350 1750
	0    1    1    0   
$EndComp
Text Label 8350 2050 2    60   ~ 0
MISO
Text Label 8350 1850 2    60   ~ 0
CLK
Text Label 8350 1950 2    60   ~ 0
~CS
$Comp
L +BATT #PWR06
U 1 1 4E62AD51
P 8400 1050
F 0 "#PWR06" H 8400 1000 20  0001 C CNN
F 1 "+BATT" H 8400 1150 30  0000 C CNN
	1    8400 1050
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR07
U 1 1 4E62AD47
P 8350 1150
F 0 "#PWR07" H 8350 1150 30  0001 C CNN
F 1 "GND" H 8350 1080 30  0001 C CNN
	1    8350 1150
	0    1    1    0   
$EndComp
$Comp
L GND #PWR08
U 1 1 4E62AD42
P 8350 1250
F 0 "#PWR08" H 8350 1250 30  0001 C CNN
F 1 "GND" H 8350 1180 30  0001 C CNN
	1    8350 1250
	0    1    1    0   
$EndComp
$Comp
L +BATT #PWR09
U 1 1 4E62AD1F
P 8400 950
F 0 "#PWR09" H 8400 900 20  0001 C CNN
F 1 "+BATT" H 8400 1050 30  0000 C CNN
	1    8400 950 
	0    -1   -1   0   
$EndComp
$Comp
L CONN_14 P2
U 1 1 4E62ACEE
P 8900 1600
F 0 "P2" V 8870 1600 60  0000 C CNN
F 1 "CONN_14" V 8980 1600 60  0000 C CNN
F 4 "long-pin-male-header" H 8900 1600 60  0001 C CNN "Field1"
	1    8900 1600
	1    0    0    -1  
$EndComp
$Comp
L CP C11
U 1 1 4E629A87
P 5200 1200
F 0 "C11" H 5250 1300 50  0000 L CNN
F 1 "1mF" H 5250 1100 50  0000 L CNN
F 4 "565-2754-ND" H 5200 1200 60  0001 C CNN "Field1"
	1    5200 1200
	1    0    0    -1  
$EndComp
$Comp
L CP C10
U 1 1 4E629A85
P 4900 1200
F 0 "C10" H 4950 1300 50  0000 L CNN
F 1 "1mF" H 4950 1100 50  0000 L CNN
F 4 "565-2754-ND" H 4900 1200 60  0001 C CNN "Field1"
	1    4900 1200
	1    0    0    -1  
$EndComp
$Comp
L CP C9
U 1 1 4E629A84
P 4600 1200
F 0 "C9" H 4650 1300 50  0000 L CNN
F 1 "1mF" H 4650 1100 50  0000 L CNN
F 4 "565-2754-ND" H 4600 1200 60  0001 C CNN "Field1"
	1    4600 1200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 4E629768
P 4300 1600
F 0 "#PWR010" H 4300 1600 30  0001 C CNN
F 1 "GND" H 4300 1530 30  0001 C CNN
	1    4300 1600
	1    0    0    -1  
$EndComp
$Comp
L CP C8
U 1 1 4E62973B
P 4300 1200
F 0 "C8" H 4350 1300 50  0000 L CNN
F 1 "1mF" H 4350 1100 50  0000 L CNN
F 4 "565-2754-ND" H 4300 1200 60  0001 C CNN "Field1"
	1    4300 1200
	1    0    0    -1  
$EndComp
Text Label 4300 900  0    60   ~ 0
CAP+
Text Label 5550 2400 0    60   ~ 0
CAP+
$Comp
L GND #PWR011
U 1 1 4E627F8A
P 7950 5800
F 0 "#PWR011" H 7950 5800 30  0001 C CNN
F 1 "GND" H 7950 5730 30  0001 C CNN
	1    7950 5800
	1    0    0    -1  
$EndComp
$Comp
L C C7
U 1 1 4E627F86
P 7950 5600
F 0 "C7" H 8000 5700 50  0000 L CNN
F 1 "100nF" H 8000 5500 50  0000 L CNN
F 4 "565-1201-ND" H 7950 5600 60  0001 C CNN "Field1"
	1    7950 5600
	1    0    0    -1  
$EndComp
Text Label 9600 4850 2    60   ~ 0
CAP+
$Comp
L CONN_2 P1
U 1 1 4E627F5E
P 9950 5150
F 0 "P1" V 9900 5150 40  0000 C CNN
F 1 "CONN_2" V 10000 5150 40  0000 C CNN
F 4 "WM4300-ND" H 9950 5150 60  0001 C CNN "Field1"
	1    9950 5150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR012
U 1 1 4E627F55
P 9600 6750
F 0 "#PWR012" H 9600 6750 30  0001 C CNN
F 1 "GND" H 9600 6680 30  0001 C CNN
	1    9600 6750
	1    0    0    -1  
$EndComp
$Comp
L IGBT_N Q3
U 1 1 4E627F51
P 9500 6300
F 0 "Q3" H 9650 6300 50  0000 C CNN
F 1 "IGBT_N" H 9350 6450 50  0000 C CNN
F 4 "FGA180N33ATDTU-ND" H 9500 6300 60  0001 C CNN "Field1"
	1    9500 6300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR013
U 1 1 4E627F4D
P 8350 6950
F 0 "#PWR013" H 8350 6950 30  0001 C CNN
F 1 "GND" H 8350 6880 30  0001 C CNN
	1    8350 6950
	1    0    0    -1  
$EndComp
Text Label 7450 6350 2    60   ~ 0
CHIP
$Comp
L MCP1415 U5
U 1 1 4E627F3F
P 8350 6350
F 0 "U5" H 8350 6300 60  0000 C CNN
F 1 "MCP1415" H 8350 6400 60  0000 C CNN
	1    8350 6350
	1    0    0    -1  
$EndComp
Text Label 6950 4800 2    60   ~ 0
CAP+
$Comp
L GND #PWR014
U 1 1 4E627E54
P 6950 6800
F 0 "#PWR014" H 6950 6800 30  0001 C CNN
F 1 "GND" H 6950 6730 30  0001 C CNN
	1    6950 6800
	1    0    0    -1  
$EndComp
$Comp
L MCP1415 U4
U 1 1 4D7BD74C
P 5600 6350
F 0 "U4" H 5600 6300 60  0000 C CNN
F 1 "MCP1415" H 5600 6400 60  0000 C CNN
	1    5600 6350
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
P 6400 3050
F 0 "U3" H 6650 2550 60  0000 C CNN
F 1 "ADS7866IDBVT" H 6450 3300 60  0000 C CNN
	1    6400 3050
	1    0    0    -1  
$EndComp
$Comp
L RURG3060CC D3
U 1 1 4D018AF7
P 6350 4950
F 0 "D3" H 6800 4850 60  0000 C CNN
F 1 "RURG3060CC" H 6800 5050 60  0000 C CNN
F 2 "TO247" H 6700 4750 60  0000 C CNN
	1    6350 4950
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR015
U 1 1 4CEECDAD
P 7800 3200
F 0 "#PWR015" H 7800 3200 30  0001 C CNN
F 1 "GND" H 7800 3130 30  0001 C CNN
	1    7800 3200
	1    0    0    -1  
$EndComp
$Comp
L CP C6
U 1 1 4CEECDAA
P 7800 3000
F 0 "C6" H 7850 3100 50  0000 L CNN
F 1 "47uF" H 7850 2900 50  0000 L CNN
F 4 "493-1065-ND" H 7800 3000 60  0001 C CNN "Field1"
	1    7800 3000
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR016
U 1 1 4CEECDA5
P 7800 2800
F 0 "#PWR016" H 7800 2750 20  0001 C CNN
F 1 "+BATT" H 7800 2900 30  0000 C CNN
	1    7800 2800
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 4CEDE442
P 6050 5650
F 0 "C5" H 6100 5750 50  0000 L CNN
F 1 "100nF" H 6100 5550 50  0000 L CNN
F 4 "565-1201-ND" H 6050 5650 60  0001 C CNN "Field1"
	1    6050 5650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR017
U 1 1 4CEDE440
P 6050 5850
F 0 "#PWR017" H 6050 5850 30  0001 C CNN
F 1 "GND" H 6050 5780 30  0001 C CNN
	1    6050 5850
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR018
U 1 1 4CEDE40D
P 7200 2350
F 0 "#PWR018" H 7200 2310 30  0001 C CNN
F 1 "+3.3V" H 7200 2460 30  0000 C CNN
	1    7200 2350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR019
U 1 1 4CEDE40C
P 7200 2750
F 0 "#PWR019" H 7200 2750 30  0001 C CNN
F 1 "GND" H 7200 2680 30  0001 C CNN
	1    7200 2750
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 4CEDE409
P 7200 2550
F 0 "C4" H 7250 2650 50  0000 L CNN
F 1 "100nF" H 7250 2450 50  0000 L CNN
	1    7200 2550
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR020
U 1 1 4CEDE400
P 6850 2350
F 0 "#PWR020" H 6850 2310 30  0001 C CNN
F 1 "+3.3V" H 6850 2460 30  0000 C CNN
	1    6850 2350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR021
U 1 1 4CEDE3FD
P 6850 2750
F 0 "#PWR021" H 6850 2750 30  0001 C CNN
F 1 "GND" H 6850 2680 30  0001 C CNN
	1    6850 2750
	1    0    0    -1  
$EndComp
$Comp
L CP C3
U 1 1 4CEDE3F8
P 6850 2550
F 0 "C3" H 6900 2650 50  0000 L CNN
F 1 "10uF" H 6900 2450 50  0000 L CNN
	1    6850 2550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR022
U 1 1 4CEDE3E9
P 2200 3000
F 0 "#PWR022" H 2200 3000 30  0001 C CNN
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
L +BATT #PWR023
U 1 1 4CEDE3E3
P 2200 2600
F 0 "#PWR023" H 2200 2550 20  0001 C CNN
F 1 "+BATT" H 2200 2700 30  0000 C CNN
	1    2200 2600
	1    0    0    -1  
$EndComp
Text Label 7200 3250 0    60   ~ 0
CLK
Text Label 7200 3150 0    60   ~ 0
MISO
Text Label 7200 3050 0    60   ~ 0
~CS
$Comp
L GND #PWR024
U 1 1 4CEDE369
P 6400 3800
F 0 "#PWR024" H 6400 3800 30  0001 C CNN
F 1 "GND" H 6400 3730 30  0001 C CNN
	1    6400 3800
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR025
U 1 1 4CEDE359
P 6400 2550
F 0 "#PWR025" H 6400 2510 30  0001 C CNN
F 1 "+3.3V" H 6400 2660 30  0000 C CNN
	1    6400 2550
	1    0    0    -1  
$EndComp
Text Label 4700 6350 2    60   ~ 0
KICK
$Comp
L GND #PWR026
U 1 1 4CEDC077
P 5600 6950
F 0 "#PWR026" H 5600 6950 30  0001 C CNN
F 1 "GND" H 5600 6880 30  0001 C CNN
	1    5600 6950
	1    0    0    -1  
$EndComp
$Comp
L IGBT_N Q4
U 1 1 4CEDBF96
P 6850 6300
F 0 "Q4" H 7000 6300 50  0000 C CNN
F 1 "IGBT_N" H 6700 6450 50  0000 C CNN
F 4 "FGA180N33ATDTU-ND" H 6850 6300 60  0001 C CNN "Field1"
	1    6850 6300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR027
U 1 1 4CE86E12
P 5550 3800
F 0 "#PWR027" H 5550 3800 30  0001 C CNN
F 1 "GND" H 5550 3730 30  0001 C CNN
	1    5550 3800
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 4CE86DF9
P 5550 3500
F 0 "R2" V 5630 3500 50  0000 C CNN
F 1 "2.2KR" V 5550 3500 50  0000 C CNN
F 4 "541-2.20KTCT-ND" H 5550 3500 60  0001 C CNN "Field1"
	1    5550 3500
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4CE86DF3
P 5550 2800
F 0 "R1" V 5630 2800 50  0000 C CNN
F 1 "220KR" V 5550 2800 50  0000 C CNN
F 4 "RHM220KAECT-ND" H 5550 2800 60  0001 C CNN "Field1"
	1    5550 2800
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
L GND #PWR028
U 1 1 4CE86D89
P 3150 3850
F 0 "#PWR028" H 3150 3850 30  0001 C CNN
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
F 4 "497-12940-1-ND" H 3050 3500 60  0001 C CNN "Field1"
	1    3050 3500
	1    0    0    -1  
$EndComp
Text Label 1100 3500 2    60   ~ 0
CHARGE
$Comp
L GND #PWR029
U 1 1 4CE86D14
P 1950 4200
F 0 "#PWR029" H 1950 4200 30  0001 C CNN
F 1 "GND" H 1950 4130 30  0001 C CNN
	1    1950 4200
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR030
U 1 1 4CE86D10
P 1950 2800
F 0 "#PWR030" H 1950 2750 20  0001 C CNN
F 1 "+BATT" H 1950 2900 30  0000 C CNN
	1    1950 2800
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P3
U 1 1 4CE85E9F
P 7300 5150
F 0 "P3" V 7250 5150 40  0000 C CNN
F 1 "CONN_2" V 7350 5150 40  0000 C CNN
F 4 "WM4300-ND" H 7300 5150 60  0001 C CNN "Field1"
	1    7300 5150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
