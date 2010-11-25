EESchema Schematic File Version 2  date 11/25/2010 12:29:41 AM
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
Sheet 8 18
Title ""
Date "25 nov 2010"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	6550 5700 5750 5700
Wire Wire Line
	6550 1800 5750 1800
Wire Bus Line
	2800 5750 2800 1650
Wire Bus Line
	2800 1650 2650 1650
Wire Wire Line
	2900 5850 3650 5850
Wire Wire Line
	3400 3450 3650 3450
Wire Bus Line
	3300 5250 3300 950 
Wire Bus Line
	3300 950  3100 950 
Connection ~ 5750 5700
Connection ~ 5900 5700
Wire Wire Line
	5750 5650 5750 5750
Wire Wire Line
	5750 5200 5750 5250
Wire Wire Line
	4850 5950 4900 5950
Wire Wire Line
	3600 6050 3650 6050
Wire Wire Line
	5400 5450 5450 5450
Wire Wire Line
	5450 5950 5400 5950
Wire Wire Line
	3600 6100 3600 5550
Wire Wire Line
	3600 5550 3650 5550
Connection ~ 3600 6050
Wire Wire Line
	4850 5450 4900 5450
Wire Wire Line
	5750 6150 5750 6200
Wire Wire Line
	5900 5650 5900 5750
Wire Wire Line
	5900 3750 5900 3850
Wire Wire Line
	5750 4250 5750 4300
Wire Wire Line
	4850 3550 4900 3550
Connection ~ 3600 4150
Wire Wire Line
	3650 3650 3600 3650
Wire Wire Line
	3600 3650 3600 4200
Wire Wire Line
	5450 4050 5400 4050
Wire Wire Line
	5400 3550 5450 3550
Wire Wire Line
	3600 4150 3650 4150
Wire Wire Line
	4850 4050 4900 4050
Wire Wire Line
	5750 3300 5750 3350
Wire Wire Line
	5750 3750 5750 3850
Connection ~ 5900 3800
Connection ~ 5750 3800
Connection ~ 5750 1800
Connection ~ 5900 1800
Wire Wire Line
	5750 1750 5750 1850
Wire Wire Line
	5750 1300 5750 1350
Wire Wire Line
	4850 2050 4900 2050
Wire Wire Line
	3600 2150 3650 2150
Wire Wire Line
	5400 1550 5450 1550
Wire Wire Line
	5450 2050 5400 2050
Wire Wire Line
	3600 2200 3600 1650
Wire Wire Line
	3600 1650 3650 1650
Connection ~ 3600 2150
Wire Wire Line
	4850 1550 4900 1550
Wire Wire Line
	5750 2250 5750 2300
Wire Wire Line
	5900 1750 5900 1850
Wire Wire Line
	3650 5350 3400 5350
Wire Wire Line
	3400 1450 3650 1450
Wire Wire Line
	2900 1950 3650 1950
Wire Wire Line
	3650 3950 2900 3950
Wire Bus Line
	6800 6000 6650 6000
Wire Bus Line
	6650 6000 6650 1900
Wire Wire Line
	6550 3800 5750 3800
Entry Wire Line
	6550 5700 6650 5800
Entry Wire Line
	6550 3800 6650 3900
Entry Wire Line
	6550 1800 6650 1900
Text Label 6100 5700 0    60   ~ 0
PHASE3
Text Label 6100 3800 0    60   ~ 0
PHASE2
Text Label 6100 1800 0    60   ~ 0
PHASE1
Text Label 2900 5850 0    60   ~ 0
CTRL-3
Text Label 2900 3950 0    60   ~ 0
CTRL-2
Entry Wire Line
	2800 5750 2900 5850
Entry Wire Line
	2800 3850 2900 3950
Entry Wire Line
	2800 1850 2900 1950
Text Label 2900 1950 0    60   ~ 0
CTRL-1
Text Label 3400 1450 0    60   ~ 0
CTRL+1
Text Label 3400 3450 0    60   ~ 0
CTRL+2
Entry Wire Line
	3300 1350 3400 1450
