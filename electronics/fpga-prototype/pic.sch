EESchema Schematic File Version 1
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,./fpga-prototype.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 4 7
Title ""
Date "27 sep 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 1700 5250
Wire Wire Line
	1700 5250 1700 5350
Connection ~ 2000 4650
Wire Wire Line
	2000 4850 2000 4500
Wire Wire Line
	2000 4500 4250 4500
Wire Bus Line
	9350 3600 9350 5750
Wire Bus Line
	9350 5750 2900 5750
Wire Bus Line
	2900 5750 2900 3400
Wire Wire Line
	7450 3800 9250 3800
Wire Wire Line
	7450 3700 9250 3700
Wire Wire Line
	3000 4100 4250 4100
Wire Wire Line
	3000 3900 4250 3900
Wire Wire Line
	3000 3600 4250 3600
Wire Wire Line
	4250 3400 3000 3400
Wire Wire Line
	7450 3200 8450 3200
Wire Wire Line
	7450 4000 8450 4000
Wire Wire Line
	7450 3400 8450 3400
Wire Wire Line
	7450 4300 8450 4300
Wire Wire Line
	8450 4500 7450 4500
Wire Wire Line
	7450 4700 8450 4700
Wire Wire Line
	7950 4850 8450 4850
Wire Wire Line
	7450 4900 7950 4900
Wire Wire Line
	7450 5000 8450 5000
Wire Wire Line
	3650 5000 4250 5000
Wire Wire Line
	3650 4700 4250 4700
Wire Wire Line
	4250 3200 3650 3200
Wire Wire Line
	4250 4300 3650 4300
Wire Wire Line
	4250 4200 3650 4200
Wire Wire Line
	3650 3700 4250 3700
Wire Wire Line
	4250 4600 3650 4600
Wire Wire Line
	4250 4900 3650 4900
Wire Wire Line
	4250 5100 3650 5100
Wire Wire Line
	8450 5100 7450 5100
Wire Wire Line
	7450 4800 7950 4800
Wire Wire Line
	7950 4800 7950 4900
Connection ~ 7950 4850
Wire Wire Line
	8450 4600 7450 4600
Wire Wire Line
	8450 4400 7450 4400
Wire Wire Line
	8450 4200 7450 4200
Wire Wire Line
	8450 4100 7450 4100
Wire Wire Line
	8450 3300 7450 3300
Wire Wire Line
	4250 3300 3000 3300
Wire Wire Line
	4250 3500 3000 3500
Wire Wire Line
	4250 3800 3000 3800
Wire Wire Line
	4250 4000 3000 4000
Wire Wire Line
	9250 3600 7450 3600
Wire Wire Line
	9250 3500 7450 3500
Wire Wire Line
	9250 3900 7450 3900
Wire Bus Line
	7250 6250 6700 6250
Wire Bus Line
	6700 6250 6700 5750
Wire Wire Line
	4250 4400 1400 4400
Wire Wire Line
	1400 4400 1400 4850
Connection ~ 1400 4650
Wire Wire Line
	1400 5250 2000 5250
Text GLabel 7250 6250 2    60   Input
ADC[0..12]
Text Label 8900 3900 0    60   ~
ADC12
Text Label 8900 3500 0    60   ~
ADC11
Text Label 8900 3800 0    60   ~
ADC10
Entry Wire Line
	9250 3900 9350 4000
Entry Wire Line
	9250 3500 9350 3600
Entry Wire Line
	9250 3800 9350 3900
Text Label 8900 3600 0    60   ~
ADC9
Text Label 8900 3700 0    60   ~
ADC8
Entry Wire Line
	9250 3700 9350 3800
Entry Wire Line
	9250 3600 9350 3700
Text Label 3050 4100 0    60   ~
ADC7
Text Label 3050 4000 0    60   ~
ADC6
Text Label 3050 3900 0    60   ~
ADC5
Text Label 3050 3800 0    60   ~
ADC4
Text Label 3050 3600 0    60   ~
ADC3
Entry Wire Line
	2900 4200 3000 4100
Entry Wire Line
	2900 4100 3000 4000
Entry Wire Line
	2900 4000 3000 3900
Entry Wire Line
	2900 3900 3000 3800
Entry Wire Line
	2900 3700 3000 3600
Text Label 3050 3500 0    60   ~
ADC2
Text Label 3050 3400 0    60   ~
ADC1
Text Label 3050 3300 0    60   ~
ADC0
Entry Wire Line
	2900 3400 3000 3300
