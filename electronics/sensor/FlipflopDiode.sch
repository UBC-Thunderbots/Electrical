EESchema Schematic File Version 2  date 08/12/2009 11:04:10 PM
LIBS:power,../thunderbots-symbols,device,transistors,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,opto,atmel,contrib,valves,.\Sensor.cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 5 5
Title ""
Date "9 dec 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 8400 5400 2    60   Input ~ 0
GND
Wire Wire Line
	5200 4100 4600 4100
Wire Wire Line
	4600 3950 4800 3950
Wire Wire Line
	5300 3950 5600 3950
Wire Wire Line
	2100 4250 2100 3650
Wire Wire Line
	2100 4250 2900 4250
Wire Wire Line
	4800 2900 5600 2900
Connection ~ 8100 3950
Wire Wire Line
	7200 3950 8100 3950
Wire Wire Line
	7200 2900 8100 2900
Wire Wire Line
	8100 2900 8100 5400
Wire Wire Line
	4600 4250 4900 4250
Wire Wire Line
	4900 4250 4900 5400
Wire Wire Line
	4900 5400 8400 5400
Connection ~ 8100 5400
Wire Wire Line
	2450 3950 2900 3950
Wire Wire Line
	2100 3650 5000 3650
Wire Wire Line
	4700 3650 4700 3950
Connection ~ 4700 3950
Connection ~ 4700 3650
$Comp
L R R6
U 1 1 4B1F424B
P 5050 3950
AR Path="/4B1F4684/4B1F424B" Ref="R6"  Part="1" 
AR Path="/4B1F467B/4B1F424B" Ref="R5"  Part="1" 
AR Path="/4B1F45DF/4B1F424B" Ref="R4"  Part="1" 
AR Path="/4B1F40D4/4B1F424B" Ref="R3"  Part="1" 
F 0 "R3" V 5130 3950 50  0000 C CNN
F 1 "R" V 5050 3950 50  0000 C CNN
	1    5050 3950
	0    1    1    0   
$EndComp
Text HLabel 4800 2900 0    60   Output ~ 0
Analog
Text HLabel 5000 3650 2    60   Output ~ 0
CLK Out
Text HLabel 2450 3950 0    60   Input ~ 0
Vcc
Text HLabel 5200 4100 2    60   Input ~ 0
CLK In
$Comp
L 74LVC1G80 U8
U 1 1 4B1F4114
P 3750 4100
AR Path="/4B1F4684/4B1F4114" Ref="U8"  Part="1" 
AR Path="/4B1F467B/4B1F4114" Ref="U6"  Part="1" 
AR Path="/4B1F45DF/4B1F4114" Ref="U4"  Part="1" 
AR Path="/4B1F40D4/4B1F4114" Ref="U2"  Part="1" 
F 0 "U2" H 3750 4150 60  0000 C CNN
F 1 "74LVC1G80" H 3750 4000 60  0000 C CNN
	1    3750 4100
	-1   0    0    -1  
$EndComp
$Comp
L OPB733TR U9
U 1 1 4B1F410F
P 6450 3450
AR Path="/4B1F4684/4B1F410F" Ref="U9"  Part="1" 
AR Path="/4B1F467B/4B1F410F" Ref="U7"  Part="1" 
AR Path="/4B1F45DF/4B1F410F" Ref="U5"  Part="1" 
AR Path="/4B1F40D4/4B1F410F" Ref="U3"  Part="1" 
F 0 "U3" H 6450 3500 60  0000 C CNN
F 1 "OPB733TR" H 6450 3400 60  0000 C CNN
	1    6450 3450
	-1   0    0    1   
$EndComp
$EndSCHEMATC
