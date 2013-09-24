EESchema Schematic File Version 2  date 2013-09-24T15:17:21 PDT
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
LIBS:main-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 2 15
Title ""
Date "24 sep 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	7700 1600 7800 1600
Wire Wire Line
	7800 1600 7800 1700
Connection ~ 7200 1600
Wire Wire Line
	7200 1500 7200 5000
Wire Wire Line
	6500 1900 6500 1600
Wire Wire Line
	6500 5300 6500 5000
Wire Wire Line
	6500 5000 7200 5000
Wire Wire Line
	5900 5750 7600 5750
Wire Wire Line
	5900 2350 7600 2350
Wire Bus Line
	4300 1850 4700 1850
Wire Bus Line
	4700 1850 4700 5550
Wire Wire Line
	5150 2350 4550 2350
Wire Wire Line
	6850 1900 6850 1800
Wire Wire Line
	6850 1800 6000 1800
Wire Wire Line
	6000 1800 6000 2150
Wire Wire Line
	6000 2150 5900 2150
Wire Wire Line
	6200 2100 6200 2250
Wire Wire Line
	6200 2250 5900 2250
Wire Wire Line
	6850 2350 6850 2300
Connection ~ 5500 1900
Wire Wire Line
	5250 1900 5500 1900
Connection ~ 6600 2350
Connection ~ 6500 2350
Wire Wire Line
	6600 2300 6600 2400
Wire Wire Line
	5500 1850 5500 1950
Wire Wire Line
	7200 950  7200 1000
Wire Wire Line
	5500 2700 5500 2600
Wire Wire Line
	6500 2300 6500 2400
Wire Wire Line
	5250 1450 5250 1500
Connection ~ 6850 2350
Wire Wire Line
	5900 2450 6200 2450
Wire Wire Line
	6200 2450 6200 2600
Wire Wire Line
	6500 2900 6500 2800
Wire Wire Line
	5150 2250 4800 2250
Wire Wire Line
	5150 3950 4800 3950
Wire Wire Line
	6500 4600 6500 4500
Wire Wire Line
	6200 4300 6200 4150
Wire Wire Line
	6200 4150 5900 4150
Connection ~ 6850 4050
Wire Wire Line
	5250 3150 5250 3200
Wire Wire Line
	6500 4000 6500 4100
Wire Wire Line
	5500 4400 5500 4300
Wire Wire Line
	5500 3550 5500 3650
Wire Wire Line
	6600 4000 6600 4100
Connection ~ 6500 4050
Connection ~ 6600 4050
Wire Wire Line
	5250 3600 5500 3600
Connection ~ 5500 3600
Wire Wire Line
	6850 4050 6850 4000
Wire Wire Line
	5900 3950 6200 3950
Wire Wire Line
	6200 3950 6200 3800
Wire Wire Line
	5900 3850 6000 3850
Wire Wire Line
	6000 3850 6000 3500
Wire Wire Line
	6000 3500 6850 3500
Wire Wire Line
	6850 3500 6850 3600
Wire Wire Line
	5150 4050 4550 4050
Wire Wire Line
	5150 5750 4550 5750
Wire Wire Line
	6850 5300 6850 5200
Wire Wire Line
	6850 5200 6000 5200
Wire Wire Line
	6000 5200 6000 5550
Wire Wire Line
	6000 5550 5900 5550
Wire Wire Line
	6200 5500 6200 5650
Wire Wire Line
	6200 5650 5900 5650
Wire Wire Line
	6850 5750 6850 5700
Connection ~ 5500 5300
Wire Wire Line
	5250 5300 5500 5300
Connection ~ 6600 5750
Connection ~ 6500 5750
Wire Wire Line
	6600 5700 6600 5800
Wire Wire Line
	5500 5250 5500 5350
Wire Wire Line
	5500 6100 5500 6000
Wire Wire Line
	6500 5700 6500 5800
Wire Wire Line
	5250 4850 5250 4900
Connection ~ 6850 5750
Wire Wire Line
	5900 5850 6200 5850
Wire Wire Line
	6200 5850 6200 6000
