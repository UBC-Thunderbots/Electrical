EESchema Schematic File Version 2  date 2012-05-22T01:11:55 PDT
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
Sheet 17 17
Title ""
Date "22 may 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 4200 4450
Wire Wire Line
	4200 4750 4200 4450
Wire Wire Line
	4800 4750 4700 4750
Wire Wire Line
	5900 4200 5350 4200
Wire Wire Line
	6650 2600 6650 2650
Wire Wire Line
	6350 2850 6000 2850
Wire Wire Line
	5450 4200 5450 3700
Connection ~ 5450 4200
Wire Wire Line
	5450 3700 5500 3700
Wire Wire Line
	4850 4200 4800 4200
Wire Wire Line
	4800 4200 4800 4250
Wire Wire Line
	6200 4450 6200 4400
Wire Wire Line
	3800 2750 4300 2750
Connection ~ 4850 3200
Wire Wire Line
	4600 2500 4600 2550
Connection ~ 4300 3400
Wire Wire Line
	4300 3500 4300 3200
Wire Wire Line
	4300 3400 5000 3400
Wire Wire Line
	3300 3700 3350 3700
Wire Wire Line
	3350 3700 3350 3750
Wire Wire Line
	9350 1950 8900 1950
Wire Wire Line
	9750 2250 9750 2550
Connection ~ 8700 5550
Wire Wire Line
	8750 5650 8700 5650
Wire Wire Line
	8700 5650 8700 5450
Wire Wire Line
	8400 5450 8750 5450
Wire Wire Line
	8750 5750 8750 5850
Wire Wire Line
	8750 5850 8400 5850
Connection ~ 10500 5550
Wire Wire Line
	10250 5550 10500 5550
Wire Wire Line
	9850 3800 10100 3800
Wire Wire Line
	9450 4450 9450 4100
Connection ~ 9000 3800
Wire Wire Line
	9000 3800 9050 3800
Wire Wire Line
	10200 1900 10200 1950
Wire Wire Line
	10200 1950 10150 1950
Connection ~ 9900 3850
Wire Wire Line
	9900 3900 9900 3750
Wire Wire Line
	9900 3900 9850 3900
Connection ~ 9900 3800
Wire Wire Line
	9900 3750 9850 3750
Connection ~ 9300 1950
Wire Wire Line
	8900 2450 8900 2550
Wire Wire Line
	10500 6000 10500 6100
Connection ~ 10100 3800
Connection ~ 9450 4400
Wire Wire Line
	10100 4300 10100 4400
Connection ~ 10100 4400
Wire Wire Line
	10500 5600 10500 5400
Connection ~ 9300 2550
Wire Wire Line
	8900 1950 8900 2050
Wire Wire Line
	9300 2050 9300 1900
Wire Wire Line
	9900 3850 9850 3850
Wire Wire Line
	9000 3750 9000 3850
Wire Wire Line
	10100 4400 9000 4400
Wire Wire Line
	9000 4400 9000 4250
Wire Wire Line
	10100 3750 10100 3900
Wire Wire Line
	10250 5450 10500 5450
Connection ~ 10500 5450
Wire Wire Line
	8600 5850 8600 5900
Connection ~ 8600 5850
Wire Wire Line
	8700 5550 8750 5550
Connection ~ 8700 5450
Wire Wire Line
	8550 5400 8550 5450
Connection ~ 8550 5450
Wire Wire Line
	9300 2600 9300 2450
Wire Wire Line
	8900 2550 9750 2550
Wire Wire Line
	5000 2950 5000 3050
Wire Wire Line
	5000 3050 6000 3050
Wire Wire Line
	6000 3050 6000 3300
Wire Wire Line
	4950 2800 4950 2750
Wire Wire Line
	4950 2750 5000 2750
Wire Wire Line
	4800 3200 5000 3200
Wire Wire Line
	4000 2150 4000 2200
Wire Wire Line
	4000 2700 4000 2750
Connection ~ 4000 2750
Wire Wire Line
	6200 3500 6200 4000
Connection ~ 6200 3500
Wire Wire Line
	3800 4450 4500 4450
Wire Wire Line
	6050 2850 6050 3700
Wire Wire Line
	6050 3700 5900 3700
Connection ~ 6050 2850
Wire Wire Line
	5500 3900 5450 3900
Connection ~ 5450 3900
Connection ~ 4300 3500
Wire Wire Line
	4850 3200 4850 2950
Wire Wire Line
	4850 2950 4600 2950
