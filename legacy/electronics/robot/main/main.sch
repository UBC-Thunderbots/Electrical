EESchema Schematic File Version 2
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
LIBS:main-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 15
Title ""
Date "19 sep 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L C C89
U 1 1 535AE8E5
P 5800 5550
F 0 "C89" H 5850 5650 50  0000 L CNN
F 1 "100nF" H 5850 5450 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 5800 5550 60  0001 C CNN
F 3 "" H 5800 5550 60  0001 C CNN
	1    5800 5550
	0    1    1    0   
$EndComp
$Comp
L +3.3V #PWR01
U 1 1 535AE8E4
P 5600 5550
F 0 "#PWR01" H 5600 5510 30  0001 C CNN
F 1 "+3.3V" H 5600 5660 30  0000 C CNN
F 2 "" H 5600 5550 60  0001 C CNN
F 3 "" H 5600 5550 60  0001 C CNN
	1    5600 5550
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR02
U 1 1 535AE8E3
P 6000 5550
F 0 "#PWR02" H 6000 5550 30  0001 C CNN
F 1 "GND" H 6000 5480 30  0001 C CNN
F 2 "" H 6000 5550 60  0001 C CNN
F 3 "" H 6000 5550 60  0001 C CNN
	1    6000 5550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6000 5550 5950 5550
Wire Wire Line
	5650 5550 5600 5550
Connection ~ 2550 3050
Connection ~ 2450 2950
Connection ~ 2350 2850
Connection ~ 2250 2750
Wire Bus Line
	2250 2750 8950 2750
Wire Bus Line
	8950 2750 8950 3550
Wire Bus Line
	8950 3550 8550 3550
Wire Bus Line
	2450 2950 8750 2950
Wire Bus Line
	8750 2950 8750 3350
Wire Bus Line
	8750 3350 8550 3350
Wire Bus Line
	5150 1900 2550 1900
Wire Bus Line
	2550 1900 2550 3200
Wire Bus Line
	5150 1700 2350 1700
Wire Bus Line
	2350 1700 2350 3400
Wire Bus Line
	10850 1050 10850 6050
Wire Bus Line
	10650 1250 10650 5450
Wire Bus Line
	10450 4850 10450 1450
Wire Bus Line
	10250 1650 10250 4250
Wire Bus Line
	10450 4850 8550 4850
Wire Wire Line
	1850 1200 1850 3900
Wire Wire Line
	1850 1200 5150 1200
Wire Wire Line
	2050 1400 2050 3700
Wire Wire Line
	2050 1400 5150 1400
Wire Wire Line
	5900 6450 6150 6450
Wire Wire Line
	5900 6350 6150 6350
Wire Wire Line
	5900 6250 6150 6250
Wire Wire Line
	5900 6150 6150 6150
Wire Wire Line
	5900 6050 6150 6050
Wire Wire Line
	6050 5300 6150 5300
Wire Wire Line
	6050 5200 6150 5200
Wire Wire Line
	6050 5100 6150 5100
Wire Wire Line
	6050 5000 6150 5000
Wire Wire Line
	6050 4900 6150 4900
Wire Wire Line
	6050 4700 6150 4700
Wire Wire Line
	6050 4600 6150 4600
Wire Wire Line
	6050 4500 6150 4500
Wire Wire Line
	6050 4400 6150 4400
Wire Wire Line
	6050 4300 6150 4300
Connection ~ 1850 2200
Wire Wire Line
	1850 3900 2650 3900
Wire Wire Line
	2050 3700 2650 3700
Wire Bus Line
	2650 3500 2250 3500
Wire Bus Line
	2650 3300 2450 3300
Wire Wire Line
	2650 4000 950  4000
Wire Wire Line
	2350 5800 2650 5800
Wire Wire Line
	2350 5600 2650 5600
Wire Wire Line
	2350 5500 2650 5500
Wire Wire Line
	2350 4700 2650 4700
Wire Wire Line
	2350 4600 2650 4600
Wire Wire Line
	6150 6800 4650 6800
Wire Bus Line
	10850 1050 7550 1050
Wire Bus Line
	10650 1250 7550 1250
Wire Bus Line
	10450 1450 7550 1450
Wire Bus Line
	10250 1650 7550 1650
Wire Wire Line
	5900 5950 6150 5950
Wire Wire Line
	5900 5850 6150 5850
Wire Bus Line
	10250 6600 8550 6600
Wire Bus Line
	10650 5450 8550 5450
