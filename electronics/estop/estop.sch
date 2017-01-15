EESchema Schematic File Version 2
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
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
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
Text Notes 5650 4200 0    60   ~ 0
R
Text Notes 5650 4100 0    60   ~ 0
T
Text Notes 5650 4000 0    60   ~ 0
S
Wire Wire Line
	5400 5150 5400 5200
Connection ~ 5400 4100
Wire Wire Line
	5100 4850 5100 5550
Connection ~ 5100 5500
$Comp
L R R2
U 1 1 4CA7AC7F
P 5100 5700
F 0 "R2" V 5180 5700 50  0000 C CNN
F 1 "2.2kR" V 5100 5700 50  0000 C CNN
F 2 "" H 5100 5700 60  0001 C CNN
F 3 "" H 5100 5700 60  0001 C CNN
F 4 "2.2KEBK-ND" H 5100 5700 60  0001 C CNN "Field1"
	1    5100 5700
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4CA7AC15
P 5100 4700
F 0 "R1" V 5180 4700 50  0000 C CNN
F 1 "2.2kR" V 5100 4700 50  0000 C CNN
F 2 "" H 5100 4700 60  0001 C CNN
F 3 "" H 5100 4700 60  0001 C CNN
F 4 "2.2KEBK-ND" H 5100 4700 60  0001 C CNN "Field1"
	1    5100 4700
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 4CA7AC0F
P 5400 5350
F 0 "R3" V 5480 5350 50  0000 C CNN
F 1 "560R" V 5400 5350 50  0000 C CNN
F 2 "" H 5400 5350 60  0001 C CNN
F 3 "" H 5400 5350 60  0001 C CNN
F 4 "560EBK-ND" H 5400 5350 60  0001 C CNN "Field1"
	1    5400 5350
	1    0    0    -1  
$EndComp
$Comp
L SPST SW1
U 1 1 4CA7A271
P 5400 4650
F 0 "SW1" H 5400 4750 70  0000 C CNN
F 1 "SPST" H 5400 4550 70  0000 C CNN
F 2 "" H 5400 4650 60  0001 C CNN
F 3 "" H 5400 4650 60  0001 C CNN
F 4 "EG4815-ND" H 5400 4650 60  0001 C CNN "Field1"
	1    5400 4650
	0    1    1    0   
$EndComp
$Comp
L CONN_01X03 K1
U 1 1 4CA7A129
P 5850 4100
F 0 "K1" V 5800 4100 50  0000 C CNN
F 1 "CONN_01X03" V 5900 4100 40  0000 C CNN
F 2 "" H 5850 4100 60  0001 C CNN
F 3 "" H 5850 4100 60  0001 C CNN
F 4 "CP1-3513-ND" H 5850 4100 60  0001 C CNN "Field1"
	1    5850 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 5500 5400 5500
Wire Wire Line
	5100 4100 5650 4100
Wire Wire Line
	4950 4000 5650 4000
Wire Wire Line
	5650 5850 5100 5850
Wire Wire Line
	5100 4100 5100 4550
Wire Wire Line
	5400 4100 5400 4150
Wire Wire Line
	4950 4000 4950 5500
Wire Wire Line
	5650 5850 5650 4200
$EndSCHEMATC
