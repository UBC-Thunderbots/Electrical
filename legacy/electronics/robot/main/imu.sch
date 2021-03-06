EESchema Schematic File Version 2
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
LIBS:main-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 15
Title ""
Date "19 jun 2014"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 6400 4550
NoConn ~ 6400 4450
NoConn ~ 6400 4350
Connection ~ 7050 3800
Wire Wire Line
	7050 3750 7050 3850
Wire Wire Line
	6450 4250 6450 4150
Wire Wire Line
	6450 4150 6400 4150
Connection ~ 6450 3950
Connection ~ 6450 3850
Wire Wire Line
	6400 3850 6450 3850
Connection ~ 6650 3800
Wire Wire Line
	6650 3850 6650 3800
Wire Wire Line
	4750 4350 4800 4350
Wire Wire Line
	4750 4250 4800 4250
Wire Wire Line
	4750 4150 4800 4150
Wire Wire Line
	4750 4050 4800 4050
Wire Wire Line
	4750 3950 4800 3950
Wire Wire Line
	6400 2650 6550 2650
Connection ~ 6750 2850
Wire Wire Line
	6800 2850 6400 2850
Connection ~ 6650 3250
Wire Wire Line
	6650 3300 6650 3250
Wire Wire Line
	6750 2850 6750 2950
Wire Wire Line
	6400 3100 6400 3050
Wire Wire Line
	4750 2950 4800 2950
Wire Wire Line
	4750 2850 4800 2850
Wire Wire Line
	4750 2750 4800 2750
Wire Wire Line
	4750 2650 4800 2650
Wire Wire Line
	4750 2550 4800 2550
Wire Wire Line
	6400 2950 6550 2950
Wire Wire Line
	6550 3250 6750 3250
Wire Wire Line
	6750 2750 6750 2650
Wire Wire Line
	6650 2300 6650 2350
Connection ~ 6650 2350
Wire Wire Line
	6800 2750 6400 2750
Connection ~ 6750 2750
Wire Wire Line
	6400 2550 6550 2550
Connection ~ 6550 2550
Wire Wire Line
	7050 3800 6450 3800
Wire Wire Line
	6400 4050 6450 4050
Wire Wire Line
	6400 3950 6450 3950
Wire Wire Line
	6650 4150 6650 4200
Connection ~ 6650 4200
Wire Wire Line
	7050 4250 7050 4150
Connection ~ 7050 4200
$Comp
L +3.3V #PWR059
U 1 1 00000000
P 7050 4250
F 0 "#PWR059" H 7050 4210 30  0001 C CNN
F 1 "+3.3V" H 7050 4360 30  0000 C CNN
F 2 "" H 7050 4250 60  0001 C CNN
F 3 "" H 7050 4250 60  0001 C CNN
	1    7050 4250
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR060
U 1 1 5243B2A0
P 7050 3750
F 0 "#PWR060" H 7050 3750 30  0001 C CNN
F 1 "GND" H 7050 3680 30  0001 C CNN
F 2 "" H 7050 3750 60  0001 C CNN
F 3 "" H 7050 3750 60  0001 C CNN
	1    7050 3750
	-1   0    0    1   
$EndComp
$Comp
L C C88
U 1 1 5243B29F
P 7050 4000
F 0 "C88" H 7100 4100 50  0000 L CNN
F 1 "10uF" H 7100 3900 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206" H 7050 4000 60  0001 C CNN
F 3 "" H 7050 4000 60  0001 C CNN
	1    7050 4000
	1    0    0    -1  
$EndComp
$Comp
L C C87
U 1 1 5243AAB2
P 6650 4000
F 0 "C87" H 6700 4100 50  0000 L CNN
F 1 "100nF" H 6700 3900 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 6650 4000 60  0001 C CNN
F 3 "" H 6650 4000 60  0001 C CNN
	1    6650 4000
	1    0    0    -1  
$EndComp
NoConn ~ 4800 4450
Text HLabel 4750 4350 0    60   Output ~ 0
ACCEL_INT
Text HLabel 4750 4250 0    60   Output ~ 0
ACCEL_MISO
Text HLabel 4750 4150 0    60   Input ~ 0
ACCEL_MOSI
Text HLabel 4750 4050 0    60   Input ~ 0
ACCEL_CLK
Text HLabel 4750 3950 0    60   Input ~ 0
~ACCEL_CS
$Comp
L +3.3V #PWR061
U 1 1 5243AABC
P 6650 3300
F 0 "#PWR061" H 6650 3260 30  0001 C CNN
F 1 "+3.3V" H 6650 3410 30  0000 C CNN
F 2 "" H 6650 3300 60  0001 C CNN
F 3 "" H 6650 3300 60  0001 C CNN
	1    6650 3300
	-1   0    0    1   
