EESchema Schematic File Version 2  date 2011-01-08T11:27:20 PST
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
Sheet 12 18
Title ""
Date "8 jan 2011"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	3150 3250 5400 3250
Connection ~ 3500 3250
Connection ~ 3500 5150
Wire Wire Line
	5400 5150 3500 5150
Wire Wire Line
	7700 5950 7700 6000
Wire Wire Line
	7700 6000 7500 6000
Wire Wire Line
	7500 6000 7500 5950
Wire Wire Line
	7700 4050 7700 4100
Wire Wire Line
	7700 4100 7500 4100
Wire Wire Line
	7500 4100 7500 4050
Wire Wire Line
	7700 2050 7700 2100
Wire Wire Line
	7700 2100 7500 2100
Wire Wire Line
	7500 2100 7500 2050
Wire Wire Line
	8300 5500 7500 5500
Wire Wire Line
	8300 1600 7500 1600
Wire Bus Line
	4550 5750 4550 1650
Wire Bus Line
	4550 1650 4400 1650
Wire Wire Line
	4650 5850 5400 5850
Wire Wire Line
	5150 3450 5400 3450
Wire Bus Line
	5050 5250 5050 950 
Wire Bus Line
	5050 950  4850 950 
Connection ~ 7500 5500
Connection ~ 7650 5500
Wire Wire Line
	7500 5450 7500 5550
Wire Wire Line
	6600 5750 6650 5750
Wire Wire Line
	7150 5250 7200 5250
Wire Wire Line
	7200 5750 7150 5750
Wire Wire Line
	6600 5250 6650 5250
Wire Wire Line
	7650 5450 7650 5550
Wire Wire Line
	7650 3550 7650 3650
Wire Wire Line
	6600 3350 6650 3350
Wire Wire Line
	7200 3850 7150 3850
Wire Wire Line
	7150 3350 7200 3350
Wire Wire Line
	6600 3850 6650 3850
Wire Wire Line
	7500 3550 7500 3650
Connection ~ 7650 3600
Connection ~ 7500 3600
Connection ~ 7500 1600
Connection ~ 7650 1600
Wire Wire Line
	7500 1550 7500 1650
Wire Wire Line
	6600 1850 6650 1850
Wire Wire Line
	7150 1350 7200 1350
Wire Wire Line
	7200 1850 7150 1850
Wire Wire Line
	6600 1350 6650 1350
Wire Wire Line
	7650 1550 7650 1650
Wire Wire Line
	5400 5350 5150 5350
Wire Wire Line
	5150 1450 5400 1450
Wire Wire Line
	4650 1950 5400 1950
Wire Wire Line
	5400 3950 4650 3950
Wire Bus Line
	8550 5800 8400 5800
Wire Bus Line
	8400 5800 8400 1700
Wire Wire Line
	8300 3600 7500 3600
Wire Wire Line
	7500 1150 7500 1100
Wire Wire Line
	7500 1100 7700 1100
Wire Wire Line
	7700 1100 7700 1150
Wire Wire Line
	7500 3150 7500 3100
Wire Wire Line
	7500 3100 7700 3100
Wire Wire Line
	7700 3100 7700 3150
Wire Wire Line
	7500 5050 7500 5000
Wire Wire Line
	7500 5000 7700 5000
Wire Wire Line
	7700 5000 7700 5050
Wire Wire Line
	5400 1250 3500 1250
Wire Wire Line
	3500 1250 3500 5650
Wire Wire Line
	3500 5650 5400 5650
Wire Wire Line
	5400 3750 3500 3750
Connection ~ 3500 3750
Wire Wire Line
	3500 1750 5400 1750
Connection ~ 3500 1750
Text HLabel 3150 3250 0    60   Input ~ 0
ENABLE
Entry Wire Line
	8300 5500 8400 5600
Entry Wire Line
	8300 3600 8400 3700
Entry Wire Line
	8300 1600 8400 1700
Text Label 7850 5500 0    60   ~ 0
PHASE3
Text Label 7850 3600 0    60   ~ 0
PHASE2
Text Label 7850 1600 0    60   ~ 0
PHASE1
Text Label 4650 5850 0    60   ~ 0
CTRL-3
Text Label 4650 3950 0    60   ~ 0
CTRL-2
Entry Wire Line
	4550 5750 4650 5850
Entry Wire Line
	4550 3850 4650 3950
Entry Wire Line
	4550 1850 4650 1950
