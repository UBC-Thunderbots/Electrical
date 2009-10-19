EESchema Schematic File Version 2  date 2009-10-18T21:24:03 PDT
LIBS:power,../thunderbots-symbols,device,transistors,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,opto,atmel,contrib,valves,./motorcontroller.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 3 9
Title ""
Date "19 oct 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 3050 3250
NoConn ~ 3050 3150
NoConn ~ 3050 3050
NoConn ~ 3050 2950
NoConn ~ 3050 2850
NoConn ~ 3050 2750
NoConn ~ 3050 2650
NoConn ~ 3050 2550
NoConn ~ 3050 2450
NoConn ~ 3050 2350
NoConn ~ 3050 2250
NoConn ~ 3050 2150
NoConn ~ 3050 2050
NoConn ~ 3050 1950
NoConn ~ 3050 1850
NoConn ~ 2250 3250
NoConn ~ 2250 3150
NoConn ~ 2250 3050
NoConn ~ 2250 2950
NoConn ~ 2250 2850
NoConn ~ 2250 2750
NoConn ~ 2250 2650
NoConn ~ 2250 2550
NoConn ~ 2250 2450
Connection ~ 5900 2800
Wire Wire Line
	5900 2850 5900 2300
Wire Wire Line
	6000 2600 5800 2600
Wire Wire Line
	5800 2100 6000 2100
Connection ~ 3100 5400
Wire Wire Line
	3100 5400 3050 5400
Connection ~ 3100 5200
Wire Wire Line
	3050 5200 3100 5200
Connection ~ 3100 5000
Wire Wire Line
	3050 5000 3100 5000
Connection ~ 3100 4800
Wire Wire Line
	3050 4800 3100 4800
Connection ~ 3100 4600
Wire Wire Line
	3050 4600 3100 4600
Connection ~ 3100 4400
Wire Wire Line
	3100 4400 3050 4400
Connection ~ 3100 4200
Wire Wire Line
	3100 4200 3050 4200
Wire Wire Line
	3100 5450 3100 4000
Wire Wire Line
	3100 4000 3050 4000
Wire Wire Line
	2200 4000 2250 4000
Wire Wire Line
	3050 1750 3450 1750
Wire Wire Line
	3050 1650 3450 1650
Wire Wire Line
	3050 1550 3450 1550
Wire Wire Line
	3050 1450 3450 1450
Wire Wire Line
	3050 1350 3450 1350
Wire Bus Line
	1500 2000 1750 2000
Wire Bus Line
	1750 2000 1750 1550
Wire Wire Line
	1850 1850 2250 1850
Wire Wire Line
	1850 1750 2250 1750
Wire Wire Line
	1850 1650 2250 1650
Wire Wire Line
	1850 1550 2250 1550
Wire Wire Line
	1850 1450 2250 1450
Wire Wire Line
	1500 1350 2250 1350
Wire Wire Line
	1850 1950 2250 1950
Wire Wire Line
	1850 2050 2250 2050
Wire Wire Line
	1850 2150 2250 2150
Wire Wire Line
	1850 2250 2250 2250
Wire Wire Line
	1850 2350 2250 2350
Wire Bus Line
	1500 2500 1750 2500
Wire Bus Line
	1750 2500 1750 2050
Wire Bus Line
	3800 1900 3550 1900
Wire Bus Line
	3550 1900 3550 1450
Wire Wire Line
	2200 3950 2200 5400
Wire Wire Line
	2200 5400 2250 5400
Connection ~ 2200 4000
Wire Wire Line
	3050 4100 3100 4100
Connection ~ 3100 4100
Wire Wire Line
	3050 4300 3100 4300
Connection ~ 3100 4300
Wire Wire Line
	3050 4500 3100 4500
Connection ~ 3100 4500
Wire Wire Line
	3050 4700 3100 4700
Connection ~ 3100 4700
Wire Wire Line
	3050 4900 3100 4900
Connection ~ 3100 4900
Wire Wire Line
	3050 5100 3100 5100
Connection ~ 3100 5100
Wire Wire Line
	3050 5300 3100 5300
Connection ~ 3100 5300
Wire Wire Line
	5900 2300 6000 2300
Wire Wire Line
	5900 2800 6000 2800
Wire Wire Line
	5800 2600 5800 2050