Entry Wire Line
	3300 3350 3400 3450
Text Label 3400 5350 0    60   ~ 0
CTRL+3
Entry Wire Line
	3300 5250 3400 5350
Text HLabel 6800 6000 2    60   Output ~ 0
PHASE[1..3]
Text HLabel 2650 1650 0    60   Input ~ 0
CTRL-[1..3]
Text HLabel 3100 950  0    60   Input ~ 0
CTRL+[1..3]
$Comp
L +BATT #PWR013
U 1 1 4CD72D0C
P 5750 5200
AR Path="/4CD72EC7/4CD72D0C" Ref="#PWR013"  Part="1" 
AR Path="/4CD72EC1/4CD72D0C" Ref="#PWR022"  Part="1" 
AR Path="/4CD72EB9/4CD72D0C" Ref="#PWR031"  Part="1" 
AR Path="/4CD72EB0/4CD72D0C" Ref="#PWR040"  Part="1" 
AR Path="/4CD72C2A/4CD72D0C" Ref="#PWR049"  Part="1" 
F 0 "#PWR013" H 5750 5150 20  0001 C CNN
F 1 "+BATT" H 5750 5300 30  0000 C CNN
	1    5750 5200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR014
U 1 1 4CD72D0B
P 5750 6200
AR Path="/4CD72EC7/4CD72D0B" Ref="#PWR014"  Part="1" 
AR Path="/4CD72EC1/4CD72D0B" Ref="#PWR023"  Part="1" 
AR Path="/4CD72EB9/4CD72D0B" Ref="#PWR032"  Part="1" 
AR Path="/4CD72EB0/4CD72D0B" Ref="#PWR041"  Part="1" 
AR Path="/4CD72C2A/4CD72D0B" Ref="#PWR050"  Part="1" 
F 0 "#PWR014" H 5750 6200 30  0001 C CNN
F 1 "GND" H 5750 6130 30  0001 C CNN
	1    5750 6200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR015
U 1 1 4CD72D0A
P 3600 6100
AR Path="/4CD72EC7/4CD72D0A" Ref="#PWR015"  Part="1" 
AR Path="/4CD72EC1/4CD72D0A" Ref="#PWR024"  Part="1" 
AR Path="/4CD72EB9/4CD72D0A" Ref="#PWR033"  Part="1" 
AR Path="/4CD72EB0/4CD72D0A" Ref="#PWR042"  Part="1" 
AR Path="/4CD72C2A/4CD72D0A" Ref="#PWR051"  Part="1" 
F 0 "#PWR015" H 3600 6100 30  0001 C CNN
F 1 "GND" H 3600 6030 30  0001 C CNN
	1    3600 6100
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q15
U 2 1 4CD72D09
P 5650 5950
AR Path="/4CD72EC7/4CD72D09" Ref="Q15"  Part="2" 
AR Path="/4CD72EC1/4CD72D09" Ref="Q12"  Part="2" 
AR Path="/4CD72EB9/4CD72D09" Ref="Q9"  Part="2" 
AR Path="/4CD72EB0/4CD72D09" Ref="Q6"  Part="2" 
AR Path="/4CD72C2A/4CD72D09" Ref="Q3"  Part="2" 
F 0 "Q15" H 5660 6120 60  0000 R CNN
F 1 "AO4616" H 5660 5800 60  0000 R CNN
	2    5650 5950
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q3
U 1 1 4CD72D08
P 5650 5450
AR Path="/4CD72C2A/4CD72D08" Ref="Q3"  Part="1" 
AR Path="/4CD72EC7/4CD72D08" Ref="Q15"  Part="1" 
AR Path="/4CD72EC1/4CD72D08" Ref="Q12"  Part="1" 
AR Path="/4CD72EB9/4CD72D08" Ref="Q9"  Part="1" 
AR Path="/4CD72EB0/4CD72D08" Ref="Q6"  Part="1" 
F 0 "Q15" H 5660 5620 60  0000 R CNN
F 1 "AO4616" H 5660 5300 60  0000 R CNN
	1    5650 5450
	1    0    0    1   
