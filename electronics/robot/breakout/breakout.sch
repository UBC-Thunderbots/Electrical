EESchema Schematic File Version 2  date 2012-10-01T18:30:33 PDT
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
LIBS:breakout-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 5
Title ""
Date "2 oct 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 2300 3800
Wire Wire Line
	2300 3800 1650 3800
Connection ~ 2900 3800
Wire Wire Line
	2950 3800 2900 3800
Connection ~ 4450 2050
Wire Wire Line
	4450 2050 4450 2100
Wire Wire Line
	4650 1600 4650 1550
Wire Wire Line
	1650 3700 1700 3700
Wire Wire Line
	1700 3900 1650 3900
Wire Wire Line
	1700 3600 1650 3600
Wire Wire Line
	1700 3200 1650 3200
Wire Wire Line
	4250 1550 4250 1600
Wire Wire Line
	4250 2000 4250 2050
Wire Wire Line
	4250 2050 4650 2050
Wire Wire Line
	4650 2050 4650 2000
Wire Wire Line
	2850 3700 2900 3700
Wire Wire Line
	2900 3700 2900 3900
Wire Wire Line
	2900 3900 2850 3900
Wire Wire Line
	2350 3700 2300 3700
Wire Wire Line
	2300 3700 2300 3900
Wire Wire Line
	2300 3900 2350 3900
$Comp
L R R?
U 1 1 506A43A5
P 2600 3900
F 0 "R?" V 2680 3900 50  0000 C CNN
F 1 "1kR" V 2600 3900 50  0000 C CNN
	1    2600 3900
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 4450 2100
F 0 "#PWR?" H 4450 2100 30  0001 C CNN
F 1 "GND" H 4450 2030 30  0001 C CNN
	1    4450 2100
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 00000000
P 4650 1800
F 0 "C?" H 4700 1900 50  0000 L CNN
F 1 "10uF" H 4700 1700 50  0000 L CNN
	1    4650 1800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 00000000
P 4250 1800
F 0 "C?" H 4300 1900 50  0000 L CNN
F 1 "10uF" H 4300 1700 50  0000 L CNN
	1    4250 1800
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 00000000
P 4650 1550
F 0 "#PWR?" H 4650 1640 20  0001 C CNN
F 1 "+5V" H 4650 1640 30  0000 C CNN
	1    4650 1550
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR?
U 1 1 00000000
P 4250 1550
F 0 "#PWR?" H 4250 1510 30  0001 C CNN
F 1 "+3.3V" H 4250 1660 30  0000 C CNN
	1    4250 1550
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR?
U 1 1 00000000
P 2950 3800
F 0 "#PWR?" H 2950 3760 30  0001 C CNN
F 1 "+3.3V" H 2950 3910 30  0000 C CNN
	1    2950 3800
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 1700 3200
F 0 "#PWR?" H 1700 3200 30  0001 C CNN
F 1 "GND" H 1700 3130 30  0001 C CNN
	1    1700 3200
	0    -1   -1   0   
$EndComp
Text Notes 1750 3300 0    60   ~ 0
LPS sensor
Text Notes 1750 3400 0    60   ~ 0
LPS clock
Text Notes 1750 3500 0    60   ~ 0
LPS /reset
$Comp
L +3.3V #PWR?
U 1 1 00000000
P 1700 3600
F 0 "#PWR?" H 1700 3560 30  0001 C CNN
F 1 "+3.3V" H 1700 3710 30  0000 C CNN
	1    1700 3600
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 1700 3700
F 0 "#PWR?" H 1700 3700 30  0001 C CNN
F 1 "GND" H 1700 3630 30  0001 C CNN
	1    1700 3700
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 1700 3900
F 0 "#PWR?" H 1700 3900 30  0001 C CNN
F 1 "GND" H 1700 3830 30  0001 C CNN
	1    1700 3900
	0    -1   -1   0   
$EndComp
Text Notes 1750 3800 0    60   ~ 0
BB laser
Text Notes 1750 4000 0    60   ~ 0
BB sensor
$Comp
L R R?
U 1 1 00000000
P 2600 3700
F 0 "R?" V 2680 3700 50  0000 C CNN
F 1 "1kR" V 2600 3700 50  0000 C CNN
	1    2600 3700
	0    -1   -1   0   
$EndComp
$Comp
L CONN_9 P?
U 1 1 00000000
P 1300 3600
F 0 "P?" V 1250 3600 60  0000 C CNN
F 1 "CONN_9" V 1350 3600 60  0000 C CNN
F 2 "WM7627" H 1300 3600 60  0001 C CNN
F 4 "WM7627" V 1300 3600 60  0001 C CNN "Field1"
	1    1300 3600
	-1   0    0    1   
$EndComp
$Comp
L CONN_20X2 P?
U 1 1 00000000
P 5200 4800
F 0 "P?" H 5200 5850 60  0000 C CNN
F 1 "CONN_20X2" V 5200 4800 50  0000 C CNN
	1    5200 4800
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 00000000
P 3500 4400
F 0 "#PWR?" H 3500 4490 20  0001 C CNN
F 1 "+5V" H 3500 4490 30  0000 C CNN
	1    3500 4400
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR?
U 1 1 00000000
P 3250 4450
F 0 "#PWR?" H 3250 4410 30  0001 C CNN
F 1 "+3.3V" H 3250 4560 30  0000 C CNN
	1    3250 4450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 3100 4450
F 0 "#PWR?" H 3100 4450 30  0001 C CNN
F 1 "GND" H 3100 4380 30  0001 C CNN
	1    3100 4450
	1    0    0    -1  
$EndComp
$Sheet
S 8150 900  900  300 
U 5065530C
F0 "wheelconn0" 60
F1 "wheelconn.sch" 60
F2 "SENSOR[0..4]" O L 8150 1100 60 
F3 "PHASE[0..2]" I L 8150 1000 60 
$EndSheet
$Sheet
S 8150 2400 900  300 
U 50655305
F0 "wheelconn3" 60
F1 "wheelconn.sch" 60
F2 "SENSOR[0..4]" O L 8150 2600 60 
F3 "PHASE[0..2]" I L 8150 2500 60 
$EndSheet
$Sheet
S 8150 1900 900  300 
U 506552F4
F0 "wheelconn2" 60
F1 "wheelconn.sch" 60
F2 "SENSOR[0..4]" O L 8150 2100 60 
F3 "PHASE[0..2]" I L 8150 2000 60 
$EndSheet
$Sheet
S 8150 1400 900  300 
U 5065526E
F0 "wheelconn1" 60
F1 "wheelconn.sch" 60
F2 "SENSOR[0..4]" O L 8150 1600 60 
F3 "PHASE[0..2]" I L 8150 1500 60 
$EndSheet
$EndSCHEMATC
