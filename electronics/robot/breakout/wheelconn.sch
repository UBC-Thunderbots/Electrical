EESchema Schematic File Version 2  date 2012-10-17T23:39:22 PDT
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
LIBS:breakout-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 5 5
Title ""
Date "18 oct 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	6550 3550 6550 3200
Wire Wire Line
	6550 3550 6050 3550
Connection ~ 6550 3000
Wire Wire Line
	6550 2900 6550 3000
Connection ~ 6700 3200
Wire Wire Line
	6700 2900 6700 3200
Wire Wire Line
	6250 2900 6250 2950
Wire Wire Line
	6250 2950 6350 2950
Connection ~ 6350 4050
Wire Wire Line
	6350 2950 6350 4050
Wire Wire Line
	6100 2900 6100 3000
Wire Wire Line
	7450 3500 7500 3500
Wire Wire Line
	4850 3150 4850 3200
Connection ~ 6850 2350
Wire Wire Line
	6850 2300 6850 2350
Connection ~ 6550 2350
Wire Wire Line
	6550 2400 6550 2350
Connection ~ 6250 2350
Wire Wire Line
	6250 2400 6250 2350
Connection ~ 6400 4150
Wire Wire Line
	6400 2900 6400 4150
Wire Wire Line
	6900 3000 6450 3000
Connection ~ 6850 3850
Wire Bus Line
	3950 3850 3950 3550
Wire Wire Line
	5300 4400 5300 4350
Wire Wire Line
	4050 3850 4550 3850
Wire Wire Line
	4550 3550 4050 3550
Wire Wire Line
	6100 3650 6050 3650
Wire Wire Line
	6850 3100 6900 3100
Wire Wire Line
	6250 4600 6900 4600
Wire Bus Line
	6150 4500 6150 5100
Wire Bus Line
	6150 5100 5900 5100
Connection ~ 6900 4600
Wire Wire Line
	6900 4850 6900 4750
Wire Wire Line
	6900 4450 6900 4350
Wire Wire Line
	6850 4250 6900 4250
Wire Wire Line
	6900 4650 6900 4550
Connection ~ 6900 4800
Connection ~ 6900 4400
Wire Wire Line
	6250 4400 6900 4400
Wire Wire Line
	6250 4800 6900 4800
Wire Wire Line
	4550 3450 4050 3450
Wire Wire Line
	4550 3750 4050 3750
Wire Wire Line
	4550 3950 4050 3950
Wire Bus Line
	3800 3650 3950 3650
Wire Wire Line
	6050 3950 6050 4150
Wire Wire Line
	5300 3000 5300 3050
Wire Wire Line
	6900 3850 6800 3850
Wire Wire Line
	6550 3200 6900 3200
Wire Wire Line
	6100 2400 6100 2350
Wire Wire Line
	6100 2350 6900 2350
Wire Wire Line
	6900 2350 6900 2900
Wire Wire Line
	6400 2400 6400 2350
Connection ~ 6400 2350
Wire Wire Line
	6700 2400 6700 2350
Connection ~ 6700 2350
Wire Wire Line
	4850 2700 4850 2750
Wire Wire Line
	6850 3850 6850 3500
Wire Wire Line
	6850 3500 7050 3500
Wire Wire Line
	6050 4150 6900 4150
Wire Wire Line
	6900 3950 6250 3950
Wire Wire Line
	6900 4050 6150 4050
Wire Wire Line
	6150 4050 6150 3850
Wire Wire Line
	6150 3850 6050 3850
Wire Wire Line
	6300 3950 6300 3000
Wire Wire Line
	6300 3000 6100 3000
Connection ~ 6300 3950
Wire Wire Line
	6250 3950 6250 3750
Wire Wire Line
	6250 3750 6050 3750
Wire Wire Line
	6450 3000 6450 3450
Wire Wire Line
	6450 3450 6050 3450
$Comp
L +3.3V #PWR032
U 1 1 5079B678
P 4850 2700
AR Path="/5065530C/5079B678" Ref="#PWR032"  Part="1" 
AR Path="/5065526E/5079B678" Ref="#PWR022"  Part="1" 
AR Path="/506552F4/5079B678" Ref="#PWR012"  Part="1" 
AR Path="/50655305/5079B678" Ref="#PWR042"  Part="1" 
F 0 "#PWR042" H 4850 2660 30  0001 C CNN
F 1 "+3.3V" H 4850 2810 30  0000 C CNN
	1    4850 2700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR033
