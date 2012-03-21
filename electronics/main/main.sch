EESchema Schematic File Version 2  date 2012-03-20T21:20:57 PDT
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
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 17
Title ""
Date "21 mar 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	3350 2050 3950 2050
Wire Wire Line
	3950 2050 3950 2650
Wire Wire Line
	3950 2650 5900 2650
Wire Wire Line
	5900 950  5650 950 
Connection ~ 4200 1300
Wire Wire Line
	4200 1300 4500 1300
Wire Wire Line
	4500 1300 4500 2100
Wire Wire Line
	4500 2100 4800 2100
Wire Wire Line
	4200 1350 4200 1250
Wire Wire Line
	4800 2300 3800 2300
Wire Wire Line
	3800 2300 3800 2450
Wire Wire Line
	3800 2450 3350 2450
Wire Wire Line
	3400 2250 3350 2250
Wire Wire Line
	5650 2300 5900 2300
Wire Wire Line
	5650 2100 5900 2100
Wire Wire Line
	5650 1350 5900 1350
Wire Bus Line
	8550 2850 8300 2850
Wire Bus Line
	8550 2750 8300 2750
Wire Bus Line
	8300 1650 8550 1650
Wire Bus Line
	8300 1550 8550 1550
Wire Bus Line
	8450 1150 8450 1250
Wire Bus Line
	8450 1150 8300 1150
Wire Bus Line
	8450 2350 8450 2450
Wire Bus Line
	8450 2350 8300 2350
Wire Bus Line
	10000 3400 9900 3400
Wire Bus Line
	9900 3400 9900 3650
Wire Bus Line
	9900 3650 8450 3650
Wire Bus Line
	10000 2200 9900 2200
Wire Bus Line
	9900 2200 9900 2450
Wire Bus Line
	9900 2450 8450 2450
Wire Bus Line
	10000 1000 9900 1000
Wire Bus Line
	9900 1000 9900 1250
Wire Bus Line
	9900 1250 8450 1250
Wire Bus Line
	9800 3300 10000 3300
Wire Bus Line
	9800 2100 10000 2100
Wire Bus Line
	9800 900  10000 900 
Wire Bus Line
	9800 1500 10000 1500
Wire Bus Line
	9800 2700 10000 2700
Wire Bus Line
	9900 1850 8450 1850
Wire Bus Line
	9900 1850 9900 1600
Wire Bus Line
	9900 1600 10000 1600
Wire Bus Line
	9900 3050 8450 3050
Wire Bus Line
	9900 3050 9900 2800
Wire Bus Line
	9900 2800 10000 2800
Wire Wire Line
	8300 4200 8550 4200
Wire Wire Line
	8300 4300 8550 4300
Wire Wire Line
	8300 4400 8550 4400
Wire Wire Line
	8300 4600 8550 4600
Wire Wire Line
	8300 4700 8550 4700
Wire Wire Line
	8300 4800 8550 4800
Wire Wire Line
	3350 2150 3800 2150
Wire Bus Line
	8300 3550 8450 3550
Wire Bus Line
	8450 3550 8450 3650
Wire Bus Line
	8450 3050 8450 2950
Wire Bus Line
	8450 2950 8300 2950
Wire Bus Line
	8300 1750 8450 1750
Wire Bus Line
	8450 1750 8450 1850
Wire Bus Line
	8300 950  8550 950 
Wire Bus Line
	8300 1050 8550 1050
Wire Bus Line
	8300 2150 8550 2150
Wire Bus Line
	8300 2250 8550 2250
Wire Bus Line
	8300 3350 8550 3350
Wire Bus Line
	8300 3450 8550 3450
Wire Wire Line
	5900 1450 5650 1450
Wire Wire Line
	5900 1650 5650 1650
Wire Wire Line
	5650 1550 5900 1550
Wire Wire Line
	5900 2200 5650 2200
Wire Wire Line
	5900 2400 5650 2400
Wire Wire Line
	3350 1950 3850 1950
Wire Wire Line
	3800 2150 3800 2200
Wire Wire Line
	3800 2200 4800 2200
Wire Wire Line
	4200 1900 4200 1850
Wire Wire Line
	4200 750  4200 700 
Wire Wire Line
	5650 850  5900 850 
Wire Wire Line
	3850 1950 3850 1900
