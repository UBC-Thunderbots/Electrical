EESchema Schematic File Version 2  date 2010-04-02T17:38:51 PDT
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 6 8
Title ""
Date "3 apr 2010"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Bus Line
	8150 4750 8150 6600
Wire Wire Line
	5750 2250 5750 2350
Wire Wire Line
	7650 3950 7750 3950
Wire Wire Line
	3850 4450 3750 4450
Wire Wire Line
	5850 2350 5850 2250
Wire Wire Line
	5650 2350 5650 2250
Wire Wire Line
	7650 4450 7750 4450
Wire Wire Line
	7650 4350 7750 4350
Wire Wire Line
	3750 4150 3850 4150
Wire Wire Line
	3750 4050 3850 4050
Wire Wire Line
	3750 3950 3850 3950
Wire Wire Line
	3750 3850 3850 3850
Wire Wire Line
	5450 6250 5450 6150
Wire Wire Line
	6150 1150 6150 1200
Wire Wire Line
	7750 4050 7650 4050
Wire Wire Line
	5350 2250 5350 2350
Wire Wire Line
	3850 4650 3750 4650
Wire Wire Line
	3850 4550 3750 4550
Wire Bus Line
	8150 6600 6150 6600
Wire Wire Line
	6150 6500 6150 6150
Wire Wire Line
	7750 3750 7650 3750
Wire Wire Line
	5350 6150 5350 6250
Wire Wire Line
	5750 6250 5750 6150
Wire Wire Line
	5550 6250 5550 6150
Wire Wire Line
	7650 4150 7750 4150
Wire Wire Line
	5250 2250 5250 2350
Wire Wire Line
	3850 4250 3750 4250
Wire Bus Line
	8150 6400 8250 6400
Wire Wire Line
	5950 6150 5950 6250
Connection ~ 5850 7100
Wire Wire Line
	5800 7100 5850 7100
Wire Wire Line
	5850 6150 5850 7150
Wire Wire Line
	5250 7100 5300 7100
Wire Wire Line
	3750 4350 3850 4350
Wire Wire Line
	5950 2250 5950 2350
Wire Wire Line
	3750 3750 3850 3750
Wire Wire Line
	7750 4250 7650 4250
Wire Wire Line
	5650 6250 5650 6150
Wire Wire Line
	6250 2350 6250 2250
Wire Wire Line
	5250 6250 5250 6150
Wire Wire Line
	6050 6150 6050 6500
Wire Wire Line
	6250 6150 6250 6500
Wire Wire Line
	7650 4650 8050 4650
Wire Wire Line
	5450 2350 5450 2250
Wire Wire Line
	6150 600  6150 650 
Wire Wire Line
	6150 1600 6150 2350
Wire Wire Line
	5550 2350 5550 2250
Wire Wire Line
	7650 3850 7750 3850
Wire Wire Line
	7650 4750 7750 4750
Wire Wire Line
	6050 2250 6050 2350
Wire Wire Line
	3750 4750 3850 4750
Wire Wire Line
	7750 4550 7650 4550
Text HLabel 7750 4550 2    60   Input ~ 0
BEAMIN
$Comp
L GND #PWR47
U 1 1 4B59299C
P 5750 2250
F 0 "#PWR47" H 5750 2250 30  0001 C CNN
F 1 "GND" H 5750 2180 30  0001 C CNN
	1    5750 2250
	-1   0    0    1   
$EndComp
Text HLabel 7750 3950 2    60   Output ~ 0
OSC
$Comp
L GND #PWR39
U 1 1 4B5929B5
P 3750 4750
F 0 "#PWR39" H 3750 4750 30  0001 C CNN
F 1 "GND" H 3750 4680 30  0001 C CNN
	1    3750 4750
	0    1    1    0   
$EndComp
$Comp
L GND #PWR38
U 1 1 4B5929AD
P 3750 4450
F 0 "#PWR38" H 3750 4450 30  0001 C CNN
F 1 "GND" H 3750 4380 30  0001 C CNN
	1    3750 4450
	0    1    1    0   