Wire Wire Line
	6500 6300 6500 6200
Wire Wire Line
	5150 5650 4800 5650
Wire Bus Line
	4450 5650 4450 1950
Wire Bus Line
	4450 1950 4300 1950
Wire Wire Line
	7600 4050 5900 4050
Wire Bus Line
	7700 2450 7700 6000
Wire Bus Line
	7700 6000 7800 6000
Wire Wire Line
	6500 3600 6500 3300
Wire Wire Line
	6500 3300 7200 3300
Connection ~ 7200 3300
Wire Wire Line
	6500 1600 7300 1600
$Comp
L GND #PWR85
U 1 1 52420F7C
P 7800 1700
AR Path="/4CD72C2A/52420F7C" Ref="#PWR85"  Part="1" 
AR Path="/4CD72EB0/52420F7C" Ref="#PWR99"  Part="1" 
AR Path="/4CD72EC7/52420F7C" Ref="#PWR20"  Part="1" 
AR Path="/4CD72EC1/52420F7C" Ref="#PWR138"  Part="1" 
AR Path="/4CD72EB9/52420F7C" Ref="#PWR152"  Part="1" 
F 0 "#PWR152" H 7800 1700 30  0001 C CNN
F 1 "GND" H 7800 1630 30  0001 C CNN
	1    7800 1700
	1    0    0    -1  
$EndComp
$Comp
L C C18
U 1 1 52420F7D
P 7500 1600
AR Path="/4CD72C2A/52420F7D" Ref="C18"  Part="1" 
AR Path="/4CD72EB0/52420F7D" Ref="C55"  Part="1" 
AR Path="/4CD72EC7/52420F7D" Ref="C10"  Part="1" 
AR Path="/4CD72EC1/52420F7D" Ref="C65"  Part="1" 
AR Path="/4CD72EB9/52420F7D" Ref="C72"  Part="1" 
F 0 "C72" H 7550 1700 50  0000 L CNN
F 1 "10uF" H 7550 1500 50  0000 L CNN
	1    7500 1600
	0    -1   -1   0   
$EndComp
Text HLabel 4300 1950 0    60   Input ~ 0
LOW[0..2]
Text HLabel 4300 1850 0    60   Input ~ 0
HIGH[0..2]
Entry Wire Line
	4450 5650 4550 5750
Entry Wire Line
	4700 5550 4800 5650
Text Label 4850 5750 0    60   ~ 0
LOW2
Text Label 4850 5650 0    60   ~ 0
HIGH2
$Comp
L GND #PWR83
U 1 1 524202E3
P 6500 6300
AR Path="/4CD72C2A/524202E3" Ref="#PWR83"  Part="1" 
AR Path="/4CD72EB0/524202E3" Ref="#PWR97"  Part="1" 
AR Path="/4CD72EC7/524202E3" Ref="#PWR18"  Part="1" 
AR Path="/4CD72EC1/524202E3" Ref="#PWR136"  Part="1" 
AR Path="/4CD72EB9/524202E3" Ref="#PWR150"  Part="1" 
F 0 "#PWR150" H 6500 6300 30  0001 C CNN
F 1 "GND" H 6500 6230 30  0001 C CNN
	1    6500 6300
	1    0    0    -1  
$EndComp
Text Label 7600 5750 2    60   ~ 0
PHASE2
Entry Wire Line
	7600 5750 7700 5850
$Comp
L GND #PWR74
U 1 1 524202E2
P 5250 4850
AR Path="/4CD72C2A/524202E2" Ref="#PWR74"  Part="1" 
AR Path="/4CD72EB0/524202E2" Ref="#PWR88"  Part="1" 
AR Path="/4CD72EC7/524202E2" Ref="#PWR9"  Part="1" 
AR Path="/4CD72EC1/524202E2" Ref="#PWR127"  Part="1" 
AR Path="/4CD72EB9/524202E2" Ref="#PWR141"  Part="1" 
F 0 "#PWR141" H 5250 4850 30  0001 C CNN
F 1 "GND" H 5250 4780 30  0001 C CNN
	1    5250 4850
	-1   0    0    1   