$EndComp
$Comp
L R R36
U 1 1 4CD72D07
P 5150 5950
AR Path="/4CD72EC7/4CD72D07" Ref="R36"  Part="1" 
AR Path="/4CD72EC1/4CD72D07" Ref="R30"  Part="1" 
AR Path="/4CD72EB9/4CD72D07" Ref="R24"  Part="1" 
AR Path="/4CD72EB0/4CD72D07" Ref="R18"  Part="1" 
AR Path="/4CD72C2A/4CD72D07" Ref="R12"  Part="1" 
F 0 "R36" V 5230 5950 50  0000 C CNN
F 1 "47R" V 5150 5950 50  0000 C CNN
	1    5150 5950
	0    1    1    0   
$EndComp
$Comp
L R R35
U 1 1 4CD72D06
P 5150 5450
AR Path="/4CD72EC7/4CD72D06" Ref="R35"  Part="1" 
AR Path="/4CD72EC1/4CD72D06" Ref="R29"  Part="1" 
AR Path="/4CD72EB9/4CD72D06" Ref="R23"  Part="1" 
AR Path="/4CD72EB0/4CD72D06" Ref="R17"  Part="1" 
AR Path="/4CD72C2A/4CD72D06" Ref="R11"  Part="1" 
F 0 "R35" V 5230 5450 50  0000 C CNN
F 1 "47R" V 5150 5450 50  0000 C CNN
	1    5150 5450
	0    1    1    0   
$EndComp
$Comp
L TC4469 U15
U 2 1 4CD72D05
P 4250 5950
AR Path="/4CD72EC7/4CD72D05" Ref="U15"  Part="2" 
AR Path="/4CD72EC1/4CD72D05" Ref="U19"  Part="2" 
AR Path="/4CD72EB9/4CD72D05" Ref="U18"  Part="4" 
AR Path="/4CD72EB0/4CD72D05" Ref="U16"  Part="2" 
AR Path="/4CD72C2A/4CD72D05" Ref="U15"  Part="4" 
F 0 "U15" H 4250 6000 60  0000 C CNN
F 1 "TC4469" H 4250 5850 60  0000 C CNN
	2    4250 5950
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U15
U 1 1 4CD72D04
P 4250 5450
AR Path="/4CD72EC7/4CD72D04" Ref="U15"  Part="1" 
AR Path="/4CD72EC1/4CD72D04" Ref="U19"  Part="1" 
AR Path="/4CD72EB9/4CD72D04" Ref="U18"  Part="3" 
AR Path="/4CD72EB0/4CD72D04" Ref="U16"  Part="1" 
AR Path="/4CD72C2A/4CD72D04" Ref="U15"  Part="3" 
F 0 "U15" H 4250 5500 60  0000 C CNN
F 1 "TC4469" H 4250 5350 60  0000 C CNN
	1    4250 5450
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U20
U 3 1 4CD72D03
P 4250 3550
AR Path="/4CD72EC7/4CD72D03" Ref="U20"  Part="3" 
AR Path="/4CD72EC1/4CD72D03" Ref="U19"  Part="3" 
AR Path="/4CD72EB9/4CD72D03" Ref="U17"  Part="1" 
AR Path="/4CD72EB0/4CD72D03" Ref="U16"  Part="3" 
AR Path="/4CD72C2A/4CD72D03" Ref="U14"  Part="1" 
F 0 "U20" H 4250 3600 60  0000 C CNN
F 1 "TC4469" H 4250 3450 60  0000 C CNN
	3    4250 3550
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U20
U 4 1 4CD72D02
P 4250 4050
AR Path="/4CD72EC7/4CD72D02" Ref="U20"  Part="4" 
AR Path="/4CD72EC1/4CD72D02" Ref="U19"  Part="4" 
AR Path="/4CD72EB9/4CD72D02" Ref="U17"  Part="2" 
AR Path="/4CD72EB0/4CD72D02" Ref="U16"  Part="4" 
AR Path="/4CD72C2A/4CD72D02" Ref="U14"  Part="2" 
F 0 "U20" H 4250 4100 60  0000 C CNN
F 1 "TC4469" H 4250 3950 60  0000 C CNN
	4    4250 4050
	1    0    0    -1  
