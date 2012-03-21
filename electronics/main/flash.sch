EESchema Schematic File Version 2  date 2012-03-20T22:07:54 PDT
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
Sheet 3 17
Title ""
Date "21 mar 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 7000 4300
Wire Wire Line
	7000 4300 7000 3550
Wire Wire Line
	7000 3550 7100 3550
Connection ~ 4850 4100
Wire Wire Line
	4850 4100 4850 3350
Wire Wire Line
	4850 3350 7100 3350
Wire Wire Line
	7050 3150 7100 3150
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
Wire Wire Line
	7100 3050 4750 3050
Wire Wire Line
	4750 3050 4750 4000
Connection ~ 4750 4000
Wire Wire Line
	7050 3250 7100 3250
Wire Wire Line
	7100 3450 6900 3450
Wire Wire Line
	6900 3450 6900 4200
Connection ~ 6900 4200
$Comp
L GND #PWR?
U 1 1 4F6961FE
P 7050 3250
F 0 "#PWR?" H 7050 3250 30  0001 C CNN
F 1 "GND" H 7050 3180 30  0001 C CNN
	1    7050 3250
	0    1    1    0   
$EndComp
$Comp
L +3.3V #PWR?
U 1 1 4F6961F9
P 7050 3150
F 0 "#PWR?" H 7050 3110 30  0001 C CNN
F 1 "+3.3V" H 7050 3260 30  0000 C CNN
	1    7050 3150
	0    -1   -1   0   
$EndComp
$Comp
L CONN_6 P?
U 1 1 4F695874
P 7450 3300
F 0 "P?" V 7400 3300 60  0000 C CNN
F 1 "CONN_6" V 7500 3300 60  0000 C CNN
F 2 "ICSP" H 7450 3300 60  0001 C CNN
	1    7450 3300
	1    0    0    -1  
$EndComp
$Comp
L W25Q16BV U6
U 1 1 4CD66182
P 5850 4150
F 0 "U6" H 5850 4150 60  0000 C CNN
F 1 "W25Q16BV" H 5850 4450 60  0000 C CNN
	1    5850 4150
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR077
U 1 1 4CC3848B
P 6700 4050
F 0 "#PWR077" H 6700 4010 30  0001 C CNN
F 1 "+3.3V" H 6700 4160 30  0000 C CNN
	1    6700 4050
	0    1    1    0   
$EndComp
$Comp
L +3.3V #PWR078
U 1 1 4CC3847F
P 5050 4200
F 0 "#PWR078" H 5050 4160 30  0001 C CNN
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
L GND #PWR079
U 1 1 4ABE8D7B
P 5050 4300
F 0 "#PWR079" H 5050 4300 30  0001 C CNN
F 1 "GND" H 5050 4230 30  0001 C CNN
	1    5050 4300
	0    1    1    0   
$EndComp
$EndSCHEMATC