Text Label 4650 1950 0    60   ~ 0
CTRL-1
Text Label 5150 1450 0    60   ~ 0
CTRL+1
Text Label 5150 3450 0    60   ~ 0
CTRL+2
Entry Wire Line
	5050 1350 5150 1450
Entry Wire Line
	5050 3350 5150 3450
Text Label 5150 5350 0    60   ~ 0
CTRL+3
Entry Wire Line
	5050 5250 5150 5350
Text HLabel 8550 5800 2    60   Output ~ 0
PHASE[1..3]
Text HLabel 4400 1650 0    60   Input ~ 0
CTRL-[1..3]
Text HLabel 4850 950  0    60   Input ~ 0
CTRL+[1..3]
$Comp
L +BATT #PWR042
U 1 1 4CD72D0C
P 7700 5950
AR Path="/4CD72EC7/4CD72D0C" Ref="#PWR042"  Part="1" 
AR Path="/4CD72EC1/4CD72D0C" Ref="#PWR048"  Part="1" 
AR Path="/4CD72EB9/4CD72D0C" Ref="#PWR054"  Part="1" 
AR Path="/4CD72EB0/4CD72D0C" Ref="#PWR060"  Part="1" 
AR Path="/4CD72C2A/4CD72D0C" Ref="#PWR066"  Part="1" 
F 0 "#PWR066" H 7700 5900 20  0001 C CNN
F 1 "+BATT" H 7700 6050 30  0000 C CNN
	1    7700 5950
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR043
U 1 1 4CD72D0B
P 7700 5050
AR Path="/4CD72EC7/4CD72D0B" Ref="#PWR043"  Part="1" 
AR Path="/4CD72EC1/4CD72D0B" Ref="#PWR049"  Part="1" 
AR Path="/4CD72EB9/4CD72D0B" Ref="#PWR055"  Part="1" 
AR Path="/4CD72EB0/4CD72D0B" Ref="#PWR061"  Part="1" 
AR Path="/4CD72C2A/4CD72D0B" Ref="#PWR067"  Part="1" 
F 0 "#PWR067" H 7700 5050 30  0001 C CNN
F 1 "GND" H 7700 4980 30  0001 C CNN
	1    7700 5050
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q15
U 2 1 4CD72D09
P 7400 5750
AR Path="/4CD72EC7/4CD72D09" Ref="Q15"  Part="2" 
AR Path="/4CD72EC1/4CD72D09" Ref="Q12"  Part="2" 
AR Path="/4CD72EB9/4CD72D09" Ref="Q9"  Part="2" 
AR Path="/4CD72EB0/4CD72D09" Ref="Q6"  Part="2" 
AR Path="/4CD72C2A/4CD72D09" Ref="Q3"  Part="2" 
F 0 "Q15" H 7410 5920 60  0000 R CNN
F 1 "AO4616" H 7410 5600 60  0000 R CNN
	2    7400 5750
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q3
U 1 1 4CD72D08
P 7400 5250
AR Path="/4CD72C2A/4CD72D08" Ref="Q3"  Part="1" 
AR Path="/4CD72EC7/4CD72D08" Ref="Q15"  Part="1" 
AR Path="/4CD72EC1/4CD72D08" Ref="Q12"  Part="1" 
AR Path="/4CD72EB9/4CD72D08" Ref="Q9"  Part="1" 
AR Path="/4CD72EB0/4CD72D08" Ref="Q6"  Part="1" 
F 0 "Q15" H 7410 5420 60  0000 R CNN
F 1 "AO4616" H 7410 5100 60  0000 R CNN
	1    7400 5250
	1    0    0    1   
$EndComp
$Comp
L R R36
U 1 1 4CD72D07
P 6900 5750
AR Path="/4CD72EC7/4CD72D07" Ref="R36"  Part="1" 
AR Path="/4CD72EC1/4CD72D07" Ref="R30"  Part="1" 
AR Path="/4CD72EB9/4CD72D07" Ref="R24"  Part="1" 
AR Path="/4CD72EB0/4CD72D07" Ref="R18"  Part="1" 
AR Path="/4CD72C2A/4CD72D07" Ref="R12"  Part="1" 
F 0 "R36" V 6980 5750 50  0000 C CNN
F 1 "47R" V 6900 5750 50  0000 C CNN
	1    6900 5750
	0    1    1    0   