Connection ~ 5800 2100
$Comp
L GND #PWR010
U 1 1 4ADA585E
P 5900 2850
F 0 "#PWR010" H 5900 2850 30  0001 C CNN
F 1 "GND" H 5900 2780 30  0001 C CNN
	1    5900 2850
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR011
U 1 1 4ADA585A
P 5800 2050
F 0 "#PWR011" H 5800 2000 20  0001 C CNN
F 1 "+BATT" H 5800 2150 30  0000 C CNN
	1    5800 2050
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P4
U 1 1 4ADA582B
P 6350 2700
F 0 "P4" V 6300 2700 40  0000 C CNN
F 1 "CONN_2" V 6400 2700 40  0000 C CNN
	1    6350 2700
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P3
U 1 1 4ADA5828
P 6350 2200
F 0 "P3" V 6300 2200 40  0000 C CNN
F 1 "CONN_2" V 6400 2200 40  0000 C CNN
	1    6350 2200
	1    0    0    -1  
$EndComp
NoConn ~ 2250 5300
NoConn ~ 2250 5200
NoConn ~ 2250 5100
NoConn ~ 2250 5000
NoConn ~ 2250 4900
NoConn ~ 2250 4800
NoConn ~ 2250 4700
NoConn ~ 2250 4600
NoConn ~ 2250 4500
NoConn ~ 2250 4400
NoConn ~ 2250 4300
NoConn ~ 2250 4200
NoConn ~ 2250 4100
$Comp
L GND #PWR012
U 1 1 4ADA4287
P 3100 5450
F 0 "#PWR012" H 3100 5450 30  0001 C CNN
F 1 "GND" H 3100 5380 30  0001 C CNN
	1    3100 5450
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR013
U 1 1 4ADA4274
P 2200 3950
F 0 "#PWR013" H 2200 3910 30  0001 C CNN
F 1 "+3.3V" H 2200 4060 30  0000 C CNN
	1    2200 3950
	1    0    0    -1  
$EndComp
$Comp
L CONN_15X2 P2
U 1 1 4ADA4267
P 2650 4700
F 0 "P2" H 2650 5500 60  0000 C CNN
F 1 "CONN_15X2" V 2650 4700 50  0000 C CNN
	1    2650 4700
	1    0    0    -1  
$EndComp
Text HLabel 3800 1900 2    60   Input ~ 0
FAULT[1..5]
Text Label 3100 1750 0    60   ~ 0
FAULT5
Text Label 3100 1650 0    60   ~ 0
FAULT4
Text Label 3100 1550 0    60   ~ 0
FAULT3
Text Label 3100 1450 0    60   ~ 0
FAULT2
Text Label 3100 1350 0    60   ~ 0
FAULT1
Entry Wire Line
	3450 1750 3550 1850
Entry Wire Line
	3450 1650 3550 1750
Entry Wire Line
	3450 1550 3550 1650
Entry Wire Line
	3450 1450 3550 1550
Entry Wire Line
	3450 1350 3550 1450
Text HLabel 1500 2500 0    60   Output ~ 0
DIR[1..5]
Text Label 1900 2350 0    60   ~ 0
DIR5
Text Label 1900 2250 0    60   ~ 0
DIR4
Text Label 1900 2150 0    60   ~ 0
DIR3
Text Label 1900 2050 0    60   ~ 0
DIR2
Text Label 1900 1950 0    60   ~ 0
DIR1
Entry Wire Line
	1750 2450 1850 2350
Entry Wire Line
	1750 2350 1850 2250
Entry Wire Line
	1750 2250 1850 2150
Entry Wire Line
	1750 2150 1850 2050
Entry Wire Line
	1750 2050 1850 1950
Text Label 1900 1850 0    60   ~ 0
PWM5
Text Label 1900 1750 0    60   ~ 0
PWM4
Text Label 1900 1650 0    60   ~ 0
PWM3
Text Label 1900 1550 0    60   ~ 0
PWM2
Text Label 1900 1450 0    60   ~ 0
PWM1
Entry Wire Line
	1750 1950 1850 1850
Entry Wire Line
	1750 1850 1850 1750
Entry Wire Line
	1750 1750 1850 1650
Entry Wire Line
	1750 1650 1850 1550
Entry Wire Line
	1750 1550 1850 1450
Text HLabel 1500 2000 0    60   Output ~ 0
PWM[1..5]
Text HLabel 1500 1350 0    60   Output ~ 0
BRAKE
$Comp
L CONN_20X2 P1
U 1 1 4ADA3E2D
P 2650 2300
F 0 "P1" H 2650 3350 60  0000 C CNN
F 1 "CONN_20X2" V 2650 2300 50  0000 C CNN
	1    2650 2300
	1    0    0    -1  
$EndComp
$EndSCHEMATC
