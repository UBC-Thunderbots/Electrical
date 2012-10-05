EESchema Schematic File Version 2  date 2012-10-04T18:49:32 PDT
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
Sheet 6 15
Title ""
Date "5 oct 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L +5V #PWR079
U 1 1 506E24BD
P 2300 4200
F 0 "#PWR079" H 2300 4290 20  0001 C CNN
F 1 "+5V" H 2300 4290 30  0000 C CNN
	1    2300 4200
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR080
U 1 1 506E24BC
P 2150 4200
F 0 "#PWR080" H 2150 4160 30  0001 C CNN
F 1 "+3.3V" H 2150 4310 30  0000 C CNN
	1    2150 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR081
U 1 1 506E24BB
P 1950 4200
F 0 "#PWR081" H 1950 4200 30  0001 C CNN
F 1 "GND" H 1950 4130 30  0001 C CNN
	1    1950 4200
	1    0    0    -1  
$EndComp
Text HLabel 2850 3500 0    60   Output ~ 0
BB_SENSOR
Text HLabel 2850 3250 0    60   Input ~ 0
LPS /RESET
Text HLabel 2850 3150 0    60   Input ~ 0
LPS_CLOCK
Text HLabel 2850 3050 0    60   Output ~ 0
LPS_SENSOR
Text HLabel 2850 2900 0    60   Input ~ 0
M3_SENSOR[0..4]
Text HLabel 2850 2800 0    60   Output ~ 0
M2_SENSOR[0..4]
Text HLabel 2850 2700 0    60   Output ~ 0
M1_SENSOR[0..4]
Text HLabel 2850 2600 0    60   Output ~ 0
M0_SENSOR[0..4]
Text HLabel 2850 2500 0    60   Input ~ 0
M3_PHASE[0..2]
Text HLabel 2850 2400 0    60   Input ~ 0
M2_PHASE[0..2]
Text HLabel 2900 2300 0    60   Input ~ 0
M1_PHASE[0..2]
Text HLabel 2850 2200 0    60   Input ~ 0
M0_PHASE[0..2]
$Comp
L CONN_20X2 P2
U 1 1 506E24BA
P 5350 3900
F 0 "P2" H 5350 4950 60  0000 C CNN
F 1 "CONN_20X2" V 5350 3900 50  0000 C CNN
F 4 "H10805-ND" H 5350 3900 60  0001 C CNN "Digi-Key Part"
	1    5350 3900
	1    0    0    -1  
$EndComp
$EndSCHEMATC