$EndComp
$Comp
L C C13
U 1 1 524202E1
P 5250 5100
AR Path="/4CD72C2A/524202E1" Ref="C13"  Part="1" 
AR Path="/4CD72EB0/524202E1" Ref="C51"  Part="1" 
AR Path="/4CD72EC7/524202E1" Ref="C6"  Part="1" 
AR Path="/4CD72EC1/524202E1" Ref="C59"  Part="1" 
AR Path="/4CD72EB9/524202E1" Ref="C68"  Part="1" 
F 0 "C68" H 5300 5200 50  0000 L CNN
F 1 "1uF" H 5300 5000 50  0000 L CNN
	1    5250 5100
	1    0    0    -1  
$EndComp
$Comp
L C C17
U 1 1 524202E0
P 6850 5500
AR Path="/4CD72C2A/524202E0" Ref="C17"  Part="1" 
AR Path="/4CD72EB0/524202E0" Ref="C54"  Part="1" 
AR Path="/4CD72EC7/524202E0" Ref="C9"  Part="1" 
AR Path="/4CD72EC1/524202E0" Ref="C64"  Part="1" 
AR Path="/4CD72EB9/524202E0" Ref="C71"  Part="1" 
F 0 "C71" H 6900 5600 50  0000 L CNN
F 1 "100nF" H 6900 5400 50  0000 L CNN
	1    6850 5500
	1    0    0    -1  
$EndComp
$Comp
L +9V #PWR79
U 1 1 524202DF
P 5500 5250
AR Path="/4CD72C2A/524202DF" Ref="#PWR79"  Part="1" 
AR Path="/4CD72EB0/524202DF" Ref="#PWR93"  Part="1" 
AR Path="/4CD72EC7/524202DF" Ref="#PWR14"  Part="1" 
AR Path="/4CD72EC1/524202DF" Ref="#PWR132"  Part="1" 
AR Path="/4CD72EB9/524202DF" Ref="#PWR146"  Part="1" 
F 0 "#PWR146" H 5500 5220 20  0001 C CNN
F 1 "+9V" H 5500 5360 30  0000 C CNN
	1    5500 5250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR80
U 1 1 524202DE
P 5500 6100
AR Path="/4CD72C2A/524202DE" Ref="#PWR80"  Part="1" 
AR Path="/4CD72EB0/524202DE" Ref="#PWR94"  Part="1" 
AR Path="/4CD72EC7/524202DE" Ref="#PWR15"  Part="1" 
AR Path="/4CD72EC1/524202DE" Ref="#PWR133"  Part="1" 
AR Path="/4CD72EB9/524202DE" Ref="#PWR147"  Part="1" 
F 0 "#PWR147" H 5500 6100 30  0001 C CNN
F 1 "GND" H 5500 6030 30  0001 C CNN
	1    5500 6100
	1    0    0    -1  
$EndComp
$Comp
L AO4882 Q6
U 2 1 524202DD
P 6400 6000
AR Path="/4CD72C2A/524202DD" Ref="Q6"  Part="2" 
AR Path="/4CD72EB0/524202DD" Ref="Q9"  Part="2" 
AR Path="/4CD72EC7/524202DD" Ref="Q3"  Part="2" 
AR Path="/4CD72EC1/524202DD" Ref="Q12"  Part="2" 
AR Path="/4CD72EB9/524202DD" Ref="Q17"  Part="2" 
F 0 "Q17" H 6410 6170 60  0000 R CNN
F 1 "AO4882" H 6410 5850 60  0000 R CNN
	2    6400 6000
	1    0    0    -1  
$EndComp
$Comp
L AO4882 Q6
U 1 1 524202DC
P 6400 5500
AR Path="/4CD72C2A/524202DC" Ref="Q6"  Part="1" 
AR Path="/4CD72EB0/524202DC" Ref="Q9"  Part="1" 
AR Path="/4CD72EC7/524202DC" Ref="Q3"  Part="1" 
AR Path="/4CD72EC1/524202DC" Ref="Q12"  Part="1" 
AR Path="/4CD72EB9/524202DC" Ref="Q17"  Part="1" 
F 0 "Q17" H 6410 5670 60  0000 R CNN
F 1 "AO4882" H 6410 5350 60  0000 R CNN
	1    6400 5500
	1    0    0    1   
