EESchema Schematic File Version 2  date 2013-03-01T20:34:08 PST
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
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "2 mar 2013"
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
L CONN_2 P1
U 1 1 4F7FB0A2
P 5250 3650
F 0 "P1" V 5200 3650 40  0000 C CNN
F 1 "CONN_2" V 5300 3650 40  0000 C CNN
F 4 "solenoid-plug" H 5250 3650 60  0001 C CNN "Digi-Key Part"
	1    5250 3650
	-1   0    0    -1  
$EndComp
$Comp
L INDUCTOR L1
U 1 1 4F7FB09F
P 6150 3650
F 0 "L1" V 6100 3650 40  0000 C CNN
F 1 "INDUCTOR" V 6250 3650 40  0000 C CNN
F 4 "none" H 6150 3650 60  0001 C CNN "Digi-Key Part"
	1    6150 3650
	1    0    0    -1  
$EndComp
$EndSCHEMATC