Wire Bus Line
	10250 4250 8550 4250
Wire Bus Line
	8550 5750 8800 5750
Wire Bus Line
	8550 4550 8800 4550
Wire Bus Line
	10050 5800 10750 5800
Wire Bus Line
	10050 4600 10350 4600
Connection ~ 950  4000
Wire Wire Line
	950  3250 950  3300
Wire Wire Line
	950  4050 950  3950
Wire Wire Line
	9300 6800 9250 6800
Wire Bus Line
	8550 6450 8800 6450
Wire Bus Line
	8550 5250 8800 5250
Wire Bus Line
	8550 4650 8800 4650
Wire Bus Line
	8800 5850 8550 5850
Wire Wire Line
	9650 6800 9600 6800
Wire Wire Line
	950  4400 950  4350
Wire Bus Line
	10050 4000 10150 4000
Wire Bus Line
	10050 5200 10550 5200
Wire Bus Line
	8550 3950 8800 3950
Wire Bus Line
	8550 4050 8800 4050
Wire Bus Line
	8800 5150 8550 5150
Wire Bus Line
	8800 6350 8550 6350
Wire Bus Line
	10850 6050 8550 6050
Wire Bus Line
	10250 6400 10050 6400
Wire Wire Line
	1100 2200 1150 2200
Wire Wire Line
	1800 2200 1850 2200
Wire Bus Line
	7550 1750 10150 1750
Wire Bus Line
	7550 1550 10350 1550
Wire Bus Line
	7550 1350 10550 1350
Wire Bus Line
	7550 1150 10750 1150
Wire Wire Line
	4650 3200 6150 3200
Wire Wire Line
	4650 3300 6150 3300
Wire Wire Line
	4650 3400 6150 3400
Wire Wire Line
	4650 3600 6150 3600
Wire Wire Line
	4650 3700 6150 3700
Wire Wire Line
	4650 3800 6150 3800
Wire Wire Line
	4650 3900 6150 3900
Wire Wire Line
	6150 7200 6050 7200
Wire Wire Line
	6050 7200 6050 6800
Connection ~ 6050 6800
Wire Wire Line
	2350 6500 2650 6500
Wire Wire Line
	2350 6600 2650 6600
Wire Wire Line
	2350 6700 2650 6700
Wire Wire Line
	2350 6800 2650 6800
Wire Bus Line
	2550 3200 2650 3200
Wire Bus Line
	2350 3400 2650 3400
Wire Bus Line
	2650 3600 2150 3600
Wire Wire Line
	2650 3800 1950 3800
Wire Wire Line
	4650 4000 6150 4000
Wire Bus Line
	2650 5700 2350 5700
Wire Bus Line
	5150 1500 2150 1500
Wire Bus Line
	2150 1500 2150 3600
Wire Wire Line
	5150 1300 1950 1300
Wire Wire Line
	1950 1300 1950 3800
Wire Bus Line
	10150 1750 10150 4000
Wire Bus Line
	10350 1550 10350 4600
Wire Bus Line
	10550 1350 10550 5200
Wire Bus Line
	10750 1150 10750 5800
Wire Bus Line
	5150 1600 2250 1600
Wire Bus Line
	2250 1600 2250 3500
Wire Bus Line
	5150 1800 2450 1800
Wire Bus Line
	2450 1800 2450 3300
Wire Bus Line
	8550 3250 8650 3250
Wire Bus Line
	8650 3250 8650 3050
Wire Bus Line
	8650 3050 2550 3050
Wire Bus Line
	8550 3450 8850 3450
Wire Bus Line
	8850 3450 8850 2850
Wire Bus Line
	8850 2850 2350 2850
