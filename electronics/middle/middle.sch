EESchema Schematic File Version 2  date 14/11/2009 17:55:23
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,.\middle.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 3
Title ""
Date "14 nov 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	3950 5850 2900 5850
Wire Wire Line
	2900 5850 2900 2900
Wire Wire Line
	2900 2900 4000 2900
Wire Wire Line
	3950 6450 3300 6450
Wire Wire Line
	3300 6450 3300 3450
Wire Wire Line
	3300 3450 4000 3450
Wire Wire Line
	6500 4750 7000 4750
Wire Wire Line
	7000 4750 7000 2600
Wire Wire Line
	7000 2600 6450 2600
Wire Wire Line
	6500 5050 7400 5050
Wire Wire Line
	7400 5050 7400 2250
Wire Wire Line
	7400 2250 6450 2250
Wire Wire Line
	6450 2450 7200 2450
Wire Wire Line
	7200 2450 7200 4900
Wire Wire Line
	7200 4900 6500 4900
Wire Wire Line
	4000 3650 3550 3650
Wire Wire Line
	3550 3650 3550 6250
Wire Wire Line
	3550 6250 3950 6250
Wire Wire Line
	4000 3050 3100 3050
Wire Wire Line
	3100 3050 3100 5650
Wire Wire Line
	3100 5650 3950 5650
$Sheet
S 3950 4350 2550 2600
U 4AECDC4C
F0 "connectors" 60
F1 "connectors.sch" 60
F2 "Solenoid1 control MOSFET" O R 6500 4900 60 
F3 "Solenoid2 control MOSFET" O R 6500 4750 60 
F4 "LT3751 IC On/Off" O R 6500 5050 60 
F5 "Capacitor Charge In(-ve)" I L 3950 5650 60 
F6 "Capacitor Charge In(+ve)" I L 3950 5850 60 
F7 "Solenoid2 Power Input" I L 3950 6250 60 
F8 "Solenoid1 Power Input" I L 3950 6450 60 
$EndSheet
$Sheet
S 4000 1500 2450 2350
U 4AECDBEB
F0 "kicker" 60
F1 "kicker.sch" 60
F2 "Vout1(500V)" O L 4000 3450 60 
F3 "Vout2(500V)" O L 4000 3650 60 
F4 "Charge_capacitor" I R 6450 2250 60 
F5 "Kick_solenoid2" I R 6450 2600 60 
F6 "Kick_solenoid1" I R 6450 2450 60 
F7 "Capacitor Charge Out(-ve)" O L 4000 3050 60 
F8 "Capacitor Charge Out(+ve)" O L 4000 2900 60 
$EndSheet
$EndSCHEMATC
