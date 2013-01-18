EESchema Schematic File Version 2  date 1/17/2013 11:49:44 PM
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
LIBS:oven_controller-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "18 jan 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	7100 3500 6700 3500
Wire Wire Line
	7100 3900 6700 3900
Wire Wire Line
	4750 4400 5100 4400
Wire Wire Line
	5400 4200 5550 4200
Connection ~ 5550 3600
Wire Wire Line
	5550 3600 5400 3600
Wire Wire Line
	5400 3600 5400 3650
Wire Wire Line
	4750 4300 4800 4300
Wire Wire Line
	4800 4300 4800 4150
Wire Wire Line
	5550 4700 5550 4600
Wire Wire Line
	5550 4200 5550 4000
Wire Wire Line
	4800 4700 4800 4500
Wire Wire Line
	4800 4500 4750 4500
Wire Wire Line
	5550 3450 5550 3650
Wire Wire Line
	5400 4050 5550 4050
Connection ~ 5550 4050
Wire Wire Line
	5550 4600 5400 4600
Wire Wire Line
	6700 3900 6700 3500
Wire Wire Line
	6350 3900 6350 4100
Wire Wire Line
	6350 4100 7100 4100
Wire Wire Line
	7100 3700 6350 3700
$Comp
L CONN_1 P4
U 1 1 50F8FAD4
P 7250 4100
F 0 "P4" H 7330 4100 40  0000 L CNN
F 1 "CONN_1" H 7250 4155 30  0001 C CNN
	1    7250 4100
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 P3
U 1 1 50F8FAD3
P 7250 3900
F 0 "P3" H 7330 3900 40  0000 L CNN
F 1 "CONN_1" H 7250 3955 30  0001 C CNN
	1    7250 3900
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 P2
U 1 1 50F8FAD1
P 7250 3700
F 0 "P2" H 7330 3700 40  0000 L CNN
F 1 "CONN_1" H 7250 3755 30  0001 C CNN
	1    7250 3700
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 P1
U 1 1 50F8FACD
P 7250 3500
F 0 "P1" H 7330 3500 40  0000 L CNN
F 1 "CONN_1" H 7250 3555 30  0001 C CNN
	1    7250 3500
	1    0    0    -1  
$EndComp
Text Notes 6700 3500 0    60   ~ 0
NEUTRAL
Text Notes 6400 3700 0    60   ~ 0
LIVE
Text Notes 6700 3900 0    60   ~ 0
NEUTRAL
Text Notes 6400 4100 0    60   ~ 0
LIVE
$Comp
L AO4616 Q1
U 1 1 50F8F205
P 5300 4400
F 0 "Q1" H 5310 4570 60  0000 R CNN
F 1 "AO4616" H 5310 4250 60  0000 R CNN
F 2 "SO8E" H 5210 4470 60  0001 C CNN
F 4 "~" H 5410 4670 60  0001 C CNN "Field4"
	1    5300 4400
	1    0    0    -1  
$EndComp
$Comp
L DIODE D1
U 1 1 50F8F1DB
P 5400 3850
F 0 "D1" H 5400 3950 40  0000 C CNN
F 1 "1N4148" H 5400 3750 40  0000 C CNN
	1    5400 3850
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR01
U 1 1 50F8F1D0
P 5550 3450
F 0 "#PWR01" H 5550 3540 20  0001 C CNN
F 1 "+5V" H 5550 3540 30  0000 C CNN
	1    5550 3450
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR02
U 1 1 50F8F1C9
P 4800 4150
F 0 "#PWR02" H 4800 4240 20  0001 C CNN
F 1 "+5V" H 4800 4240 30  0000 C CNN
	1    4800 4150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 50F8F1BF
P 4800 4700
F 0 "#PWR03" H 4800 4700 30  0001 C CNN
F 1 "GND" H 4800 4630 30  0001 C CNN
	1    4800 4700
	1    0    0    -1  
$EndComp
$Comp
L CONN_3 K1
U 1 1 50F8F1BA
P 4400 4400
F 0 "K1" V 4350 4400 50  0000 C CNN
F 1 "CONN_3" V 4450 4400 40  0000 C CNN
	1    4400 4400
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR04
U 1 1 50F8F1AB
P 5550 4700
F 0 "#PWR04" H 5550 4700 30  0001 C CNN
F 1 "GND" H 5550 4630 30  0001 C CNN
	1    5550 4700
	1    0    0    -1  
$EndComp
$Comp
L RELAY_SPST K2
U 1 1 50F8F19A
P 5950 3750
F 0 "K2" H 6250 3950 60  0000 C CNN
F 1 "RELAY_SPST" H 5850 3950 60  0000 C CNN
	1    5950 3750
	1    0    0    -1  
$EndComp
$EndSCHEMATC
