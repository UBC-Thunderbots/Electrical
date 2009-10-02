EESchema Schematic File Version 1
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,./fpga-prototype.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 3 7
Title ""
Date "2 oct 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Kmarq B 9700 4100 "Warning Pin power_in not driven (Net 82)" F=1
Kmarq B 9400 1950 "Warning: Pin power_out connected to Pin BiDi (net 24)" F=1
Wire Wire Line
	2550 1400 2200 1400
Wire Wire Line
	9150 1950 9400 1950
Wire Wire Line
	10150 1800 10400 1800
Connection ~ 9800 4300
Wire Wire Line
	9800 4300 9800 3750
Wire Wire Line
	9800 3750 9850 3750
Wire Wire Line
	5200 5150 5450 5150
Wire Wire Line
	6350 5250 6350 5150
Wire Wire Line
	6350 5150 6250 5150
Wire Wire Line
	4950 5050 5450 5050
Wire Wire Line
	4950 4950 5450 4950
Wire Wire Line
	4950 4850 5450 4850
Wire Wire Line
	4950 4750 5450 4750
Wire Wire Line
	4950 4650 5450 4650
Wire Wire Line
	4950 4550 5450 4550
Wire Wire Line
	4950 4450 5450 4450
Wire Wire Line
	4950 4350 5450 4350
Wire Wire Line
	4950 4250 5450 4250
Wire Wire Line
	4950 4150 5450 4150
Wire Wire Line
	4950 4050 5450 4050
Wire Wire Line
	4950 3950 5450 3950
Wire Wire Line
	4950 3850 5450 3850
Wire Wire Line
	4950 3750 5450 3750
Wire Wire Line
	4950 3650 5450 3650
Wire Wire Line
	4950 3550 5450 3550
Wire Wire Line
	4950 3450 5450 3450
Wire Wire Line
	4950 3350 5450 3350
Wire Wire Line
	5600 1700 5950 1700
Wire Wire Line
	5600 1500 5950 1500
Wire Wire Line
	5600 1300 5950 1300
Wire Wire Line
	9850 4100 9700 4100
Wire Bus Line
	4850 5550 4850 3350
Wire Wire Line
	2050 3550 2550 3550
Wire Wire Line
	2050 3650 2550 3650
Wire Wire Line
	2050 3750 2550 3750
Wire Wire Line
	2050 3850 2550 3850
Wire Wire Line
	2050 3950 2550 3950
Wire Wire Line
	2050 4050 2550 4050
Wire Wire Line
	2050 4150 2550 4150
Wire Wire Line
	2050 4250 2550 4250
Wire Wire Line
	2050 4350 2550 4350
Wire Wire Line
	2050 4450 2550 4450
Wire Wire Line
	2050 4550 2550 4550
Wire Wire Line
	2050 4650 2550 4650
Wire Wire Line
	2050 4750 2550 4750
Wire Bus Line
	1650 5050 1950 5050
Wire Bus Line
	1950 5050 1950 3650
Wire Bus Line
	4600 5550 6900 5550
Wire Bus Line
	6900 5550 6900 3350
Wire Wire Line
	9700 4300 9850 4300
Wire Wire Line
	5950 1400 5600 1400
Wire Wire Line
	5950 1600 5600 1600
Wire Wire Line
	4950 3250 5450 3250
Wire Wire Line
	6250 3250 6800 3250
Wire Wire Line
	6250 3350 6800 3350
Wire Wire Line
	6250 3450 6800 3450
Wire Wire Line
	6250 3550 6800 3550
Wire Wire Line
	6250 3650 6800 3650
Wire Wire Line
	6250 3750 6800 3750
Wire Wire Line
	6250 3850 6800 3850
Wire Wire Line
	6250 3950 6800 3950
Wire Wire Line
	6250 4050 6800 4050
Wire Wire Line
	6250 4150 6800 4150
Wire Wire Line
	6250 4250 6800 4250