$EndComp
$Comp
L LM5107 U13
U 1 1 524202DB
P 5500 5700
AR Path="/4CD72C2A/524202DB" Ref="U13"  Part="1" 
AR Path="/4CD72EB0/524202DB" Ref="U16"  Part="1" 
AR Path="/4CD72EC7/524202DB" Ref="U3"  Part="1" 
AR Path="/4CD72EC1/524202DB" Ref="U19"  Part="1" 
AR Path="/4CD72EB9/524202DB" Ref="U22"  Part="1" 
F 0 "U22" H 5500 5650 60  0000 C CNN
F 1 "LM5107" H 5500 5750 60  0000 C CNN
	1    5500 5700
	1    0    0    -1  
$EndComp
$Comp
L LM5107 U5
U 1 1 524202CE
P 5500 4000
AR Path="/4CD72C2A/524202CE" Ref="U5"  Part="1" 
AR Path="/4CD72EB0/524202CE" Ref="U15"  Part="1" 
AR Path="/4CD72EC7/524202CE" Ref="U2"  Part="1" 
AR Path="/4CD72EC1/524202CE" Ref="U18"  Part="1" 
AR Path="/4CD72EB9/524202CE" Ref="U21"  Part="1" 
F 0 "U21" H 5500 3950 60  0000 C CNN
F 1 "LM5107" H 5500 4050 60  0000 C CNN
	1    5500 4000
	1    0    0    -1  
$EndComp
$Comp
L AO4882 Q5
U 1 1 524202CD
P 6400 3800
AR Path="/4CD72C2A/524202CD" Ref="Q5"  Part="1" 
AR Path="/4CD72EB0/524202CD" Ref="Q8"  Part="1" 
AR Path="/4CD72EC7/524202CD" Ref="Q2"  Part="1" 
AR Path="/4CD72EC1/524202CD" Ref="Q11"  Part="1" 
AR Path="/4CD72EB9/524202CD" Ref="Q16"  Part="1" 
F 0 "Q16" H 6410 3970 60  0000 R CNN
F 1 "AO4882" H 6410 3650 60  0000 R CNN
	1    6400 3800
	1    0    0    1   
$EndComp
$Comp
L AO4882 Q5
U 2 1 524202CC
P 6400 4300
AR Path="/4CD72C2A/524202CC" Ref="Q5"  Part="2" 
AR Path="/4CD72EB0/524202CC" Ref="Q8"  Part="2" 
AR Path="/4CD72EC7/524202CC" Ref="Q2"  Part="2" 
AR Path="/4CD72EC1/524202CC" Ref="Q11"  Part="2" 
AR Path="/4CD72EB9/524202CC" Ref="Q16"  Part="2" 
F 0 "Q16" H 6410 4470 60  0000 R CNN
F 1 "AO4882" H 6410 4150 60  0000 R CNN
	2    6400 4300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR78
U 1 1 524202CB
P 5500 4400
AR Path="/4CD72C2A/524202CB" Ref="#PWR78"  Part="1" 
AR Path="/4CD72EB0/524202CB" Ref="#PWR92"  Part="1" 
AR Path="/4CD72EC7/524202CB" Ref="#PWR13"  Part="1" 
AR Path="/4CD72EC1/524202CB" Ref="#PWR131"  Part="1" 
AR Path="/4CD72EB9/524202CB" Ref="#PWR145"  Part="1" 
F 0 "#PWR145" H 5500 4400 30  0001 C CNN
F 1 "GND" H 5500 4330 30  0001 C CNN
	1    5500 4400
	1    0    0    -1  