$Comp
L GND #PWR?
U 1 1 4F644EA8
P 4200 1900
F 0 "#PWR?" H 4200 1900 30  0001 C CNN
F 1 "GND" H 4200 1830 30  0001 C CNN
	1    4200 1900
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 4F644E8B
P 4200 1600
F 0 "R?" V 4280 1600 50  0000 C CNN
F 1 "330R" V 4200 1600 50  0000 C CNN
	1    4200 1600
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 4F644E89
P 4200 1000
F 0 "R?" V 4280 1000 50  0000 C CNN
F 1 "1.5kR" V 4200 1000 50  0000 C CNN
	1    4200 1000
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR?
U 1 1 4F644E6B
P 4200 700
F 0 "#PWR?" H 4200 650 20  0001 C CNN
F 1 "+BATT" H 4200 800 30  0000 C CNN
	1    4200 700 
	1    0    0    -1  
$EndComp
NoConn ~ 3350 2350
Text Notes 3350 1950 0    60   ~ 0
BB bias
$Sheet
S 5900 800  2400 4050
U 4AD9040D
F0 "fpga" 60
F1 "fpga.sch" 60
F2 "M_CTRL5+[0..2]" O R 8300 3450 60 
F3 "M_CTRL5-[0..2]" O R 8300 3350 60 
F4 "M_CTRL4+[0..2]" O R 8300 2850 60 
F5 "M_CTRL4-[0..2]" O R 8300 2750 60 
F6 "M_CTRL3+[0..2]" O R 8300 2250 60 
F7 "CHIP" O R 8300 4800 60 
F8 "KICK" O R 8300 4700 60 
F9 "CHICKER_CHARGE" O R 8300 4200 60 
F10 "CHICKER_MISO" I R 8300 4600 60 
F11 "CHICKER_CLK" O R 8300 4400 60 
F12 "/CHICKER_CS" O R 8300 4300 60 
F13 "M_CTRL3-[0..2]" O R 8300 2150 60 
F14 "M_CTRL2+[0..2]" O R 8300 1650 60 
F15 "M_CTRL2-[0..2]" O R 8300 1550 60 
F16 "M_CTRL1+[0..2]" O R 8300 1050 60 
F17 "M_CTRL1-[0..2]" O R 8300 950 60 
F18 "OSC" I L 5900 850 60 
F19 "/FLASH_SS" B L 5900 1350 60 
F20 "/ADC_SS" O L 5900 2100 60 
F21 "FLASH_MOSI" B L 5900 1550 60 
F22 "FLASH_CLK" B L 5900 1450 60 
F23 "FLASH_MISO" I L 5900 1650 60 
F24 "ADC_MISO" I L 5900 2400 60 
F25 "ADC_MOSI" O L 5900 2300 60 
F26 "ADC_CLK" O L 5900 2200 60 
F27 "OSC_ENABLE" O L 5900 950 60 
F28 "M_SENSOR5[0..2]" I R 8300 3550 60 
F29 "M_SENSOR4[0..4]" I R 8300 2950 60 
F30 "M_SENSOR3[0..4]" I R 8300 2350 60 
F31 "M_SENSOR2[0..4]" I R 8300 1750 60 
F32 "M_SENSOR1[0..4]" I R 8300 1150 60 
F33 "BREAKBEAM_DRIVE" O L 5900 2650 60 
$EndSheet
$Sheet
S 4800 1250 850  550 
U 4AD90415
F0 "flash" 60
F1 "flash.sch" 60
F2 "MISO" O R 5650 1650 60 
F3 "/CS" I R 5650 1350 60 
F4 "MOSI" I R 5650 1550 60 
F5 "CLK" I R 5650 1450 60 
$EndSheet
$Sheet
S 4800 2050 850  400 
U 4F618EFD
F0 "adc" 60
F1 "adc.sch" 60
F2 "CH3" I L 4800 2400 60 
F3 "CH2" I L 4800 2300 60 
F4 "CH1" I L 4800 2200 60 
F5 "CH0" I L 4800 2100 60 
F6 "CLK" I R 5650 2200 60 
F7 "MISO" O R 5650 2400 60 
F8 "MOSI" I R 5650 2300 60 
F9 "/CS" I R 5650 2100 60 
$EndSheet
Text Notes 3350 2450 0    60   ~ 0
Therm in
Text Notes 3350 2150 0    60   ~ 0
BB in
Text Notes 3350 2050 0    60   ~ 0
BB drive
$Comp
L GND #PWR03
U 1 1 4CE5E075
P 3400 2250
F 0 "#PWR03" H 3400 2250 30  0001 C CNN
F 1 "GND" H 3400 2180 30  0001 C CNN
	1    3400 2250
	0    -1   -1   0   
$EndComp
$Comp
L +3.3V #PWR04
U 1 1 4CE5E05F
P 3850 1900
F 0 "#PWR04" H 3850 1860 30  0001 C CNN
F 1 "+3.3V" H 3850 2010 30  0000 C CNN
	1    3850 1900
	1    0    0    -1  