$EndComp
$Comp
L R R33
U 1 1 4CD72D01
P 5150 3550
AR Path="/4CD72EC7/4CD72D01" Ref="R33"  Part="1" 
AR Path="/4CD72EC1/4CD72D01" Ref="R27"  Part="1" 
AR Path="/4CD72EB9/4CD72D01" Ref="R21"  Part="1" 
AR Path="/4CD72EB0/4CD72D01" Ref="R15"  Part="1" 
AR Path="/4CD72C2A/4CD72D01" Ref="R9"  Part="1" 
F 0 "R33" V 5230 3550 50  0000 C CNN
F 1 "47R" V 5150 3550 50  0000 C CNN
	1    5150 3550
	0    1    1    0   
$EndComp
$Comp
L R R34
U 1 1 4CD72D00
P 5150 4050
AR Path="/4CD72EC7/4CD72D00" Ref="R34"  Part="1" 
AR Path="/4CD72EC1/4CD72D00" Ref="R28"  Part="1" 
AR Path="/4CD72EB9/4CD72D00" Ref="R22"  Part="1" 
AR Path="/4CD72EB0/4CD72D00" Ref="R16"  Part="1" 
AR Path="/4CD72C2A/4CD72D00" Ref="R10"  Part="1" 
F 0 "R34" V 5230 4050 50  0000 C CNN
F 1 "47R" V 5150 4050 50  0000 C CNN
	1    5150 4050
	0    1    1    0   
$EndComp
$Comp
L AO4616 Q2
U 1 1 4CD72CFF
P 5650 3550
AR Path="/4CD72C2A/4CD72CFF" Ref="Q2"  Part="1" 
AR Path="/4CD72EC7/4CD72CFF" Ref="Q14"  Part="1" 
AR Path="/4CD72EC1/4CD72CFF" Ref="Q11"  Part="1" 
AR Path="/4CD72EB9/4CD72CFF" Ref="Q8"  Part="1" 
AR Path="/4CD72EB0/4CD72CFF" Ref="Q5"  Part="1" 
F 0 "Q14" H 5660 3720 60  0000 R CNN
F 1 "AO4616" H 5660 3400 60  0000 R CNN
	1    5650 3550
	1    0    0    1   
$EndComp
$Comp
L AO4616 Q14
U 2 1 4CD72CFE
P 5650 4050
AR Path="/4CD72EC7/4CD72CFE" Ref="Q14"  Part="2" 
AR Path="/4CD72EC1/4CD72CFE" Ref="Q11"  Part="2" 
AR Path="/4CD72EB9/4CD72CFE" Ref="Q8"  Part="2" 
AR Path="/4CD72EB0/4CD72CFE" Ref="Q5"  Part="2" 
AR Path="/4CD72C2A/4CD72CFE" Ref="Q2"  Part="2" 
F 0 "Q14" H 5660 4220 60  0000 R CNN
F 1 "AO4616" H 5660 3900 60  0000 R CNN
	2    5650 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR016
U 1 1 4CD72CFD
P 3600 4200
AR Path="/4CD72EC7/4CD72CFD" Ref="#PWR016"  Part="1" 
AR Path="/4CD72EC1/4CD72CFD" Ref="#PWR025"  Part="1" 
AR Path="/4CD72EB9/4CD72CFD" Ref="#PWR034"  Part="1" 
AR Path="/4CD72EB0/4CD72CFD" Ref="#PWR043"  Part="1" 
AR Path="/4CD72C2A/4CD72CFD" Ref="#PWR052"  Part="1" 
F 0 "#PWR016" H 3600 4200 30  0001 C CNN
F 1 "GND" H 3600 4130 30  0001 C CNN
	1    3600 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR017
