EESchema Schematic File Version 2  date 2013-03-01T20:33:31 PST
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
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title "noname.sch"
Date "2 mar 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 4400 3300 0    60   ~ 0
Components for the harness are ordered with breakout board. \nIn dribbler-harness-connector-and-components multi-part.
Text Notes 5550 3600 0    60   ~ 0
LPS ground
Text Notes 5550 3700 0    60   ~ 0
LPS sensor
Text Notes 5550 3800 0    60   ~ 0
LPS3
Text Notes 5550 3900 0    60   ~ 0
LPS2
Text Notes 5550 4000 0    60   ~ 0
LPS1
Text Notes 5550 4100 0    60   ~ 0
LPS0
Text Notes 5550 4200 0    60   ~ 0
LPS +3.3V
Wire Wire Line
	5400 4200 6150 4200
Wire Wire Line
	5400 4100 6150 4100
Wire Wire Line
	5400 4000 6150 4000
Wire Wire Line
	5400 3900 6150 3900
Wire Wire Line
	5400 3800 6150 3800
Wire Wire Line
	5400 3700 6150 3700
Wire Wire Line
	5400 3600 6150 3600
Wire Wire Line
	6950 4450 6950 4400
Wire Wire Line
	6950 4400 5400 4400
Wire Wire Line
	5400 4600 6750 4600
Wire Wire Line
	5400 4500 6850 4500
Wire Wire Line
	6850 4500 6850 5000
Wire Wire Line
	6850 5000 6750 5000
Wire Wire Line
	7350 4450 7350 4300
Wire Wire Line
	7350 4300 5400 4300
$Comp
L CONN_7 P2
U 1 1 51318112
P 6500 3900
F 0 "P2" V 6470 3900 60  0000 C CNN
F 1 "CONN_7" V 6570 3900 60  0000 C CNN
F 4 "dribbler-harness-to-lps" V 6500 3900 60  0001 C CNN "Digi-Key Part"
	1    6500 3900
	1    0    0    -1  
$EndComp
$Comp
L CONN_11 P1
U 1 1 00000000
P 5050 4100
F 0 "P1" V 5000 4100 60  0000 C CNN
F 1 "CONN_11" V 5100 4100 60  0000 C CNN
F 4 "dribbler-harness-to-breakout-board" V 5050 4100 60  0001 C CNN "Digi-Key Part"
	1    5050 4100
	-1   0    0    1   
$EndComp
Text Notes 6700 3950 0    60   ~ 0
To Lateral Position Sensor
Text Notes 4900 4150 2    60   ~ 0
To Mainboard
$Comp
L NPN Q1
U 1 1 4E03DD91
P 6650 4800
F 0 "Q1" H 6650 4650 50  0000 R CNN
F 1 "PHOTOTRANSISTOR" H 6650 4950 50  0000 R CNN
F 4 "475-1419-ND" H 6650 4800 60  0001 C CNN "Digi-Key Part"
	1    6650 4800
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 4E03DCF1
P 7150 4450
F 0 "D1" H 7150 4550 50  0000 C CNN
F 1 "LED" H 7150 4350 50  0000 C CNN
F 4 "365-1145-ND" H 7150 4450 60  0001 C CNN "Digi-Key Part"
	1    7150 4450
	1    0    0    -1  
$EndComp
$EndSCHEMATC
