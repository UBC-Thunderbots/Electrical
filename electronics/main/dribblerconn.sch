EESchema Schematic File Version 2  date 2012-02-12T19:59:28 PST
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
Sheet 3 17
Title ""
Date "13 feb 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Bus Line
	4800 4100 4800 4400
Wire Bus Line
	4800 4400 4700 4400
Wire Wire Line
	4900 4200 5400 4200
Wire Wire Line
	4900 4100 5400 4100
Wire Wire Line
	4900 4000 5400 4000
Wire Wire Line
	5400 3800 5350 3800
Wire Wire Line
	5350 3900 5400 3900
Wire Wire Line
	4900 3500 5400 3500
Wire Wire Line
	4900 3600 5400 3600
Wire Wire Line
	4900 3700 5400 3700
Wire Bus Line
	4700 3300 4800 3300
Wire Bus Line
	4800 3300 4800 3600
Text HLabel 4700 3300 0    60   Input ~ 0
PHASE[0..2]
Text HLabel 4700 4400 0    60   Output ~ 0
HALL[0..2]
Entry Wire Line
	4800 4300 4900 4200
Entry Wire Line
	4800 4200 4900 4100
Entry Wire Line
	4800 4100 4900 4000
Entry Wire Line
	4800 3600 4900 3700
Entry Wire Line
	4800 3500 4900 3600
Entry Wire Line
	4800 3400 4900 3500
$Comp
L GND #PWR032
U 1 1 4CD7321A
P 5350 3900
F 0 "#PWR032" H 5350 3900 30  0001 C CNN
F 1 "GND" H 5350 3830 30  0001 C CNN
	1    5350 3900
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR033
U 1 1 4CD73217
P 5350 3800
F 0 "#PWR033" H 5350 3890 20  0001 C CNN
F 1 "+5V" H 5350 3890 30  0000 C CNN
	1    5350 3800
	0    -1   -1   0   
$EndComp
Text Label 4900 4200 0    60   ~ 0
HALL2
Text Label 4900 4100 0    60   ~ 0
HALL1
Text Label 4900 4000 0    60   ~ 0
HALL0
Text Label 4900 3700 0    60   ~ 0
PHASE2
Text Label 4900 3600 0    60   ~ 0
PHASE1
Text Label 4900 3500 0    60   ~ 0
PHASE0
$Comp
L CONN_8 P14
U 1 1 4CD731E0
P 5750 3850
F 0 "P14" V 5700 3850 60  0000 C CNN
F 1 "CONN_8" V 5800 3850 60  0000 C CNN
F 2 "DRIBBLERCONN" H 5750 3850 60  0001 C CNN
F 4 "dribbler-header" H 5750 3850 60  0001 C CNN "Field1"
	1    5750 3850
	1    0    0    -1  
$EndComp
$EndSCHEMATC