U 1 1 4CD72CFC
P 5750 4300
AR Path="/4CD72EC7/4CD72CFC" Ref="#PWR017"  Part="1" 
AR Path="/4CD72EC1/4CD72CFC" Ref="#PWR026"  Part="1" 
AR Path="/4CD72EB9/4CD72CFC" Ref="#PWR035"  Part="1" 
AR Path="/4CD72EB0/4CD72CFC" Ref="#PWR044"  Part="1" 
AR Path="/4CD72C2A/4CD72CFC" Ref="#PWR053"  Part="1" 
F 0 "#PWR017" H 5750 4300 30  0001 C CNN
F 1 "GND" H 5750 4230 30  0001 C CNN
	1    5750 4300
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR018
U 1 1 4CD72CFB
P 5750 3300
AR Path="/4CD72EC7/4CD72CFB" Ref="#PWR018"  Part="1" 
AR Path="/4CD72EC1/4CD72CFB" Ref="#PWR027"  Part="1" 
AR Path="/4CD72EB9/4CD72CFB" Ref="#PWR036"  Part="1" 
AR Path="/4CD72EB0/4CD72CFB" Ref="#PWR045"  Part="1" 
AR Path="/4CD72C2A/4CD72CFB" Ref="#PWR054"  Part="1" 
F 0 "#PWR018" H 5750 3250 20  0001 C CNN
F 1 "+BATT" H 5750 3400 30  0000 C CNN
	1    5750 3300
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR055
U 1 1 4CD72CE4
P 5750 1300
AR Path="/4CD72C2A/4CD72CE4" Ref="#PWR055"  Part="1" 
AR Path="/4CD72EC7/4CD72CE4" Ref="#PWR019"  Part="1" 
AR Path="/4CD72EC1/4CD72CE4" Ref="#PWR028"  Part="1" 
AR Path="/4CD72EB9/4CD72CE4" Ref="#PWR037"  Part="1" 
AR Path="/4CD72EB0/4CD72CE4" Ref="#PWR046"  Part="1" 
F 0 "#PWR019" H 5750 1250 20  0001 C CNN
F 1 "+BATT" H 5750 1400 30  0000 C CNN
	1    5750 1300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR056
U 1 1 4CD72CE1
P 5750 2300
AR Path="/4CD72C2A/4CD72CE1" Ref="#PWR056"  Part="1" 
AR Path="/4CD72EC7/4CD72CE1" Ref="#PWR020"  Part="1" 
AR Path="/4CD72EC1/4CD72CE1" Ref="#PWR029"  Part="1" 
AR Path="/4CD72EB9/4CD72CE1" Ref="#PWR038"  Part="1" 
AR Path="/4CD72EB0/4CD72CE1" Ref="#PWR047"  Part="1" 
F 0 "#PWR020" H 5750 2300 30  0001 C CNN
F 1 "GND" H 5750 2230 30  0001 C CNN
	1    5750 2300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR057
U 1 1 4CD72CCD
P 3600 2200
AR Path="/4CD72C2A/4CD72CCD" Ref="#PWR057"  Part="1" 
AR Path="/4CD72EC7/4CD72CCD" Ref="#PWR021"  Part="1" 
AR Path="/4CD72EC1/4CD72CCD" Ref="#PWR030"  Part="1" 
AR Path="/4CD72EB9/4CD72CCD" Ref="#PWR039"  Part="1" 
AR Path="/4CD72EB0/4CD72CCD" Ref="#PWR048"  Part="1" 
F 0 "#PWR021" H 3600 2200 30  0001 C CNN
F 1 "GND" H 3600 2130 30  0001 C CNN
	1    3600 2200
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q1
U 2 1 4CD72C5C
P 5650 2050
AR Path="/4CD72C2A/4CD72C5C" Ref="Q1"  Part="2" 
AR Path="/4CD72EC7/4CD72C5C" Ref="Q13"  Part="2" 
AR Path="/4CD72EC1/4CD72C5C" Ref="Q10"  Part="2" 
AR Path="/4CD72EB9/4CD72C5C" Ref="Q7"  Part="2" 
AR Path="/4CD72EB0/4CD72C5C" Ref="Q4"  Part="2" 
F 0 "Q13" H 5660 2220 60  0000 R CNN
F 1 "AO4616" H 5660 1900 60  0000 R CNN
	2    5650 2050
	1    0    0    -1  