Wire Wire Line
	6650 3050 6650 3500
Wire Wire Line
	6650 3500 4250 3500
Wire Wire Line
	6000 3900 6200 3900
Connection ~ 6200 3900
Wire Wire Line
	3300 3500 3750 3500
Wire Wire Line
	4800 4800 4800 4650
Connection ~ 4800 4750
$Comp
L R R58
U 1 1 4FB9793E
P 4450 4750
F 0 "R58" V 4530 4750 50  0000 C CNN
F 1 "10kR" V 4450 4750 50  0000 C CNN
	1    4450 4750
	0    1    1    0   
$EndComp
Text Label 3350 3500 0    60   ~ 0
FUSE_IN
Text Label 4400 3500 0    60   ~ 0
FUSE_OUT
$Comp
L MOSFET_P Q27
U 1 1 4F6C23C6
P 6100 4200
F 0 "Q27" H 6100 4390 60  0000 R CNN
F 1 "MOSFET_P" H 6100 4020 60  0000 R CNN
F 4 "IRF9310TRPBFCT-ND" H 6100 4200 60  0001 C CNN "Field1"
	1    6100 4200
	1    0    0    1   
$EndComp
$Comp
L MOSFET_P Q28
U 1 1 4F6C238C
P 6550 2850
F 0 "Q28" H 6550 3040 60  0000 R CNN
F 1 "MOSFET_P" H 6550 2670 60  0000 R CNN
F 2 "SO8E-IRF9310" H 6550 2850 60  0001 C CNN
F 4 "IRF9310TRPBFCT-ND" H 6550 2850 60  0001 C CNN "Field1"
	1    6550 2850
	1    0    0    -1  
$EndComp
$Comp
L MOSFET_N Q14
U 1 1 4F698F29
P 4500 2750
F 0 "Q14" H 4510 2920 60  0000 R CNN
F 1 "MOSFET_N" H 4510 2600 60  0000 R CNN
F 2 "SOT23_3GDS" H 4500 2750 60  0001 C CNN
F 4 "568-5818-1-ND" H 4500 2750 60  0001 C CNN "Field1"
	1    4500 2750
	1    0    0    1   
$EndComp
$Comp
L FUSE F1
U 1 1 4F6971B8
P 4000 3500
F 0 "F1" H 4100 3550 40  0000 C CNN
F 1 "FUSE" H 3900 3450 40  0000 C CNN
F 2 "SM1206" H 4000 3500 60  0001 C CNN
F 4 "mainboard-fuses" H 4000 3500 60  0001 C CNN "Field1"
	1    4000 3500
	1    0    0    -1  
$EndComp
Text Notes 5300 3050 0    60   ~ 0
SP3T PCB Conn
Text Notes 5000 3400 0    60   ~ 0
Off
Text Notes 5000 3200 0    60   ~ 0
On
Text Notes 4950 2650 0    60   ~ 0
Start
Text Notes 6000 2850 0    60   ~ 0
Out
$Comp
L GND #PWR0225
U 1 1 4F6523FD
P 4800 4800
F 0 "#PWR0225" H 4800 4800 30  0001 C CNN
F 1 "GND" H 4800 4730 30  0001 C CNN
	1    4800 4800
	1    0    0    -1  
$EndComp
$Comp
L R R53
U 1 1 4F652290
P 5750 3900
F 0 "R53" V 5830 3900 50  0000 C CNN
F 1 "10kR" V 5750 3900 50  0000 C CNN
	1    5750 3900
	0    1    1    0   
$EndComp
$Comp
L DIODESCH D24
U 1 1 4F651F65
P 5700 3700
F 0 "D24" H 5700 3800 40  0000 C CNN
F 1 "DIODESCH" H 5700 3600 40  0000 C CNN
F 2 "SM0603" H 5700 3700 60  0001 C CNN
F 4 "RB521G-30T2RCT-ND" H 5700 3700 60  0001 C CNN "Field1"
	1    5700 3700
	-1   0    0    1   
$EndComp
Text HLabel 3800 4450 0    60   Input ~ 0
HV_PWR
$Comp
L R R52
U 1 1 4F651EF6
P 5100 4200
F 0 "R52" V 5180 4200 50  0000 C CNN
F 1 "1kR" V 5100 4200 50  0000 C CNN
	1    5100 4200
	0    1    1    0   
