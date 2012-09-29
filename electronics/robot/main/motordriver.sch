EESchema Schematic File Version 2  date 2012-09-29T16:13:15 PDT
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
Sheet 2 14
Title ""
Date "29 sep 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	9050 3000 9050 3050
Connection ~ 8050 3250
Wire Wire Line
	8050 3200 8050 3250
Wire Wire Line
	7000 3400 7300 3400
Wire Wire Line
	8250 3350 7400 3350
Wire Wire Line
	7400 3350 7400 3500
Wire Wire Line
	7400 3500 7000 3500
Wire Wire Line
	8100 3600 8150 3600
Wire Wire Line
	5200 3700 4400 3700
Wire Wire Line
	7650 3700 7000 3700
Wire Wire Line
	7050 4000 7000 4000
Wire Bus Line
	4500 3700 4500 2950
Wire Wire Line
	5200 3800 4600 3800
Wire Wire Line
	5200 3400 4750 3400
Wire Bus Line
	4600 2850 7600 2850
Wire Wire Line
	7000 3800 7400 3800
Wire Wire Line
	7000 3900 7500 3900
Wire Wire Line
	5150 3300 5200 3300
Wire Wire Line
	7000 4100 7050 4100
Wire Wire Line
	5150 3200 5200 3200
Wire Wire Line
	5200 4100 5150 4100
Wire Wire Line
	7000 3200 7050 3200
Wire Wire Line
	7050 3300 7000 3300
Wire Bus Line
	7600 2850 7600 3800
Wire Bus Line
	7500 3700 7500 2950
Wire Bus Line
	7500 2950 4450 2950
Wire Bus Line
	4650 3800 4650 2850
Wire Wire Line
	4750 3900 5200 3900
Wire Wire Line
	4600 3500 5200 3500
Wire Wire Line
	5150 4000 5200 4000
Wire Bus Line
	7750 4600 7750 3800
Wire Wire Line
	4400 3600 5200 3600
Wire Bus Line
	4300 3700 4300 4600
Wire Bus Line
	4300 4600 7800 4600
Wire Wire Line
	7700 3600 7000 3600
Wire Wire Line
	7300 3400 7300 3250
Wire Wire Line
	7300 3250 8250 3250
Wire Wire Line
	8050 2750 8050 2800
Wire Wire Line
	9050 3500 9050 3450
$Comp
L +HVBATT #PWR?
U 1 1 00000000
P 9050 3000
AR Path="/4CD72C2A/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 9050 2950 20  0001 C CNN
F 1 "+HVBATT" H 9050 3100 30  0000 C CNN
	1    9050 3000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 9050 3500
AR Path="/4CD72C2A/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 9050 3500 30  0001 C CNN
F 1 "GND" H 9050 3430 30  0001 C CNN
	1    9050 3500
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 00000000
P 9050 3250
AR Path="/4CD72C2A/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="C?"  Part="1" 
F 0 "C?" H 9100 3350 50  0000 L CNN
F 1 "100nF" H 9100 3150 50  0000 L CNN
	1    9050 3250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 8050 2750
AR Path="/4CD72C2A/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 8050 2750 30  0001 C CNN
F 1 "GND" H 8050 2680 30  0001 C CNN
	1    8050 2750
	-1   0    0    1   
$EndComp
$Comp
L C C?
U 1 1 00000000
P 8050 3000
AR Path="/4CD72C2A/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="C?"  Part="1" 
F 0 "C?" H 8100 3100 50  0000 L CNN
F 1 "220nF" H 8100 2900 50  0000 L CNN
	1    8050 3000
	1    0    0    -1  
$EndComp
Text HLabel 8250 3250 2    60   Input ~ 0
VBOOT
Text HLabel 8250 3350 2    60   Output ~ 0
VCP
$Comp
L GND #PWR?
U 1 1 00000000
P 8150 3600
AR Path="/4CD72C2A/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 8150 3600 30  0001 C CNN
F 1 "GND" H 8150 3530 30  0001 C CNN
	1    8150 3600
	0    -1   -1   0   
$EndComp
$Comp
L C C?
U 1 1 00000000
P 7900 3600
AR Path="/4CD72C2A/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="C?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="C?"  Part="1" 
F 0 "C?" H 7950 3700 50  0000 L CNN
F 1 "1uF" H 7950 3500 50  0000 L CNN
	1    7900 3600
	0    -1   -1   0   