Entry Wire Line
	2900 3600 3000 3500
Entry Wire Line
	2900 3500 3000 3400
Text GLabel 8450 3300 2    60   Input
PGC
Text GLabel 8450 3200 2    60   BiDi
PGD
$Comp
L GND #PWR07
U 1 1 4ABE95D6
P 8450 3400
F 0 "#PWR07" H 8450 3400 30  0001 C C
F 1 "GND" H 8450 3330 30  0001 C C
	1    8450 3400
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR08
U 1 1 4ABE95C5
P 8450 4100
F 0 "#PWR08" H 8450 4100 30  0001 C C
F 1 "GND" H 8450 4030 30  0001 C C
	1    8450 4100
	0    -1   -1   0   
$EndComp
$Comp
L VCC #PWR09
U 1 1 4ABE95C2
P 8450 4000
F 0 "#PWR09" H 8450 4100 30  0001 C C
F 1 "VCC" H 8450 4100 30  0000 C C
	1    8450 4000
	0    1    1    0   
$EndComp
Text GLabel 8450 4200 2    60   Input
BOOTLOAD
Text GLabel 8450 4300 2    60   Output
FPGA_SS
Text GLabel 8450 4400 2    60   3State
FLASH_SS
Text GLabel 8450 4500 2    60   Input
DONE
Text GLabel 8450 4600 2    60   Input
RX
Text GLabel 8450 4700 2    60   BiDi
TX
$Comp
L GND #PWR010
U 1 1 4ABE94D0
P 8450 4850
F 0 "#PWR010" H 8450 4850 30  0001 C C
F 1 "GND" H 8450 4780 30  0001 C C
	1    8450 4850
	0    -1   -1   0   
$EndComp
Text GLabel 8450 5000 2    60   Output
PROG_B
Text GLabel 8450 5100 2    60   Input
INIT_B
Text GLabel 3650 5100 0    60   BiDi
SPIOUT
Text GLabel 3650 5000 0    60   Input
SPIIN
$Comp
L VCC #PWR011
U 1 1 4ABE9454
P 3650 4900
F 0 "#PWR011" H 3650 5000 30  0001 C C
F 1 "VCC" H 3650 5000 30  0000 C C
	1    3650 4900
	0    -1   -1   0   
$EndComp
NoConn ~ 4250 4800
Text GLabel 3650 4700 0    60   3State
BRAKE
Text GLabel 3650 4600 0    60   BiDi
SPICK
$Comp
L GND #PWR012
U 1 1 4ABE9401
P 1700 5350
F 0 "#PWR012" H 1700 5350 30  0001 C C
F 1 "GND" H 1700 5280 30  0001 C C
	1    1700 5350
	1    0    0    -1  
$EndComp
$Comp
L C C7
U 1 1 4ABE93EC
P 2000 5050
F 0 "C7" H 2050 5150 50  0000 L C
F 1 "27pF" H 2050 4950 50  0000 L C
	1    2000 5050
	1    0    0    -1  
$EndComp
$Comp
L C C6
U 1 1 4ABE93EB
P 1400 5050
F 0 "C6" H 1450 5150 50  0000 L C
F 1 "27pF" H 1450 4950 50  0000 L C
	1    1400 5050
	1    0    0    -1  
$EndComp
$Comp
L CRYSTAL X1
U 1 1 4ABE93E3
P 1700 4650
F 0 "X1" H 1700 4800 60  0000 C C
F 1 "4MHz" H 1700 4500 60  0000 C C
	1    1700 4650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR013
U 1 1 4ABE93C2
P 3650 4300
F 0 "#PWR013" H 3650 4300 30  0001 C C
F 1 "GND" H 3650 4230 30  0001 C C
	1    3650 4300
	0    1    1    0   
$EndComp
$Comp
L VCC #PWR014
U 1 1 4ABE93BC
P 3650 4200
F 0 "#PWR014" H 3650 4300 30  0001 C C
F 1 "VCC" H 3650 4300 30  0000 C C
	1    3650 4200
	0    -1   -1   0   
$EndComp
Text GLabel 3650 3700 0    60   Output
/WP
Text GLabel 3650 3200 0    60   Input
MCLR
$Comp
L PIC18F4550 U7
U 1 1 4ABE92C3
P 5850 4150
F 0 "U7" H 5850 4100 60  0000 C C
F 1 "PIC18F4550" H 5850 4200 60  0000 C C
	1    5850 4150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
