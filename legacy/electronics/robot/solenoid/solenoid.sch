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
Date "2 mar 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5850 3700 5850 3950
Wire Wire Line
	5850 3950 6150 3950
Wire Wire Line
	6150 3350 5850 3350
Wire Wire Line
	5850 3350 5850 3600
$Comp
L CONN_01X02 P1
U 1 1 4F7FB0A2
P 5400 3650
F 0 "P1" V 5350 3650 40  0000 C CNN
F 1 "CONN_01X02" V 5450 3650 40  0000 C CNN
F 2 "" H 5400 3650 60  0001 C CNN
F 3 "" H 5400 3650 60  0001 C CNN
F 4 "solenoid-plug" H 5400 3650 60  0001 C CNN "Digi-Key Part"
	1    5400 3650
	-1   0    0    -1  
$EndComp
$Comp
L INDUCTOR L1
U 1 1 4F7FB09F
P 6150 3650
F 0 "L1" V 6100 3650 40  0000 C CNN
F 1 "INDUCTOR" V 6250 3650 40  0000 C CNN
F 2 "" H 6150 3650 60  0001 C CNN
F 3 "" H 6150 3650 60  0001 C CNN
F 4 "none" H 6150 3650 60  0001 C CNN "Digi-Key Part"
	1    6150 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 3600 5600 3600
Wire Wire Line
	5600 3700 5850 3700
$EndSCHEMATC
