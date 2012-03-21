EESchema Schematic File Version 2  date 2012-03-21T00:14:25 PDT
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
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title "noname.sch"
Date "21 mar 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 1500 3950
NoConn ~ 1500 4050
NoConn ~ 1500 4150
NoConn ~ 1500 4250
NoConn ~ 1500 4350
Wire Wire Line
	2350 4250 2350 4050
Wire Wire Line
	2350 4050 1650 4050
Wire Wire Line
	1650 4050 1650 4450
Wire Wire Line
	1650 4450 1500 4450
Wire Wire Line
	2850 5050 3000 5050
Wire Wire Line
	3000 5050 3000 4450
Wire Wire Line
	3000 4450 1850 4450
Wire Wire Line
	1850 4450 1850 4650
Wire Wire Line
	1850 4650 1500 4650
Wire Wire Line
	1500 4850 2100 4850
Wire Wire Line
	2100 4850 2100 5050
Wire Wire Line
	2850 4650 2850 4550
Wire Wire Line
	1500 4950 1500 5050
Wire Wire Line
	1500 5050 1600 5050
Wire Wire Line
	1500 4750 1950 4750
Wire Wire Line
	1950 4750 1950 4550
Wire Wire Line
	1950 4550 2850 4550
Wire Wire Line
	1500 4550 1750 4550
Wire Wire Line
	1750 4550 1750 4250
Wire Wire Line
	1750 4250 1950 4250
$Comp
L CONN_11 P?
U 1 1 4F697E69
P 1150 4450
F 0 "P?" V 1100 4450 60  0000 C CNN
F 1 "CONN_11" V 1200 4450 60  0000 C CNN
	1    1150 4450
	-1   0    0    1   
$EndComp
$Comp
L THERMISTOR TH?
U 1 1 4E03DE1E
P 1850 5050
F 0 "TH?" V 1950 5100 50  0000 C CNN
F 1 "THERMISTOR" V 1750 5050 50  0000 C CNN
	1    1850 5050
	0    1    1    0   
$EndComp
$Comp
L NPN Q?
U 1 1 4E03DD91
P 2750 4850
F 0 "Q?" H 2750 4700 50  0000 R CNN
F 1 "PHOTOTRANSISTOR" H 2750 5000 50  0000 R CNN
	1    2750 4850
	1    0    0    -1  
$EndComp
$Comp
L LED D?
U 1 1 4E03DCF1
P 2150 4250
F 0 "D?" H 2150 4350 50  0000 C CNN
F 1 "LED" H 2150 4150 50  0000 C CNN
	1    2150 4250
	1    0    0    -1  
$EndComp
$EndSCHEMATC