U 1 1 506555D4
P 4850 3200
AR Path="/5065530C/506555D4" Ref="#PWR033"  Part="1" 
AR Path="/5065526E/506555D4" Ref="#PWR023"  Part="1" 
AR Path="/506552F4/506555D4" Ref="#PWR013"  Part="1" 
AR Path="/50655305/506555D4" Ref="#PWR043"  Part="1" 
F 0 "#PWR043" H 4850 3200 30  0001 C CNN
F 1 "GND" H 4850 3130 30  0001 C CNN
	1    4850 3200
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 506555D3
P 4850 2950
AR Path="/5065530C/506555D3" Ref="C5"  Part="1" 
AR Path="/5065526E/506555D3" Ref="C6"  Part="1" 
AR Path="/506552F4/506555D3" Ref="C7"  Part="1" 
AR Path="/50655305/506555D3" Ref="C8"  Part="1" 
F 0 "C8" H 4900 3050 50  0000 L CNN
F 1 "100nF" H 4900 2850 50  0000 L CNN
	1    4850 2950
	1    0    0    -1  
$EndComp
$Comp
L 10KR7 R1
U 5 1 4FB9E1A3
P 6100 2650
AR Path="/5065530C/4FB9E1A3" Ref="R1"  Part="5" 
AR Path="/50655305/4FB9E1A3" Ref="R4"  Part="5" 
AR Path="/506552F4/4FB9E1A3" Ref="R3"  Part="5" 
AR Path="/5065526E/4FB9E1A3" Ref="R2"  Part="5" 
F 0 "R4" V 6180 2650 50  0000 C CNN
F 1 "10KR7" V 6100 2650 50  0000 C CNN
F 4 "SOMC10KCCT-ND" H 6100 2650 60  0001 C CNN "Field1"
	5    6100 2650
	1    0    0    -1  
$EndComp
$Comp
L 10KR7 R1
U 6 1 4FB9E1A0
P 6250 2650
AR Path="/5065530C/4FB9E1A0" Ref="R1"  Part="6" 
AR Path="/50655305/4FB9E1A0" Ref="R4"  Part="6" 
AR Path="/506552F4/4FB9E1A0" Ref="R3"  Part="6" 
AR Path="/5065526E/4FB9E1A0" Ref="R2"  Part="6" 
F 0 "R4" V 6330 2650 50  0000 C CNN
F 1 "10KR7" V 6250 2650 50  0000 C CNN
F 4 "SOMC10KCCT-ND" H 6250 2650 60  0001 C CNN "Field1"
	6    6250 2650
	1    0    0    -1  
$EndComp
$Comp
L 10KR7 R1
U 4 1 4FB9E19A
P 6700 2650
AR Path="/5065530C/4FB9E19A" Ref="R1"  Part="4" 
AR Path="/50655305/4FB9E19A" Ref="R4"  Part="4" 
AR Path="/506552F4/4FB9E19A" Ref="R3"  Part="4" 
AR Path="/5065526E/4FB9E19A" Ref="R2"  Part="4" 
F 0 "R4" V 6780 2650 50  0000 C CNN
F 1 "10KR7" V 6700 2650 50  0000 C CNN
F 4 "SOMC10KCCT-ND" H 6700 2650 60  0001 C CNN "Field1"
	4    6700 2650
	1    0    0    -1  
$EndComp
$Comp
L 10KR7 R1
U 3 1 4FB9E197
P 6550 2650
AR Path="/5065530C/4FB9E197" Ref="R1"  Part="3" 
AR Path="/50655305/4FB9E197" Ref="R4"  Part="3" 
AR Path="/506552F4/4FB9E197" Ref="R3"  Part="3" 
AR Path="/5065526E/4FB9E197" Ref="R2"  Part="3" 
F 0 "R4" V 6630 2650 50  0000 C CNN
F 1 "10KR7" V 6550 2650 50  0000 C CNN
F 4 "SOMC10KCCT-ND" H 6550 2650 60  0001 C CNN "Field1"
	3    6550 2650
	1    0    0    -1  
$EndComp
$Comp
L 10KR7 R1
U 7 1 4FB9E193
P 6400 2650
AR Path="/5065530C/4FB9E193" Ref="R1"  Part="7" 
AR Path="/50655305/4FB9E193" Ref="R4"  Part="7" 
AR Path="/506552F4/4FB9E193" Ref="R3"  Part="7" 
AR Path="/5065526E/4FB9E193" Ref="R2"  Part="7" 
F 0 "R4" V 6480 2650 50  0000 C CNN
F 1 "10KR7" V 6400 2650 50  0000 C CNN
F 4 "SOMC10KCCT-ND" H 6400 2650 60  0001 C CNN "Field1"
	7    6400 2650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR034