$EndComp
$Comp
L +9V #PWR77
U 1 1 524202CA
P 5500 3550
AR Path="/4CD72C2A/524202CA" Ref="#PWR77"  Part="1" 
AR Path="/4CD72EB0/524202CA" Ref="#PWR91"  Part="1" 
AR Path="/4CD72EC7/524202CA" Ref="#PWR12"  Part="1" 
AR Path="/4CD72EC1/524202CA" Ref="#PWR130"  Part="1" 
AR Path="/4CD72EB9/524202CA" Ref="#PWR144"  Part="1" 
F 0 "#PWR144" H 5500 3520 20  0001 C CNN
F 1 "+9V" H 5500 3660 30  0000 C CNN
	1    5500 3550
	1    0    0    -1  
$EndComp
$Comp
L C C16
U 1 1 524202C9
P 6850 3800
AR Path="/4CD72C2A/524202C9" Ref="C16"  Part="1" 
AR Path="/4CD72EB0/524202C9" Ref="C53"  Part="1" 
AR Path="/4CD72EC7/524202C9" Ref="C8"  Part="1" 
AR Path="/4CD72EC1/524202C9" Ref="C63"  Part="1" 
AR Path="/4CD72EB9/524202C9" Ref="C70"  Part="1" 
F 0 "C70" H 6900 3900 50  0000 L CNN
F 1 "100nF" H 6900 3700 50  0000 L CNN
	1    6850 3800
	1    0    0    -1  
$EndComp
$Comp
L C C12
U 1 1 524202C8
P 5250 3400
AR Path="/4CD72C2A/524202C8" Ref="C12"  Part="1" 
AR Path="/4CD72EB0/524202C8" Ref="C20"  Part="1" 
AR Path="/4CD72EC7/524202C8" Ref="C4"  Part="1" 
AR Path="/4CD72EC1/524202C8" Ref="C58"  Part="1" 
AR Path="/4CD72EB9/524202C8" Ref="C67"  Part="1" 
F 0 "C67" H 5300 3500 50  0000 L CNN
F 1 "1uF" H 5300 3300 50  0000 L CNN
	1    5250 3400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR73
U 1 1 524202C7
P 5250 3150
AR Path="/4CD72C2A/524202C7" Ref="#PWR73"  Part="1" 
AR Path="/4CD72EB0/524202C7" Ref="#PWR87"  Part="1" 
AR Path="/4CD72EC7/524202C7" Ref="#PWR8"  Part="1" 
AR Path="/4CD72EC1/524202C7" Ref="#PWR126"  Part="1" 
AR Path="/4CD72EB9/524202C7" Ref="#PWR140"  Part="1" 
F 0 "#PWR140" H 5250 3150 30  0001 C CNN
F 1 "GND" H 5250 3080 30  0001 C CNN
	1    5250 3150
	-1   0    0    1   
$EndComp
Entry Wire Line
	7600 4050 7700 4150
Text Label 7600 4050 2    60   ~ 0
PHASE1
$Comp
L GND #PWR82
U 1 1 524202C6
P 6500 4600
AR Path="/4CD72C2A/524202C6" Ref="#PWR82"  Part="1" 
AR Path="/4CD72EB0/524202C6" Ref="#PWR96"  Part="1" 
AR Path="/4CD72EC7/524202C6" Ref="#PWR17"  Part="1" 
AR Path="/4CD72EC1/524202C6" Ref="#PWR135"  Part="1" 
AR Path="/4CD72EB9/524202C6" Ref="#PWR149"  Part="1" 
F 0 "#PWR149" H 6500 4600 30  0001 C CNN
F 1 "GND" H 6500 4530 30  0001 C CNN
	1    6500 4600
	1    0    0    -1  
$EndComp
Text Label 4850 3950 0    60   ~ 0
HIGH1
Text Label 4850 4050 0    60   ~ 0
LOW1
Entry Wire Line
	4700 3850 4800 3950
Entry Wire Line
	4450 3950 4550 4050
Entry Wire Line
	4450 2250 4550 2350
Entry Wire Line
	4700 2150 4800 2250
