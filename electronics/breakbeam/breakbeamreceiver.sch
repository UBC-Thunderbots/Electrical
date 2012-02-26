EESchema Schematic File Version 2  date 26/02/2012 3:38:48 PM
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
LIBS:breakbeamreceiver-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "26 feb 2012"
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
F 1 "OPTO_NPN" H 5350 3650 50  0000 L CNN
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
	6150 3750 6150 4650
Wire Wire Line
	6150 4650 5300 4650
Wire Wire Line
	5300 3950 5300 4150
Text Label 6400 3850 0    60   ~ 0
SIG
Text Label 6400 3750 0    60   ~ 0
GND
Text Label 6400 3650 0    60   ~ 0
3.3v
$Comp
L CONN_3 K1
U 1 1 4F4ABF4E
P 6700 3750
F 0 "K1" V 6650 3750 50  0000 C CNN
F 1 "CONN_3" V 6750 3750 40  0000 C CNN
	1    6700 3750
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4F4ABF26
P 5300 4400
F 0 "R1" V 5380 4400 50  0000 C CNN
F 1 "100" V 5300 4400 50  0000 C CNN
	1    5300 4400
	1    0    0    -1  
$EndComp
$EndSCHEMATC
