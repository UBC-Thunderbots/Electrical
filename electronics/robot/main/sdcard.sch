EESchema Schematic File Version 2  date 2012-09-29T23:40:59 PDT
LIBS:power
LIBS:device
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
LIBS:contrib
LIBS:valves
LIBS:thunderbots-symbols
LIBS:main-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 2 15
Title ""
Date "30 sep 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5500 4650 5550 4650
Wire Wire Line
	5500 4350 5550 4350
Wire Wire Line
	5500 4150 5550 4150
Wire Wire Line
	5500 3950 5550 3950
Wire Wire Line
	5500 3850 5550 3850
Wire Wire Line
	5500 4050 5550 4050
Wire Wire Line
	5500 4250 5550 4250
Wire Wire Line
	5500 4550 5550 4550
Text HLabel 5500 4650 0    60   Output ~ 0
PRESENT
$Comp
L +3.3V #PWR?
U 1 1 00000000
P 5500 4550
F 0 "#PWR?" H 5500 4510 30  0001 C CNN
F 1 "+3.3V" H 5500 4660 30  0000 C CNN
	1    5500 4550
	0    -1   -1   0   
$EndComp
NoConn ~ 5550 4450
Text HLabel 5500 4350 0    60   Output ~ 0
MISO
$Comp
L GND #PWR?
U 1 1 00000000
P 5500 4250
F 0 "#PWR?" H 5500 4250 30  0001 C CNN
F 1 "GND" H 5500 4180 30  0001 C CNN
	1    5500 4250
	0    1    1    0   
$EndComp
Text HLabel 5500 4150 0    60   Input ~ 0
CLOCK
$Comp
L +3.3V #PWR?
U 1 1 00000000
P 5500 4050
F 0 "#PWR?" H 5500 4010 30  0001 C CNN
F 1 "+3.3V" H 5500 4160 30  0000 C CNN
	1    5500 4050
	0    -1   -1   0   
$EndComp
Text HLabel 5500 3950 0    60   Input ~ 0
MOSI
Text HLabel 5500 3850 0    60   Input ~ 0
/CS
NoConn ~ 5550 3750
$Comp
L CONN_10 P?
U 1 1 00000000
P 5900 4200
F 0 "P?" V 5850 4200 60  0000 C CNN
F 1 "CONN_10" V 5950 4200 60  0000 C CNN
	1    5900 4200
	1    0    0    -1  
$EndComp
$EndSCHEMATC
