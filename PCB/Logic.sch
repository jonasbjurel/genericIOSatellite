EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L modelRailway:genIOSatelite U?
U 1 1 64D573DB
P 5800 3900
F 0 "U?" H 5687 5468 118 0000 C CNN
F 1 "genIOSatelite" H 5687 5275 118 0000 C CNN
F 2 "" H 5800 5500 118 0001 C CNN
F 3 "" H 5800 5500 118 0001 C CNN
	1    5800 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 5150 6600 5150
Wire Wire Line
	6600 5150 6600 5250
Connection ~ 6600 5250
Wire Wire Line
	6600 5250 6450 5250
Wire Wire Line
	4900 5250 4900 5150
Wire Wire Line
	4900 4550 5100 4550
Wire Wire Line
	4900 5250 5100 5250
Wire Wire Line
	5100 4650 4900 4650
Connection ~ 4900 4650
Wire Wire Line
	4900 4650 4900 4550
Wire Wire Line
	5100 4750 4900 4750
Connection ~ 4900 4750
Wire Wire Line
	4900 4750 4900 4650
Wire Wire Line
	5100 4850 4900 4850
Connection ~ 4900 4850
Wire Wire Line
	4900 4850 4900 4750
Wire Wire Line
	5100 4950 4900 4950
Connection ~ 4900 4950
Wire Wire Line
	4900 4950 4900 4850
Wire Wire Line
	5100 5050 4900 5050
Connection ~ 4900 5050
Wire Wire Line
	4900 5050 4900 4950
Wire Wire Line
	5100 5150 4900 5150
Connection ~ 4900 5150
Wire Wire Line
	4900 5150 4900 5050
Wire Wire Line
	4650 5250 4900 5250
Connection ~ 4900 5250
Text HLabel 4450 2750 0    118  Input ~ 0
S_IN+
Wire Wire Line
	4450 2750 5100 2750
Text HLabel 3750 2850 0    118  Input ~ 0
S_IN-
Wire Wire Line
	3750 2850 5100 2850
Text HLabel 4450 3050 0    118  Input ~ 0
S-0
Wire Wire Line
	4450 3050 5100 3050
Text HLabel 3750 3150 0    118  Input ~ 0
S-1
Wire Wire Line
	3750 3150 5100 3150
Text HLabel 4450 3250 0    118  Input ~ 0
S-2
Wire Wire Line
	4450 3250 5100 3250
Text HLabel 3750 3350 0    118  Input ~ 0
S-3
Wire Wire Line
	3750 3350 5100 3350
Text HLabel 4450 3450 0    118  Input ~ 0
S-4
Wire Wire Line
	4450 3450 5100 3450
Text HLabel 3750 3550 0    118  Input ~ 0
S-5
Wire Wire Line
	3750 3550 5100 3550
Text HLabel 4450 3650 0    118  Input ~ 0
S-6
Wire Wire Line
	4450 3650 5100 3650
Text HLabel 3750 3750 0    118  Input ~ 0
S-7
Wire Wire Line
	3750 3750 5100 3750
Text HLabel 7150 2750 2    118  Output ~ 0
S_OUT+
Wire Wire Line
	7150 2750 6450 2750
Text HLabel 8100 2850 2    118  Output ~ 0
S_OUT-
Wire Wire Line
	6450 2850 8100 2850
Text HLabel 7150 3050 2    118  Output ~ 0
ACT-0
Wire Wire Line
	7150 3050 6450 3050
Text HLabel 8100 3150 2    118  Output ~ 0
ACT-1
Wire Wire Line
	6450 3150 8100 3150
Text HLabel 7150 3250 2    118  Output ~ 0
ACT-2
Wire Wire Line
	7150 3250 6450 3250
Text HLabel 8100 3350 2    118  Output ~ 0
ACT-3
Wire Wire Line
	6450 3350 8100 3350
$Comp
L Device:LED D?
U 1 1 64D6D445
P 7300 4000
AR Path="/64D6D445" Ref="D?"  Part="1" 
AR Path="/64D5578B/64D6D445" Ref="D?"  Part="1" 
F 0 "D?" V 7339 3882 50  0000 R CNN
F 1 "LED" V 7248 3882 50  0000 R CNN
F 2 "" H 7300 4000 50  0001 C CNN
F 3 "~" H 7300 4000 50  0001 C CNN
	1    7300 4000
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 64D6D44B
P 7300 4350
AR Path="/64D6D44B" Ref="R?"  Part="1" 
AR Path="/64D5578B/64D6D44B" Ref="R?"  Part="1" 
F 0 "R?" H 7230 4304 50  0000 R CNN
F 1 "R" H 7230 4395 50  0000 R CNN
F 2 "" V 7230 4350 50  0001 C CNN
F 3 "~" H 7300 4350 50  0001 C CNN
	1    7300 4350
	-1   0    0    1   
$EndComp
Wire Wire Line
	7300 4150 7300 4200
$Comp
L Device:LED D?
U 1 1 64D6E96E
P 6900 4000
AR Path="/64D6E96E" Ref="D?"  Part="1" 
AR Path="/64D5578B/64D6E96E" Ref="D?"  Part="1" 
F 0 "D?" V 6939 3882 50  0000 R CNN
F 1 "LED" V 6848 3882 50  0000 R CNN
F 2 "" H 6900 4000 50  0001 C CNN
F 3 "~" H 6900 4000 50  0001 C CNN
	1    6900 4000
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 64D6E974
P 6900 4350
AR Path="/64D6E974" Ref="R?"  Part="1" 
AR Path="/64D5578B/64D6E974" Ref="R?"  Part="1" 
F 0 "R?" H 6830 4304 50  0000 R CNN
F 1 "R" H 6830 4395 50  0000 R CNN
F 2 "" V 6830 4350 50  0001 C CNN
F 3 "~" H 6900 4350 50  0001 C CNN
	1    6900 4350
	-1   0    0    1   
$EndComp
Wire Wire Line
	6900 4150 6900 4200
Wire Wire Line
	7300 3850 7300 3600
Wire Wire Line
	7300 3600 6450 3600
Wire Wire Line
	6900 3850 6900 3700
Wire Wire Line
	6900 3700 6450 3700
Wire Wire Line
	7300 5250 7500 5250
Wire Wire Line
	7300 4500 7300 5250
Wire Wire Line
	6900 5250 7300 5250
Wire Wire Line
	6900 4500 6900 5250
Connection ~ 7300 5250
Wire Wire Line
	6600 5250 6900 5250
Connection ~ 6900 5250
Wire Wire Line
	4450 4000 5100 4000
Wire Wire Line
	3750 4100 5100 4100
Wire Wire Line
	4450 4200 5100 4200
Wire Wire Line
	3750 4300 5100 4300
Text Notes 6800 4150 1    39   ~ 0
Watchdog
Text Notes 7650 4100 1    39   ~ 0
Active
Text GLabel 4450 4000 0    118  Input ~ 0
TMS
Text GLabel 3750 4100 0    118  Input ~ 0
TCK
Text GLabel 4450 4200 0    118  Input ~ 0
TDI
Text GLabel 3750 4300 0    118  Output ~ 0
TDO
Text GLabel 4650 5250 0    118  UnSpc ~ 0
3V3_INT
Text GLabel 7500 5250 2    118  UnSpc ~ 0
GND
$EndSCHEMATC
