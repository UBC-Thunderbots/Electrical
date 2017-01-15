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
Date "11 jan 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L OPTO_NPN Q1
U 1 1 4F4AC0B2
P 5200 3750
F 0 "Q1" H 5350 3800 50  0000 L CNN
F 1 "TEMT1000" H 5350 3650 50  0000 L CNN
F 2 "thunderbots-modules:PHOTOTRANS-TEMT1000" H 5200 3750 60  0001 C CNN
F 3 "" H 5200 3750 60  0001 C CNN
	1    5200 3750
	1    0    0    -1  
$EndComp
Connection ~ 5300 4000
Wire Wire Line
	5300 4000 5900 4000
Wire Wire Line
	5900 4000 5900 3850
Wire Wire Line
	5900 3850 6350 3850
Wire Wire Line
	5300 3550 5300 3450
Wire Wire Line
	5300 3450 6150 3450
Wire Wire Line
	6150 3450 6150 3650
Wire Wire Line
	6150 3650 6350 3650
Wire Wire Line
	6350 3750 6150 3750
Wire Wire Line
	5300 3950 5300 4150
Text Label 6250 3850 0    60   ~ 0
SIG
Text Label 6250 3750 0    60   ~ 0
GND
Text Label 6250 3650 0    60   ~ 0
3.3v
$Comp
L CONN_01X03 K1
U 1 1 4F4ABF4E
P 6550 3750
F 0 "K1" V 6500 3750 50  0000 C CNN
F 1 "CONN_01X03" V 6600 3750 40  0000 C CNN
F 2 "thunderbots-modules:connector_0_49_in_3pin" H 6550 3750 60  0001 C CNN
F 3 "" H 6550 3750 60  0001 C CNN
F 4 "none" H 6550 3750 60  0001 C CNN "Digi-Key Part"
	1    6550 3750
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4F4ABF26
P 5300 4300
F 0 "R1" V 5380 4300 50  0000 C CNN
F 1 "100R" V 5300 4300 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 5300 4300 60  0001 C CNN
F 3 "" H 5300 4300 60  0001 C CNN
	1    5300 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6150 3750 6150 4450
Wire Wire Line
	6150 4450 5300 4450
$EndSCHEMATC
