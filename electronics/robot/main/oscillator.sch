EESchema Schematic File Version 2  date 2014年01月28日 星期二 13时04分52秒
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
LIBS:main-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 14 15
Title ""
Date "28 jan 2014"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5100 3900 5200 3900
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
$Comp
L +3.3V #PWR0174
U 1 1 52425F2F
P 5100 3900
F 0 "#PWR0174" H 5100 3860 30  0001 C CNN
F 1 "+3.3V" H 5100 4010 30  0000 C CNN
	1    5100 3900
	0    -1   -1   0   
$EndComp
$Comp
L ECS-3953M U12
U 1 1 4FB9D6EE
P 6100 4050
F 0 "U12" H 6100 4000 60  0000 C CNN
F 1 "ECS-3953M" H 6100 4100 60  0000 C CNN
F 2 "ECS-3953M" H 6000 3950 60  0001 C CNN
F 4 "XC287CT-ND" H 6100 4050 60  0001 C CNN "Field1"
	1    6100 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0175
U 1 1 4CC50E98
P 4150 4300
F 0 "#PWR0175" H 4150 4300 30  0001 C CNN
F 1 "GND" H 4150 4230 30  0001 C CNN
	1    4150 4300
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR0176
U 1 1 4CC50E96
P 4150 3800
F 0 "#PWR0176" H 4150 3760 30  0001 C CNN
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
L +3.3V #PWR0177
U 1 1 4CC50DEA
P 5150 4200
F 0 "#PWR0177" H 5150 4160 30  0001 C CNN
F 1 "+3.3V" H 5150 4310 30  0000 C CNN
	1    5150 4200
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR0178
U 1 1 4CC50DE7
P 5150 4000
F 0 "#PWR0178" H 5150 4000 30  0001 C CNN
F 1 "GND" H 5150 3930 30  0001 C CNN
	1    5150 4000
	0    1    1    0   
$EndComp
$EndSCHEMATC
