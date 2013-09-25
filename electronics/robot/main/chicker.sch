EESchema Schematic File Version 2  date 2013-09-24T20:57:41 PDT
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
Sheet 14 15
Title ""
Date "25 sep 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 4900 4300 2    60   ~ 0
RELAY
Wire Wire Line
	5050 4250 5150 4250
Wire Wire Line
	5100 4150 5150 4150
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
$Comp
L +3.3V #PWR0158
U 1 1 52425F30
P 5050 4250
F 0 "#PWR0158" H 5050 4210 30  0001 C CNN
F 1 "+3.3V" H 5050 4360 30  0000 C CNN
	1    5050 4250
	0    -1   -1   0   
$EndComp
Text Notes 5100 3800 2    60   ~ 0
~PRESENT
NoConn ~ 5150 3750
$Comp
L GND #PWR0159
U 1 1 50667D7D
P 5100 4050
F 0 "#PWR0159" H 5100 4050 30  0001 C CNN
F 1 "GND" H 5100 3980 30  0001 C CNN
	1    5100 4050
	0    1    1    0   
$EndComp
$Comp
L CONN_12 P18
U 1 1 506E24B5
P 5500 3700
F 0 "P18" V 5450 3700 60  0000 C CNN
F 1 "CONN_12" V 5550 3700 60  0000 C CNN
F 4 "chicker-waysl-header" V 5500 3700 60  0001 C CNN "Digi-Key Part"
	1    5500 3700
	1    0    0    -1  
$EndComp
Text HLabel 5100 4150 0    60   Output ~ 0
VOLTAGE_SENSE
$Comp
L GND #PWR0160
U 1 1 4F69666B
P 5100 3950
F 0 "#PWR0160" H 5100 3950 30  0001 C CNN
F 1 "GND" H 5100 3880 30  0001 C CNN
	1    5100 3950
	0    1    1    0   
$EndComp
$Comp
L GND #PWR0161
U 1 1 4F696643
P 5050 3400
F 0 "#PWR0161" H 5050 3400 30  0001 C CNN
F 1 "GND" H 5050 3330 30  0001 C CNN
	1    5050 3400
	0    1    1    0   
$EndComp
$Comp
L +BATT #PWR0162
U 1 1 4F696638
P 5050 3200
F 0 "#PWR0162" H 5050 3150 20  0001 C CNN
F 1 "+BATT" H 5050 3300 30  0000 C CNN
	1    5050 3200
	0    -1   -1   0   
$EndComp
Text HLabel 5100 3650 0    60   Input ~ 0
CHIP
Text HLabel 5100 3850 0    60   Input ~ 0
KICK
Text HLabel 5100 3550 0    60   Input ~ 0
CHARGE
$EndSCHEMATC