$EndComp
$Comp
L R R35
U 1 1 4CD72D06
P 6900 5250
AR Path="/4CD72EC7/4CD72D06" Ref="R35"  Part="1" 
AR Path="/4CD72EC1/4CD72D06" Ref="R29"  Part="1" 
AR Path="/4CD72EB9/4CD72D06" Ref="R23"  Part="1" 
AR Path="/4CD72EB0/4CD72D06" Ref="R17"  Part="1" 
AR Path="/4CD72C2A/4CD72D06" Ref="R11"  Part="1" 
F 0 "R35" V 6980 5250 50  0000 C CNN
F 1 "47R" V 6900 5250 50  0000 C CNN
	1    6900 5250
	0    1    1    0   
$EndComp
$Comp
L TC4469 U15
U 2 1 4CD72D05
P 6000 5750
AR Path="/4CD72EC7/4CD72D05" Ref="U15"  Part="2" 
AR Path="/4CD72EC1/4CD72D05" Ref="U19"  Part="2" 
AR Path="/4CD72EB9/4CD72D05" Ref="U18"  Part="4" 
AR Path="/4CD72EB0/4CD72D05" Ref="U16"  Part="2" 
AR Path="/4CD72C2A/4CD72D05" Ref="U15"  Part="4" 
F 0 "U15" H 6000 5800 60  0000 C CNN
F 1 "TC4469" H 6000 5650 60  0000 C CNN
	2    6000 5750
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U15
U 1 1 4CD72D04
P 6000 5250
AR Path="/4CD72EC7/4CD72D04" Ref="U15"  Part="1" 
AR Path="/4CD72EC1/4CD72D04" Ref="U19"  Part="1" 
AR Path="/4CD72EB9/4CD72D04" Ref="U18"  Part="3" 
AR Path="/4CD72EB0/4CD72D04" Ref="U16"  Part="1" 
AR Path="/4CD72C2A/4CD72D04" Ref="U15"  Part="3" 
F 0 "U15" H 6000 5300 60  0000 C CNN
F 1 "TC4469" H 6000 5150 60  0000 C CNN
	1    6000 5250
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U20
U 3 1 4CD72D03
P 6000 3350
AR Path="/4CD72EC7/4CD72D03" Ref="U20"  Part="3" 
AR Path="/4CD72EC1/4CD72D03" Ref="U19"  Part="3" 
AR Path="/4CD72EB9/4CD72D03" Ref="U17"  Part="1" 
AR Path="/4CD72EB0/4CD72D03" Ref="U16"  Part="3" 
AR Path="/4CD72C2A/4CD72D03" Ref="U14"  Part="1" 
F 0 "U20" H 6000 3400 60  0000 C CNN
F 1 "TC4469" H 6000 3250 60  0000 C CNN
	3    6000 3350
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U20
U 4 1 4CD72D02
P 6000 3850
AR Path="/4CD72EC7/4CD72D02" Ref="U20"  Part="4" 
AR Path="/4CD72EC1/4CD72D02" Ref="U19"  Part="4" 
AR Path="/4CD72EB9/4CD72D02" Ref="U17"  Part="2" 
AR Path="/4CD72EB0/4CD72D02" Ref="U16"  Part="4" 
AR Path="/4CD72C2A/4CD72D02" Ref="U14"  Part="2" 
F 0 "U20" H 6000 3900 60  0000 C CNN
F 1 "TC4469" H 6000 3750 60  0000 C CNN
	4    6000 3850
	1    0    0    -1  
$EndComp
$Comp
L R R33
U 1 1 4CD72D01
P 6900 3350
AR Path="/4CD72EC7/4CD72D01" Ref="R33"  Part="1" 
AR Path="/4CD72EC1/4CD72D01" Ref="R27"  Part="1" 
AR Path="/4CD72EB9/4CD72D01" Ref="R21"  Part="1" 
AR Path="/4CD72EB0/4CD72D01" Ref="R15"  Part="1" 
AR Path="/4CD72C2A/4CD72D01" Ref="R9"  Part="1" 
F 0 "R33" V 6980 3350 50  0000 C CNN
F 1 "47R" V 6900 3350 50  0000 C CNN
	1    6900 3350
	0    1    1    0   
$EndComp
$Comp
L R R34
U 1 1 4CD72D00
P 6900 3850
AR Path="/4CD72EC7/4CD72D00" Ref="R34"  Part="1" 
AR Path="/4CD72EC1/4CD72D00" Ref="R28"  Part="1" 
AR Path="/4CD72EB9/4CD72D00" Ref="R22"  Part="1" 
AR Path="/4CD72EB0/4CD72D00" Ref="R16"  Part="1" 
AR Path="/4CD72C2A/4CD72D00" Ref="R10"  Part="1" 
F 0 "R34" V 6980 3850 50  0000 C CNN
F 1 "47R" V 6900 3850 50  0000 C CNN
	1    6900 3850
	0    1    1    0   
