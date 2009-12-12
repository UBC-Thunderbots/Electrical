EESchema Schematic File Version 2  date 08/12/2009 11:04:10 PM
LIBS:power,../thunderbots-symbols,device,transistors,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,opto,atmel,contrib,valves,.\Sensor.cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 5
Title ""
Date "9 dec 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 1600 4400
Wire Wire Line
	2000 4400 1600 4400
Connection ~ 1550 3900
Wire Wire Line
	1550 3700 1550 3900
Wire Wire Line
	8150 4650 8150 4750
Connection ~ 7000 2600
Connection ~ 7000 3800
Wire Wire Line
	7000 2600 7000 3800
Wire Wire Line
	8150 2800 8150 3000
Wire Wire Line
	8150 1400 8150 1650
Connection ~ 3550 2500
Wire Wire Line
	3550 2500 3550 1450
Wire Wire Line
	3550 1450 5900 1450
Wire Wire Line
	5900 1450 5900 2400
Wire Wire Line
	5900 2400 5350 2400
Wire Wire Line
	4650 3050 4650 3200
Connection ~ 8250 3800
Wire Wire Line
	8250 3800 8250 4500
Wire Wire Line
	8250 4500 8000 4500
Wire Wire Line
	4100 3800 10500 3800
Wire Wire Line
	10500 3800 10500 4850
Wire Wire Line
	10500 4850 9950 4850
Wire Wire Line
	4500 4050 4250 4050
Wire Wire Line
	2350 3550 2350 3700
Wire Wire Line
	2350 3700 2550 3700
Wire Wire Line
	1650 3800 1650 3900
Wire Wire Line
	1650 3900 1500 3900
Wire Wire Line
	1500 4200 1600 4200
Wire Wire Line
	2550 4500 2300 4500
Wire Wire Line
	2300 4500 2300 4650
Wire Wire Line
	1500 4100 2550 4100
Wire Wire Line
	4500 4850 4250 4850
Wire Wire Line
	4250 4850 4250 5000
Wire Wire Line
	4100 4450 4500 4450
Wire Wire Line
	6450 5200 6200 5200
Wire Wire Line
	6200 5200 6200 5350
Wire Wire Line
	6050 4800 6450 4800
Wire Wire Line
	8150 4750 8400 4750
Wire Wire Line
	8400 5550 8150 5550
Wire Wire Line
	8150 5550 8150 5700
Wire Wire Line
	8000 5150 8400 5150
Wire Wire Line
	6050 4150 6200 4150
Wire Wire Line
	6200 4150 6200 3800
Connection ~ 6200 3800
Wire Wire Line
	4650 1800 4650 1950
Wire Wire Line
	3750 2500 1900 2500
Wire Wire Line
	1900 2500 1900 4000
Wire Wire Line
	1900 4000 1500 4000
Wire Wire Line
	8150 2150 8150 2300
Wire Wire Line
	5350 2600 7400 2600
Wire Wire Line
	7400 2600 7400 2200
Wire Wire Line
	7400 2200 8150 2200
Connection ~ 8150 2200
Wire Wire Line
	4250 4050 4250 3950
Wire Wire Line
	6450 4400 6200 4400
Wire Wire Line
	6200 4400 6200 4300
Wire Wire Line
	1600 4200 1600 4550
$Comp
L PWR_FLAG #FLG01
U 1 1 4B1F49AF
P 2000 4400
F 0 "#FLG01" H 2000 4670 30  0001 C CNN
F 1 "PWR_FLAG" H 2000 4630 30  0000 C CNN
	1    2000 4400
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG02
U 1 1 4B1F492B
P 1550 3700
F 0 "#FLG02" H 1550 3970 30  0001 C CNN
F 1 "PWR_FLAG" H 1550 3930 30  0000 C CNN
	1    1550 3700
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR03
U 1 1 4B1F4906
P 6200 4300
F 0 "#PWR03" H 6200 4400 30  0001 C CNN
F 1 "VCC" H 6200 4400 30  0000 C CNN
	1    6200 4300
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR04
U 1 1 4B1F4757
P 8150 1400
F 0 "#PWR04" H 8150 1500 30  0001 C CNN
F 1 "VCC" H 8150 1500 30  0000 C CNN
	1    8150 1400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 4B1F4752
P 8150 3000
F 0 "#PWR05" H 8150 3000 30  0001 C CNN
F 1 "GND" H 8150 2930 30  0001 C CNN
	1    8150 3000
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 4B1F474B
P 8150 2550
F 0 "R2" V 8230 2550 50  0000 C CNN
F 1 "R" V 8150 2550 50  0000 C CNN
	1    8150 2550
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4B1F4749
P 8150 1900
F 0 "R1" V 8230 1900 50  0000 C CNN
F 1 "R" V 8150 1900 50  0000 C CNN
	1    8150 1900
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR06
U 1 1 4B1F4722
P 4650 1800
F 0 "#PWR06" H 4650 1900 30  0001 C CNN
F 1 "VCC" H 4650 1900 30  0000 C CNN
	1    4650 1800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 4B1F471D
