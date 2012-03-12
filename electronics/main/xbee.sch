EESchema Schematic File Version 2  date 2012-02-12T19:59:28 PST
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
Sheet 16 17
Title ""
Date "13 feb 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4200 5700 4550 5700
Wire Wire Line
	7800 5700 7150 5700
Wire Wire Line
	7800 3500 7150 3500
Wire Wire Line
	4550 3600 4200 3600
Wire Wire Line
	4550 2800 4200 2800
Wire Wire Line
	4200 2700 4550 2700
Wire Wire Line
	4200 2900 4550 2900
Wire Wire Line
	7800 3100 7150 3100
Wire Wire Line
	4200 3100 4550 3100
Wire Wire Line
	4200 5300 4550 5300
Wire Wire Line
	7800 5300 7150 5300
Wire Wire Line
	4200 5100 4550 5100
Wire Wire Line
	4200 4900 4550 4900
Wire Wire Line
	4550 5000 4200 5000
Wire Wire Line
	4550 5800 4200 5800
Wire Wire Line
	4200 3500 4550 3500
Text HLabel 4200 5700 0    60   Input ~ 0
SLEEP0
Text HLabel 4200 3500 0    60   Input ~ 0
SLEEP1
Text HLabel 7800 5700 2    60   Output ~ 0
/CTS0
Text HLabel 7800 3500 2    60   Output ~ 0
/CTS1
$Comp
L XBEE U10
U 1 1 4CC4753B
P 5850 5350
F 0 "U10" H 5850 5300 60  0000 C CNN
F 1 "XBEE" H 5850 5400 60  0000 C CNN
F 2 "XBee" H 5850 5350 60  0001 C CNN
	1    5850 5350
	1    0    0    -1  
$EndComp
Text HLabel 4200 5000 0    60   Output ~ 0
DOUT0
Text HLabel 4200 5100 0    60   Input ~ 0
DIN0
NoConn ~ 4550 5200
NoConn ~ 4550 5400
NoConn ~ 4550 5500
NoConn ~ 4550 5600
$Comp
L GND #PWR086
U 1 1 4CC4753A
P 4200 5800
F 0 "#PWR086" H 4200 5800 30  0001 C CNN
F 1 "GND" H 4200 5730 30  0001 C CNN
	1    4200 5800
	0    1    1    0   
$EndComp
NoConn ~ 7150 5800
NoConn ~ 7150 5600
NoConn ~ 7150 5500
NoConn ~ 7150 5400
NoConn ~ 7150 5200
NoConn ~ 7150 5100
Text HLabel 7800 5300 2    60   Input ~ 0
/RTS0
Text HLabel 4200 5300 0    60   Input ~ 0
/RESET0
$Comp
L +3.3V #PWR087
U 1 1 4CC47539
P 4200 4900
F 0 "#PWR087" H 4200 4860 30  0001 C CNN
F 1 "+3.3V" H 4200 5010 30  0000 C CNN
	1    4200 4900
	0    -1   -1   0   
$EndComp
NoConn ~ 7150 5000
NoConn ~ 7150 4900
NoConn ~ 7150 2700
NoConn ~ 7150 2800
$Comp
L +3.3V #PWR088
U 1 1 4CC3843E
P 4200 2700
F 0 "#PWR088" H 4200 2660 30  0001 C CNN
F 1 "+3.3V" H 4200 2810 30  0000 C CNN
	1    4200 2700
	0    -1   -1   0   
$EndComp
Text HLabel 4200 3100 0    60   Input ~ 0
/RESET1
Text HLabel 7800 3100 2    60   Input ~ 0
/RTS1
NoConn ~ 7150 2900
NoConn ~ 7150 3000
NoConn ~ 7150 3200
NoConn ~ 7150 3300
NoConn ~ 7150 3400
NoConn ~ 7150 3600
$Comp
L GND #PWR089
U 1 1 4ABE98E5
P 4200 3600
F 0 "#PWR089" H 4200 3600 30  0001 C CNN
F 1 "GND" H 4200 3530 30  0001 C CNN
	1    4200 3600
	0    1    1    0   
$EndComp
NoConn ~ 4550 3400
NoConn ~ 4550 3300
NoConn ~ 4550 3200
NoConn ~ 4550 3000
Text HLabel 4200 2900 0    60   Input ~ 0
DIN1
Text HLabel 4200 2800 0    60   Output ~ 0
DOUT1
$Comp
L XBEE U8
U 1 1 4ABE98A8
P 5850 3150
F 0 "U8" H 5850 3100 60  0000 C CNN
F 1 "XBEE" H 5850 3200 60  0000 C CNN
F 2 "XBee" H 5850 3150 60  0001 C CNN
	1    5850 3150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