$EndComp
$Comp
L AO4616 Q1
U 1 1 4CD72C5A
P 5650 1550
AR Path="/4CD72C2A/4CD72C5A" Ref="Q1"  Part="1" 
AR Path="/4CD72EC7/4CD72C5A" Ref="Q13"  Part="1" 
AR Path="/4CD72EC1/4CD72C5A" Ref="Q10"  Part="1" 
AR Path="/4CD72EB9/4CD72C5A" Ref="Q7"  Part="1" 
AR Path="/4CD72EB0/4CD72C5A" Ref="Q4"  Part="1" 
F 0 "Q13" H 5660 1720 60  0000 R CNN
F 1 "AO4616" H 5660 1400 60  0000 R CNN
	1    5650 1550
	1    0    0    1   
$EndComp
$Comp
L R R8
U 1 1 4CD72C49
P 5150 2050
AR Path="/4CD72C2A/4CD72C49" Ref="R8"  Part="1" 
AR Path="/4CD72EC7/4CD72C49" Ref="R32"  Part="1" 
AR Path="/4CD72EC1/4CD72C49" Ref="R26"  Part="1" 
AR Path="/4CD72EB9/4CD72C49" Ref="R20"  Part="1" 
AR Path="/4CD72EB0/4CD72C49" Ref="R14"  Part="1" 
F 0 "R32" V 5230 2050 50  0000 C CNN
F 1 "47R" V 5150 2050 50  0000 C CNN
	1    5150 2050
	0    1    1    0   
$EndComp
$Comp
L R R7
U 1 1 4CD72C46
P 5150 1550
AR Path="/4CD72C2A/4CD72C46" Ref="R7"  Part="1" 
AR Path="/4CD72EC7/4CD72C46" Ref="R31"  Part="1" 
AR Path="/4CD72EC1/4CD72C46" Ref="R25"  Part="1" 
AR Path="/4CD72EB9/4CD72C46" Ref="R19"  Part="1" 
AR Path="/4CD72EB0/4CD72C46" Ref="R13"  Part="1" 
F 0 "R31" V 5230 1550 50  0000 C CNN
F 1 "47R" V 5150 1550 50  0000 C CNN
	1    5150 1550
	0    1    1    0   
$EndComp
$Comp
L TC4469 U14
U 2 1 4CD72C3D
P 4250 2050
AR Path="/4CD72C2A/4CD72C3D" Ref="U14"  Part="4" 
AR Path="/4CD72EC7/4CD72C3D" Ref="U20"  Part="2" 
AR Path="/4CD72EC1/4CD72C3D" Ref="U18"  Part="2" 
AR Path="/4CD72EB9/4CD72C3D" Ref="U17"  Part="4" 
AR Path="/4CD72EB0/4CD72C3D" Ref="U21"  Part="2" 
F 0 "U20" H 4250 2100 60  0000 C CNN
F 1 "TC4469" H 4250 1950 60  0000 C CNN
	2    4250 2050
	1    0    0    -1  
$EndComp
$Comp
L TC4469 U14
U 1 1 4CD72C3B
P 4250 1550
AR Path="/4CD72C2A/4CD72C3B" Ref="U14"  Part="3" 
AR Path="/4CD72EC7/4CD72C3B" Ref="U20"  Part="1" 
AR Path="/4CD72EC1/4CD72C3B" Ref="U18"  Part="1" 
AR Path="/4CD72EB9/4CD72C3B" Ref="U17"  Part="3" 
AR Path="/4CD72EB0/4CD72C3B" Ref="U21"  Part="1" 
F 0 "U20" H 4250 1600 60  0000 C CNN
F 1 "TC4469" H 4250 1450 60  0000 C CNN
	1    4250 1550
	1    0    0    -1  
$EndComp
$EndSCHEMATC
