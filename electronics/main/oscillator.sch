EESchema Schematic File Version 2  date 2011-01-12T18:57:08 PST
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
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 13 18
Title ""
Date "13 jan 2011"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4450 3850 4450 3800
Wire Wire Line
	5150 3900 5200 3900
Wire Wire Line
	5200 4000 5150 4000
Wire Wire Line
	5150 4200 5200 4200
Wire Wire Line
	5150 4100 5200 4100
Wire Wire Line
	4450 4300 4450 4250
$Comp
L GND #PWR072
U 1 1 4CC50E98
P 4450 4300
F 0 "#PWR072" H 4450 4300 30  0001 C CNN
F 1 "GND" H 4450 4230 30  0001 C CNN
	1    4450 4300
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR073
U 1 1 4CC50E96
P 4450 3800
F 0 "#PWR073" H 4450 3760 30  0001 C CNN
F 1 "+3.3V" H 4450 3910 30  0000 C CNN
	1    4450 3800
	1    0    0    -1  
$EndComp
$Comp
L C C23
U 1 1 4CC50E90
P 4450 4050
F 0 "C23" H 4500 4150 50  0000 L CNN
F 1 "10uF" H 4500 3950 50  0000 L CNN
F 4 "" H 4450 4050 60  0001 C CNN "Digikey Part"
	1    4450 4050
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR074
U 1 1 4CC50DFE
P 5150 3900
F 0 "#PWR074" H 5150 3860 30  0001 C CNN
F 1 "+3.3V" H 5150 4010 30  0000 C CNN
	1    5150 3900
	0    -1   -1   0   
$EndComp
Text HLabel 5150 4100 0    60   Output ~ 0
OSC
$Comp
L +3.3V #PWR075
U 1 1 4CC50DEA
P 5150 4200
F 0 "#PWR075" H 5150 4160 30  0001 C CNN
F 1 "+3.3V" H 5150 4310 30  0000 C CNN
	1    5150 4200
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR076
U 1 1 4CC50DE7
P 5150 4000
F 0 "#PWR076" H 5150 4000 30  0001 C CNN
F 1 "GND" H 5150 3930 30  0001 C CNN
	1    5150 4000
	0    1    1    0   
$EndComp
$Comp
L FXO-HC73 U13
U 1 1 4CC4F8BA
P 6100 4050
F 0 "U13" H 6100 4000 60  0000 C CNN
F 1 "FXO-HC73" H 6100 4100 60  0000 C CNN
F 4 "" H 6100 4050 60  0001 C CNN "Digikey Part"
	1    6100 4050
	1    0    0    -1  
$EndComp
$EndSCHEMATC