$EndComp
$Comp
L +HVBATT #PWR0226
U 1 1 4F651EAC
P 6200 4450
F 0 "#PWR0226" H 6200 4400 20  0001 C CNN
F 1 "+HVBATT" H 6200 4550 30  0000 C CNN
	1    6200 4450
	-1   0    0    1   
$EndComp
Text HLabel 3800 2750 0    60   Input ~ 0
LOGIC_PWR
$Comp
L GND #PWR0227
U 1 1 4F651E66
P 4000 2150
F 0 "#PWR0227" H 4000 2150 30  0001 C CNN
F 1 "GND" H 4000 2080 30  0001 C CNN
	1    4000 2150
	-1   0    0    1   
$EndComp
$Comp
L R R50
U 1 1 4F651E58
P 4000 2450
F 0 "R50" V 4080 2450 50  0000 C CNN
F 1 "10kR" V 4000 2450 50  0000 C CNN
	1    4000 2450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0228
U 1 1 4F651E1D
P 4600 2500
F 0 "#PWR0228" H 4600 2500 30  0001 C CNN
F 1 "GND" H 4600 2430 30  0001 C CNN
	1    4600 2500
	-1   0    0    1   
$EndComp
$Comp
L R R51
U 1 1 4F651D80
P 4550 3200
F 0 "R51" V 4630 3200 50  0000 C CNN
F 1 "10kR" V 4550 3200 50  0000 C CNN
	1    4550 3200
	0    1    1    0   
$EndComp
$Comp
L +BATT #PWR0229
U 1 1 4F651D02
P 6650 2600
F 0 "#PWR0229" H 6650 2550 20  0001 C CNN
F 1 "+BATT" H 6650 2700 30  0000 C CNN
	1    6650 2600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0230
U 1 1 4F6514C0
P 4950 2800
F 0 "#PWR0230" H 4950 2800 30  0001 C CNN
F 1 "GND" H 4950 2730 30  0001 C CNN
	1    4950 2800
	1    0    0    -1  
$EndComp
$Comp
L SP3T SW1
U 1 1 4F651110
P 5500 2850
F 0 "SW1" H 5300 3000 50  0000 C CNN
F 1 "SP3T" H 5350 2300 50  0000 C CNN
F 4 "A27AW-ND" H 5500 2850 60  0001 C CNN "Field1"
	1    5500 2850
	-1   0    0    -1  
$EndComp
$Comp
L MOSFET_N Q15
U 1 1 4F650793
P 4700 4450
F 0 "Q15" H 4710 4620 60  0000 R CNN
F 1 "MOSFET_N" H 4710 4300 60  0000 R CNN
F 2 "SOT23_3GDS" H 4700 4450 60  0001 C CNN
F 4 "568-5818-1-ND" H 4700 4450 60  0001 C CNN "Field1"
	1    4700 4450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0231
U 1 1 4F650264
P 3350 3750
F 0 "#PWR0231" H 3350 3750 30  0001 C CNN
F 1 "GND" H 3350 3680 30  0001 C CNN
	1    3350 3750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0232
U 1 1 4F644CB3
P 10500 6100
F 0 "#PWR0232" H 10500 6100 30  0001 C CNN
F 1 "GND" H 10500 6030 30  0001 C CNN
	1    10500 6100
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR0233
U 1 1 4F644CAC
P 8550 5400
F 0 "#PWR0233" H 8550 5490 20  0001 C CNN
F 1 "+5V" H 8550 5490 30  0000 C CNN
	1    8550 5400
	1    0    0    -1  
$EndComp
$Comp
L C C48
U 1 1 4F644C94
P 8400 5650
F 0 "C48" H 8450 5750 50  0000 L CNN
F 1 "1uF" H 8450 5550 50  0000 L CNN
	1    8400 5650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0234
U 1 1 4F644C87
P 8600 5900
F 0 "#PWR0234" H 8600 5900 30  0001 C CNN
F 1 "GND" H 8600 5830 30  0001 C CNN
	1    8600 5900
	1    0    0    -1  
$EndComp
NoConn ~ 10250 5750
NoConn ~ 10250 5650
$Comp
L MCP1726 U10
U 1 1 4F644C5E
P 9500 5600
F 0 "U10" H 9500 5550 60  0000 C CNN
F 1 "MCP1726" H 9500 5650 60  0000 C CNN
F 2 "SO8N" H 9400 5450 60  0001 C CNN
F 4 "MCP1726-1202E/SN-ND" H 9500 5600 60  0001 C CNN "Field1"
	1    9500 5600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0235