Text Label 2950 1600 0    60   ~ 0
M0_ENCODER[0..1]
Text Label 2950 1700 0    60   ~ 0
M1_ENCODER[0..1]
Text Label 2950 1800 0    60   ~ 0
M2_ENCODER[0..1]
Text Label 2950 1900 0    60   ~ 0
M3_ENCODER[0..1]
$Sheet
S 5150 750  2400 1600
U 5066737C
F0 "breakoutconn" 60
F1 "breakoutconn.sch" 60
F2 "BB_SENSOR" O L 5150 1200 60 
F3 "LPS_SENSOR" O L 5150 1300 60 
F4 "M3_PHASE[0..2]" I R 7550 1150 60 
F5 "M2_PHASE[0..2]" I R 7550 1350 60 
F6 "M1_PHASE[0..2]" I R 7550 1550 60 
F7 "M0_PHASE[0..2]" I R 7550 1750 60 
F8 "LPS_DRIVE[0..3]" I L 5150 1500 60 
F9 "LASER_DRIVE" I L 5150 1400 60 
F10 "M3_HALL[0..2]" O R 7550 1050 60 
F11 "M2_HALL[0..2]" O R 7550 1250 60 
F12 "M1_HALL[0..2]" O R 7550 1450 60 
F13 "M0_HALL[0..2]" O R 7550 1650 60 
F14 "M0_ENCODER[0..1]" O L 5150 1600 60 
F15 "M1_ENCODER[0..1]" O L 5150 1700 60 
F16 "M2_ENCODER[0..1]" O L 5150 1800 60 
F17 "M3_ENCODER[0..1]" O L 5150 1900 60 
$EndSheet
$Sheet
S 6150 3150 2400 3700
U 4AD9040D
F0 "fpga" 60
F1 "fpga.sch" 60
F2 "OSC" I L 6150 6800 60 
F3 "/MRF_CS" O L 6150 6450 60 
F4 "MRF_CLK" O L 6150 6250 60 
F5 "MRF_MISO" I L 6150 6350 60 
F6 "MRF_MOSI" O L 6150 6150 60 
F7 "MRF_INT" I L 6150 6050 60 
F8 "MRF_WAKE" O L 6150 5950 60 
F9 "/MRF_RESET" O L 6150 5850 60 
F10 "PROG_B" I L 6150 3200 60 
F11 "M4_LOW[0..2]" O R 8550 6350 60 
F12 "M4_HIGH[0..2]" O R 8550 6450 60 
F13 "M1_HIGH[0..2]" O R 8550 4650 60 
F14 "M2_LOW[0..2]" O R 8550 5150 60 
F15 "M2_HIGH[0..2]" O R 8550 5250 60 
F16 "M3_LOW[0..2]" O R 8550 5750 60 
F17 "M3_HIGH[0..2]" O R 8550 5850 60 
F18 "DONE" O L 6150 3400 60 
F19 "INIT_B" O L 6150 3300 60 
F20 "~ICB_CS" I L 6150 3600 60 
F21 "ICB_MISO" O L 6150 3900 60 
F22 "ICB_CLK" I L 6150 3700 60 
F23 "ICB_MOSI" I L 6150 3800 60 
F24 "ICB_IRQ" O L 6150 4000 60 
F25 "ACCEL_INT" I L 6150 5300 60 
F26 "ACCEL_MISO" I L 6150 5200 60 
F27 "ACCEL_MOSI" O L 6150 5100 60 
F28 "ACCEL_CLK" O L 6150 5000 60 
F29 "~ACCEL_CS" O L 6150 4900 60 
F30 "GYRO_INT" I L 6150 4700 60 
F31 "GYRO_MISO" I L 6150 4600 60 
F32 "GYRO_MOSI" O L 6150 4500 60 
F33 "GYRO_CLK" O L 6150 4400 60 
F34 "~GYRO_CS" O L 6150 4300 60 
F35 "M3_ENCODER[0..1]" I R 8550 3250 60 
F36 "M2_ENCODER[0..1]" I R 8550 3350 60 
F37 "M1_ENCODER[0..1]" I R 8550 3450 60 
F38 "M0_ENCODER[0..1]" I R 8550 3550 60 
F39 "M2_HALL[0..2]" I R 8550 5450 60 
F40 "M4_HALL[0..2]" I R 8550 6600 60 
F41 "M0_HALL[0..2]" I R 8550 4250 60 
F42 "M1_HALL[0..2]" I R 8550 4850 60 
F43 "M3_HALL[0..2]" I R 8550 6050 60 
F44 "M1_LOW[0..2]" O R 8550 4550 60 
F45 "M0_LOW[0..2]" O R 8550 3950 60 
F46 "M0_HIGH[0..2]" O R 8550 4050 60 
$EndSheet
$Sheet
S 4750 4200 1300 1200
U 52438F48
F0 "imu" 60
F1 "imu.sch" 60
F2 "ACCEL_INT" O R 6050 5300 60 
F3 "ACCEL_MISO" O R 6050 5200 60 
F4 "ACCEL_MOSI" I R 6050 5100 60 
F5 "ACCEL_CLK" I R 6050 5000 60 
F6 "~ACCEL_CS" I R 6050 4900 60 
F7 "GYRO_INT" O R 6050 4700 60 
F8 "GYRO_MISO" O R 6050 4600 60 
F9 "GYRO_MOSI" I R 6050 4500 60 
F10 "GYRO_CLK" I R 6050 4400 60 
F11 "~GYRO_CS" I R 6050 4300 60 
$EndSheet
$Sheet
S 2650 3150 2000 3700
U 52431B80
F0 "microcontroller" 60
F1 "microcontroller.sch" 60
F2 "OSC" I R 4650 6800 60 
F3 "CHICKER_VOLTAGE" I L 2650 6800 60 
F4 "CHICKER_CHIP" O L 2650 6700 60 
F5 "CHICKER_KICK" O L 2650 6600 60 
F6 "CHICKER_CHARGE" O L 2650 6500 60 
F7 "SD_CD" I L 2650 5800 60 
F8 "SD_D[0..3]" B L 2650 5700 60 
F9 "SD_CMD" B L 2650 5600 60 
F10 "SD_CK" O L 2650 5500 60 
F11 "LOGIC_PWR" O L 2650 4600 60 
F12 "HV_PWR" O L 2650 4700 60 
F13 "LPS_DRIVE[0..3]" O L 2650 3600 60 
F14 "LASER_DRIVE" O L 2650 3700 60 
F15 "LPS_SENSOR" I L 2650 3800 60 
F16 "BB_SENSOR" I L 2650 3900 60 
F17 "M3_ENCODER[0..1]" I L 2650 3200 60 
F18 "M2_ENCODER[0..1]" I L 2650 3300 60 
F19 "M1_ENCODER[0..1]" I L 2650 3400 60 
F20 "M0_ENCODER[0..1]" I L 2650 3500 60 
F21 "ICB_MISO" I R 4650 3900 60 
F22 "ICB_MOSI" O R 4650 3800 60 
F23 "ICB_CLK" O R 4650 3700 60 
F24 "~ICB_CS" O R 4650 3600 60 
F25 "DONE" I R 4650 3400 60 
F26 "INIT_B" I R 4650 3300 60 
F27 "PROG_B" O R 4650 3200 60 
F28 "BATTERY" I L 2650 4000 60 
F29 "ICB_IRQ" I R 4650 4000 60 
$EndSheet
$Sheet
S 1650 6450 700  400 
U 4B4D69E7
F0 "chicker" 60
F1 "chicker.sch" 60
F2 "CHIP" I R 2350 6700 60 
F3 "KICK" I R 2350 6600 60 
F4 "CHARGE" I R 2350 6500 60 
F5 "VOLTAGE" O R 2350 6800 60 
$EndSheet
$Comp
L +3.3V #PWR03
U 1 1 524343A4
P 1100 2200
F 0 "#PWR03" H 1100 2160 30  0001 C CNN
F 1 "+3.3V" H 1100 2310 30  0000 C CNN
F 2 "" H 1100 2200 60  0001 C CNN
F 3 "" H 1100 2200 60  0001 C CNN
	1    1100 2200
	0    -1   -1   0   