U 1 1 4F69823B
P 7500 3500
AR Path="/5065530C/4F69823B" Ref="#PWR034"  Part="1" 
AR Path="/50655305/4F69823B" Ref="#PWR044"  Part="1" 
AR Path="/506552F4/4F69823B" Ref="#PWR014"  Part="1" 
AR Path="/5065526E/4F69823B" Ref="#PWR024"  Part="1" 
F 0 "#PWR044" H 7500 3500 30  0001 C CNN
F 1 "GND" H 7500 3430 30  0001 C CNN
	1    7500 3500
	0    -1   -1   0   
$EndComp
$Comp
L C C1
U 1 1 4F698233
P 7250 3500
AR Path="/5065530C/4F698233" Ref="C1"  Part="1" 
AR Path="/50655305/4F698233" Ref="C4"  Part="1" 
AR Path="/506552F4/4F698233" Ref="C3"  Part="1" 
AR Path="/5065526E/4F698233" Ref="C2"  Part="1" 
F 0 "C4" H 7300 3600 50  0000 L CNN
F 1 "100nF" H 7300 3400 50  0000 L CNN
	1    7250 3500
	0    1    1    0   
$EndComp
NoConn ~ 4550 3650
$Comp
L +3.3V #PWR035
U 1 1 4F64543E
P 5300 3000
AR Path="/5065530C/4F64543E" Ref="#PWR035"  Part="1" 
AR Path="/50655305/4F64543E" Ref="#PWR045"  Part="1" 
AR Path="/506552F4/4F64543E" Ref="#PWR015"  Part="1" 
AR Path="/5065526E/4F64543E" Ref="#PWR025"  Part="1" 
F 0 "#PWR045" H 5300 2960 30  0001 C CNN
F 1 "+3.3V" H 5300 3110 30  0000 C CNN
	1    5300 3000
	1    0    0    -1  
$EndComp
$Comp
L 74HC4050 U1
U 1 1 4F64540F
P 5300 3700
AR Path="/5065530C/4F64540F" Ref="U1"  Part="1" 
AR Path="/50655305/4F64540F" Ref="U4"  Part="1" 
AR Path="/506552F4/4F64540F" Ref="U3"  Part="1" 
AR Path="/5065526E/4F64540F" Ref="U2"  Part="1" 
F 0 "U4" H 5300 3650 60  0000 C CNN
F 1 "74HC4050" H 5300 3750 60  0000 C CNN
F 2 "SO16N" H 5200 3550 60  0001 C CNN
F 4 "568-8150-1-ND" H 5300 3700 60  0001 C CNN "Field1"
	1    5300 3700
	-1   0    0    -1  
$EndComp
Entry Wire Line
	3950 3650 4050 3550
Entry Wire Line
	3950 3550 4050 3450
Entry Wire Line
	3950 3850 4050 3950
Entry Wire Line
	3950 3750 4050 3850
Entry Wire Line
	3950 3650 4050 3750
$Comp
L GND #PWR036
U 1 1 4F62AFE9
P 6100 3650
AR Path="/5065530C/4F62AFE9" Ref="#PWR036"  Part="1" 
AR Path="/50655305/4F62AFE9" Ref="#PWR046"  Part="1" 
AR Path="/506552F4/4F62AFE9" Ref="#PWR016"  Part="1" 
AR Path="/5065526E/4F62AFE9" Ref="#PWR026"  Part="1" 
F 0 "#PWR046" H 6100 3650 30  0001 C CNN
F 1 "GND" H 6100 3580 30  0001 C CNN
	1    6100 3650
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR037
U 1 1 4F62AF30
P 5300 4400
AR Path="/5065530C/4F62AF30" Ref="#PWR037"  Part="1" 
AR Path="/50655305/4F62AF30" Ref="#PWR047"  Part="1" 
AR Path="/506552F4/4F62AF30" Ref="#PWR017"  Part="1" 
AR Path="/5065526E/4F62AF30" Ref="#PWR027"  Part="1" 
F 0 "#PWR047" H 5300 4400 30  0001 C CNN
F 1 "GND" H 5300 4330 30  0001 C CNN
	1    5300 4400
	1    0    0    -1  
