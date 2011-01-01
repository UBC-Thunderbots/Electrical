EESchema Schematic File Version 2  date Fri 31 Dec 2010 06:23:11 PM PST
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
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 14 18
Title ""
Date "1 jan 2011"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L W25Q16BV U6
U 1 1 4CD66182
P 5850 4150
F 0 "U6" H 5850 4150 60  0000 C CNN
F 1 "W25Q16BV" H 5850 4450 60  0000 C CNN
	1    5850 4150
	1    0    0    -1  
$EndComp
Connection ~ 6650 4050
Wire Wire Line
	6650 4050 6700 4050
Wire Wire Line
	6600 4100 6650 4100
Wire Wire Line
	5050 4300 5100 4300
Wire Wire Line
	7050 4300 6600 4300
Wire Wire Line
	4450 4000 5100 4000
Wire Wire Line
	4450 4100 5100 4100
Wire Wire Line
	6600 4200 7050 4200
Wire Wire Line
	5100 4200 5050 4200
Wire Wire Line
	6600 4000 6650 4000
Wire Wire Line
	6650 4000 6650 4100
$Comp
L +3.3V #PWR090
U 1 1 4CC3848B
P 6700 4050
F 0 "#PWR090" H 6700 4010 30  0001 C CNN
F 1 "+3.3V" H 6700 4160 30  0000 C CNN
	1    6700 4050
	0    1    1    0   
$EndComp
$Comp
L +3.3V #PWR091
U 1 1 4CC3847F
P 5050 4200
F 0 "#PWR091" H 5050 4160 30  0001 C CNN
F 1 "+3.3V" H 5050 4310 30  0000 C CNN
	1    5050 4200
	0    -1   -1   0   
$EndComp
Text HLabel 4450 4100 0    60   Output ~ 0
MISO
Text HLabel 4450 4000 0    60   Input ~ 0
/CS
Text HLabel 7050 4300 2    60   Input ~ 0
MOSI
Text HLabel 7050 4200 2    60   Input ~ 0
CLK
$Comp
L GND #PWR092
U 1 1 4ABE8D7B
P 5050 4300
F 0 "#PWR092" H 5050 4300 30  0001 C CNN
F 1 "GND" H 5050 4230 30  0001 C CNN
	1    5050 4300
	0    1    1    0   
$EndComp
$EndSCHEMATC