$EndComp
$Sheet
S 8800 6300 1250 200 
U 4CD72EC7
F0 "motordriver4" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 10050 6400 60 
F3 "LOW[0..2]" I L 8800 6350 60 
F4 "HIGH[0..2]" I L 8800 6450 60 
$EndSheet
$Comp
L M3_MOUNT M6
U 1 1 50EFD200
P 3050 1000
F 0 "M6" H 3050 1000 60  0000 C CNN
F 1 "16mm" H 3050 1100 60  0000 C CNN
F 2 "Thunderbots:M3_MOUNT" H 3050 1000 60  0001 C CNN
F 3 "" H 3050 1000 60  0001 C CNN
F 4 "952-1507-ND" H 3050 1000 60  0001 C CNN "Digi-Key Part"
	1    3050 1000
	1    0    0    -1  
$EndComp
$Comp
L M3_MOUNT M5
U 1 1 50EFD1FE
P 2500 1000
F 0 "M5" H 2500 1000 60  0000 C CNN
F 1 "16mm" H 2500 1100 60  0000 C CNN
F 2 "Thunderbots:M3_MOUNT" H 2500 1000 60  0001 C CNN
F 3 "" H 2500 1000 60  0001 C CNN
F 4 "952-1507-ND" H 2500 1000 60  0001 C CNN "Digi-Key Part"
	1    2500 1000
	1    0    0    -1  