$EndComp
Text Label 4500 3550 2    60   ~ 0
SENSOR4
Text Label 4500 3450 2    60   ~ 0
SENSOR3
$Comp
L GND #PWR038
U 1 1 4F6292C5
P 6850 3100
AR Path="/5065530C/4F6292C5" Ref="#PWR038"  Part="1" 
AR Path="/50655305/4F6292C5" Ref="#PWR048"  Part="1" 
AR Path="/506552F4/4F6292C5" Ref="#PWR018"  Part="1" 
AR Path="/5065526E/4F6292C5" Ref="#PWR028"  Part="1" 
F 0 "#PWR048" H 6850 3100 30  0001 C CNN
F 1 "GND" H 6850 3030 30  0001 C CNN
	1    6850 3100
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR039
U 1 1 4F6292C2
P 6850 2300
AR Path="/5065530C/4F6292C2" Ref="#PWR039"  Part="1" 
AR Path="/50655305/4F6292C2" Ref="#PWR049"  Part="1" 
AR Path="/506552F4/4F6292C2" Ref="#PWR019"  Part="1" 
AR Path="/5065526E/4F6292C2" Ref="#PWR029"  Part="1" 
F 0 "#PWR049" H 6850 2390 20  0001 C CNN
F 1 "+5V" H 6850 2390 30  0000 C CNN
	1    6850 2300
	1    0    0    -1  
$EndComp
$Comp
L CONN_4 P1
U 1 1 4F6292AE
P 7250 3050
AR Path="/5065530C/4F6292AE" Ref="P1"  Part="1" 
AR Path="/50655305/4F6292AE" Ref="P4"  Part="1" 
AR Path="/506552F4/4F6292AE" Ref="P3"  Part="1" 
AR Path="/5065526E/4F6292AE" Ref="P2"  Part="1" 
F 0 "P4" V 7200 3050 50  0000 C CNN
F 1 "CONN_4" V 7300 3050 50  0000 C CNN
F 2 "53048-0410" H 7250 3050 60  0001 C CNN
F 4 "WM1744-ND" H 7250 3050 60  0001 C CNN "Field1"
	1    7250 3050
	1    0    0    -1  
$EndComp
Entry Wire Line
	6150 4900 6250 4800
Entry Wire Line
	6150 4700 6250 4600
Entry Wire Line
	6150 4500 6250 4400
Text Label 4500 3750 2    60   ~ 0
SENSOR2
Text Label 4500 3950 2    60   ~ 0
SENSOR1
Text Label 4500 3850 2    60   ~ 0
SENSOR0
Text HLabel 3800 3650 0    60   Output ~ 0
SENSOR[0..4]
Text Label 6300 4400 0    60   ~ 0
PHASE2
Text Label 6300 4600 0    60   ~ 0
PHASE1
Text Label 6300 4800 0    60   ~ 0
PHASE0
Text HLabel 5900 5100 0    60   Input ~ 0
PHASE[0..2]
$Comp
L GND #PWR040
U 1 1 4CD730A5
P 6850 4250
AR Path="/5065530C/4CD730A5" Ref="#PWR040"  Part="1" 
AR Path="/50655305/4CD730A5" Ref="#PWR050"  Part="1" 
AR Path="/506552F4/4CD730A5" Ref="#PWR020"  Part="1" 
AR Path="/5065526E/4CD730A5" Ref="#PWR030"  Part="1" 
F 0 "#PWR050" H 6850 4250 30  0001 C CNN
F 1 "GND" H 6850 4180 30  0001 C CNN
	1    6850 4250
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR041
U 1 1 4CD73087
P 6800 3850
AR Path="/5065530C/4CD73087" Ref="#PWR041"  Part="1" 
AR Path="/50655305/4CD73087" Ref="#PWR051"  Part="1" 
AR Path="/506552F4/4CD73087" Ref="#PWR021"  Part="1" 
AR Path="/5065526E/4CD73087" Ref="#PWR031"  Part="1" 
F 0 "#PWR051" H 6800 3940 20  0001 C CNN
F 1 "+5V" H 6800 3940 30  0000 C CNN
	1    6800 3850
	0    -1   -1   0   
$EndComp
$Comp
L CONN_11 P5
U 1 1 4CD73060
P 7250 4350
AR Path="/5065530C/4CD73060" Ref="P5"  Part="1" 
AR Path="/50655305/4CD73060" Ref="P8"  Part="1" 
AR Path="/506552F4/4CD73060" Ref="P7"  Part="1" 
AR Path="/5065526E/4CD73060" Ref="P6"  Part="1" 
F 0 "P8" V 7200 4350 60  0000 C CNN
F 1 "CONN_11" V 7300 4350 60  0000 C CNN
F 2 "FH12-11S-1SH" H 7250 4350 60  0001 C CNN
F 4 "HFB111CT-ND" H 7250 4350 60  0001 C CNN "Field1"
	1    7250 4350
	1    0    0    -1  
$EndComp
$EndSCHEMATC
