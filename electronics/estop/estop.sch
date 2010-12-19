EESchema Schematic File Version 2  date 2010-12-18T16:16:28 PST
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
Date "19 dec 2010"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 6100 3900 0    60   ~ 0
R
Text Notes 6100 3800 0    60   ~ 0
T
Text Notes 6100 3700 0    60   ~ 0
S
Wire Wire Line
	5100 6050 6100 6050
Wire Wire Line
	6100 6050 6100 3900
Connection ~ 4750 5500
Wire Wire Line
	5400 5500 4550 5500
Wire Wire Line
	4550 5500 4550 3700
Wire Wire Line
	4550 3700 6100 3700
Wire Wire Line
	5400 4950 5400 5000
Wire Wire Line
	5400 3800 5400 3950
Wire Wire Line
	4750 4450 4750 3800
Wire Wire Line
	4750 3800 6100 3800
Connection ~ 5400 3800
Wire Wire Line
	4750 5500 4750 4950
Wire Wire Line
	5100 5550 5100 5500
Connection ~ 5100 5500
$Comp
L R R2
U 1 1 4CA7AC7F
P 5100 5800
F 0 "R2" V 5180 5800 50  0000 C CNN
F 1 "2.2kR" V 5100 5800 50  0000 C CNN
F 4 "2.2KEBK-ND" H 5100 5800 60  0001 C CNN "Field1"
	1    5100 5800
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4CA7AC15
P 4750 4700
F 0 "R1" V 4830 4700 50  0000 C CNN
F 1 "2.2kR" V 4750 4700 50  0000 C CNN
F 4 "2.2KEBK-ND" H 4750 4700 60  0001 C CNN "Field1"
	1    4750 4700
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 4CA7AC0F
P 5400 5250
F 0 "R3" V 5480 5250 50  0000 C CNN
F 1 "560R" V 5400 5250 50  0000 C CNN
F 4 "560EBK-ND" H 5400 5250 60  0001 C CNN "Field1"
	1    5400 5250
	1    0    0    -1  
$EndComp
$Comp
L SPST SW1
U 1 1 4CA7A271
P 5400 4450
F 0 "SW1" H 5400 4550 70  0000 C CNN
F 1 "SPST" H 5400 4350 70  0000 C CNN
F 4 "EG4815-ND" H 5400 4450 60  0001 C CNN "Field1"
	1    5400 4450
	0    1    1    0   
$EndComp
$Comp
L CONN_3 K1
U 1 1 4CA7A129
P 6450 3800
F 0 "K1" V 6400 3800 50  0000 C CNN
F 1 "CONN_3" V 6500 3800 40  0000 C CNN
F 4 "CP1-3513-ND" H 6450 3800 60  0001 C CNN "Field1"
	1    6450 3800
	1    0    0    -1  
$EndComp
$EndSCHEMATC
