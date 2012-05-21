EESchema Schematic File Version 2  date 2012-05-20T20:58:45 PDT
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
Sheet 15 17
Title ""
Date "21 may 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 5150 3900
Wire Wire Line
	5150 3900 5150 3850
Wire Wire Line
	5150 3300 5150 3350
Wire Wire Line
	4150 3850 4150 3800
Wire Wire Line
	5200 4000 5150 4000
Wire Wire Line
	5150 4200 5200 4200
Wire Wire Line
	5150 4100 5200 4100
Wire Wire Line
	4150 4300 4150 4250
Wire Wire Line
	5100 3900 5200 3900
$Comp
L +3.3V #PWR?
U 1 1 4FB97867
P 5150 3300
F 0 "#PWR?" H 5150 3260 30  0001 C CNN
F 1 "+3.3V" H 5150 3410 30  0000 C CNN
	1    5150 3300
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 4FB97860
P 5150 3600
F 0 "R?" V 5230 3600 50  0000 C CNN
F 1 "10kR" V 5150 3600 50  0000 C CNN
	1    5150 3600
	1    0    0    -1  
$EndComp
Text HLabel 5100 3900 0    60   Input ~ 0
ENABLE
$Comp
L ECS-2033 U12
U 1 1 4F6436C0
P 6100 4050
F 0 "U12" H 6100 4000 60  0000 C CNN
F 1 "ECS-2033" H 6100 4100 60  0000 C CNN
F 2 "ECS-2033" H 6000 3950 60  0001 C CNN
F 4 "XC1424CT-ND" H 6100 4050 60  0001 C CNN "Field1"
	1    6100 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR85
U 1 1 4CC50E98
P 4150 4300
F 0 "#PWR85" H 4150 4300 30  0001 C CNN
F 1 "GND" H 4150 4230 30  0001 C CNN
	1    4150 4300
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR84
U 1 1 4CC50E96
P 4150 3800
F 0 "#PWR84" H 4150 3760 30  0001 C CNN
F 1 "+3.3V" H 4150 3910 30  0000 C CNN
	1    4150 3800
	1    0    0    -1  
$EndComp
$Comp
L C C23
U 1 1 4CC50E90
P 4150 4050
F 0 "C23" H 4200 4150 50  0000 L CNN
F 1 "100nF" H 4200 3950 50  0000 L CNN
F 4 "" H 4150 4050 60  0001 C CNN "Digikey Part"
	1    4150 4050
	1    0    0    -1  
$EndComp
Text HLabel 5150 4100 0    60   Output ~ 0
OSC
$Comp
L +3.3V #PWR87
U 1 1 4CC50DEA
P 5150 4200
F 0 "#PWR87" H 5150 4160 30  0001 C CNN
F 1 "+3.3V" H 5150 4310 30  0000 C CNN
	1    5150 4200
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR86
U 1 1 4CC50DE7
P 5150 4000
F 0 "#PWR86" H 5150 4000 30  0001 C CNN
F 1 "GND" H 5150 3930 30  0001 C CNN
	1    5150 4000
	0    1    1    0   
$EndComp
$EndSCHEMATC