U 1 1 4F644C3B
P 9450 4450
F 0 "#PWR0235" H 9450 4450 30  0001 C CNN
F 1 "GND" H 9450 4380 30  0001 C CNN
	1    9450 4450
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR0236
U 1 1 4F644C30
P 9000 3750
F 0 "#PWR0236" H 9000 3840 20  0001 C CNN
F 1 "+5V" H 9000 3840 30  0000 C CNN
	1    9000 3750
	1    0    0    -1  
$EndComp
$Comp
L LD1117D33 U9
U 1 1 4F643E3C
P 9450 3850
F 0 "U9" H 9600 3654 60  0000 C CNN
F 1 "LD1117D33" H 9450 4050 60  0000 C CNN
F 2 "SO8E" H 9450 3550 60  0001 C CNN
F 4 "497-7306-1-ND" H 9450 3850 60  0001 C CNN "Field1"
	1    9450 3850
	1    0    0    -1  
$EndComp
$Comp
L 7805 U11
U 1 1 4F6438FB
P 9750 2000
F 0 "U11" H 9900 1804 60  0000 C CNN
F 1 "7805" H 9750 2200 60  0000 C CNN
F 2 "LM78XX_VERT" H 9750 2000 60  0001 C CNN
F 4 "811-2196-5-ND" H 9750 2000 60  0001 C CNN "Field1"
	1    9750 2000
	1    0    0    -1  
$EndComp
$Comp
L C C21
U 1 1 4CC4781A
P 8900 2250
F 0 "C21" H 8950 2350 50  0000 L CNN
F 1 "10uF" H 8950 2150 50  0000 L CNN
F 4 "" H 8900 2250 60  0001 C CNN "Digikey Part"
	1    8900 2250
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P7
U 1 1 4CC474AD
P 2950 3600
F 0 "P7" V 2900 3600 40  0000 C CNN
F 1 "CONN_2" V 3000 3600 40  0000 C CNN
F 4 "battery-inlet" H 2950 3600 60  0001 C CNN "Field1"
	1    2950 3600
	-1   0    0    -1  
$EndComp
$Comp
L CP C14
U 1 1 4ABF00CA
P 9300 2250
F 0 "C14" H 9350 2350 50  0000 L CNN
F 1 "100uF" H 9350 2150 50  0000 L CNN
F 2 "C1.8V8V" H 9300 2250 60  0001 C CNN
	1    9300 2250
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 4ABE8225
P 10500 5800
F 0 "C5" H 10550 5900 50  0000 L CNN
F 1 "1uF" H 10550 5700 50  0000 L CNN
F 4 "" H 10500 5800 60  0001 C CNN "Digikey Part"
	1    10500 5800
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 4ABE8044
P 10100 4100
F 0 "C3" H 10150 4200 50  0000 L CNN
F 1 "10uF" H 10150 4000 50  0000 L CNN
F 4 "" H 10100 4100 60  0001 C CNN "Digikey Part"
	1    10100 4100
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR0237
U 1 1 4CC361C8
P 10100 3750
F 0 "#PWR0237" H 10100 3710 30  0001 C CNN
F 1 "+3.3V" H 10100 3860 30  0000 C CNN
	1    10100 3750
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR0238
U 1 1 4ADACEE2
P 10200 1900
F 0 "#PWR0238" H 10200 1990 20  0001 C CNN
F 1 "+5V" H 10200 1990 30  0000 C CNN
	1    10200 1900
	1    0    0    -1  
$EndComp
$Comp
L +1.2V #PWR0239
U 1 1 4ABE8237
P 10500 5400
F 0 "#PWR0239" H 10500 5540 20  0001 C CNN
F 1 "+1.2V" H 10500 5510 30  0000 C CNN
	1    10500 5400
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 4ABE8019
P 9000 4050
F 0 "C1" H 9050 4150 50  0000 L CNN
F 1 "100nF" H 9050 3950 50  0000 L CNN
	1    9000 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR0240
U 1 1 4ABE7E4F
P 9300 2600
F 0 "#PWR0240" H 9300 2600 30  0001 C CNN
F 1 "GND" H 9300 2530 30  0001 C CNN
	1    9300 2600
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR0241
U 1 1 4ABE7E3F
P 9300 1900
F 0 "#PWR0241" H 9300 1850 20  0001 C CNN
F 1 "+BATT" H 9300 2000 30  0000 C CNN
	1    9300 1900
	1    0    0    -1  
$EndComp
$EndSCHEMATC