$EndComp
$Comp
L AO4616 Q2
U 1 1 4CD72CFF
P 7400 3350
AR Path="/4CD72C2A/4CD72CFF" Ref="Q2"  Part="1" 
AR Path="/4CD72EC7/4CD72CFF" Ref="Q14"  Part="1" 
AR Path="/4CD72EC1/4CD72CFF" Ref="Q11"  Part="1" 
AR Path="/4CD72EB9/4CD72CFF" Ref="Q8"  Part="1" 
AR Path="/4CD72EB0/4CD72CFF" Ref="Q5"  Part="1" 
F 0 "Q14" H 7410 3520 60  0000 R CNN
F 1 "AO4616" H 7410 3200 60  0000 R CNN
	1    7400 3350
	1    0    0    1   
$EndComp
$Comp
L AO4616 Q14
U 2 1 4CD72CFE
P 7400 3850
AR Path="/4CD72EC7/4CD72CFE" Ref="Q14"  Part="2" 
AR Path="/4CD72EC1/4CD72CFE" Ref="Q11"  Part="2" 
AR Path="/4CD72EB9/4CD72CFE" Ref="Q8"  Part="2" 
AR Path="/4CD72EB0/4CD72CFE" Ref="Q5"  Part="2" 
AR Path="/4CD72C2A/4CD72CFE" Ref="Q2"  Part="2" 
F 0 "Q14" H 7410 4020 60  0000 R CNN
F 1 "AO4616" H 7410 3700 60  0000 R CNN
	2    7400 3850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR044
U 1 1 4CD72CFC
P 7700 3150
AR Path="/4CD72EC7/4CD72CFC" Ref="#PWR044"  Part="1" 
AR Path="/4CD72EC1/4CD72CFC" Ref="#PWR050"  Part="1" 
AR Path="/4CD72EB9/4CD72CFC" Ref="#PWR056"  Part="1" 
AR Path="/4CD72EB0/4CD72CFC" Ref="#PWR062"  Part="1" 
AR Path="/4CD72C2A/4CD72CFC" Ref="#PWR068"  Part="1" 
F 0 "#PWR068" H 7700 3150 30  0001 C CNN
F 1 "GND" H 7700 3080 30  0001 C CNN
	1    7700 3150
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR045
U 1 1 4CD72CFB
P 7700 4050
AR Path="/4CD72EC7/4CD72CFB" Ref="#PWR045"  Part="1" 
AR Path="/4CD72EC1/4CD72CFB" Ref="#PWR051"  Part="1" 
AR Path="/4CD72EB9/4CD72CFB" Ref="#PWR057"  Part="1" 
AR Path="/4CD72EB0/4CD72CFB" Ref="#PWR063"  Part="1" 
AR Path="/4CD72C2A/4CD72CFB" Ref="#PWR069"  Part="1" 
F 0 "#PWR069" H 7700 4000 20  0001 C CNN
F 1 "+BATT" H 7700 4150 30  0000 C CNN
	1    7700 4050
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR070
U 1 1 4CD72CE4
P 7700 2050
AR Path="/4CD72C2A/4CD72CE4" Ref="#PWR070"  Part="1" 
AR Path="/4CD72EC7/4CD72CE4" Ref="#PWR046"  Part="1" 
AR Path="/4CD72EC1/4CD72CE4" Ref="#PWR052"  Part="1" 
AR Path="/4CD72EB9/4CD72CE4" Ref="#PWR058"  Part="1" 
AR Path="/4CD72EB0/4CD72CE4" Ref="#PWR064"  Part="1" 
F 0 "#PWR070" H 7700 2000 20  0001 C CNN
F 1 "+BATT" H 7700 2150 30  0000 C CNN
	1    7700 2050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR071
