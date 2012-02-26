EESchema Schematic File Version 2  date 26/02/2012 3:41:51 PM
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
LIBS:breakbeam-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "26 feb 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 5050 2750 0    60   ~ 0
GND
Text Label 5050 2550 0    60   ~ 0
3.3v
Wire Wire Line
	4200 3050 4200 3250
Wire Wire Line
	5000 2550 4200 2550
Wire Wire Line
	5000 2750 5000 3700
Wire Wire Line
	5000 3700 4200 3700
Wire Wire Line
	4200 3700 4200 3650
$Comp
L CONN_2 P1
U 1 1 4F4A9B88
P 5350 2650
F 0 "P1" V 5300 2650 40  0000 C CNN
F 1 "CONN_2" V 5400 2650 40  0000 C CNN
	1    5350 2650
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4F4A9331
P 4200 2800
F 0 "R1" V 4280 2800 50  0000 C CNN
F 1 "16.5" V 4200 2800 50  0000 C CNN
	1    4200 2800
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 4F4A8D52
P 4200 3450
F 0 "D1" H 4200 3550 50  0000 C CNN
F 1 "VSMY2850RG" H 4200 3350 50  0000 C CNN
F 3 "VSMY2850RG" H 4200 3450 60  0000 C CNN
	1    4200 3450
	0    1    1    0   
$EndComp
$EndSCHEMATC