$EndComp
Text Label 5150 3600 2    60   ~ 0
PHASE1
Text Label 5150 3700 2    60   ~ 0
PHASE0
Entry Wire Line
	4300 3800 4400 3700
Entry Wire Line
	4300 3700 4400 3600
Text Label 7050 3700 0    60   ~ 0
PHASE2
Entry Wire Line
	7650 3700 7750 3800
$Comp
L +HVBATT #PWR?
U 1 1 00000000
P 7050 4000
AR Path="/4CD72C2A/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 7050 3950 20  0001 C CNN
F 1 "+HVBATT" H 7050 4100 30  0000 C CNN
	1    7050 4000
	0    1    1    0   
$EndComp
$Comp
L +HVBATT #PWR?
U 1 1 00000000
P 5150 4000
AR Path="/4CD72C2A/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 5150 3950 20  0001 C CNN
F 1 "+HVBATT" H 5150 4100 30  0000 C CNN
	1    5150 4000
	0    -1   -1   0   
$EndComp
Entry Wire Line
	4500 3700 4600 3800
Entry Wire Line
	4500 3400 4600 3500
Entry Wire Line
	4650 3800 4750 3900
Entry Wire Line
	4650 3300 4750 3400
Text Label 5150 3900 2    60   ~ 0
ENABLE0
Text Label 5150 3800 2    60   ~ 0
LEVEL0
Text Label 5150 3500 2    60   ~ 0
LEVEL1
Text Label 5150 3400 2    60   ~ 0
ENABLE1
Entry Wire Line
	7400 3800 7500 3700
Text Label 7050 3800 0    60   ~ 0
LEVEL2
Entry Wire Line
	7500 3900 7600 3800
Text Label 7050 3900 0    60   ~ 0
ENABLE2
$Comp
L GND #PWR?
U 1 1 50677277
P 7050 3300
AR Path="/4CD72C2A/50677277" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/50677277" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/50677277" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/50677277" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/50677277" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 7050 3300 30  0001 C CNN
F 1 "GND" H 7050 3230 30  0001 C CNN
	1    7050 3300
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 50677275
P 5150 3300
AR Path="/4CD72C2A/50677275" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/50677275" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/50677275" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/50677275" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/50677275" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 5150 3300 30  0001 C CNN
F 1 "GND" H 5150 3230 30  0001 C CNN
	1    5150 3300
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 50677201
P 7050 3200
AR Path="/4CD72C2A/50677201" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/50677201" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/50677201" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/50677201" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/50677201" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 7050 3200 30  0001 C CNN
F 1 "GND" H 7050 3130 30  0001 C CNN
	1    7050 3200
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 50677200
P 7050 4100
AR Path="/4CD72C2A/50677200" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/50677200" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/50677200" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/50677200" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/50677200" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 7050 4100 30  0001 C CNN
F 1 "GND" H 7050 4030 30  0001 C CNN
	1    7050 4100
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 506771FE
P 5150 4100
AR Path="/4CD72C2A/506771FE" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/506771FE" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/506771FE" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/506771FE" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/506771FE" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 5150 4100 30  0001 C CNN
F 1 "GND" H 5150 4030 30  0001 C CNN
	1    5150 4100
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 00000000
P 5150 3200
AR Path="/4CD72C2A/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="#PWR?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 5150 3200 30  0001 C CNN
F 1 "GND" H 5150 3130 30  0001 C CNN
	1    5150 3200
	0    1    1    0   
$EndComp
$Comp
L L6234-SO20 U?
U 1 1 00000000
P 6100 3650
AR Path="/4CD72C2A/00000000" Ref="U?"  Part="1" 
AR Path="/4CD72EB0/00000000" Ref="U?"  Part="1" 
AR Path="/4CD72EC7/00000000" Ref="U?"  Part="1" 
AR Path="/4CD72EC1/00000000" Ref="U?"  Part="1" 
AR Path="/4CD72EB9/00000000" Ref="U?"  Part="1" 
F 0 "U?" H 6100 3600 60  0000 C CNN
F 1 "L6234-SO20" H 6100 3700 60  0000 C CNN
F 4 "497-5352-1-ND" H 6100 4200 60  0001 C CNN "Digi-Key Part"
	1    6100 3650
	1    0    0    -1  
$EndComp
Text HLabel 7800 4600 2    60   Output ~ 0
PHASE[0..2]
Text HLabel 4450 2950 0    60   Input ~ 0
LEVEL[0..2]
Text HLabel 4600 2850 0    60   Input ~ 0
ENABLE[0..2]
$EndSCHEMATC