$EndComp
$Comp
L GND #PWR50
U 1 1 4B5929A0
P 6050 2250
F 0 "#PWR50" H 6050 2250 30  0001 C CNN
F 1 "GND" H 6050 2180 30  0001 C CNN
	1    6050 2250
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR48
U 1 1 4B59299E
P 5850 2250
F 0 "#PWR48" H 5850 2250 30  0001 C CNN
F 1 "GND" H 5850 2180 30  0001 C CNN
	1    5850 2250
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR46
U 1 1 4B59299A
P 5650 2250
F 0 "#PWR46" H 5650 2250 30  0001 C CNN
F 1 "GND" H 5650 2180 30  0001 C CNN
	1    5650 2250
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR54
U 1 1 4B58FBF2
P 7750 4050
F 0 "#PWR54" H 7750 4050 30  0001 C CNN
F 1 "GND" H 7750 3980 30  0001 C CNN
	1    7750 4050
	0    -1   -1   0   
$EndComp
Text HLabel 5550 2250 3    60   Output ~ 0
XBEE_RST
$Comp
L PIC18F4550 U7
U 1 1 4B135439
P 5750 4250
F 0 "U7" H 5750 4200 60  0000 C CNN
F 1 "PIC18F4550" H 5750 4300 60  0000 C CNN
F 2 "TQFP44" H 5750 4250 60  0001 C CNN
F 4 "PIC18LF4550" H 5750 4250 60  0001 C CNN "Field1"
	1    5750 4250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR44
U 1 1 4B4D0D1C
P 5450 2250
F 0 "#PWR44" H 5450 2250 30  0001 C CNN
F 1 "GND" H 5450 2180 30  0001 C CNN
	1    5450 2250
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR42
U 1 1 4B4D0D19
P 5350 2250
F 0 "#PWR42" H 5350 2250 30  0001 C CNN
F 1 "GND" H 5350 2180 30  0001 C CNN
	1    5350 2250
	-1   0    0    1   
$EndComp
Entry Wire Line
	6250 6500 6350 6600
Entry Wire Line
	6150 6500 6250 6600
Entry Wire Line
	6050 6500 6150 6600
Text Label 6250 6450 1    60   ~ 0
ADC2
Text Label 6150 6450 1    60   ~ 0
ADC3
Text Label 6050 6450 1    60   ~ 0
ADC4
Text Label 7800 4650 0    60   ~ 0
ADC1
$Comp
L GND #PWR53
U 1 1 4B4903C0
P 7750 3750
F 0 "#PWR53" H 7750 3750 30  0001 C CNN
F 1 "GND" H 7750 3680 30  0001 C CNN
	1    7750 3750
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR43
U 1 1 4B4903AC
P 5350 6250
F 0 "#PWR43" H 5350 6250 30  0001 C CNN
F 1 "GND" H 5350 6180 30  0001 C CNN
	1    5350 6250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR40
U 1 1 4B4903A9
P 5250 6250
F 0 "#PWR40" H 5250 6250 30  0001 C CNN
F 1 "GND" H 5250 6180 30  0001 C CNN
	1    5250 6250
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR52
U 1 1 4B490393
P 6250 2250
F 0 "#PWR52" H 6250 2350 30  0001 C CNN
F 1 "VCC" H 6250 2350 30  0000 C CNN
	1    6250 2250
	1    0    0    -1  
$EndComp
Entry Wire Line
	8050 4650 8150 4750
Text HLabel 8250 6400 2    60   Input ~ 0
ADC[1..4]
$Comp
L GND #PWR51
U 1 1 4B33DEA0
P 6150 600
F 0 "#PWR51" H 6150 600 30  0001 C CNN
F 1 "GND" H 6150 530 30  0001 C CNN
	1    6150 600 
	-1   0    0    1   
$EndComp
$Comp
L R R5
U 1 1 4B33DE9B
P 6150 900
F 0 "R5" V 6230 900 50  0000 C CNN
F 1 "100R" V 6150 900 50  0000 C CNN
F 2 "R1" H 6150 900 60  0001 C CNN
	1    6150 900 
	-1   0    0    1   
