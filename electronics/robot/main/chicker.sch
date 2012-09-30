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
Sheet 13 15
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
	5100 4250 5150 4250
Wire Wire Line
	5100 4050 5150 4050
Wire Wire Line
	5100 3950 5150 3950
Wire Wire Line
	5100 3850 5150 3850
Wire Wire Line
	5100 3650 5150 3650
Wire Wire Line
	5100 3550 5150 3550
Wire Wire Line
	5150 3450 5100 3450
Connection ~ 5100 3200
Wire Wire Line
	5100 3200 5050 3200
Wire Wire Line
	5150 3150 5100 3150
Wire Wire Line
	5100 3150 5100 3250
Wire Wire Line
	5100 3250 5150 3250
Wire Wire Line
	5100 3400 5050 3400
Wire Wire Line
	5150 3350 5100 3350
Wire Wire Line
	5100 3350 5100 3450
Connection ~ 5100 3400
Wire Wire Line
	5100 3750 5150 3750
Wire Wire Line
	5100 4150 5150 4150
Text HLabel 5100 4250 0    60   Input ~ 0
RELAY
$Comp
L GND #PWR?
U 1 1 50667D7D
P 5100 4050
F 0 "#PWR?" H 5100 4050 30  0001 C CNN
F 1 "GND" H 5100 3980 30  0001 C CNN
	1    5100 4050
	0    1    1    0   
$EndComp
$Comp
L CONN_12 P18
U 1 1 00000000
P 5500 3700
F 0 "P18" V 5450 3700 60  0000 C CNN
F 1 "CONN_12" V 5550 3700 60  0000 C CNN
	1    5500 3700
	1    0    0    -1  
$EndComp
Text HLabel 5100 4150 0    60   Output ~ 0
VOLTAGE_SENSE
$Comp
L GND #PWR0220
U 1 1 4F69666B
P 5100 3950
F 0 "#PWR0220" H 5100 3950 30  0001 C CNN
F 1 "GND" H 5100 3880 30  0001 C CNN
	1    5100 3950
	0    1    1    0   
$EndComp
$Comp
L GND #PWR0221
U 1 1 4F696643
P 5050 3400
F 0 "#PWR0221" H 5050 3400 30  0001 C CNN
F 1 "GND" H 5050 3330 30  0001 C CNN
	1    5050 3400
	0    1    1    0   
$EndComp
$Comp
L +BATT #PWR0222
U 1 1 4F696638
P 5050 3200
F 0 "#PWR0222" H 5050 3150 20  0001 C CNN
F 1 "+BATT" H 5050 3300 30  0000 C CNN
	1    5050 3200
	0    -1   -1   0   
$EndComp
Text HLabel 5100 3750 0    60   Input ~ 0
POWER_CTL
Text HLabel 5100 3650 0    60   Input ~ 0
CHIP
Text HLabel 5100 3850 0    60   Input ~ 0
KICK
Text HLabel 5100 3550 0    60   Input ~ 0
CHARGE
$EndSCHEMATC
