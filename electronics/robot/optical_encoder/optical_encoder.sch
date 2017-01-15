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
Text Notes 6350 2650 0    60   ~ 0
Connecting Cable
Text Notes 4950 2650 0    60   ~ 0
Optical Encoder
Wire Notes Line
	6250 2250 6250 5150
Wire Wire Line
	6550 3900 6600 3900
Wire Wire Line
	6550 3700 6600 3700
Wire Wire Line
	4800 4450 4800 4500
Wire Wire Line
	5950 3800 5350 3800
Wire Wire Line
	5900 3900 5950 3900
Wire Wire Line
	5900 3700 5950 3700
Wire Wire Line
	5950 4000 5650 4000
Wire Wire Line
	5650 4000 5650 3900
Wire Wire Line
	5650 3900 5350 3900
Wire Wire Line
	4800 3200 4800 3150
Wire Wire Line
	6600 3800 6550 3800
Wire Wire Line
	6600 4000 6550 4000
$Comp
L CONN_01X04 P3
U 1 1 4F7FB015
P 6800 3850
F 0 "P3" V 6750 3850 50  0000 C CNN
F 1 "CONN_01X04" V 6850 3850 50  0000 C CNN
F 2 "" H 6800 3850 60  0001 C CNN
F 3 "" H 6800 3850 60  0001 C CNN
F 4 "optical-encoder-plug" H 6800 3850 60  0001 C CNN "Digi-Key Part"
	1    6800 3850
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 P2
U 1 1 4F7FB012
P 6350 3850
F 0 "P2" V 6300 3850 50  0000 C CNN
F 1 "CONN_01X04" V 6400 3850 50  0000 C CNN
F 2 "" H 6350 3850 60  0001 C CNN
F 3 "" H 6350 3850 60  0001 C CNN
F 4 "optical-encoder-plug" H 6350 3850 60  0001 C CNN "Digi-Key Part"
	1    6350 3850
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR2
U 1 1 4F7FAF39
P 4800 4500
F 0 "#PWR2" H 4800 4500 30  0001 C CNN
F 1 "GND" H 4800 4430 30  0001 C CNN
F 2 "" H 4800 4500 60  0001 C CNN
F 3 "" H 4800 4500 60  0001 C CNN
	1    4800 4500
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR1
U 1 1 4F7FAF36
P 4800 3150
F 0 "#PWR1" H 4800 3240 20  0001 C CNN
F 1 "+5V" H 4800 3240 30  0000 C CNN
F 2 "" H 4800 3150 60  0001 C CNN
F 3 "" H 4800 3150 60  0001 C CNN
	1    4800 3150
	1    0    0    -1  
$EndComp
$Comp
L E4P U1
U 1 1 4F7FAF2A
P 4800 3850
F 0 "U1" H 4800 3800 60  0000 C CNN
F 1 "E4P" H 4800 3900 60  0000 C CNN
F 2 "" H 4800 3850 60  0001 C CNN
F 3 "" H 4800 3850 60  0001 C CNN
F 4 "none" H 4800 3850 60  0001 C CNN "Digi-Key Part"
	1    4800 3850
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR3
U 1 1 4F7FA55B
P 5900 3700
F 0 "#PWR3" H 5900 3790 20  0001 C CNN
F 1 "+5V" H 5900 3790 30  0000 C CNN
F 2 "" H 5900 3700 60  0001 C CNN
F 3 "" H 5900 3700 60  0001 C CNN
	1    5900 3700
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR4
U 1 1 4F7FA555
P 5900 3900
F 0 "#PWR4" H 5900 3900 30  0001 C CNN
F 1 "GND" H 5900 3830 30  0001 C CNN
F 2 "" H 5900 3900 60  0001 C CNN
F 3 "" H 5900 3900 60  0001 C CNN
	1    5900 3900
	0    1    1    0   
$EndComp
$Comp
L CONN_01X04 P1
U 1 1 4F7FA4A8
P 6150 3850
F 0 "P1" V 6100 3850 50  0000 C CNN
F 1 "CONN_01X04" V 6200 3850 50  0000 C CNN
F 2 "" H 6150 3850 60  0001 C CNN
F 3 "" H 6150 3850 60  0001 C CNN
F 4 "none" V 6150 3850 60  0001 C CNN "Digi-Key Part"
	1    6150 3850
	1    0    0    -1  
$EndComp
$EndSCHEMATC