$EndComp
$Comp
L M3_MOUNT M4
U 1 1 50EFD1E4
P 1950 1000
F 0 "M4" H 1950 1000 60  0000 C CNN
F 1 "16mm" H 1950 1100 60  0000 C CNN
F 2 "Thunderbots:M3_MOUNT" H 1950 1000 60  0001 C CNN
F 3 "" H 1950 1000 60  0001 C CNN
F 4 "952-1507-ND" H 1950 1000 60  0001 C CNN "Digi-Key Part"
	1    1950 1000
	1    0    0    -1  
$EndComp
$Comp
L M3_MOUNT M3
U 1 1 50EFD1DC
P 3050 650
F 0 "M3" H 3050 650 60  0000 C CNN
F 1 "5mm" H 3050 750 60  0000 C CNN
F 2 "Thunderbots:M3_MOUNT" H 3050 650 60  0001 C CNN
F 3 "" H 3050 650 60  0001 C CNN
F 4 "952-1496-ND" H 3050 650 60  0001 C CNN "Digi-Key Part"
	1    3050 650 
	1    0    0    -1  
$EndComp
$Comp
L M3_MOUNT M2
U 1 1 50EFD1DB
P 2500 650
F 0 "M2" H 2500 650 60  0000 C CNN
F 1 "5mm" H 2500 750 60  0000 C CNN
F 2 "Thunderbots:M3_MOUNT" H 2500 650 60  0001 C CNN
F 3 "" H 2500 650 60  0001 C CNN
F 4 "952-1496-ND" H 2500 650 60  0001 C CNN "Digi-Key Part"
	1    2500 650 
	1    0    0    -1  
$EndComp
$Comp
L M3_MOUNT M1
U 1 1 50EFD1E0
P 1950 650
F 0 "M1" H 1950 650 60  0000 C CNN
F 1 "5mm" H 1950 750 60  0000 C CNN
F 2 "Thunderbots:M3_MOUNT" H 1950 650 60  0001 C CNN
F 3 "" H 1950 650 60  0001 C CNN
F 4 "952-1496-ND" H 1950 650 60  0001 C CNN "Digi-Key Part"
	1    1950 650 
	1    0    0    -1  
$EndComp
Text Notes 1650 1000 2    60   ~ 0
Up to Chicker Board:
Text Notes 1650 700  2    60   ~ 0
Down to Breakout Board:
$Comp
L R R1
U 1 1 506A4662
P 950 3450
F 0 "R1" V 1030 3450 50  0000 C CNN
F 1 "10kR" V 950 3450 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" H 950 3450 60  0001 C CNN
F 3 "" H 950 3450 60  0001 C CNN
	1    950  3450
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 506A42F8
P 1650 2200
F 0 "R3" V 1730 2200 50  0000 C CNN
F 1 "100R" V 1650 2200 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" H 1650 2200 60  0001 C CNN
F 3 "" H 1650 2200 60  0001 C CNN
	1    1650 2200
	0    1    1    0   
$EndComp
$Sheet
S 1650 5450 700  400 
U 5067E816
F0 "sdcard" 60
F1 "sdcard.sch" 60
F2 "SD_D[0..3]" B R 2350 5700 60 
F3 "SD_CK" I R 2350 5500 60 
F4 "SD_CMD" B R 2350 5600 60 
F5 "SD_CD" O R 2350 5800 60 
$EndSheet
$Sheet
S 8800 3900 1250 200 
U 4CD72C2A
F0 "motordriver0" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 10050 4000 60 
F3 "LOW[0..2]" I L 8800 3950 60 
F4 "HIGH[0..2]" I L 8800 4050 60 
$EndSheet
$Sheet
S 8800 4500 1250 200 
U 4CD72EB0
F0 "motordriver1" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 10050 4600 60 
F3 "LOW[0..2]" I L 8800 4550 60 
F4 "HIGH[0..2]" I L 8800 4650 60 
$EndSheet
$Comp
L GND #PWR04
U 1 1 4F74094A
P 9650 6800
F 0 "#PWR04" H 9650 6800 30  0001 C CNN
F 1 "GND" H 9650 6730 30  0001 C CNN
F 2 "" H 9650 6800 60  0001 C CNN
F 3 "" H 9650 6800 60  0001 C CNN
	1    9650 6800
	0    -1   -1   0   
