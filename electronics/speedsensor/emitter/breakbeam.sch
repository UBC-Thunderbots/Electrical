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
LIBS:breakbeam-cache
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
Text Label 5000 2750 0    60   ~ 0
GND
Text Label 5000 2650 0    60   ~ 0
3.3v
Wire Wire Line
	4200 3050 4200 3250
Wire Wire Line
	5000 2750 5000 3700
Wire Wire Line
	5000 3700 4200 3700
Wire Wire Line
	4200 3700 4200 3650
$Comp
L CONN_01X02 P1
U 1 1 4F4A9B88
P 5350 2700
F 0 "P1" V 5300 2700 40  0000 C CNN
F 1 "CONN_01X02" V 5400 2700 40  0000 C CNN
F 2 "thunderbots-modules:connector_0_49_in_2pin" H 5350 2700 60  0001 C CNN
F 3 "" H 5350 2700 60  0001 C CNN
F 4 "none" H 5350 2700 60  0001 C CNN "Digi-Key Part"
	1    5350 2700
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4F4A9331
P 4200 2900
F 0 "R1" V 4280 2900 50  0000 C CNN
F 1 "16.5R" V 4200 2900 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4200 2900 60  0001 C CNN
F 3 "" H 4200 2900 60  0001 C CNN
	1    4200 2900
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 4F4A8D52
P 4200 3450
F 0 "D1" H 4200 3550 50  0000 C CNN
F 1 "VSMY2850RG" H 4200 3350 50  0000 C CNN
F 2 "thunderbots-modules:LED-VSMY2850RG" H 4200 3450 60  0001 C CNN
F 3 "VSMY2850RG" H 4200 3450 60  0000 C CNN
	1    4200 3450
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5150 2750 5000 2750
Wire Wire Line
	5150 2650 4200 2650
Wire Wire Line
	4200 2650 4200 2750
$EndSCHEMATC