$EndComp
$Comp
L LED D2
U 1 1 4B33DE92
P 6150 1400
F 0 "D2" H 6150 1500 50  0000 C CNN
F 1 "LED" H 6150 1300 50  0000 C CNN
F 2 "LEDV" H 6150 1400 60  0001 C CNN
	1    6150 1400
	0    -1   -1   0   
$EndComp
Text HLabel 5950 6250 1    60   Input ~ 0
VMON
$Comp
L VCC #PWR41
U 1 1 4AD91E7E
P 5250 7100
F 0 "#PWR41" H 5250 7200 30  0001 C CNN
F 1 "VCC" H 5250 7200 30  0000 C CNN
	1    5250 7100
	0    -1   -1   0   
$EndComp
$Comp
L R R2
U 1 1 4AD91E77
P 5550 7100
F 0 "R2" V 5630 7100 50  0000 C CNN
F 1 "10kR" V 5550 7100 50  0000 C CNN
F 2 "R1" H 5550 7100 60  0001 C CNN
	1    5550 7100
	0    1    1    0   
$EndComp
Text HLabel 5450 6250 1    60   Output ~ 0
/RTS
Text HLabel 3750 4650 0    60   Input ~ 0
/EMERG_ERASE
Text HLabel 5650 6250 1    60   Input ~ 0
PGC
Text HLabel 5750 6250 1    60   BiDi ~ 0
PGD
$Comp
L GND #PWR45
U 1 1 4ABE95D6
P 5550 6250
F 0 "#PWR45" H 5550 6250 30  0001 C CNN
F 1 "GND" H 5550 6180 30  0001 C CNN
	1    5550 6250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR55
U 1 1 4ABE95C5
P 7750 4150
F 0 "#PWR55" H 7750 4150 30  0001 C CNN
F 1 "GND" H 7750 4080 30  0001 C CNN
	1    7750 4150
	0    -1   -1   0   
$EndComp
$Comp
L VCC #PWR56
U 1 1 4ABE95C2
P 7750 4250
F 0 "#PWR56" H 7750 4350 30  0001 C CNN
F 1 "VCC" H 7750 4350 30  0000 C CNN
	1    7750 4250
	0    1    1    0   
$EndComp
Text HLabel 3750 4550 0    60   Input ~ 0
BOOTLOAD
Text HLabel 7750 4350 2    60   3State ~ 0
FLASH_SS
Text HLabel 3750 3950 0    60   Output ~ 0
FPGA_SS
Text HLabel 3750 4150 0    60   Input ~ 0
DONE
Text HLabel 3750 3750 0    60   Input ~ 0
RX
Text HLabel 5250 2250 3    60   BiDi ~ 0
TX
Text HLabel 3750 3850 0    60   Output ~ 0
PROG_B
Text HLabel 3750 4050 0    60   Input ~ 0
INIT_B
Text HLabel 7750 4450 2    60   BiDi ~ 0
SPIOUT
Text HLabel 7750 3850 2    60   Input ~ 0
SPIIN
$Comp
L VCC #PWR49
U 1 1 4ABE9454
P 5950 2250
F 0 "#PWR49" H 5950 2350 30  0001 C CNN
F 1 "VCC" H 5950 2350 30  0000 C CNN
	1    5950 2250
	1    0    0    -1  
$EndComp
Text HLabel 7750 4750 2    60   BiDi ~ 0
SPICK
$Comp
L GND #PWR36
U 1 1 4ABE93C2
P 3750 4250
F 0 "#PWR36" H 3750 4250 30  0001 C CNN
F 1 "GND" H 3750 4180 30  0001 C CNN
	1    3750 4250
	0    1    1    0   
$EndComp
$Comp
L VCC #PWR37
U 1 1 4ABE93BC
P 3750 4350
F 0 "#PWR37" H 3750 4450 30  0001 C CNN
F 1 "VCC" H 3750 4450 30  0000 C CNN
	1    3750 4350
	0    -1   -1   0   
$EndComp
Text HLabel 5850 7150 1    60   Input ~ 0
MCLR
$EndSCHEMATC