U 1 1 4CD72CE1
P 7700 1150
AR Path="/4CD72C2A/4CD72CE1" Ref="#PWR071"  Part="1" 
AR Path="/4CD72EC7/4CD72CE1" Ref="#PWR047"  Part="1" 
AR Path="/4CD72EC1/4CD72CE1" Ref="#PWR053"  Part="1" 
AR Path="/4CD72EB9/4CD72CE1" Ref="#PWR059"  Part="1" 
AR Path="/4CD72EB0/4CD72CE1" Ref="#PWR065"  Part="1" 
F 0 "#PWR071" H 7700 1150 30  0001 C CNN
F 1 "GND" H 7700 1080 30  0001 C CNN
	1    7700 1150
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q1
U 2 1 4CD72C5C
P 7400 1850
AR Path="/4CD72C2A/4CD72C5C" Ref="Q1"  Part="2" 
AR Path="/4CD72EC7/4CD72C5C" Ref="Q13"  Part="2" 
AR Path="/4CD72EC1/4CD72C5C" Ref="Q10"  Part="2" 
AR Path="/4CD72EB9/4CD72C5C" Ref="Q7"  Part="2" 
AR Path="/4CD72EB0/4CD72C5C" Ref="Q4"  Part="2" 
F 0 "Q13" H 7410 2020 60  0000 R CNN
F 1 "AO4616" H 7410 1700 60  0000 R CNN
	2    7400 1850
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q1
U 1 1 4CD72C5A
P 7400 1350
AR Path="/4CD72C2A/4CD72C5A" Ref="Q1"  Part="1" 
AR Path="/4CD72EC7/4CD72C5A" Ref="Q13"  Part="1" 
AR Path="/4CD72EC1/4CD72C5A" Ref="Q10"  Part="1" 
AR Path="/4CD72EB9/4CD72C5A" Ref="Q7"  Part="1" 
AR Path="/4CD72EB0/4CD72C5A" Ref="Q4"  Part="1" 
F 0 "Q13" H 7410 1520 60  0000 R CNN
F 1 "AO4616" H 7410 1200 60  0000 R CNN
	1    7400 1350
	1    0    0    1   
$EndComp
$Comp
L R R8
U 1 1 4CD72C49
P 6900 1850
AR Path="/4CD72C2A/4CD72C49" Ref="R8"  Part="1" 
AR Path="/4CD72EC7/4CD72C49" Ref="R32"  Part="1" 
AR Path="/4CD72EC1/4CD72C49" Ref="R26"  Part="1" 
AR Path="/4CD72EB9/4CD72C49" Ref="R20"  Part="1" 
AR Path="/4CD72EB0/4CD72C49" Ref="R14"  Part="1" 
F 0 "R32" V 6980 1850 50  0000 C CNN
F 1 "47R" V 6900 1850 50  0000 C CNN
	1    6900 1850
	0    1    1    0   
$EndComp
$Comp
L R R7
U 1 1 4CD72C46
P 6900 1350
AR Path="/4CD72C2A/4CD72C46" Ref="R7"  Part="1" 
AR Path="/4CD72EC7/4CD72C46" Ref="R31"  Part="1" 
AR Path="/4CD72EC1/4CD72C46" Ref="R25"  Part="1" 
AR Path="/4CD72EB9/4CD72C46" Ref="R19"  Part="1" 
AR Path="/4CD72EB0/4CD72C46" Ref="R13"  Part="1" 
F 0 "R31" V 6980 1350 50  0000 C CNN
F 1 "47R" V 6900 1350 50  0000 C CNN
	1    6900 1350
	0    1    1    0   
$EndComp
$Comp
L TC4469 U14
U 2 1 4CD72C3D
P 6000 1850
AR Path="/4CD72C2A/4CD72C3D" Ref="U14"  Part="4" 
AR Path="/4CD72EC7/4CD72C3D" Ref="U20"  Part="2" 
AR Path="/4CD72EC1/4CD72C3D" Ref="U18"  Part="2" 
AR Path="/4CD72EB9/4CD72C3D" Ref="U17"  Part="4" 
AR Path="/4CD72EB0/4CD72C3D" Ref="U21"  Part="2" 
F 0 "U20" H 6000 1900 60  0000 C CNN
F 1 "TC4469" H 6000 1750 60  0000 C CNN
	2    6000 1850
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U14
U 1 1 4CD72C3B
P 6000 1350
AR Path="/4CD72C2A/4CD72C3B" Ref="U14"  Part="3" 
AR Path="/4CD72EC7/4CD72C3B" Ref="U20"  Part="1" 
AR Path="/4CD72EC1/4CD72C3B" Ref="U18"  Part="1" 
AR Path="/4CD72EB9/4CD72C3B" Ref="U17"  Part="3" 
AR Path="/4CD72EB0/4CD72C3B" Ref="U21"  Part="1" 
F 0 "U20" H 6000 1400 60  0000 C CNN
F 1 "TC4469" H 6000 1250 60  0000 C CNN
	1    6000 1350
	1    0    0    -1  
$EndComp
$EndSCHEMATC
