EESchema Schematic File Version 2  date 2012-05-20T21:53:36 PDT
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
Sheet 16 17
Title ""
Date "21 may 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5100 3750 5150 3750
Connection ~ 5100 3400
Wire Wire Line
	5100 3350 5100 3450
Wire Wire Line
	5100 3350 5150 3350
Wire Wire Line
	5100 3400 5050 3400
Wire Wire Line
	5150 3250 5100 3250
Wire Wire Line
	5100 3250 5100 3150
Wire Wire Line
	5100 3150 5150 3150
Wire Wire Line
	5100 3200 5050 3200
Connection ~ 5100 3200
Wire Wire Line
	5100 3450 5150 3450
Wire Wire Line
	5100 3550 5150 3550
Wire Wire Line
	5100 3650 5150 3650
Wire Wire Line
	5100 3850 5150 3850
Wire Wire Line
	5100 3950 5150 3950
Wire Wire Line
	5100 4050 5150 4050
Wire Wire Line
	5100 4150 5150 4150
Wire Wire Line
	5100 4250 5150 4250
Wire Wire Line
	5100 4350 5150 4350
Wire Wire Line
	5100 4450 5150 4450
Text Notes 6650 3600 0    60   ~ 0
Header for mechanical support
NoConn ~ 7100 3900
NoConn ~ 7100 3700
$Comp
L CONN_2 P19
U 1 1 4F69669B
P 7450 3800
F 0 "P19" V 7400 3800 40  0000 C CNN
F 1 "CONN_2" V 7500 3800 40  0000 C CNN
F 4 "2.54mm-header-general" H 7450 3800 60  0001 C CNN "Field1"
	1    7450 3800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR81
U 1 1 4F69666B
P 5100 3950
F 0 "#PWR81" H 5100 3950 30  0001 C CNN
F 1 "GND" H 5100 3880 30  0001 C CNN
	1    5100 3950
	0    1    1    0   
$EndComp
$Comp
L GND #PWR80
U 1 1 4F696643
P 5050 3400
F 0 "#PWR80" H 5050 3400 30  0001 C CNN
F 1 "GND" H 5050 3330 30  0001 C CNN
	1    5050 3400
	0    1    1    0   
$EndComp
$Comp
L +BATT #PWR79
U 1 1 4F696638
P 5050 3200
F 0 "#PWR79" H 5050 3150 20  0001 C CNN
F 1 "+BATT" H 5050 3300 30  0000 C CNN
	1    5050 3200
	0    -1   -1   0   
$EndComp
$Comp
L CONN_14 P18
U 1 1 4F696627
P 5500 3800
F 0 "P18" V 5470 3800 60  0000 C CNN
F 1 "CONN_14" V 5580 3800 60  0000 C CNN
F 4 "2.54mm-header-general" H 5500 3800 60  0001 C CNN "Field1"
	1    5500 3800
	1    0    0    -1  
$EndComp
Text HLabel 5100 3750 0    60   Input ~ 0
POWER_CTL
$Comp
L GND #PWR83
U 1 1 4CEE1DF8
P 5100 4450
F 0 "#PWR83" H 5100 4450 30  0001 C CNN
F 1 "GND" H 5100 4380 30  0001 C CNN
	1    5100 4450
	0    1    1    0   
$EndComp
Text HLabel 5100 4050 0    60   Input ~ 0
CLK
Text HLabel 5100 3650 0    60   Input ~ 0
CHIP
Text HLabel 5100 3850 0    60   Input ~ 0
KICK
Text HLabel 5100 3550 0    60   Input ~ 0
CHARGE
Text HLabel 5100 4250 0    60   Output ~ 0
MISO
Text HLabel 5100 4150 0    60   Input ~ 0
/CS
$Comp
L +3.3V #PWR82
U 1 1 4CC361B6
P 5100 4350
F 0 "#PWR82" H 5100 4310 30  0001 C CNN
F 1 "+3.3V" H 5100 4460 30  0000 C CNN
	1    5100 4350
	0    -1   -1   0   
$EndComp
$EndSCHEMATC