Wire Wire Line
	6250 4350 6800 4350
Wire Wire Line
	6250 4450 6800 4450
Wire Wire Line
	6250 4550 6800 4550
Wire Wire Line
	6250 4650 6800 4650
Wire Wire Line
	6250 4750 6800 4750
Wire Wire Line
	6250 4850 6800 4850
Wire Wire Line
	6250 4950 6800 4950
Wire Wire Line
	6250 5050 6800 5050
Wire Wire Line
	2450 5100 2450 4950
Wire Wire Line
	2450 4950 2550 4950
Wire Wire Line
	2550 4850 2250 4850
Wire Wire Line
	9850 3550 9700 3550
Wire Wire Line
	9700 3550 9700 4100
Wire Wire Line
	10400 1950 10150 1950
Wire Wire Line
	2450 1750 2450 1600
Wire Wire Line
	2450 1600 2550 1600
Text GLabel 2200 1400 0    60   BiDi
MISC
$Comp
L GND #PWR015
U 1 1 4AC57812
P 2450 1750
F 0 "#PWR015" H 2450 1750 30  0001 C C
F 1 "GND" H 2450 1680 30  0001 C C
	1    2450 1750
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P6
U 1 1 4AC5780B
P 2900 1500
F 0 "P6" V 2850 1500 40  0000 C C
F 1 "CONN_2" V 2950 1500 40  0000 C C
	1    2900 1500
	1    0    0    -1  
$EndComp
Text GLabel 10400 1950 2    60   BiDi
USBD-
Text GLabel 10400 1800 2    60   BiDi
USBD+
NoConn ~ 10150 2050
NoConn ~ 9400 2050
NoConn ~ 9400 1800
$Comp
L GND #PWR016
U 1 1 4AC56AA4
P 9150 1950
F 0 "#PWR016" H 9150 1950 30  0001 C C
F 1 "GND" H 9150 1880 30  0001 C C
	1    9150 1950
	0    1    1    0   
$EndComp
$Comp
L USB J1
U 1 1 4AC56A9A
P 9800 1600
F 0 "J1" H 9750 2000 60  0000 C C
F 1 "USB" V 9550 1750 60  0000 C C
	1    9800 1600
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P5
U 1 1 4AC543BE
P 10200 3650
F 0 "P5" V 10150 3650 40  0000 C C
F 1 "CONN_2" V 10250 3650 40  0000 C C
	1    10200 3650
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR017
U 1 1 4AC0506E
P 2250 4850
F 0 "#PWR017" H 2250 4950 30  0001 C C
F 1 "VCC" H 2250 4950 30  0000 C C
	1    2250 4850
	0    -1   -1   0   
$EndComp
$Comp
L CONN_15 P1
U 1 1 4AC05060
P 2900 4200
F 0 "P1" V 2870 4200 60  0000 C C
F 1 "CONN_15" V 2980 4200 60  0000 C C
	1    2900 4200
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR018
U 1 1 4AC04F74
P 5200 5150
F 0 "#PWR018" H 5200 5250 30  0001 C C
F 1 "VCC" H 5200 5250 30  0000 C C
	1    5200 5150
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR019
U 1 1 4AC04F51
P 2450 5100
F 0 "#PWR019" H 2450 5100 30  0001 C C
F 1 "GND" H 2450 5030 30  0001 C C
	1    2450 5100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR020
U 1 1 4AC04EA4
P 6350 5250
F 0 "#PWR020" H 6350 5250 30  0001 C C
F 1 "GND" H 6350 5180 30  0001 C C
	1    6350 5250
	1    0    0    -1  
