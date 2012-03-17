EESchema Schematic File Version 2  date 2012-03-17T02:09:32 PDT
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
Date "17 mar 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_6X2 P9
U 1 1 4DE48200
P 7950 3650
F 0 "P9" H 7950 4000 60  0000 C CNN
F 1 "CONN_6X2" V 7950 3650 60  0000 C CNN
F 4 "chicker-header" H 7950 3650 60  0001 C CNN "Field1"
	1    7950 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 3900 7150 3900
Wire Wire Line
	8450 3600 8350 3600
Wire Wire Line
	7550 3800 7450 3800
Wire Wire Line
	7550 3500 7450 3500
Wire Wire Line
	7500 3400 7550 3400
Connection ~ 3250 4100
Wire Wire Line
	3300 4100 3250 4100
Connection ~ 3250 3900
Wire Wire Line
	3300 3900 3250 3900
Connection ~ 3250 3700
Wire Wire Line
	3300 3700 3250 3700
Connection ~ 3250 3500
Wire Wire Line
	3300 3500 3250 3500
Connection ~ 4150 3400
Wire Wire Line
	4150 3400 4100 3400
Connection ~ 4150 3600
Wire Wire Line
	4150 3600 4100 3600
Connection ~ 4150 3800
Wire Wire Line
	4150 3800 4100 3800
Connection ~ 4150 4000
Wire Wire Line
	4150 4000 4100 4000
Wire Wire Line
	4100 4200 4150 4200
Wire Wire Line
	4150 4200 4150 3350
Wire Wire Line
	4100 4100 4150 4100
Connection ~ 4150 4100
Wire Wire Line
	4100 3900 4150 3900
Connection ~ 4150 3900
Wire Wire Line
	4100 3700 4150 3700
Connection ~ 4150 3700
Wire Wire Line
	4100 3500 4150 3500
Connection ~ 4150 3500
Wire Wire Line
	3250 4250 3250 3400
Wire Wire Line
	3250 3400 3300 3400
Wire Wire Line
	3250 3600 3300 3600
Connection ~ 3250 3600
Wire Wire Line
	3250 3800 3300 3800
Connection ~ 3250 3800
Wire Wire Line
	3250 4000 3300 4000
Connection ~ 3250 4000
Wire Wire Line
	3250 4200 3300 4200
Connection ~ 3250 4200
Wire Wire Line
	7450 3600 7550 3600
Wire Wire Line
	8350 3500 8450 3500
Wire Wire Line
	7450 3700 7550 3700
Wire Wire Line
	8350 3700 8450 3700
Wire Wire Line
	8450 3800 8350 3800
Wire Wire Line
	8450 3400 8350 3400
$Comp
L +BATT #PWR080
U 1 1 4D1E8E72
P 7150 3900
F 0 "#PWR080" H 7150 3850 20  0001 C CNN
F 1 "+BATT" H 7150 4000 30  0000 C CNN
	1    7150 3900
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR081
U 1 1 4CEE1DFC
P 7450 3600
F 0 "#PWR081" H 7450 3600 30  0001 C CNN
F 1 "GND" H 7450 3530 30  0001 C CNN
	1    7450 3600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR082
U 1 1 4CEE1DF8
P 8450 3500
F 0 "#PWR082" H 8450 3500 30  0001 C CNN
F 1 "GND" H 8450 3430 30  0001 C CNN
	1    8450 3500
	1    0    0    -1  
$EndComp
Text HLabel 7450 3500 0    60   Input ~ 0
CLK
Text HLabel 8450 3800 2    60   Output ~ 0
PRESENT
Text HLabel 7450 3800 0    60   Input ~ 0
CHIP
Text HLabel 8450 3700 2    60   Input ~ 0
KICK
Text HLabel 7450 3700 0    60   Input ~ 0
CHARGE
Text HLabel 8450 3600 2    60   Output ~ 0
MISO
Text HLabel 8450 3400 2    60   Input ~ 0
/CS
$Comp
L +3.3V #PWR083
U 1 1 4CC361B6
P 7500 3400
F 0 "#PWR083" H 7500 3360 30  0001 C CNN
F 1 "+3.3V" H 7500 3510 30  0000 C CNN
	1    7500 3400
	0    -1   -1   0   
$EndComp
$Comp
L +BATT #PWR084
U 1 1 4CC3600A
P 4150 3350
F 0 "#PWR084" H 4150 3300 20  0001 C CNN
F 1 "+BATT" H 4150 3450 30  0000 C CNN
	1    4150 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR085
U 1 1 4CC36003
P 3250 4250
F 0 "#PWR085" H 3250 4250 30  0001 C CNN
F 1 "GND" H 3250 4180 30  0001 C CNN
	1    3250 4250
	1    0    0    -1  
$EndComp
$Comp
L CONN_9X2 P8
U 1 1 4CC35F90
P 3700 3750
F 0 "P8" H 3700 4200 60  0000 C CNN
F 1 "CONN_9X2" V 3700 3750 50  0000 C CNN
F 4 "chicker-header" H 3700 3750 60  0001 C CNN "Field1"
	1    3700 3750
	1    0    0    -1  
$EndComp
$EndSCHEMATC