$EndComp
$Comp
L +3.3V #PWR062
U 1 1 5243AABB
P 6800 2750
F 0 "#PWR062" H 6800 2710 30  0001 C CNN
F 1 "+3.3V" H 6800 2860 30  0000 C CNN
F 2 "" H 6800 2750 60  0001 C CNN
F 3 "" H 6800 2750 60  0001 C CNN
	1    6800 2750
	0    1    1    0   
$EndComp
$Comp
L GND #PWR063
U 1 1 5243AABA
P 6650 2300
F 0 "#PWR063" H 6650 2300 30  0001 C CNN
F 1 "GND" H 6650 2230 30  0001 C CNN
F 2 "" H 6650 2300 60  0001 C CNN
F 3 "" H 6650 2300 60  0001 C CNN
	1    6650 2300
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR064
U 1 1 5243AAB9
P 6800 2850
F 0 "#PWR064" H 6800 2850 30  0001 C CNN
F 1 "GND" H 6800 2780 30  0001 C CNN
F 2 "" H 6800 2850 60  0001 C CNN
F 3 "" H 6800 2850 60  0001 C CNN
	1    6800 2850
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR065
U 1 1 5243AAB8
P 6400 3100
F 0 "#PWR065" H 6400 3100 30  0001 C CNN
F 1 "GND" H 6400 3030 30  0001 C CNN
F 2 "" H 6400 3100 60  0001 C CNN
F 3 "" H 6400 3100 60  0001 C CNN
	1    6400 3100
	1    0    0    -1  
$EndComp
$Comp
L C C86
U 1 1 5243AAB7
P 6750 3100
F 0 "C86" H 6800 3200 50  0000 L CNN
F 1 "100nF" H 6800 3000 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 6750 3100 60  0001 C CNN
F 3 "" H 6750 3100 60  0001 C CNN
	1    6750 3100
	1    0    0    -1  
$EndComp
$Comp
L C C85
U 1 1 5243AAB6
P 6750 2500
F 0 "C85" H 6800 2600 50  0000 L CNN
F 1 "100nF" H 6800 2400 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 6750 2500 60  0001 C CNN
F 3 "" H 6750 2500 60  0001 C CNN
	1    6750 2500
	1    0    0    -1  
$EndComp
NoConn ~ 4800 3050
Text HLabel 4750 2950 0    60   Output ~ 0
GYRO_INT
Text HLabel 4750 2850 0    60   Output ~ 0
GYRO_MISO
Text HLabel 4750 2750 0    60   Input ~ 0
GYRO_MOSI
Text HLabel 4750 2650 0    60   Input ~ 0
GYRO_CLK
Text HLabel 4750 2550 0    60   Input ~ 0
~GYRO_CS
$Comp
L LIS3DH U25
U 1 1 5243AAB5
P 5600 4200
F 0 "U25" H 5600 4150 60  0000 C CNN
F 1 "LIS3DH" H 5600 4250 60  0000 C CNN
F 2 "Thunderbots:LGA16" H 5600 4200 60  0001 C CNN
F 3 "" H 5600 4200 60  0001 C CNN
	1    5600 4200
	1    0    0    -1  
$EndComp
$Comp
L BMG160 U6
U 1 1 5243AAB4
P 5600 2800
F 0 "U6" H 5600 2750 60  0000 C CNN
F 1 "BMG160" H 5600 2850 60  0000 C CNN
F 2 "Thunderbots:LGA12" H 5600 2800 60  0001 C CNN
F 3 "" H 5600 2800 60  0001 C CNN
	1    5600 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 2650 6550 2350
Wire Wire Line
	6550 2350 6750 2350
Wire Wire Line
	6550 2950 6550 3250
Wire Wire Line
	6450 4050 6450 3800
Wire Wire Line
	6450 4250 6400 4250
Wire Wire Line
	6450 4200 7050 4200
Connection ~ 6450 4200
$EndSCHEMATC