$EndComp
Text Label 6400 5050 0    60   ~
GPIO38
Text Label 6400 4950 0    60   ~
GPIO36
Text Label 6400 4850 0    60   ~
GPIO34
Text Label 6400 4750 0    60   ~
GPIO32
Text Label 6400 4650 0    60   ~
GPIO30
Text Label 6400 4550 0    60   ~
GPIO28
Text Label 6400 4450 0    60   ~
GPIO26
Text Label 6400 4350 0    60   ~
GPIO24
Text Label 6400 4250 0    60   ~
GPIO22
Text Label 6400 4150 0    60   ~
GPIO20
Text Label 6400 4050 0    60   ~
GPIO18
Text Label 6400 3950 0    60   ~
GPIO16
Text Label 6400 3850 0    60   ~
GPIO14
Text Label 6400 3750 0    60   ~
GPIO12
Text Label 6400 3650 0    60   ~
GPIO10
Text Label 6400 3550 0    60   ~
GPIO8
Text Label 6400 3450 0    60   ~
GPIO6
Text Label 6400 3350 0    60   ~
GPIO4
Text Label 6400 3250 0    60   ~
GPIO2
Text Label 5000 5050 0    60   ~
GPIO37
Text Label 5000 4950 0    60   ~
GPIO35
Text Label 5000 4850 0    60   ~
GPIO33
Text Label 5000 4750 0    60   ~
GPIO31
Text Label 5000 4650 0    60   ~
GPIO29
Text Label 5000 4550 0    60   ~
GPIO27
Text Label 5000 4450 0    60   ~
GPIO25
Text Label 5000 4350 0    60   ~
GPIO23
Text Label 5000 4250 0    60   ~
GPIO21
Text Label 5000 4150 0    60   ~
GPIO19
Text Label 5000 4050 0    60   ~
GPIO17
Text Label 5000 3950 0    60   ~
GPIO15
Text Label 5000 3850 0    60   ~
GPIO13
Text Label 5000 3750 0    60   ~
GPIO11
Text Label 5000 3650 0    60   ~
GPIO9
Text Label 5000 3550 0    60   ~
GPIO7
Text Label 5000 3450 0    60   ~
GPIO5
Text Label 5000 3350 0    60   ~
GPIO3
Text Label 5000 3250 0    60   ~
GPIO1
$Comp
L VCC #PWR021
U 1 1 4ABEA0F8
P 5600 1400
F 0 "#PWR021" H 5600 1500 30  0001 C C
F 1 "VCC" H 5600 1500 30  0000 C C
	1    5600 1400
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR022
U 1 1 4ABEA0F3
P 5600 1500
F 0 "#PWR022" H 5600 1500 30  0001 C C
F 1 "GND" H 5600 1430 30  0001 C C
	1    5600 1500
	0    1    1    0   
$EndComp
NoConn ~ 5950 1800
Text GLabel 5600 1700 0    60   Output
PGC
Text GLabel 5600 1600 0    60   BiDi
PGD
Text GLabel 5600 1300 0    60   Output
MCLR
$Comp
L CONN_6 P4
U 1 1 4ABEA039
P 6300 1550
F 0 "P4" V 6250 1550 60  0000 C C
F 1 "CONN_6" V 6350 1550 60  0000 C C
	1    6300 1550
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR023
U 1 1 4ABE9D54
P 9700 4100
F 0 "#PWR023" H 9700 4050 20  0001 C C
F 1 "+BATT" H 9700 4200 30  0000 C C
	1    9700 4100
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR024
U 1 1 4ABE9D4E
P 9700 4300
F 0 "#PWR024" H 9700 4300 30  0001 C C
F 1 "GND" H 9700 4230 30  0001 C C
	1    9700 4300
	0    1    1    0   
$EndComp
$Comp
L CONN_2 P2
U 1 1 4ABE9D49
P 10200 4200
F 0 "P2" V 10150 4200 40  0000 C C
F 1 "CONN_2" V 10250 4200 40  0000 C C
	1    10200 4200
	1    0    0    -1  
$EndComp
Text GLabel 4600 5550 0    60   BiDi
GPIO[1..38]
Entry Wire Line
	6800 5050 6900 5150