$EndComp
$Comp
L +3.3V #PWR05
U 1 1 4F740946
P 9250 6800
F 0 "#PWR05" H 9250 6760 30  0001 C CNN
F 1 "+3.3V" H 9250 6910 30  0000 C CNN
F 2 "" H 9250 6800 60  0001 C CNN
F 3 "" H 9250 6800 60  0001 C CNN
	1    9250 6800
	0    -1   -1   0   
$EndComp
$Comp
L C C61
U 1 1 4F74093B
P 9450 6800
F 0 "C61" H 9500 6900 50  0000 L CNN
F 1 "100nF" H 9500 6700 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 9450 6800 60  0001 C CNN
F 3 "" H 9450 6800 60  0001 C CNN
	1    9450 6800
	0    1    1    0   
$EndComp
$Comp
L R R43
U 1 1 4F697B5F
P 1300 2200
F 0 "R43" V 1380 2200 50  0000 C CNN
F 1 "100R" V 1300 2200 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" H 1300 2200 60  0001 C CNN
F 3 "" H 1300 2200 60  0001 C CNN
	1    1300 2200
	0    1    1    0   
$EndComp
$Comp
L MRF24J40M U7
U 1 1 4F69649C
P 5150 6150
F 0 "U7" H 5150 6100 60  0000 C CNN
F 1 "MRF24J40MD" H 5150 6200 60  0000 C CNN
F 2 "Thunderbots:MRF24J40M" H 5150 6150 60  0001 C CNN
F 3 "" H 5150 6150 60  0001 C CNN
	1    5150 6150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 4F644EA8
P 950 4400
F 0 "#PWR06" H 950 4400 30  0001 C CNN
F 1 "GND" H 950 4330 30  0001 C CNN
F 2 "" H 950 4400 60  0001 C CNN
F 3 "" H 950 4400 60  0001 C CNN
	1    950  4400
	1    0    0    -1  
$EndComp
$Comp
L R R45
U 1 1 4F644E8B
P 950 4200
F 0 "R45" V 1030 4200 50  0000 C CNN
F 1 "2.2kR" V 950 4200 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" H 950 4200 60  0001 C CNN
F 3 "" H 950 4200 60  0001 C CNN
	1    950  4200
	1    0    0    -1  
$EndComp
$Comp
L R R44
U 1 1 4F644E89
P 950 3800
F 0 "R44" V 1030 3800 50  0000 C CNN
F 1 "10kR" V 950 3800 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" H 950 3800 60  0001 C CNN
F 3 "" H 950 3800 60  0001 C CNN
	1    950  3800
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR07
U 1 1 4F644E6B
P 950 3250
F 0 "#PWR07" H 950 3200 20  0001 C CNN
F 1 "+BATT" H 950 3350 30  0000 C CNN
F 2 "" H 950 3250 60  0001 C CNN
F 3 "" H 950 3250 60  0001 C CNN
	1    950  3250
	1    0    0    -1  
$EndComp
$Sheet
S 10250 6350 900  300 
U 4CD73194
F0 "dribblerconn" 60
F1 "dribblerconn.sch" 60
F2 "PHASE[0..2]" I L 10250 6400 60 
F3 "SENSOR[0..2]" O L 10250 6600 60 
$EndSheet
$Sheet
S 8800 5700 1250 200 
U 4CD72EC1
F0 "motordriver3" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 10050 5800 60 
F3 "LOW[0..2]" I L 8800 5750 60 
F4 "HIGH[0..2]" I L 8800 5850 60 
$EndSheet
$Sheet
S 8800 5100 1250 200 
U 4CD72EB9
F0 "motordriver2" 60
F1 "motordriver.sch" 60
F2 "PHASE[0..2]" O R 10050 5200 60 
F3 "LOW[0..2]" I L 8800 5150 60 
F4 "HIGH[0..2]" I L 8800 5250 60 
$EndSheet
$Sheet
S 6150 7100 800  200 
U 4CC4F481
F0 "oscillator" 60
F1 "oscillator.sch" 60
F2 "OSC" O L 6150 7200 60 
$EndSheet
$Sheet
S 1650 4550 700  200 
U 4AD90417
F0 "power" 60
F1 "power.sch" 60
F2 "HV_PWR" I R 2350 4700 60 
F3 "LOGIC_PWR" I R 2350 4600 60 
$EndSheet
Wire Wire Line
	1450 2200 1500 2200
Wire Wire Line
	950  3600 950  3650
$EndSCHEMATC