P 4650 3200
F 0 "#PWR07" H 4650 3200 30  0001 C CNN
F 1 "GND" H 4650 3130 30  0001 C CNN
	1    4650 3200
	1    0    0    -1  
$EndComp
$Comp
L MIC7300 U1
U 1 1 4B1F46E6
P 4550 2500
F 0 "U1" H 4550 2550 60  0000 C CNN
F 1 "MIC7300" H 4550 2450 60  0000 C CNN
	1    4550 2500
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 4B1F4686
P 8150 5700
F 0 "#PWR08" H 8150 5700 30  0001 C CNN
F 1 "GND" H 8150 5630 30  0001 C CNN
	1    8150 5700
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR09
U 1 1 4B1F4685
P 8150 4650
F 0 "#PWR09" H 8150 4750 30  0001 C CNN
F 1 "VCC" H 8150 4750 30  0000 C CNN
	1    8150 4650
	1    0    0    -1  
$EndComp
$Sheet
S 8400 4650 1550 1050
U 4B1F4684
F0 "FlipFlopDiode" 60
F1 "FlopflopDiode.sch" 60
F2 "Analog" O R 9950 4850 60 
F3 "CLK Out" O R 9950 5500 60 
F4 "Vcc" I L 8400 4750 60 
F5 "CLK In" I L 8400 5150 60 
F6 "GND" I L 8400 5550 60 
$EndSheet
$Comp
L GND #PWR010
U 1 1 4B1F467D
P 6200 5350
F 0 "#PWR010" H 6200 5350 30  0001 C CNN
F 1 "GND" H 6200 5280 30  0001 C CNN
	1    6200 5350
	1    0    0    -1  
$EndComp
$Sheet
S 6450 4300 1550 1050
U 4B1F467B
F0 "FlipFlopDiode" 60
F1 "FlopflopDiode.sch" 60
F2 "Analog" O R 8000 4500 60 
F3 "CLK Out" O R 8000 5150 60 
F4 "Vcc" I L 6450 4400 60 
F5 "CLK In" I L 6450 4800 60 
F6 "GND" I L 6450 5200 60 
$EndSheet
$Comp
L GND #PWR011
U 1 1 4B1F45E1
P 4250 5000
F 0 "#PWR011" H 4250 5000 30  0001 C CNN
F 1 "GND" H 4250 4930 30  0001 C CNN
	1    4250 5000
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR012
U 1 1 4B1F45E0
P 4250 3950
F 0 "#PWR012" H 4250 4050 30  0001 C CNN
F 1 "VCC" H 4250 4050 30  0000 C CNN
	1    4250 3950
	1    0    0    -1  
$EndComp
$Sheet
S 4500 3950 1550 1050
U 4B1F45DF
F0 "FlipFlopDiode" 60
F1 "FlopflopDiode.sch" 60
F2 "Analog" O R 6050 4150 60 
F3 "CLK Out" O R 6050 4800 60 
F4 "Vcc" I L 4500 4050 60 
F5 "CLK In" I L 4500 4450 60 
F6 "GND" I L 4500 4850 60 
$EndSheet
$Comp
L GND #PWR013
U 1 1 4B1F45AD
P 2300 4650
F 0 "#PWR013" H 2300 4650 30  0001 C CNN
F 1 "GND" H 2300 4580 30  0001 C CNN
	1    2300 4650
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR014
U 1 1 4B1F45AA
P 2350 3550
F 0 "#PWR014" H 2350 3650 30  0001 C CNN
F 1 "VCC" H 2350 3650 30  0000 C CNN
	1    2350 3550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR015
U 1 1 4B1F4585
P 1600 4550
F 0 "#PWR015" H 1600 4550 30  0001 C CNN
F 1 "GND" H 1600 4480 30  0001 C CNN
	1    1600 4550
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR016
U 1 1 4B1F457A
P 1650 3800
F 0 "#PWR016" H 1650 3900 30  0001 C CNN
F 1 "VCC" H 1650 3900 30  0000 C CNN
	1    1650 3800
	1    0    0    -1  
$EndComp
$Sheet
S 2550 3600 1550 1050
U 4B1F40D4
F0 "FlipFlopDiode" 60
F1 "FlopflopDiode.sch" 60
F2 "Analog" O R 4100 3800 60 
F3 "CLK Out" O R 4100 4450 60 
F4 "Vcc" I L 2550 3700 60 
F5 "CLK In" I L 2550 4100 60 
F6 "GND" I L 2550 4500 60 
$EndSheet
$Comp
L CONN_4 P1
U 1 1 4B1F3C5A
P 1150 4050
F 0 "P1" V 1100 4050 50  0000 C CNN
F 1 "CONN_4" V 1200 4050 50  0000 C CNN
	1    1150 4050
	-1   0    0    1   
$EndComp
$EndSCHEMATC