Text Label 4850 2350 0    60   ~ 0
LOW0
Text Label 4850 2250 0    60   ~ 0
HIGH0
$Comp
L GND #PWR81
U 1 1 52420F80
P 6500 2900
AR Path="/4CD72C2A/52420F80" Ref="#PWR81"  Part="1" 
AR Path="/4CD72EB0/52420F80" Ref="#PWR95"  Part="1" 
AR Path="/4CD72EC7/52420F80" Ref="#PWR16"  Part="1" 
AR Path="/4CD72EC1/52420F80" Ref="#PWR134"  Part="1" 
AR Path="/4CD72EB9/52420F80" Ref="#PWR148"  Part="1" 
F 0 "#PWR148" H 6500 2900 30  0001 C CNN
F 1 "GND" H 6500 2830 30  0001 C CNN
	1    6500 2900
	1    0    0    -1  
$EndComp
Text Label 7600 2350 2    60   ~ 0
PHASE0
Entry Wire Line
	7600 2350 7700 2450
$Comp
L GND #PWR72
U 1 1 52420F82
P 5250 1450
AR Path="/4CD72C2A/52420F82" Ref="#PWR72"  Part="1" 
AR Path="/4CD72EB0/52420F82" Ref="#PWR86"  Part="1" 
AR Path="/4CD72EC7/52420F82" Ref="#PWR7"  Part="1" 
AR Path="/4CD72EC1/52420F82" Ref="#PWR125"  Part="1" 
AR Path="/4CD72EB9/52420F82" Ref="#PWR139"  Part="1" 
F 0 "#PWR139" H 5250 1450 30  0001 C CNN
F 1 "GND" H 5250 1380 30  0001 C CNN
	1    5250 1450
	-1   0    0    1   
$EndComp
$Comp
L C C11
U 1 1 52420F76
P 5250 1700
AR Path="/4CD72C2A/52420F76" Ref="C11"  Part="1" 
AR Path="/4CD72EB0/52420F76" Ref="C19"  Part="1" 
AR Path="/4CD72EC7/52420F76" Ref="C2"  Part="1" 
AR Path="/4CD72EC1/52420F76" Ref="C56"  Part="1" 
AR Path="/4CD72EB9/52420F76" Ref="C66"  Part="1" 
F 0 "C66" H 5300 1800 50  0000 L CNN
F 1 "1uF" H 5300 1600 50  0000 L CNN
	1    5250 1700
	1    0    0    -1  
$EndComp
$Comp
L C C15
U 1 1 52420F6E
P 6850 2100
AR Path="/4CD72C2A/52420F6E" Ref="C15"  Part="1" 
AR Path="/4CD72EB0/52420F6E" Ref="C52"  Part="1" 
AR Path="/4CD72EC7/52420F6E" Ref="C7"  Part="1" 
AR Path="/4CD72EC1/52420F6E" Ref="C62"  Part="1" 
AR Path="/4CD72EB9/52420F6E" Ref="C69"  Part="1" 
F 0 "C69" H 6900 2200 50  0000 L CNN
F 1 "100nF" H 6900 2000 50  0000 L CNN
	1    6850 2100
	1    0    0    -1  
$EndComp
$Comp
L +9V #PWR75
U 1 1 52420F78
P 5500 1850
AR Path="/4CD72C2A/52420F78" Ref="#PWR75"  Part="1" 
AR Path="/4CD72EB0/52420F78" Ref="#PWR89"  Part="1" 
AR Path="/4CD72EC7/52420F78" Ref="#PWR10"  Part="1" 
AR Path="/4CD72EC1/52420F78" Ref="#PWR128"  Part="1" 
AR Path="/4CD72EB9/52420F78" Ref="#PWR142"  Part="1" 
F 0 "#PWR142" H 5500 1820 20  0001 C CNN
F 1 "+9V" H 5500 1960 30  0000 C CNN
	1    5500 1850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR76
U 1 1 52420F79
P 5500 2700
AR Path="/4CD72C2A/52420F79" Ref="#PWR76"  Part="1" 
AR Path="/4CD72EB0/52420F79" Ref="#PWR90"  Part="1" 
AR Path="/4CD72EC7/52420F79" Ref="#PWR11"  Part="1" 
AR Path="/4CD72EC1/52420F79" Ref="#PWR129"  Part="1" 
AR Path="/4CD72EB9/52420F79" Ref="#PWR143"  Part="1" 
F 0 "#PWR143" H 5500 2700 30  0001 C CNN
F 1 "GND" H 5500 2630 30  0001 C CNN
	1    5500 2700
	1    0    0    -1  
