EESchema Schematic File Version 2  date 2012-03-15T00:18:53 PDT
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
Sheet 7 17
Title ""
Date "15 mar 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Bus Line
	5950 3250 5950 2750
Wire Bus Line
	5950 2750 5800 2750
Wire Wire Line
	6500 3250 6050 3250
Connection ~ 6500 3600
Wire Wire Line
	6500 3600 6050 3600
Connection ~ 6500 4000
Wire Wire Line
	6500 4000 6050 4000
Wire Wire Line
	6500 3750 6500 3850
Wire Bus Line
	5950 3700 5950 4300
Wire Bus Line
	5950 4300 5800 4300
Wire Wire Line
	6450 3050 6500 3050
Wire Wire Line
	6450 3450 6500 3450
Wire Wire Line
	6500 3550 6500 3650
Wire Wire Line
	6500 3950 6500 4050
Wire Wire Line
	6050 3800 6500 3800
Connection ~ 6500 3800
Wire Wire Line
	6050 3350 6500 3350
Wire Wire Line
	6050 3150 6500 3150
Entry Wire Line
	5950 3250 6050 3350
Entry Wire Line
	5950 3150 6050 3250
Entry Wire Line
	5950 3050 6050 3150
Text Label 6050 3150 0    60   ~ 0
HALL2
Text Label 6050 3350 0    60   ~ 0
HALL1
Text Label 6050 3250 0    60   ~ 0
HALL0
Text HLabel 5800 2750 0    60   Output ~ 0
HALL[0..2]
Entry Wire Line
	5950 3700 6050 3600
Entry Wire Line
	5950 3900 6050 3800
Entry Wire Line
	5950 4100 6050 4000
Text Label 6050 3600 0    60   ~ 0
PHASE2
Text Label 6050 3800 0    60   ~ 0
PHASE1
Text Label 6050 4000 0    60   ~ 0
PHASE0
Text HLabel 5800 4300 0    60   Input ~ 0
PHASE[0..2]
$Comp
L GND #PWR040
U 1 1 4CD730A5
P 6450 3450
AR Path="/4CD73053/4CD730A5" Ref="#PWR040"  Part="1" 
AR Path="/4CD73188/4CD730A5" Ref="#PWR034"  Part="1" 
AR Path="/4CD7317F/4CD730A5" Ref="#PWR036"  Part="1" 
AR Path="/4CD73172/4CD730A5" Ref="#PWR038"  Part="1" 
F 0 "#PWR040" H 6450 3450 30  0001 C CNN
F 1 "GND" H 6450 3380 30  0001 C CNN
	1    6450 3450
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR041
U 1 1 4CD73087
P 6450 3050
AR Path="/4CD73053/4CD73087" Ref="#PWR041"  Part="1" 
AR Path="/4CD73188/4CD73087" Ref="#PWR035"  Part="1" 
AR Path="/4CD7317F/4CD73087" Ref="#PWR037"  Part="1" 
AR Path="/4CD73172/4CD73087" Ref="#PWR039"  Part="1" 
F 0 "#PWR041" H 6450 3140 20  0001 C CNN
F 1 "+5V" H 6450 3140 30  0000 C CNN
	1    6450 3050
	0    -1   -1   0   
$EndComp
$Comp
L CONN_11 P10
U 1 1 4CD73060
P 6850 3550
AR Path="/4CD73053/4CD73060" Ref="P10"  Part="1" 
AR Path="/4CD73188/4CD73060" Ref="P11"  Part="1" 
AR Path="/4CD7317F/4CD73060" Ref="P12"  Part="1" 
AR Path="/4CD73172/4CD73060" Ref="P13"  Part="1" 
F 0 "P10" V 6800 3550 60  0000 C CNN
F 1 "CONN_11" V 6900 3550 60  0000 C CNN
F 2 "FPC" H 6850 3550 60  0001 C CNN
F 4 "WM7971CT-ND" H 6850 3550 60  0001 C CNN "Field1"
	1    6850 3550
	1    0    0    -1  
$EndComp
$EndSCHEMATC
