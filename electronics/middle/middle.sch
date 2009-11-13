EESchema Schematic File Version 2  date 12/11/2009 16:17:56
LIBS:power,../thunderbots-symbols,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,.\middle.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 3
Title ""
Date "1 nov 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
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
$Sheet
S 4000 1500 2450 2350
U 4AECDBEB
F0 "kicker" 60
F1 "kicker.sch" 60
F2 "Vout1(500V)" I L 4000 3450 60 
F3 "Vout2(500V)" I L 4000 3650 60 
F4 "Input_Battery(Vcc)" I L 4000 1800 60 
F5 "Input_Battery(Vtrans)" I L 4000 1950 60 
F6 "Charge_capacitor" I R 6450 2250 60 
F7 "Kick_solenoid2" I R 6450 2600 60 
F8 "Kick_solenoid1" I R 6450 2450 60 
$EndSheet
$Sheet
S 3950 4350 2550 2600
U 4AECDC4C
F0 "connectors" 60
F1 "connectors.sch" 60
F2 "Solenoid1 control MOSFET" I R 6500 4900 60 
F3 "Solenoid2 control MOSFET" I R 6500 4750 60 
F4 "LT3751 IC On/Off" I R 6500 5050 60 
$EndSheet
$EndSCHEMATC