$EndComp
$Comp
L AO4882 Q4
U 2 1 52420F7A
P 6400 2600
AR Path="/4CD72C2A/52420F7A" Ref="Q4"  Part="2" 
AR Path="/4CD72EB0/52420F7A" Ref="Q7"  Part="2" 
AR Path="/4CD72EC7/52420F7A" Ref="Q1"  Part="2" 
AR Path="/4CD72EC1/52420F7A" Ref="Q10"  Part="2" 
AR Path="/4CD72EB9/52420F7A" Ref="Q13"  Part="2" 
F 0 "Q13" H 6410 2770 60  0000 R CNN
F 1 "AO4882" H 6410 2450 60  0000 R CNN
	2    6400 2600
	1    0    0    -1  
$EndComp
$Comp
L AO4882 Q4
U 1 1 52420F7B
P 6400 2100
AR Path="/4CD72C2A/52420F7B" Ref="Q4"  Part="1" 
AR Path="/4CD72EB0/52420F7B" Ref="Q7"  Part="1" 
AR Path="/4CD72EC7/52420F7B" Ref="Q1"  Part="1" 
AR Path="/4CD72EC1/52420F7B" Ref="Q10"  Part="1" 
AR Path="/4CD72EB9/52420F7B" Ref="Q13"  Part="1" 
F 0 "Q13" H 6410 2270 60  0000 R CNN
F 1 "AO4882" H 6410 1950 60  0000 R CNN
	1    6400 2100
	1    0    0    1   
$EndComp
$Comp
L LM5107 U4
U 1 1 52420F7E
P 5500 2300
AR Path="/4CD72C2A/52420F7E" Ref="U4"  Part="1" 
AR Path="/4CD72EB0/52420F7E" Ref="U14"  Part="1" 
AR Path="/4CD72EC7/52420F7E" Ref="U1"  Part="1" 
AR Path="/4CD72EC1/52420F7E" Ref="U17"  Part="1" 
AR Path="/4CD72EB9/52420F7E" Ref="U20"  Part="1" 
F 0 "U20" H 5500 2250 60  0000 C CNN
F 1 "LM5107" H 5500 2350 60  0000 C CNN
	1    5500 2300
	1    0    0    -1  
$EndComp
$Comp
L FUSE F2
U 1 1 507B2A09
P 7200 1250
AR Path="/4CD72C2A/507B2A09" Ref="F2"  Part="1" 
AR Path="/4CD72EB0/507B2A09" Ref="F3"  Part="1" 
AR Path="/4CD72EC7/507B2A09" Ref="F4"  Part="1" 
AR Path="/4CD72EC1/507B2A09" Ref="F5"  Part="1" 
AR Path="/4CD72EB9/507B2A09" Ref="F6"  Part="1" 
F 0 "F6" H 7300 1300 40  0000 C CNN
F 1 "5A" H 7100 1200 40  0000 C CNN
F 4 "F1460CT-ND" H 7200 1250 60  0001 C CNN "Digi-Key Part"
	1    7200 1250
	0    1    1    0   
$EndComp
$Comp
L +HVBATT #PWR84
U 1 1 506E24C0
P 7200 950
AR Path="/4CD72C2A/506E24C0" Ref="#PWR84"  Part="1" 
AR Path="/4CD72EB0/506E24C0" Ref="#PWR98"  Part="1" 
AR Path="/4CD72EC7/506E24C0" Ref="#PWR19"  Part="1" 
AR Path="/4CD72EC1/506E24C0" Ref="#PWR137"  Part="1" 
AR Path="/4CD72EB9/506E24C0" Ref="#PWR151"  Part="1" 
F 0 "#PWR151" H 7200 900 20  0001 C CNN
F 1 "+HVBATT" H 7200 1050 30  0000 C CNN
	1    7200 950 
	1    0    0    -1  
$EndComp
Text HLabel 7800 6000 2    60   Output ~ 0
PHASE[0..2]
$EndSCHEMATC