Entry Wire Line
	6800 4950 6900 5050
Entry Wire Line
	6800 4850 6900 4950
Entry Wire Line
	6800 4750 6900 4850
Entry Wire Line
	6800 4650 6900 4750
Entry Wire Line
	6800 4550 6900 4650
Entry Wire Line
	6800 4450 6900 4550
Entry Wire Line
	6800 4350 6900 4450
Entry Wire Line
	6800 4250 6900 4350
Entry Wire Line
	6800 4150 6900 4250
Entry Wire Line
	6800 4050 6900 4150
Entry Wire Line
	6800 3950 6900 4050
Entry Wire Line
	6800 3850 6900 3950
Entry Wire Line
	6800 3750 6900 3850
Entry Wire Line
	6800 3650 6900 3750
Entry Wire Line
	6800 3550 6900 3650
Entry Wire Line
	6800 3450 6900 3550
Entry Wire Line
	6800 3350 6900 3450
Entry Wire Line
	6800 3250 6900 3350
Entry Wire Line
	4850 5150 4950 5050
Entry Wire Line
	4850 5050 4950 4950
Entry Wire Line
	4850 4950 4950 4850
Entry Wire Line
	4850 4850 4950 4750
Entry Wire Line
	4850 4750 4950 4650
Entry Wire Line
	4850 4650 4950 4550
Entry Wire Line
	4850 4550 4950 4450
Entry Wire Line
	4850 4450 4950 4350
Entry Wire Line
	4850 4350 4950 4250
Entry Wire Line
	4850 4250 4950 4150
Entry Wire Line
	4850 4150 4950 4050
Entry Wire Line
	4850 4050 4950 3950
Entry Wire Line
	4850 3950 4950 3850
Entry Wire Line
	4850 3850 4950 3750
Entry Wire Line
	4850 3750 4950 3650
Entry Wire Line
	4850 3650 4950 3550
Entry Wire Line
	4850 3550 4950 3450
Entry Wire Line
	4850 3450 4950 3350
Entry Wire Line
	4850 3350 4950 3250
$Comp
L CONN_20X2 P3
U 1 1 4ABE9C9E
P 5850 4200
F 0 "P3" H 5850 5500 60  0000 C C
F 1 "CONN_20X2" V 5850 4200 50  0000 C C
	1    5850 4200
	1    0    0    -1  
$EndComp
Text Label 2100 4750 0    60   ~
ADC12
Text Label 2100 4650 0    60   ~
ADC11
Text Label 2100 4550 0    60   ~
ADC10
Text Label 2100 4450 0    60   ~
ADC9
Text Label 2100 4350 0    60   ~
ADC8
Text Label 2100 4250 0    60   ~
ADC7
Text Label 2100 4150 0    60   ~
ADC6
Text Label 2100 4050 0    60   ~
ADC5
Text Label 2100 3950 0    60   ~
ADC4
Text Label 2100 3850 0    60   ~
ADC3
Text Label 2100 3750 0    60   ~
ADC2
Text Label 2100 3650 0    60   ~
ADC1
Text Label 2100 3550 0    60   ~
ADC0
Entry Wire Line
	1950 4850 2050 4750
Entry Wire Line
	1950 4750 2050 4650
Entry Wire Line
	1950 4650 2050 4550
Entry Wire Line
	1950 4550 2050 4450
Entry Wire Line
	1950 4450 2050 4350
Entry Wire Line
	1950 4350 2050 4250
Entry Wire Line
	1950 4250 2050 4150
Entry Wire Line
	1950 4150 2050 4050
Entry Wire Line
	1950 4050 2050 3950
Entry Wire Line
	1950 3950 2050 3850
Entry Wire Line
	1950 3850 2050 3750
Entry Wire Line
	1950 3750 2050 3650
Entry Wire Line
	1950 3650 2050 3550
Text GLabel 1650 5050 0    60   Output
ADC[0..12]
$EndSCHEMATC
