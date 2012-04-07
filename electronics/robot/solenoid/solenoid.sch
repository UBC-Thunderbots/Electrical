EESchema Schematic File Version 2  date 2012-04-06T21:04:06 PDT
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
LIBS:thunderbots-symbols
LIBS:solenoid-cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title ""
Date "7 apr 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5600 3750 5850 3750
Wire Wire Line
	5850 3750 5850 3950
Wire Wire Line
	5850 3950 6150 3950
Wire Wire Line
	6150 3350 5850 3350
Wire Wire Line
	5850 3350 5850 3550
Wire Wire Line
	5850 3550 5600 3550
$Comp
L CONN_2 P?
U 1 1 4F7FB0A2
P 5250 3650
F 0 "P?" V 5200 3650 40  0000 C CNN
F 1 "CONN_2" V 5300 3650 40  0000 C CNN
F 4 "WM2613-ND" H 5250 3650 60  0001 C CNN "Field1"
	1    5250 3650
	-1   0    0    -1  
$EndComp
$Comp
L INDUCTOR L?
U 1 1 4F7FB09F
P 6150 3650
F 0 "L?" V 6100 3650 40  0000 C CNN
F 1 "INDUCTOR" V 6250 3650 40  0000 C CNN
F 4 "KICKER_SOLENOID" H 6150 3650 60  0001 C CNN "Field1"
	1    6150 3650
	1    0    0    -1  
$EndComp
$EndSCHEMATC