$EndComp
$Comp
L CONN_6 P15
U 1 1 4CE5DFE0
P 3000 2200
F 0 "P15" V 2950 2200 60  0000 C CNN
F 1 "CONN_6" V 3050 2200 60  0000 C CNN
F 4 "WM7624CT-ND" H 3000 2200 60  0001 C CNN "Field1"
	1    3000 2200
	-1   0    0    1   
$EndComp
$Sheet
S 10000 3200 900  300 
U 4CD73194
F0 "dribblerconn" 60
F1 "dribblerconn.sch" 60
F2 "PHASE[0..2]" I L 10000 3300 60 
F3 "SENSOR[0..2]" O L 10000 3400 60 
$EndSheet
$Sheet
S 10000 2600 900  300 
U 4CD73188
F0 "wheelconn4" 60
F1 "wheelconn.sch" 60
F2 "PHASE[0..2]" I L 10000 2700 60 
F3 "SENSOR[0..4]" O L 10000 2800 60 
$EndSheet
$Sheet
S 10000 2000 900  300 
U 4CD7317F
F0 "wheelconn3" 60
F1 "wheelconn.sch" 60
F2 "PHASE[0..2]" I L 10000 2100 60 
F3 "SENSOR[0..4]" O L 10000 2200 60 
$EndSheet
$Sheet
S 10000 1400 900  300 
U 4CD73172
F0 "wheelconn2" 60
F1 "wheelconn.sch" 60
F2 "PHASE[0..2]" I L 10000 1500 60 
F3 "SENSOR[0..4]" O L 10000 1600 60 
$EndSheet
$Sheet
S 10000 800  900  300 
U 4CD73053
F0 "wheelconn1" 60
F1 "wheelconn.sch" 60
F2 "PHASE[0..2]" I L 10000 900 60 
F3 "SENSOR[0..4]" O L 10000 1000 60 
$EndSheet
$Sheet
S 8550 3200 1250 300 
U 4CD72EC7
F0 "motordriver5" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 9800 3300 60 
F3 "CTRL-[0..2]" I L 8550 3350 60 
F4 "CTRL+[0..2]" I L 8550 3450 60 
F5 "ENABLE" I L 8550 3250 60 
$EndSheet
$Sheet
S 8550 2600 1250 300 
U 4CD72EC1
F0 "motordriver4" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 9800 2700 60 
F3 "CTRL-[0..2]" I L 8550 2750 60 
F4 "CTRL+[0..2]" I L 8550 2850 60 
F5 "ENABLE" I L 8550 2650 60 
$EndSheet
$Sheet
S 8550 2000 1250 300 
U 4CD72EB9
F0 "motordriver3" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 9800 2100 60 
F3 "CTRL-[0..2]" I L 8550 2150 60 
F4 "CTRL+[0..2]" I L 8550 2250 60 
F5 "ENABLE" I L 8550 2050 60 
$EndSheet
$Sheet
S 8550 1400 1250 300 
U 4CD72EB0
F0 "motordriver2" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 9800 1500 60 
F3 "CTRL-[0..2]" I L 8550 1550 60 
F4 "CTRL+[0..2]" I L 8550 1650 60 
F5 "ENABLE" I L 8550 1450 60 
$EndSheet
$Sheet
S 8550 800  1250 300 
U 4CD72C2A
F0 "motordriver1" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 9800 900 60 
F3 "CTRL-[0..2]" I L 8550 950 60 
F4 "CTRL+[0..2]" I L 8550 1050 60 
F5 "ENABLE" I L 8550 850 60 
$EndSheet
$Sheet
S 4800 800  850  200 
U 4CC4F481
F0 "oscillator" 60
F1 "oscillator.sch" 60
F2 "OSC" O R 5650 850 60 
F3 "ENABLE" I R 5650 950 60 
$EndSheet
$Sheet
S 8550 4050 1250 800 
U 4B4D69E7
F0 "chicker" 60
F1 "chicker.sch" 60
F2 "PRESENT" O L 8550 4100 60 
F3 "CHIP" I L 8550 4800 60 
F4 "KICK" I L 8550 4700 60 
F5 "CHARGE" I L 8550 4200 60 
F6 "MISO" O L 8550 4600 60 
F7 "/CS" I L 8550 4300 60 
F8 "CLK" I L 8550 4400 60 
$EndSheet
$Sheet
S 2400 4900 950  600 
U 4AD90417
F0 "power" 60
F1 "power.sch" 60
$EndSheet
$EndSCHEMATC
