EESchema Schematic File Version 2  date 2010-04-01T16:15:12 PDT
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 7 8
Title ""
Date "1 apr 2010"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	6650 4100 6600 4100
Wire Wire Line
	5050 4300 5100 4300
Wire Wire Line
	7050 4300 6600 4300
Wire Wire Line
	4450 4000 5100 4000
Wire Wire Line
	4450 4100 5100 4100
Wire Wire Line
	6600 4200 7050 4200
Wire Wire Line
	5100 4200 5050 4200
Wire Wire Line
	6600 4000 6650 4000
$Comp
L VCC #PWR081
U 1 1 4B557990
P 5050 4200
F 0 "#PWR081" H 5050 4300 30  0001 C CNN
F 1 "VCC" H 5050 4300 30  0000 C CNN
	1    5050 4200
	0    -1   -1   0   
$EndComp
$Comp
L VCC #PWR082
U 1 1 4B557970
P 6650 4100
F 0 "#PWR082" H 6650 4200 30  0001 C CNN
F 1 "VCC" H 6650 4200 30  0000 C CNN
	1    6650 4100
	0    1    1    0   
$EndComp
$Comp
L M25P16-8 U6
U 1 1 4B557951
P 5850 4150
F 0 "U6" H 5850 4150 60  0000 C CNN
F 1 "M25P16-8" H 5850 4450 60  0000 C CNN
F 2 "M25P16-VMN" H 5850 4150 60  0001 C CNN
	1    5850 4150
	1    0    0    -1  
$EndComp
Text HLabel 4450 4100 0    60   Output ~ 0
DOUT
Text HLabel 4450 4000 0    60   Input ~ 0
CS
Text HLabel 7050 4300 2    60   Input ~ 0
DIN
Text HLabel 7050 4200 2    60   Input ~ 0
CLK
$Comp
L GND #PWR083
U 1 1 4ABE8D7B
P 5050 4300
F 0 "#PWR083" H 5050 4300 30  0001 C CNN
F 1 "GND" H 5050 4230 30  0001 C CNN
	1    5050 4300
	0    1    1    0   
$EndComp
$Comp
L VCC #PWR084
U 1 1 4ABE8D6C
P 6650 4000
F 0 "#PWR084" H 6650 4100 30  0001 C CNN
F 1 "VCC" H 6650 4100 30  0000 C CNN
	1    6650 4000
	0    1    1    0   
$EndComp
$EndSCHEMATC
