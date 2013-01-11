EESchema Schematic File Version 2  date 2013-01-11T01:05:17 PST
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
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
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
Text Notes 6350 2650 0    60   ~ 0
Connecting Cable
Text Notes 4950 2650 0    60   ~ 0
Optical Encoder
Wire Notes Line
	6250 2250 6250 5150
Wire Wire Line
	6750 3900 6800 3900
Wire Wire Line
	6750 3700 6800 3700
Wire Wire Line
	4600 4450 4600 4500
Wire Wire Line
	5750 3800 5150 3800
Wire Wire Line
	5700 3900 5750 3900
Wire Wire Line
	5700 3700 5750 3700
Wire Wire Line
	5750 4000 5450 4000
Wire Wire Line
	5450 4000 5450 3900
Wire Wire Line
	5450 3900 5150 3900
Wire Wire Line
	4600 3200 4600 3150
Wire Wire Line
	6800 3800 6750 3800
Wire Wire Line
	6800 4000 6750 4000
$Comp
L CONN_4 P?
U 1 1 4F7FB015
P 7150 3850
F 0 "P?" V 7100 3850 50  0000 C CNN
F 1 "CONN_4" V 7200 3850 50  0000 C CNN
F 4 "WM1722-ND" H 7150 3850 60  0001 C CNN "Digi-Key Part"
	1    7150 3850
	1    0    0    -1  
$EndComp
$Comp
L CONN_4 P?
U 1 1 4F7FB012
P 6400 3850
F 0 "P?" V 6350 3850 50  0000 C CNN
F 1 "CONN_4" V 6450 3850 50  0000 C CNN
F 4 "WM1722-ND" H 6400 3850 60  0001 C CNN "Digi-Key Part"
	1    6400 3850
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 4F7FAF39
P 4600 4500
F 0 "#PWR?" H 4600 4500 30  0001 C CNN
F 1 "GND" H 4600 4430 30  0001 C CNN
	1    4600 4500
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 4F7FAF36
P 4600 3150
F 0 "#PWR?" H 4600 3240 20  0001 C CNN
F 1 "+5V" H 4600 3240 30  0000 C CNN
	1    4600 3150
	1    0    0    -1  
$EndComp
$Comp
L E4P U?
U 1 1 4F7FAF2A
P 4600 3850
F 0 "U?" H 4600 3800 60  0000 C CNN
F 1 "E4P" H 4600 3900 60  0000 C CNN
F 4 "none" H 4600 3850 60  0001 C CNN "Digi-Key Part"
	1    4600 3850
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 4F7FA55B
P 5700 3700
F 0 "#PWR?" H 5700 3790 20  0001 C CNN
F 1 "+5V" H 5700 3790 30  0000 C CNN
	1    5700 3700
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 4F7FA555
P 5700 3900
F 0 "#PWR?" H 5700 3900 30  0001 C CNN
F 1 "GND" H 5700 3830 30  0001 C CNN
	1    5700 3900
	0    1    1    0   
$EndComp
$Comp
L CONN_4 P?
U 1 1 4F7FA4A8
P 6100 3850
F 0 "P?" V 6050 3850 50  0000 C CNN
F 1 "CONN_4" V 6150 3850 50  0000 C CNN
F 4 "none" V 6100 3850 60  0001 C CNN "Digi-Key Part"
	1    6100 3850
	1    0    0    -1  
$EndComp
$EndSCHEMATC
