EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
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
L Device:Polyfuse F?
U 1 1 655898D9
P 3100 1150
AR Path="/655898D9" Ref="F?"  Part="1" 
AR Path="/653FA36F/655898D9" Ref="F?"  Part="1" 
F 0 "F?" H 3188 1196 50  0000 L CNN
F 1 "Polyfuse" H 3188 1105 50  0000 L CNN
F 2 "" H 3150 950 50  0001 L CNN
F 3 "~" H 3100 1150 50  0001 C CNN
	1    3100 1150
	1    0    0    -1  
$EndComp
$Comp
L Diode:US2BA D?
U 1 1 655898DF
P 3100 1500
AR Path="/655898DF" Ref="D?"  Part="1" 
AR Path="/653FA36F/655898DF" Ref="D?"  Part="1" 
F 0 "D?" V 3146 1580 50  0000 L CNN
F 1 "US2BA" V 3055 1580 50  0000 L CNN
F 2 "Diode_SMD:D_SMA" H 3100 1325 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/US2AA-D.PDF" H 3100 1500 50  0001 C CNN
	1    3100 1500
	0    1    -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 655898E5
P 2200 1700
AR Path="/655898E5" Ref="R?"  Part="1" 
AR Path="/653FA36F/655898E5" Ref="R?"  Part="1" 
F 0 "R?" V 2407 1700 50  0000 C CNN
F 1 "R" V 2316 1700 50  0000 C CNN
F 2 "" V 2130 1700 50  0001 C CNN
F 3 "~" H 2200 1700 50  0001 C CNN
	1    2200 1700
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2650 3050 3100 3050
Wire Wire Line
	1700 850  1700 1700
Wire Wire Line
	1700 3050 2250 3050
Text Notes 1550 5000 0    118  ~ 24
Power regulation and protection\n
$Comp
L Device:D_Zener D?
U 1 1 655898F0
P 2700 1700
AR Path="/655898F0" Ref="D?"  Part="1" 
AR Path="/653FA36F/655898F0" Ref="D?"  Part="1" 
F 0 "D?" H 2700 1917 50  0000 C CNN
F 1 "D_Zener" H 2700 1826 50  0000 C CNN
F 2 "" H 2700 1700 50  0001 C CNN
F 3 "~" H 2700 1700 50  0001 C CNN
	1    2700 1700
	-1   0    0    -1  
$EndComp
$Comp
L Isolator:TLP291 U?
U 1 1 655898F6
P 12450 1400
AR Path="/655898F6" Ref="U?"  Part="1" 
AR Path="/653FA36F/655898F6" Ref="U?"  Part="1" 
F 0 "U?" H 12450 1725 50  0000 C CNN
F 1 "TLP291" H 12450 1634 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 12250 1200 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 12450 1400 50  0001 L CNN
	1    12450 1400
	1    0    0    -1  
$EndComp
$Comp
L Driver_FET:NCV8402xST Q?
U 1 1 655898FC
P 13450 1500
AR Path="/655898FC" Ref="Q?"  Part="1" 
AR Path="/653FA36F/655898FC" Ref="Q?"  Part="1" 
F 0 "Q?" H 13878 1546 50  0000 L CNN
F 1 "NCV8402xST" H 13878 1455 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-223" H 13450 1220 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/NCV8402-D.PDF" H 13750 1500 50  0001 C CNN
	1    13450 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	12750 1500 12950 1500
Wire Wire Line
	12850 1300 12750 1300
$Comp
L Device:Polyfuse F?
U 1 1 65589904
P 13750 2100
AR Path="/65589904" Ref="F?"  Part="1" 
AR Path="/653FA36F/65589904" Ref="F?"  Part="1" 
F 0 "F?" H 13838 2146 50  0000 L CNN
F 1 "Polyfuse" H 13838 2055 50  0000 L CNN
F 2 "" H 13800 1900 50  0001 L CNN
F 3 "~" H 13750 2100 50  0001 C CNN
	1    13750 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	13750 1900 13750 1950
$Comp
L Diode:US1M D?
U 1 1 6558990B
P 13750 2450
AR Path="/6558990B" Ref="D?"  Part="1" 
AR Path="/653FA36F/6558990B" Ref="D?"  Part="1" 
F 0 "D?" V 13704 2530 50  0000 L CNN
F 1 "US1M" V 13795 2530 50  0000 L CNN
F 2 "Diode_SMD:D_SMA" H 13750 2275 50  0001 C CNN
F 3 "https://www.diodes.com/assets/Datasheets/ds16008.pdf" H 13750 2450 50  0001 C CNN
	1    13750 2450
	0    1    1    0   
$EndComp
Text HLabel 11600 2600 0    118  Input ~ 0
ACT_GND-0
$Comp
L Device:R R?
U 1 1 65589912
P 11700 1300
AR Path="/65589912" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589912" Ref="R?"  Part="1" 
F 0 "R?" V 11907 1300 50  0000 C CNN
F 1 "R" V 11816 1300 50  0000 C CNN
F 2 "" V 11630 1300 50  0001 C CNN
F 3 "~" H 11700 1300 50  0001 C CNN
	1    11700 1300
	0    -1   -1   0   
$EndComp
Text HLabel 11250 1300 0    118  Input ~ 0
ACT-0
Wire Wire Line
	11250 1300 11400 1300
Wire Wire Line
	11850 1300 12150 1300
Wire Wire Line
	11250 1500 12150 1500
Wire Wire Line
	12850 1300 12850 1000
Wire Wire Line
	12850 1000 13750 1000
Wire Wire Line
	13750 1100 13750 1000
Connection ~ 13750 1000
Wire Wire Line
	14350 2250 13750 2250
Wire Wire Line
	13750 2250 13750 2300
Connection ~ 13750 2250
Wire Wire Line
	13750 1000 14500 1000
$Comp
L Device:Q_NJFET_DGS Q?
U 1 1 65589925
P 11600 2200
AR Path="/65589925" Ref="Q?"  Part="1" 
AR Path="/653FA36F/65589925" Ref="Q?"  Part="1" 
F 0 "Q?" H 11791 2246 50  0000 L CNN
F 1 "Q_NJFET_DGS" H 11791 2155 50  0000 L CNN
F 2 "" H 11800 2300 50  0001 C CNN
F 3 "~" H 11600 2200 50  0001 C CNN
	1    11600 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	11400 2200 11400 1300
Connection ~ 11400 1300
Wire Wire Line
	11400 1300 11550 1300
Wire Wire Line
	11250 1700 11700 1700
Wire Wire Line
	11700 1700 11700 2000
Text HLabel 14350 2850 2    118  Output ~ 0
SERVO-0
$Comp
L Device:Polyfuse F?
U 1 1 65589932
P 12100 2850
AR Path="/65589932" Ref="F?"  Part="1" 
AR Path="/653FA36F/65589932" Ref="F?"  Part="1" 
F 0 "F?" V 11875 2850 50  0000 C CNN
F 1 "Polyfuse" V 11966 2850 50  0000 C CNN
F 2 "" H 12150 2650 50  0001 L CNN
F 3 "~" H 12100 2850 50  0001 C CNN
	1    12100 2850
	0    1    1    0   
$EndComp
Wire Wire Line
	11700 2400 11700 2850
Wire Wire Line
	11700 2850 11950 2850
Wire Wire Line
	12250 2850 14350 2850
Text HLabel 14350 2250 2    118  Output ~ 0
ACTOUT-0
Text HLabel 14500 1000 2    118  Input ~ 0
ACT_IN-0
$Comp
L Isolator:TLP291 U?
U 1 1 6558993D
P 12450 3500
AR Path="/6558993D" Ref="U?"  Part="1" 
AR Path="/653FA36F/6558993D" Ref="U?"  Part="1" 
F 0 "U?" H 12450 3825 50  0000 C CNN
F 1 "TLP291" H 12450 3734 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 12250 3300 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 12450 3500 50  0001 L CNN
	1    12450 3500
	1    0    0    -1  
$EndComp
$Comp
L Driver_FET:NCV8402xST Q?
U 1 1 65589943
P 13450 3600
AR Path="/65589943" Ref="Q?"  Part="1" 
AR Path="/653FA36F/65589943" Ref="Q?"  Part="1" 
F 0 "Q?" H 13878 3646 50  0000 L CNN
F 1 "NCV8402xST" H 13878 3555 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-223" H 13450 3320 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/NCV8402-D.PDF" H 13750 3600 50  0001 C CNN
	1    13450 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	12750 3600 12950 3600
Wire Wire Line
	12850 3400 12750 3400
$Comp
L Device:Polyfuse F?
U 1 1 6558994B
P 13750 4200
AR Path="/6558994B" Ref="F?"  Part="1" 
AR Path="/653FA36F/6558994B" Ref="F?"  Part="1" 
F 0 "F?" H 13838 4246 50  0000 L CNN
F 1 "Polyfuse" H 13838 4155 50  0000 L CNN
F 2 "" H 13800 4000 50  0001 L CNN
F 3 "~" H 13750 4200 50  0001 C CNN
	1    13750 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	13750 4000 13750 4050
$Comp
L Diode:US1M D?
U 1 1 65589952
P 13750 4550
AR Path="/65589952" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589952" Ref="D?"  Part="1" 
F 0 "D?" V 13704 4630 50  0000 L CNN
F 1 "US1M" V 13795 4630 50  0000 L CNN
F 2 "Diode_SMD:D_SMA" H 13750 4375 50  0001 C CNN
F 3 "https://www.diodes.com/assets/Datasheets/ds16008.pdf" H 13750 4550 50  0001 C CNN
	1    13750 4550
	0    1    1    0   
$EndComp
Text HLabel 11600 4700 0    118  Input ~ 0
ACT_GND-1
$Comp
L Device:R R?
U 1 1 65589959
P 11700 3400
AR Path="/65589959" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589959" Ref="R?"  Part="1" 
F 0 "R?" V 11907 3400 50  0000 C CNN
F 1 "R" V 11816 3400 50  0000 C CNN
F 2 "" V 11630 3400 50  0001 C CNN
F 3 "~" H 11700 3400 50  0001 C CNN
	1    11700 3400
	0    -1   -1   0   
$EndComp
Text HLabel 11250 3400 0    118  Input ~ 0
ACT-1
Wire Wire Line
	11250 3400 11400 3400
Wire Wire Line
	11850 3400 12150 3400
Wire Wire Line
	11250 3600 12150 3600
Wire Wire Line
	12850 3400 12850 3100
Wire Wire Line
	12850 3100 13750 3100
Wire Wire Line
	13750 3200 13750 3100
Connection ~ 13750 3100
Wire Wire Line
	14350 4350 13750 4350
Wire Wire Line
	13750 4350 13750 4400
Connection ~ 13750 4350
Wire Wire Line
	13750 3100 14500 3100
$Comp
L Device:Q_NJFET_DGS Q?
U 1 1 6558996C
P 11600 4300
AR Path="/6558996C" Ref="Q?"  Part="1" 
AR Path="/653FA36F/6558996C" Ref="Q?"  Part="1" 
F 0 "Q?" H 11791 4346 50  0000 L CNN
F 1 "Q_NJFET_DGS" H 11791 4255 50  0000 L CNN
F 2 "" H 11800 4400 50  0001 C CNN
F 3 "~" H 11600 4300 50  0001 C CNN
	1    11600 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	11400 4300 11400 3400
Connection ~ 11400 3400
Wire Wire Line
	11400 3400 11550 3400
Wire Wire Line
	11250 3800 11700 3800
Wire Wire Line
	11700 3800 11700 4100
Text HLabel 14350 4950 2    118  Output ~ 0
SERVO-1
$Comp
L Device:Polyfuse F?
U 1 1 65589979
P 12100 4950
AR Path="/65589979" Ref="F?"  Part="1" 
AR Path="/653FA36F/65589979" Ref="F?"  Part="1" 
F 0 "F?" V 11875 4950 50  0000 C CNN
F 1 "Polyfuse" V 11966 4950 50  0000 C CNN
F 2 "" H 12150 4750 50  0001 L CNN
F 3 "~" H 12100 4950 50  0001 C CNN
	1    12100 4950
	0    1    1    0   
$EndComp
Wire Wire Line
	11700 4500 11700 4950
Wire Wire Line
	11700 4950 11950 4950
Wire Wire Line
	12250 4950 14350 4950
Text HLabel 14350 4350 2    118  Output ~ 0
ACTOUT-1
Text HLabel 14500 3100 2    118  Input ~ 0
ACT_IN-1
$Comp
L Isolator:TLP291 U?
U 1 1 65589984
P 12450 5650
AR Path="/65589984" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589984" Ref="U?"  Part="1" 
F 0 "U?" H 12450 5975 50  0000 C CNN
F 1 "TLP291" H 12450 5884 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 12250 5450 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 12450 5650 50  0001 L CNN
	1    12450 5650
	1    0    0    -1  
$EndComp
$Comp
L Driver_FET:NCV8402xST Q?
U 1 1 6558998A
P 13450 5750
AR Path="/6558998A" Ref="Q?"  Part="1" 
AR Path="/653FA36F/6558998A" Ref="Q?"  Part="1" 
F 0 "Q?" H 13878 5796 50  0000 L CNN
F 1 "NCV8402xST" H 13878 5705 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-223" H 13450 5470 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/NCV8402-D.PDF" H 13750 5750 50  0001 C CNN
	1    13450 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	12750 5750 12950 5750
Wire Wire Line
	12850 5550 12750 5550
$Comp
L Device:Polyfuse F?
U 1 1 65589992
P 13750 6350
AR Path="/65589992" Ref="F?"  Part="1" 
AR Path="/653FA36F/65589992" Ref="F?"  Part="1" 
F 0 "F?" H 13838 6396 50  0000 L CNN
F 1 "Polyfuse" H 13838 6305 50  0000 L CNN
F 2 "" H 13800 6150 50  0001 L CNN
F 3 "~" H 13750 6350 50  0001 C CNN
	1    13750 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	13750 6150 13750 6200
$Comp
L Diode:US1M D?
U 1 1 65589999
P 13750 6700
AR Path="/65589999" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589999" Ref="D?"  Part="1" 
F 0 "D?" V 13704 6780 50  0000 L CNN
F 1 "US1M" V 13795 6780 50  0000 L CNN
F 2 "Diode_SMD:D_SMA" H 13750 6525 50  0001 C CNN
F 3 "https://www.diodes.com/assets/Datasheets/ds16008.pdf" H 13750 6700 50  0001 C CNN
	1    13750 6700
	0    1    1    0   
$EndComp
Text HLabel 11600 6850 0    118  Input ~ 0
ACT_GND-2
$Comp
L Device:R R?
U 1 1 655899A0
P 11700 5550
AR Path="/655899A0" Ref="R?"  Part="1" 
AR Path="/653FA36F/655899A0" Ref="R?"  Part="1" 
F 0 "R?" V 11907 5550 50  0000 C CNN
F 1 "R" V 11816 5550 50  0000 C CNN
F 2 "" V 11630 5550 50  0001 C CNN
F 3 "~" H 11700 5550 50  0001 C CNN
	1    11700 5550
	0    -1   -1   0   
$EndComp
Text HLabel 11250 5550 0    118  Input ~ 0
ACT-2
Wire Wire Line
	11250 5550 11400 5550
Wire Wire Line
	11850 5550 12150 5550
Wire Wire Line
	11250 5750 12150 5750
Wire Wire Line
	12850 5550 12850 5250
Wire Wire Line
	12850 5250 13750 5250
Wire Wire Line
	13750 5350 13750 5250
Connection ~ 13750 5250
Wire Wire Line
	14350 6500 13750 6500
Wire Wire Line
	13750 6500 13750 6550
Connection ~ 13750 6500
Wire Wire Line
	13750 5250 14500 5250
$Comp
L Device:Q_NJFET_DGS Q?
U 1 1 655899B3
P 11600 6450
AR Path="/655899B3" Ref="Q?"  Part="1" 
AR Path="/653FA36F/655899B3" Ref="Q?"  Part="1" 
F 0 "Q?" H 11791 6496 50  0000 L CNN
F 1 "Q_NJFET_DGS" H 11791 6405 50  0000 L CNN
F 2 "" H 11800 6550 50  0001 C CNN
F 3 "~" H 11600 6450 50  0001 C CNN
	1    11600 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	11400 6450 11400 5550
Connection ~ 11400 5550
Wire Wire Line
	11400 5550 11550 5550
Wire Wire Line
	11250 5950 11700 5950
Wire Wire Line
	11700 5950 11700 6250
Text HLabel 14350 7100 2    118  Output ~ 0
SERVO-0
$Comp
L Device:Polyfuse F?
U 1 1 655899C0
P 12100 7100
AR Path="/655899C0" Ref="F?"  Part="1" 
AR Path="/653FA36F/655899C0" Ref="F?"  Part="1" 
F 0 "F?" V 11875 7100 50  0000 C CNN
F 1 "Polyfuse" V 11966 7100 50  0000 C CNN
F 2 "" H 12150 6900 50  0001 L CNN
F 3 "~" H 12100 7100 50  0001 C CNN
	1    12100 7100
	0    1    1    0   
$EndComp
Wire Wire Line
	11700 6650 11700 7100
Wire Wire Line
	11700 7100 11950 7100
Wire Wire Line
	12250 7100 14350 7100
Text HLabel 14350 6500 2    118  Output ~ 0
ACTOUT-2
Text HLabel 14500 5250 2    118  Input ~ 0
ACT_IN-2
$Comp
L Isolator:TLP291 U?
U 1 1 655899CB
P 12450 7750
AR Path="/655899CB" Ref="U?"  Part="1" 
AR Path="/653FA36F/655899CB" Ref="U?"  Part="1" 
F 0 "U?" H 12450 8075 50  0000 C CNN
F 1 "TLP291" H 12450 7984 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 12250 7550 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 12450 7750 50  0001 L CNN
	1    12450 7750
	1    0    0    -1  
$EndComp
$Comp
L Driver_FET:NCV8402xST Q?
U 1 1 655899D1
P 13450 7850
AR Path="/655899D1" Ref="Q?"  Part="1" 
AR Path="/653FA36F/655899D1" Ref="Q?"  Part="1" 
F 0 "Q?" H 13878 7896 50  0000 L CNN
F 1 "NCV8402xST" H 13878 7805 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-223" H 13450 7570 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/NCV8402-D.PDF" H 13750 7850 50  0001 C CNN
	1    13450 7850
	1    0    0    -1  
$EndComp
Wire Wire Line
	12750 7850 12950 7850
Wire Wire Line
	12850 7650 12750 7650
$Comp
L Device:Polyfuse F?
U 1 1 655899D9
P 13750 8450
AR Path="/655899D9" Ref="F?"  Part="1" 
AR Path="/653FA36F/655899D9" Ref="F?"  Part="1" 
F 0 "F?" H 13838 8496 50  0000 L CNN
F 1 "Polyfuse" H 13838 8405 50  0000 L CNN
F 2 "" H 13800 8250 50  0001 L CNN
F 3 "~" H 13750 8450 50  0001 C CNN
	1    13750 8450
	1    0    0    -1  
$EndComp
Wire Wire Line
	13750 8250 13750 8300
$Comp
L Diode:US1M D?
U 1 1 655899E0
P 13750 8800
AR Path="/655899E0" Ref="D?"  Part="1" 
AR Path="/653FA36F/655899E0" Ref="D?"  Part="1" 
F 0 "D?" V 13704 8880 50  0000 L CNN
F 1 "US1M" V 13795 8880 50  0000 L CNN
F 2 "Diode_SMD:D_SMA" H 13750 8625 50  0001 C CNN
F 3 "https://www.diodes.com/assets/Datasheets/ds16008.pdf" H 13750 8800 50  0001 C CNN
	1    13750 8800
	0    1    1    0   
$EndComp
Text HLabel 11600 8950 0    118  Input ~ 0
ACT_GND-3
$Comp
L Device:R R?
U 1 1 655899E7
P 11700 7650
AR Path="/655899E7" Ref="R?"  Part="1" 
AR Path="/653FA36F/655899E7" Ref="R?"  Part="1" 
F 0 "R?" V 11907 7650 50  0000 C CNN
F 1 "R" V 11816 7650 50  0000 C CNN
F 2 "" V 11630 7650 50  0001 C CNN
F 3 "~" H 11700 7650 50  0001 C CNN
	1    11700 7650
	0    -1   -1   0   
$EndComp
Text HLabel 11250 7650 0    118  Input ~ 0
ACT-3
Wire Wire Line
	11250 7650 11400 7650
Wire Wire Line
	11850 7650 12150 7650
Wire Wire Line
	11250 7850 12150 7850
Wire Wire Line
	12850 7650 12850 7350
Wire Wire Line
	12850 7350 13750 7350
Wire Wire Line
	13750 7450 13750 7350
Connection ~ 13750 7350
Wire Wire Line
	14350 8600 13750 8600
Wire Wire Line
	13750 8600 13750 8650
Connection ~ 13750 8600
Wire Wire Line
	13750 7350 14500 7350
$Comp
L Device:Q_NJFET_DGS Q?
U 1 1 655899FA
P 11600 8550
AR Path="/655899FA" Ref="Q?"  Part="1" 
AR Path="/653FA36F/655899FA" Ref="Q?"  Part="1" 
F 0 "Q?" H 11791 8596 50  0000 L CNN
F 1 "Q_NJFET_DGS" H 11791 8505 50  0000 L CNN
F 2 "" H 11800 8650 50  0001 C CNN
F 3 "~" H 11600 8550 50  0001 C CNN
	1    11600 8550
	1    0    0    -1  
$EndComp
Wire Wire Line
	11400 8550 11400 7650
Connection ~ 11400 7650
Wire Wire Line
	11400 7650 11550 7650
Wire Wire Line
	11250 8050 11700 8050
Wire Wire Line
	11700 8050 11700 8350
Text HLabel 14350 9200 2    118  Output ~ 0
SERVO-3
$Comp
L Device:Polyfuse F?
U 1 1 65589A07
P 12100 9200
AR Path="/65589A07" Ref="F?"  Part="1" 
AR Path="/653FA36F/65589A07" Ref="F?"  Part="1" 
F 0 "F?" V 11875 9200 50  0000 C CNN
F 1 "Polyfuse" V 11966 9200 50  0000 C CNN
F 2 "" H 12150 9000 50  0001 L CNN
F 3 "~" H 12100 9200 50  0001 C CNN
	1    12100 9200
	0    1    1    0   
$EndComp
Wire Wire Line
	11700 8750 11700 9200
Wire Wire Line
	11700 9200 11950 9200
Wire Wire Line
	12250 9200 14350 9200
Text HLabel 14350 8600 2    118  Output ~ 0
ACTOUT-3
Text HLabel 14500 7350 2    118  Input ~ 0
ACT_IN-3
$Comp
L Isolator:TLP291 U?
U 1 1 65589A12
P 4800 5950
AR Path="/65589A12" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589A12" Ref="U?"  Part="1" 
F 0 "U?" H 4800 6275 50  0000 C CNN
F 1 "TLP291" H 4800 6184 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 4600 5750 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 4800 5950 50  0001 L CNN
	1    4800 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 5850 5100 5850
Text HLabel 5150 6050 2    118  Output ~ 0
S-0
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589A1B
P 3700 5850
AR Path="/65589A1B" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589A1B" Ref="U?"  Part="1" 
F 0 "U?" H 3700 6092 50  0000 C CNN
F 1 "LM317_TO-220" H 3700 6001 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 3700 6100 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 3700 5850 50  0001 C CNN
	1    3700 5850
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589A21
P 4100 6350
AR Path="/65589A21" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A21" Ref="R?"  Part="1" 
F 0 "R?" H 4170 6396 50  0000 L CNN
F 1 "R" H 4170 6305 50  0000 L CNN
F 2 "" V 4030 6350 50  0001 C CNN
F 3 "~" H 4100 6350 50  0001 C CNN
	1    4100 6350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589A27
P 3700 6350
AR Path="/65589A27" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A27" Ref="R?"  Part="1" 
F 0 "R?" H 3770 6396 50  0000 L CNN
F 1 "R" H 3770 6305 50  0000 L CNN
F 2 "" V 3630 6350 50  0001 C CNN
F 3 "~" H 3700 6350 50  0001 C CNN
	1    3700 6350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589A2D
P 3700 6700
AR Path="/65589A2D" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A2D" Ref="R?"  Part="1" 
F 0 "R?" H 3770 6746 50  0000 L CNN
F 1 "R" H 3770 6655 50  0000 L CNN
F 2 "" V 3630 6700 50  0001 C CNN
F 3 "~" H 3700 6700 50  0001 C CNN
	1    3700 6700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 6150 3700 6200
Wire Wire Line
	4000 5850 4100 5850
Wire Wire Line
	4100 5850 4100 6200
Wire Wire Line
	4100 6500 3700 6500
Wire Wire Line
	3700 6500 3700 6550
Connection ~ 3700 6500
$Comp
L Device:R R?
U 1 1 65589A39
P 4300 5850
AR Path="/65589A39" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A39" Ref="R?"  Part="1" 
F 0 "R?" V 4093 5850 50  0000 C CNN
F 1 "R" V 4184 5850 50  0000 C CNN
F 2 "" V 4230 5850 50  0001 C CNN
F 3 "~" H 4300 5850 50  0001 C CNN
	1    4300 5850
	0    1    1    0   
$EndComp
Wire Wire Line
	4100 5850 4150 5850
Connection ~ 4100 5850
Wire Wire Line
	4450 5850 4500 5850
Wire Wire Line
	4500 6050 4500 6850
Wire Wire Line
	4500 6850 3700 6850
$Comp
L Device:R R?
U 1 1 65589A44
P 3050 5850
AR Path="/65589A44" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A44" Ref="R?"  Part="1" 
F 0 "R?" V 2843 5850 50  0000 C CNN
F 1 "R" V 2934 5850 50  0000 C CNN
F 2 "" V 2980 5850 50  0001 C CNN
F 3 "~" H 3050 5850 50  0001 C CNN
	1    3050 5850
	0    1    1    0   
$EndComp
Wire Wire Line
	3300 6500 3300 6850
Wire Wire Line
	3300 6850 3700 6850
Connection ~ 3700 6850
Wire Wire Line
	3300 6200 3300 5850
Wire Wire Line
	3300 5850 3400 5850
Wire Wire Line
	3300 5850 3200 5850
Connection ~ 3300 5850
Wire Wire Line
	2700 5850 2900 5850
Text HLabel 2700 5850 0    118  Input ~ 0
SENSE-0
Text HLabel 2700 6850 0    118  Input ~ 0
SENSE_GND-0
$Comp
L Device:D_Zener D?
U 1 1 65589A54
P 3300 6350
AR Path="/65589A54" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589A54" Ref="D?"  Part="1" 
F 0 "D?" V 3254 6270 50  0000 R CNN
F 1 "D_Zener" V 3345 6270 50  0000 R CNN
F 2 "" H 3300 6350 50  0001 C CNN
F 3 "~" H 3300 6350 50  0001 C CNN
	1    3300 6350
	0    -1   1    0   
$EndComp
Wire Wire Line
	5200 5850 5200 5500
Wire Wire Line
	5200 5500 5100 5500
Wire Wire Line
	5100 6050 5150 6050
$Comp
L Isolator:TLP291 U?
U 1 1 65589A5D
P 4800 7300
AR Path="/65589A5D" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589A5D" Ref="U?"  Part="1" 
F 0 "U?" H 4800 7625 50  0000 C CNN
F 1 "TLP291" H 4800 7534 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 4600 7100 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 4800 7300 50  0001 L CNN
	1    4800 7300
	1    0    0    -1  
$EndComp
Text HLabel 5150 7400 2    118  Output ~ 0
S-1
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589A65
P 3700 7200
AR Path="/65589A65" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589A65" Ref="U?"  Part="1" 
F 0 "U?" H 3700 7442 50  0000 C CNN
F 1 "LM317_TO-220" H 3700 7351 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 3700 7450 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 3700 7200 50  0001 C CNN
	1    3700 7200
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589A6B
P 4100 7700
AR Path="/65589A6B" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A6B" Ref="R?"  Part="1" 
F 0 "R?" H 4170 7746 50  0000 L CNN
F 1 "R" H 4170 7655 50  0000 L CNN
F 2 "" V 4030 7700 50  0001 C CNN
F 3 "~" H 4100 7700 50  0001 C CNN
	1    4100 7700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589A71
P 3700 7700
AR Path="/65589A71" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A71" Ref="R?"  Part="1" 
F 0 "R?" H 3770 7746 50  0000 L CNN
F 1 "R" H 3770 7655 50  0000 L CNN
F 2 "" V 3630 7700 50  0001 C CNN
F 3 "~" H 3700 7700 50  0001 C CNN
	1    3700 7700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589A77
P 3700 8050
AR Path="/65589A77" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A77" Ref="R?"  Part="1" 
F 0 "R?" H 3770 8096 50  0000 L CNN
F 1 "R" H 3770 8005 50  0000 L CNN
F 2 "" V 3630 8050 50  0001 C CNN
F 3 "~" H 3700 8050 50  0001 C CNN
	1    3700 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 7500 3700 7550
Wire Wire Line
	4000 7200 4100 7200
Wire Wire Line
	4100 7200 4100 7550
Wire Wire Line
	4100 7850 3700 7850
Wire Wire Line
	3700 7850 3700 7900
Connection ~ 3700 7850
$Comp
L Device:R R?
U 1 1 65589A83
P 4300 7200
AR Path="/65589A83" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A83" Ref="R?"  Part="1" 
F 0 "R?" V 4093 7200 50  0000 C CNN
F 1 "R" V 4184 7200 50  0000 C CNN
F 2 "" V 4230 7200 50  0001 C CNN
F 3 "~" H 4300 7200 50  0001 C CNN
	1    4300 7200
	0    1    1    0   
$EndComp
Wire Wire Line
	4100 7200 4150 7200
Connection ~ 4100 7200
Wire Wire Line
	4450 7200 4500 7200
Wire Wire Line
	4500 7400 4500 8200
Wire Wire Line
	4500 8200 3700 8200
$Comp
L Device:R R?
U 1 1 65589A8E
P 3050 7200
AR Path="/65589A8E" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589A8E" Ref="R?"  Part="1" 
F 0 "R?" V 2843 7200 50  0000 C CNN
F 1 "R" V 2934 7200 50  0000 C CNN
F 2 "" V 2980 7200 50  0001 C CNN
F 3 "~" H 3050 7200 50  0001 C CNN
	1    3050 7200
	0    1    1    0   
$EndComp
Wire Wire Line
	3300 7850 3300 8200
Wire Wire Line
	3300 8200 3700 8200
Connection ~ 3700 8200
Wire Wire Line
	3300 7550 3300 7200
Wire Wire Line
	3300 7200 3400 7200
Wire Wire Line
	3300 7200 3200 7200
Connection ~ 3300 7200
Wire Wire Line
	2700 7200 2900 7200
Text HLabel 2700 7200 0    118  Input ~ 0
SENSE-1
Text HLabel 2700 8200 0    118  Input ~ 0
SENSE_GND-1
$Comp
L Device:D_Zener D?
U 1 1 65589A9E
P 3300 7700
AR Path="/65589A9E" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589A9E" Ref="D?"  Part="1" 
F 0 "D?" V 3254 7620 50  0000 R CNN
F 1 "D_Zener" V 3345 7620 50  0000 R CNN
F 2 "" H 3300 7700 50  0001 C CNN
F 3 "~" H 3300 7700 50  0001 C CNN
	1    3300 7700
	0    -1   1    0   
$EndComp
Wire Wire Line
	5100 7400 5150 7400
$Comp
L Isolator:TLP291 U?
U 1 1 65589AA5
P 4800 8650
AR Path="/65589AA5" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589AA5" Ref="U?"  Part="1" 
F 0 "U?" H 4800 8975 50  0000 C CNN
F 1 "TLP291" H 4800 8884 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 4600 8450 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 4800 8650 50  0001 L CNN
	1    4800 8650
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 8550 5100 8550
Text HLabel 5150 8750 2    118  Output ~ 0
S-2
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589AAE
P 3700 8550
AR Path="/65589AAE" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589AAE" Ref="U?"  Part="1" 
F 0 "U?" H 3700 8792 50  0000 C CNN
F 1 "LM317_TO-220" H 3700 8701 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 3700 8800 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 3700 8550 50  0001 C CNN
	1    3700 8550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589AB4
P 4100 9050
AR Path="/65589AB4" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589AB4" Ref="R?"  Part="1" 
F 0 "R?" H 4170 9096 50  0000 L CNN
F 1 "R" H 4170 9005 50  0000 L CNN
F 2 "" V 4030 9050 50  0001 C CNN
F 3 "~" H 4100 9050 50  0001 C CNN
	1    4100 9050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589ABA
P 3700 9050
AR Path="/65589ABA" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589ABA" Ref="R?"  Part="1" 
F 0 "R?" H 3770 9096 50  0000 L CNN
F 1 "R" H 3770 9005 50  0000 L CNN
F 2 "" V 3630 9050 50  0001 C CNN
F 3 "~" H 3700 9050 50  0001 C CNN
	1    3700 9050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589AC0
P 3700 9400
AR Path="/65589AC0" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589AC0" Ref="R?"  Part="1" 
F 0 "R?" H 3770 9446 50  0000 L CNN
F 1 "R" H 3770 9355 50  0000 L CNN
F 2 "" V 3630 9400 50  0001 C CNN
F 3 "~" H 3700 9400 50  0001 C CNN
	1    3700 9400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 8850 3700 8900
Wire Wire Line
	4000 8550 4100 8550
Wire Wire Line
	4100 8550 4100 8900
Wire Wire Line
	4100 9200 3700 9200
Wire Wire Line
	3700 9200 3700 9250
Connection ~ 3700 9200
$Comp
L Device:R R?
U 1 1 65589ACC
P 4300 8550
AR Path="/65589ACC" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589ACC" Ref="R?"  Part="1" 
F 0 "R?" V 4093 8550 50  0000 C CNN
F 1 "R" V 4184 8550 50  0000 C CNN
F 2 "" V 4230 8550 50  0001 C CNN
F 3 "~" H 4300 8550 50  0001 C CNN
	1    4300 8550
	0    1    1    0   
$EndComp
Wire Wire Line
	4100 8550 4150 8550
Connection ~ 4100 8550
Wire Wire Line
	4450 8550 4500 8550
Wire Wire Line
	4500 8750 4500 9550
Wire Wire Line
	4500 9550 3700 9550
$Comp
L Device:R R?
U 1 1 65589AD7
P 3050 8550
AR Path="/65589AD7" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589AD7" Ref="R?"  Part="1" 
F 0 "R?" V 2843 8550 50  0000 C CNN
F 1 "R" V 2934 8550 50  0000 C CNN
F 2 "" V 2980 8550 50  0001 C CNN
F 3 "~" H 3050 8550 50  0001 C CNN
	1    3050 8550
	0    1    1    0   
$EndComp
Wire Wire Line
	3300 9200 3300 9550
Wire Wire Line
	3300 9550 3700 9550
Connection ~ 3700 9550
Wire Wire Line
	3300 8900 3300 8550
Wire Wire Line
	3300 8550 3400 8550
Wire Wire Line
	3300 8550 3200 8550
Connection ~ 3300 8550
Wire Wire Line
	2700 8550 2900 8550
Text HLabel 2700 8550 0    118  Input ~ 0
SENSE-2
Text HLabel 2700 9550 0    118  Input ~ 0
SENSE_GND-2
$Comp
L Device:D_Zener D?
U 1 1 65589AE7
P 3300 9050
AR Path="/65589AE7" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589AE7" Ref="D?"  Part="1" 
F 0 "D?" V 3254 8970 50  0000 R CNN
F 1 "D_Zener" V 3345 8970 50  0000 R CNN
F 2 "" H 3300 9050 50  0001 C CNN
F 3 "~" H 3300 9050 50  0001 C CNN
	1    3300 9050
	0    -1   1    0   
$EndComp
Wire Wire Line
	5200 8550 5200 8200
Wire Wire Line
	5100 8750 5150 8750
$Comp
L Isolator:TLP291 U?
U 1 1 65589AEF
P 4800 10000
AR Path="/65589AEF" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589AEF" Ref="U?"  Part="1" 
F 0 "U?" H 4800 10325 50  0000 C CNN
F 1 "TLP291" H 4800 10234 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 4600 9800 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 4800 10000 50  0001 L CNN
	1    4800 10000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 9900 5100 9900
Text HLabel 5150 10100 2    118  Output ~ 0
S-3
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589AF8
P 3700 9900
AR Path="/65589AF8" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589AF8" Ref="U?"  Part="1" 
F 0 "U?" H 3700 10142 50  0000 C CNN
F 1 "LM317_TO-220" H 3700 10051 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 3700 10150 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 3700 9900 50  0001 C CNN
	1    3700 9900
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589AFE
P 4100 10400
AR Path="/65589AFE" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589AFE" Ref="R?"  Part="1" 
F 0 "R?" H 4170 10446 50  0000 L CNN
F 1 "R" H 4170 10355 50  0000 L CNN
F 2 "" V 4030 10400 50  0001 C CNN
F 3 "~" H 4100 10400 50  0001 C CNN
	1    4100 10400
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589B04
P 3700 10400
AR Path="/65589B04" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B04" Ref="R?"  Part="1" 
F 0 "R?" H 3770 10446 50  0000 L CNN
F 1 "R" H 3770 10355 50  0000 L CNN
F 2 "" V 3630 10400 50  0001 C CNN
F 3 "~" H 3700 10400 50  0001 C CNN
	1    3700 10400
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589B0A
P 3700 10750
AR Path="/65589B0A" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B0A" Ref="R?"  Part="1" 
F 0 "R?" H 3770 10796 50  0000 L CNN
F 1 "R" H 3770 10705 50  0000 L CNN
F 2 "" V 3630 10750 50  0001 C CNN
F 3 "~" H 3700 10750 50  0001 C CNN
	1    3700 10750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 10200 3700 10250
Wire Wire Line
	4000 9900 4100 9900
Wire Wire Line
	4100 9900 4100 10250
Wire Wire Line
	4100 10550 3700 10550
Wire Wire Line
	3700 10550 3700 10600
Connection ~ 3700 10550
$Comp
L Device:R R?
U 1 1 65589B16
P 4300 9900
AR Path="/65589B16" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B16" Ref="R?"  Part="1" 
F 0 "R?" V 4093 9900 50  0000 C CNN
F 1 "R" V 4184 9900 50  0000 C CNN
F 2 "" V 4230 9900 50  0001 C CNN
F 3 "~" H 4300 9900 50  0001 C CNN
	1    4300 9900
	0    1    1    0   
$EndComp
Wire Wire Line
	4100 9900 4150 9900
Connection ~ 4100 9900
Wire Wire Line
	4450 9900 4500 9900
Wire Wire Line
	4500 10100 4500 10900
Wire Wire Line
	4500 10900 3700 10900
$Comp
L Device:R R?
U 1 1 65589B21
P 3050 9900
AR Path="/65589B21" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B21" Ref="R?"  Part="1" 
F 0 "R?" V 2843 9900 50  0000 C CNN
F 1 "R" V 2934 9900 50  0000 C CNN
F 2 "" V 2980 9900 50  0001 C CNN
F 3 "~" H 3050 9900 50  0001 C CNN
	1    3050 9900
	0    1    1    0   
$EndComp
Wire Wire Line
	3300 10550 3300 10900
Wire Wire Line
	3300 10900 3700 10900
Connection ~ 3700 10900
Wire Wire Line
	3300 10250 3300 9900
Wire Wire Line
	3300 9900 3400 9900
Wire Wire Line
	3300 9900 3200 9900
Connection ~ 3300 9900
Wire Wire Line
	2700 9900 2900 9900
Text HLabel 2700 9900 0    118  Input ~ 0
SENSE-3
Text HLabel 2700 10900 0    118  Input ~ 0
SENSE_GND-3
$Comp
L Device:D_Zener D?
U 1 1 65589B31
P 3300 10400
AR Path="/65589B31" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589B31" Ref="D?"  Part="1" 
F 0 "D?" V 3254 10320 50  0000 R CNN
F 1 "D_Zener" V 3345 10320 50  0000 R CNN
F 2 "" H 3300 10400 50  0001 C CNN
F 3 "~" H 3300 10400 50  0001 C CNN
	1    3300 10400
	0    -1   1    0   
$EndComp
Wire Wire Line
	5200 9900 5200 9550
Wire Wire Line
	5100 10100 5150 10100
$Comp
L Isolator:TLP291 U?
U 1 1 65589B39
P 9250 5900
AR Path="/65589B39" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589B39" Ref="U?"  Part="1" 
F 0 "U?" H 9250 6225 50  0000 C CNN
F 1 "TLP291" H 9250 6134 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 9050 5700 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 9250 5900 50  0001 L CNN
	1    9250 5900
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 5800 9550 5800
Text HLabel 9600 6000 2    118  Output ~ 0
S-4
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589B42
P 8150 5800
AR Path="/65589B42" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589B42" Ref="U?"  Part="1" 
F 0 "U?" H 8150 6042 50  0000 C CNN
F 1 "LM317_TO-220" H 8150 5951 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 8150 6050 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 8150 5800 50  0001 C CNN
	1    8150 5800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589B48
P 8550 6300
AR Path="/65589B48" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B48" Ref="R?"  Part="1" 
F 0 "R?" H 8620 6346 50  0000 L CNN
F 1 "R" H 8620 6255 50  0000 L CNN
F 2 "" V 8480 6300 50  0001 C CNN
F 3 "~" H 8550 6300 50  0001 C CNN
	1    8550 6300
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589B4E
P 8150 6300
AR Path="/65589B4E" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B4E" Ref="R?"  Part="1" 
F 0 "R?" H 8220 6346 50  0000 L CNN
F 1 "R" H 8220 6255 50  0000 L CNN
F 2 "" V 8080 6300 50  0001 C CNN
F 3 "~" H 8150 6300 50  0001 C CNN
	1    8150 6300
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589B54
P 8150 6650
AR Path="/65589B54" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B54" Ref="R?"  Part="1" 
F 0 "R?" H 8220 6696 50  0000 L CNN
F 1 "R" H 8220 6605 50  0000 L CNN
F 2 "" V 8080 6650 50  0001 C CNN
F 3 "~" H 8150 6650 50  0001 C CNN
	1    8150 6650
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 6100 8150 6150
Wire Wire Line
	8450 5800 8550 5800
Wire Wire Line
	8550 5800 8550 6150
Wire Wire Line
	8550 6450 8150 6450
Wire Wire Line
	8150 6450 8150 6500
Connection ~ 8150 6450
$Comp
L Device:R R?
U 1 1 65589B60
P 8750 5800
AR Path="/65589B60" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B60" Ref="R?"  Part="1" 
F 0 "R?" V 8543 5800 50  0000 C CNN
F 1 "R" V 8634 5800 50  0000 C CNN
F 2 "" V 8680 5800 50  0001 C CNN
F 3 "~" H 8750 5800 50  0001 C CNN
	1    8750 5800
	0    1    1    0   
$EndComp
Wire Wire Line
	8550 5800 8600 5800
Connection ~ 8550 5800
Wire Wire Line
	8900 5800 8950 5800
Wire Wire Line
	8950 6000 8950 6800
Wire Wire Line
	8950 6800 8150 6800
$Comp
L Device:R R?
U 1 1 65589B6B
P 7500 5800
AR Path="/65589B6B" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B6B" Ref="R?"  Part="1" 
F 0 "R?" V 7293 5800 50  0000 C CNN
F 1 "R" V 7384 5800 50  0000 C CNN
F 2 "" V 7430 5800 50  0001 C CNN
F 3 "~" H 7500 5800 50  0001 C CNN
	1    7500 5800
	0    1    1    0   
$EndComp
Wire Wire Line
	7750 6450 7750 6800
Wire Wire Line
	7750 6800 8150 6800
Connection ~ 8150 6800
Wire Wire Line
	7750 6150 7750 5800
Wire Wire Line
	7750 5800 7850 5800
Wire Wire Line
	7750 5800 7650 5800
Connection ~ 7750 5800
Wire Wire Line
	7150 5800 7350 5800
Text HLabel 7150 5800 0    118  Input ~ 0
SENSE-4
Text HLabel 7100 6800 0    118  Input ~ 0
SENSE_GND-4
Wire Wire Line
	7100 6800 7750 6800
Connection ~ 7750 6800
$Comp
L Device:D_Zener D?
U 1 1 65589B7D
P 7750 6300
AR Path="/65589B7D" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589B7D" Ref="D?"  Part="1" 
F 0 "D?" V 7704 6220 50  0000 R CNN
F 1 "D_Zener" V 7795 6220 50  0000 R CNN
F 2 "" H 7750 6300 50  0001 C CNN
F 3 "~" H 7750 6300 50  0001 C CNN
	1    7750 6300
	0    -1   1    0   
$EndComp
Wire Wire Line
	9650 5800 9650 5450
Wire Wire Line
	9550 6000 9600 6000
$Comp
L Isolator:TLP291 U?
U 1 1 65589B85
P 9200 7250
AR Path="/65589B85" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589B85" Ref="U?"  Part="1" 
F 0 "U?" H 9200 7575 50  0000 C CNN
F 1 "TLP291" H 9200 7484 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 9000 7050 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 9200 7250 50  0001 L CNN
	1    9200 7250
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 7150 9500 7150
Text HLabel 9550 7350 2    118  Output ~ 0
S-5
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589B8E
P 8100 7150
AR Path="/65589B8E" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589B8E" Ref="U?"  Part="1" 
F 0 "U?" H 8100 7392 50  0000 C CNN
F 1 "LM317_TO-220" H 8100 7301 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 8100 7400 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 8100 7150 50  0001 C CNN
	1    8100 7150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589B94
P 8500 7650
AR Path="/65589B94" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B94" Ref="R?"  Part="1" 
F 0 "R?" H 8570 7696 50  0000 L CNN
F 1 "R" H 8570 7605 50  0000 L CNN
F 2 "" V 8430 7650 50  0001 C CNN
F 3 "~" H 8500 7650 50  0001 C CNN
	1    8500 7650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589B9A
P 8100 7650
AR Path="/65589B9A" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589B9A" Ref="R?"  Part="1" 
F 0 "R?" H 8170 7696 50  0000 L CNN
F 1 "R" H 8170 7605 50  0000 L CNN
F 2 "" V 8030 7650 50  0001 C CNN
F 3 "~" H 8100 7650 50  0001 C CNN
	1    8100 7650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589BA0
P 8100 8000
AR Path="/65589BA0" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589BA0" Ref="R?"  Part="1" 
F 0 "R?" H 8170 8046 50  0000 L CNN
F 1 "R" H 8170 7955 50  0000 L CNN
F 2 "" V 8030 8000 50  0001 C CNN
F 3 "~" H 8100 8000 50  0001 C CNN
	1    8100 8000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 7450 8100 7500
Wire Wire Line
	8400 7150 8500 7150
Wire Wire Line
	8500 7150 8500 7500
Wire Wire Line
	8500 7800 8100 7800
Wire Wire Line
	8100 7800 8100 7850
Connection ~ 8100 7800
$Comp
L Device:R R?
U 1 1 65589BAC
P 8700 7150
AR Path="/65589BAC" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589BAC" Ref="R?"  Part="1" 
F 0 "R?" V 8493 7150 50  0000 C CNN
F 1 "R" V 8584 7150 50  0000 C CNN
F 2 "" V 8630 7150 50  0001 C CNN
F 3 "~" H 8700 7150 50  0001 C CNN
	1    8700 7150
	0    1    1    0   
$EndComp
Wire Wire Line
	8500 7150 8550 7150
Connection ~ 8500 7150
Wire Wire Line
	8850 7150 8900 7150
Wire Wire Line
	8900 7350 8900 8150
Wire Wire Line
	8900 8150 8100 8150
$Comp
L Device:R R?
U 1 1 65589BB7
P 7450 7150
AR Path="/65589BB7" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589BB7" Ref="R?"  Part="1" 
F 0 "R?" V 7243 7150 50  0000 C CNN
F 1 "R" V 7334 7150 50  0000 C CNN
F 2 "" V 7380 7150 50  0001 C CNN
F 3 "~" H 7450 7150 50  0001 C CNN
	1    7450 7150
	0    1    1    0   
$EndComp
Wire Wire Line
	7700 7800 7700 8150
Wire Wire Line
	7700 8150 8100 8150
Connection ~ 8100 8150
Wire Wire Line
	7700 7500 7700 7150
Wire Wire Line
	7700 7150 7800 7150
Wire Wire Line
	7700 7150 7600 7150
Connection ~ 7700 7150
Wire Wire Line
	7100 7150 7300 7150
Text HLabel 7100 7150 0    118  Input ~ 0
SENSE-5
Text HLabel 7050 8150 0    118  Input ~ 0
SENSE_GND-5
Wire Wire Line
	7050 8150 7700 8150
Connection ~ 7700 8150
$Comp
L Device:D_Zener D?
U 1 1 65589BC9
P 7700 7650
AR Path="/65589BC9" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589BC9" Ref="D?"  Part="1" 
F 0 "D?" V 7654 7570 50  0000 R CNN
F 1 "D_Zener" V 7745 7570 50  0000 R CNN
F 2 "" H 7700 7650 50  0001 C CNN
F 3 "~" H 7700 7650 50  0001 C CNN
	1    7700 7650
	0    -1   1    0   
$EndComp
Wire Wire Line
	9600 7150 9600 6800
Wire Wire Line
	9600 6800 9500 6800
Wire Wire Line
	9500 7350 9550 7350
$Comp
L Isolator:TLP291 U?
U 1 1 65589BD2
P 9150 8600
AR Path="/65589BD2" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589BD2" Ref="U?"  Part="1" 
F 0 "U?" H 9150 8925 50  0000 C CNN
F 1 "TLP291" H 9150 8834 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 8950 8400 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 9150 8600 50  0001 L CNN
	1    9150 8600
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 8500 9450 8500
Text HLabel 9500 8700 2    118  Output ~ 0
S-6
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589BDB
P 8050 8500
AR Path="/65589BDB" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589BDB" Ref="U?"  Part="1" 
F 0 "U?" H 8050 8742 50  0000 C CNN
F 1 "LM317_TO-220" H 8050 8651 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 8050 8750 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 8050 8500 50  0001 C CNN
	1    8050 8500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589BE1
P 8450 9000
AR Path="/65589BE1" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589BE1" Ref="R?"  Part="1" 
F 0 "R?" H 8520 9046 50  0000 L CNN
F 1 "R" H 8520 8955 50  0000 L CNN
F 2 "" V 8380 9000 50  0001 C CNN
F 3 "~" H 8450 9000 50  0001 C CNN
	1    8450 9000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589BE7
P 8050 9000
AR Path="/65589BE7" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589BE7" Ref="R?"  Part="1" 
F 0 "R?" H 8120 9046 50  0000 L CNN
F 1 "R" H 8120 8955 50  0000 L CNN
F 2 "" V 7980 9000 50  0001 C CNN
F 3 "~" H 8050 9000 50  0001 C CNN
	1    8050 9000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589BED
P 8050 9350
AR Path="/65589BED" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589BED" Ref="R?"  Part="1" 
F 0 "R?" H 8120 9396 50  0000 L CNN
F 1 "R" H 8120 9305 50  0000 L CNN
F 2 "" V 7980 9350 50  0001 C CNN
F 3 "~" H 8050 9350 50  0001 C CNN
	1    8050 9350
	1    0    0    -1  
$EndComp
Wire Wire Line
	8050 8800 8050 8850
Wire Wire Line
	8350 8500 8450 8500
Wire Wire Line
	8450 8500 8450 8850
Wire Wire Line
	8450 9150 8050 9150
Wire Wire Line
	8050 9150 8050 9200
Connection ~ 8050 9150
$Comp
L Device:R R?
U 1 1 65589BF9
P 8650 8500
AR Path="/65589BF9" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589BF9" Ref="R?"  Part="1" 
F 0 "R?" V 8443 8500 50  0000 C CNN
F 1 "R" V 8534 8500 50  0000 C CNN
F 2 "" V 8580 8500 50  0001 C CNN
F 3 "~" H 8650 8500 50  0001 C CNN
	1    8650 8500
	0    1    1    0   
$EndComp
Wire Wire Line
	8450 8500 8500 8500
Connection ~ 8450 8500
Wire Wire Line
	8800 8500 8850 8500
Wire Wire Line
	8850 8700 8850 9500
Wire Wire Line
	8850 9500 8050 9500
$Comp
L Device:R R?
U 1 1 65589C04
P 7400 8500
AR Path="/65589C04" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C04" Ref="R?"  Part="1" 
F 0 "R?" V 7193 8500 50  0000 C CNN
F 1 "R" V 7284 8500 50  0000 C CNN
F 2 "" V 7330 8500 50  0001 C CNN
F 3 "~" H 7400 8500 50  0001 C CNN
	1    7400 8500
	0    1    1    0   
$EndComp
Wire Wire Line
	7650 9150 7650 9500
Wire Wire Line
	7650 9500 8050 9500
Connection ~ 8050 9500
Wire Wire Line
	7650 8850 7650 8500
Wire Wire Line
	7650 8500 7750 8500
Wire Wire Line
	7650 8500 7550 8500
Connection ~ 7650 8500
Wire Wire Line
	7050 8500 7250 8500
Text HLabel 7050 8500 0    118  Input ~ 0
SENSE-6
Text HLabel 7000 9500 0    118  Input ~ 0
SENSE_GND-6
Wire Wire Line
	7000 9500 7650 9500
Connection ~ 7650 9500
$Comp
L Device:D_Zener D?
U 1 1 65589C16
P 7650 9000
AR Path="/65589C16" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589C16" Ref="D?"  Part="1" 
F 0 "D?" V 7604 8920 50  0000 R CNN
F 1 "D_Zener" V 7695 8920 50  0000 R CNN
F 2 "" H 7650 9000 50  0001 C CNN
F 3 "~" H 7650 9000 50  0001 C CNN
	1    7650 9000
	0    -1   1    0   
$EndComp
Wire Wire Line
	9550 8500 9550 8150
Wire Wire Line
	9550 8150 9450 8150
Wire Wire Line
	9450 8700 9500 8700
$Comp
L Isolator:TLP291 U?
U 1 1 65589C1F
P 9100 9950
AR Path="/65589C1F" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589C1F" Ref="U?"  Part="1" 
F 0 "U?" H 9100 10275 50  0000 C CNN
F 1 "TLP291" H 9100 10184 50  0000 C CNN
F 2 "Package_SO:SOIC-4_4.55x2.6mm_P1.27mm" H 8900 9750 50  0001 L CIN
F 3 "https://toshiba.semicon-storage.com/info/docget.jsp?did=12884&prodName=TLP291" H 9100 9950 50  0001 L CNN
	1    9100 9950
	1    0    0    -1  
$EndComp
Wire Wire Line
	9500 9850 9400 9850
Text HLabel 9450 10050 2    118  Output ~ 0
S-7
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589C28
P 8000 9850
AR Path="/65589C28" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589C28" Ref="U?"  Part="1" 
F 0 "U?" H 8000 10092 50  0000 C CNN
F 1 "LM317_TO-220" H 8000 10001 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 8000 10100 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 8000 9850 50  0001 C CNN
	1    8000 9850
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589C2E
P 8400 10350
AR Path="/65589C2E" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C2E" Ref="R?"  Part="1" 
F 0 "R?" H 8470 10396 50  0000 L CNN
F 1 "R" H 8470 10305 50  0000 L CNN
F 2 "" V 8330 10350 50  0001 C CNN
F 3 "~" H 8400 10350 50  0001 C CNN
	1    8400 10350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589C34
P 8000 10350
AR Path="/65589C34" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C34" Ref="R?"  Part="1" 
F 0 "R?" H 8070 10396 50  0000 L CNN
F 1 "R" H 8070 10305 50  0000 L CNN
F 2 "" V 7930 10350 50  0001 C CNN
F 3 "~" H 8000 10350 50  0001 C CNN
	1    8000 10350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589C3A
P 8000 10700
AR Path="/65589C3A" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C3A" Ref="R?"  Part="1" 
F 0 "R?" H 8070 10746 50  0000 L CNN
F 1 "R" H 8070 10655 50  0000 L CNN
F 2 "" V 7930 10700 50  0001 C CNN
F 3 "~" H 8000 10700 50  0001 C CNN
	1    8000 10700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 10150 8000 10200
Wire Wire Line
	8300 9850 8400 9850
Wire Wire Line
	8400 9850 8400 10200
Wire Wire Line
	8400 10500 8000 10500
Wire Wire Line
	8000 10500 8000 10550
Connection ~ 8000 10500
$Comp
L Device:R R?
U 1 1 65589C46
P 8600 9850
AR Path="/65589C46" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C46" Ref="R?"  Part="1" 
F 0 "R?" V 8393 9850 50  0000 C CNN
F 1 "R" V 8484 9850 50  0000 C CNN
F 2 "" V 8530 9850 50  0001 C CNN
F 3 "~" H 8600 9850 50  0001 C CNN
	1    8600 9850
	0    1    1    0   
$EndComp
Wire Wire Line
	8400 9850 8450 9850
Connection ~ 8400 9850
Wire Wire Line
	8750 9850 8800 9850
Wire Wire Line
	8800 10050 8800 10850
Wire Wire Line
	8800 10850 8000 10850
$Comp
L Device:R R?
U 1 1 65589C51
P 7350 9850
AR Path="/65589C51" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C51" Ref="R?"  Part="1" 
F 0 "R?" V 7143 9850 50  0000 C CNN
F 1 "R" V 7234 9850 50  0000 C CNN
F 2 "" V 7280 9850 50  0001 C CNN
F 3 "~" H 7350 9850 50  0001 C CNN
	1    7350 9850
	0    1    1    0   
$EndComp
Wire Wire Line
	7600 10500 7600 10850
Wire Wire Line
	7600 10850 8000 10850
Connection ~ 8000 10850
Wire Wire Line
	7600 10200 7600 9850
Wire Wire Line
	7600 9850 7700 9850
Wire Wire Line
	7600 9850 7500 9850
Connection ~ 7600 9850
Wire Wire Line
	7000 9850 7200 9850
Text HLabel 7000 9850 0    118  Input ~ 0
SENSE-7
Text HLabel 6950 10850 0    118  Input ~ 0
SENSE_GND-7
Wire Wire Line
	6950 10850 7600 10850
Connection ~ 7600 10850
$Comp
L Device:D_Zener D?
U 1 1 65589C63
P 7600 10350
AR Path="/65589C63" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589C63" Ref="D?"  Part="1" 
F 0 "D?" V 7554 10270 50  0000 R CNN
F 1 "D_Zener" V 7645 10270 50  0000 R CNN
F 2 "" H 7600 10350 50  0001 C CNN
F 3 "~" H 7600 10350 50  0001 C CNN
	1    7600 10350
	0    -1   1    0   
$EndComp
Wire Wire Line
	9500 9850 9500 9500
Wire Wire Line
	9500 9500 9400 9500
Wire Wire Line
	9400 10050 9450 10050
Wire Wire Line
	2350 1700 2450 1700
Wire Wire Line
	2850 1700 3100 1700
Wire Wire Line
	3100 1700 3100 1650
Wire Wire Line
	3100 1300 3100 1350
Wire Wire Line
	1700 850  1450 850 
Wire Wire Line
	1450 650  3100 650 
Wire Wire Line
	3100 1000 3100 650 
$Comp
L pspice:OPAMP U?
U 1 1 65589C73
P 2400 2250
AR Path="/65589C73" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589C73" Ref="U?"  Part="1" 
F 0 "U?" H 2744 2296 50  0000 L CNN
F 1 "OPAMP" H 2744 2205 50  0000 L CNN
F 2 "" H 2400 2250 50  0001 C CNN
F 3 "~" H 2400 2250 50  0001 C CNN
	1    2400 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589C79
P 1900 2050
AR Path="/65589C79" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C79" Ref="R?"  Part="1" 
F 0 "R?" H 1970 2096 50  0000 L CNN
F 1 "R" H 1970 2005 50  0000 L CNN
F 2 "" V 1830 2050 50  0001 C CNN
F 3 "~" H 1900 2050 50  0001 C CNN
	1    1900 2050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589C7F
P 2450 2650
AR Path="/65589C7F" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589C7F" Ref="R?"  Part="1" 
F 0 "R?" V 2657 2650 50  0000 C CNN
F 1 "R" V 2566 2650 50  0000 C CNN
F 2 "" V 2380 2650 50  0001 C CNN
F 3 "~" H 2450 2650 50  0001 C CNN
	1    2450 2650
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1700 1700 1900 1700
Wire Wire Line
	2100 1850 2450 1850
Wire Wire Line
	2450 1850 2450 1700
Connection ~ 2450 1700
Wire Wire Line
	2450 1700 2550 1700
Wire Wire Line
	2700 2650 2600 2650
Wire Wire Line
	2300 2650 1900 2650
Wire Wire Line
	1900 2650 1900 2350
Wire Wire Line
	1900 1900 1900 1700
Connection ~ 1900 1700
Wire Wire Line
	1900 1700 2050 1700
Wire Wire Line
	2100 2150 2100 1850
Wire Wire Line
	2100 2350 1900 2350
Connection ~ 1900 2350
Wire Wire Line
	1900 2350 1900 2200
Wire Wire Line
	2700 2250 2700 2650
Wire Wire Line
	2700 2650 2700 2750
Connection ~ 2700 2650
Wire Wire Line
	2300 1950 3100 1950
Wire Wire Line
	3100 1950 3100 1700
Connection ~ 3100 1700
Wire Wire Line
	2300 2550 1700 2550
Connection ~ 1700 2550
Wire Wire Line
	1700 2550 1700 3050
Wire Wire Line
	1700 1700 1700 2550
Connection ~ 1700 1700
Wire Wire Line
	3100 1950 3100 3050
Connection ~ 3100 1950
$Comp
L Device:Q_NJFET_DGS Q?
U 1 1 65589CA1
P 2450 2950
AR Path="/65589CA1" Ref="Q?"  Part="1" 
AR Path="/653FA36F/65589CA1" Ref="Q?"  Part="1" 
F 0 "Q?" V 2685 2950 50  0000 C CNN
F 1 "Q_NJFET_DGS" V 2776 2950 50  0000 C CNN
F 2 "" H 2650 3050 50  0001 C CNN
F 3 "~" H 2450 2950 50  0001 C CNN
	1    2450 2950
	0    1    1    0   
$EndComp
$Comp
L Regulator_Linear:LM317_TO-220 U?
U 1 1 65589CA7
P 2450 3700
AR Path="/65589CA7" Ref="U?"  Part="1" 
AR Path="/653FA36F/65589CA7" Ref="U?"  Part="1" 
F 0 "U?" H 2450 3942 50  0000 C CNN
F 1 "LM317_TO-220" H 2450 3851 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 2450 3950 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/lm317.pdf" H 2450 3700 50  0001 C CNN
	1    2450 3700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 65589CAD
P 2450 4200
AR Path="/65589CAD" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589CAD" Ref="R?"  Part="1" 
F 0 "R?" H 2380 4154 50  0000 R CNN
F 1 "R" H 2380 4245 50  0000 R CNN
F 2 "" V 2380 4200 50  0001 C CNN
F 3 "~" H 2450 4200 50  0001 C CNN
	1    2450 4200
	-1   0    0    1   
$EndComp
Wire Wire Line
	3100 3050 3100 3400
Wire Wire Line
	3100 3400 2050 3400
Wire Wire Line
	2050 3400 2050 3700
Wire Wire Line
	2050 3700 2150 3700
Connection ~ 3100 3050
$Comp
L Device:R R?
U 1 1 65589CB8
P 2450 4550
AR Path="/65589CB8" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589CB8" Ref="R?"  Part="1" 
F 0 "R?" H 2380 4504 50  0000 R CNN
F 1 "R" H 2380 4595 50  0000 R CNN
F 2 "" V 2380 4550 50  0001 C CNN
F 3 "~" H 2450 4550 50  0001 C CNN
	1    2450 4550
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 65589CBE
P 2900 4200
AR Path="/65589CBE" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589CBE" Ref="R?"  Part="1" 
F 0 "R?" H 2830 4154 50  0000 R CNN
F 1 "R" H 2830 4245 50  0000 R CNN
F 2 "" V 2830 4200 50  0001 C CNN
F 3 "~" H 2900 4200 50  0001 C CNN
	1    2900 4200
	-1   0    0    1   
$EndComp
Wire Wire Line
	2750 3700 2900 3700
Wire Wire Line
	2900 3700 2900 4050
Wire Wire Line
	2450 4000 2450 4050
Wire Wire Line
	2900 4350 2450 4350
Wire Wire Line
	2450 4350 2450 4400
Connection ~ 2450 4350
Connection ~ 2900 3700
Wire Wire Line
	1700 3050 1700 4700
Wire Wire Line
	1700 4700 2450 4700
Connection ~ 1700 3050
Connection ~ 2450 4700
Wire Wire Line
	2700 2750 2450 2750
Wire Wire Line
	3100 1950 3700 1950
Wire Wire Line
	2900 3700 3250 3700
Wire Wire Line
	2450 4700 3250 4700
Wire Notes Line
	10150 5100 10150 11050
Text Notes 8000 5300 0    118  ~ 24
Sensor Input: 3.3-40V
Wire Notes Line
	4550 950  4550 5000
Wire Notes Line
	10400 800  10400 9800
Wire Notes Line
	10400 9800 15650 9800
Wire Notes Line
	15650 9800 15650 750 
Wire Notes Line
	15650 750  10400 750 
Text HLabel 3700 4700 2    118  Output ~ 0
GND
Text HLabel 5650 2650 0    118  Input ~ 0
3V3_INT
Wire Wire Line
	5950 1950 6350 1950
Connection ~ 5950 1950
Wire Wire Line
	5950 1750 5950 1950
Wire Wire Line
	6350 1950 6750 1950
Connection ~ 6350 1950
Wire Wire Line
	6350 1750 6350 1950
Wire Wire Line
	6750 1950 7150 1950
Connection ~ 6750 1950
Wire Wire Line
	6750 1750 6750 1950
Wire Wire Line
	7150 1950 7550 1950
Connection ~ 7150 1950
Wire Wire Line
	7150 1750 7150 1950
Wire Wire Line
	7550 1950 7550 1750
Wire Wire Line
	5650 1950 5950 1950
Wire Wire Line
	5950 1250 6350 1250
Connection ~ 5950 1250
Wire Wire Line
	5950 1450 5950 1250
Wire Wire Line
	6350 1250 6750 1250
Connection ~ 6350 1250
Wire Wire Line
	6350 1450 6350 1250
Wire Wire Line
	6750 1250 7150 1250
Connection ~ 6750 1250
Wire Wire Line
	6750 1450 6750 1250
Wire Wire Line
	7150 1250 7550 1250
Connection ~ 7150 1250
Wire Wire Line
	7150 1450 7150 1250
Wire Wire Line
	7550 1250 7550 1450
Wire Wire Line
	5650 1250 5950 1250
Text HLabel 5650 1950 0    118  Input ~ 0
GND
$Comp
L Device:CP C?
U 1 1 65589CFA
P 7550 1600
AR Path="/65589CFA" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589CFA" Ref="C?"  Part="1" 
F 0 "C?" H 7668 1646 50  0000 L CNN
F 1 "CP" H 7668 1555 50  0000 L CNN
F 2 "" H 7588 1450 50  0001 C CNN
F 3 "~" H 7550 1600 50  0001 C CNN
	1    7550 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C?
U 1 1 65589D00
P 7150 1600
AR Path="/65589D00" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D00" Ref="C?"  Part="1" 
F 0 "C?" H 7268 1646 50  0000 L CNN
F 1 "CP" H 7268 1555 50  0000 L CNN
F 2 "" H 7188 1450 50  0001 C CNN
F 3 "~" H 7150 1600 50  0001 C CNN
	1    7150 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C?
U 1 1 65589D06
P 6750 1600
AR Path="/65589D06" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D06" Ref="C?"  Part="1" 
F 0 "C?" H 6868 1646 50  0000 L CNN
F 1 "CP" H 6868 1555 50  0000 L CNN
F 2 "" H 6788 1450 50  0001 C CNN
F 3 "~" H 6750 1600 50  0001 C CNN
	1    6750 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C?
U 1 1 65589D0C
P 6350 1600
AR Path="/65589D0C" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D0C" Ref="C?"  Part="1" 
F 0 "C?" H 6468 1646 50  0000 L CNN
F 1 "CP" H 6468 1555 50  0000 L CNN
F 2 "" H 6388 1450 50  0001 C CNN
F 3 "~" H 6350 1600 50  0001 C CNN
	1    6350 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C?
U 1 1 65589D12
P 5950 1600
AR Path="/65589D12" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D12" Ref="C?"  Part="1" 
F 0 "C?" H 6068 1646 50  0000 L CNN
F 1 "CP" H 6068 1555 50  0000 L CNN
F 2 "" H 5988 1450 50  0001 C CNN
F 3 "~" H 5950 1600 50  0001 C CNN
	1    5950 1600
	1    0    0    -1  
$EndComp
Text HLabel 5650 1250 0    118  Input ~ 0
6V_INT
Wire Wire Line
	5950 1950 5950 2150
$Comp
L Device:C_Small C?
U 1 1 65589D1A
P 5950 3000
AR Path="/65589D1A" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D1A" Ref="C?"  Part="1" 
F 0 "C?" H 6042 3046 50  0000 L CNN
F 1 "C_Small" H 6042 2955 50  0000 L CNN
F 2 "" H 5950 3000 50  0001 C CNN
F 3 "~" H 5950 3000 50  0001 C CNN
	1    5950 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D20
P 6350 3000
AR Path="/65589D20" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D20" Ref="C?"  Part="1" 
F 0 "C?" H 6442 3046 50  0000 L CNN
F 1 "C_Small" H 6442 2955 50  0000 L CNN
F 2 "" H 6350 3000 50  0001 C CNN
F 3 "~" H 6350 3000 50  0001 C CNN
	1    6350 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D26
P 6750 3000
AR Path="/65589D26" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D26" Ref="C?"  Part="1" 
F 0 "C?" H 6842 3046 50  0000 L CNN
F 1 "C_Small" H 6842 2955 50  0000 L CNN
F 2 "" H 6750 3000 50  0001 C CNN
F 3 "~" H 6750 3000 50  0001 C CNN
	1    6750 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D2C
P 7200 3000
AR Path="/65589D2C" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D2C" Ref="C?"  Part="1" 
F 0 "C?" H 7292 3046 50  0000 L CNN
F 1 "C_Small" H 7292 2955 50  0000 L CNN
F 2 "" H 7200 3000 50  0001 C CNN
F 3 "~" H 7200 3000 50  0001 C CNN
	1    7200 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D32
P 7600 3000
AR Path="/65589D32" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D32" Ref="C?"  Part="1" 
F 0 "C?" H 7692 3046 50  0000 L CNN
F 1 "C_Small" H 7692 2955 50  0000 L CNN
F 2 "" H 7600 3000 50  0001 C CNN
F 3 "~" H 7600 3000 50  0001 C CNN
	1    7600 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D38
P 8000 3000
AR Path="/65589D38" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D38" Ref="C?"  Part="1" 
F 0 "C?" H 8092 3046 50  0000 L CNN
F 1 "C_Small" H 8092 2955 50  0000 L CNN
F 2 "" H 8000 3000 50  0001 C CNN
F 3 "~" H 8000 3000 50  0001 C CNN
	1    8000 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D3E
P 8400 3000
AR Path="/65589D3E" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D3E" Ref="C?"  Part="1" 
F 0 "C?" H 8492 3046 50  0000 L CNN
F 1 "C_Small" H 8492 2955 50  0000 L CNN
F 2 "" H 8400 3000 50  0001 C CNN
F 3 "~" H 8400 3000 50  0001 C CNN
	1    8400 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D44
P 8800 3000
AR Path="/65589D44" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D44" Ref="C?"  Part="1" 
F 0 "C?" H 8892 3046 50  0000 L CNN
F 1 "C_Small" H 8892 2955 50  0000 L CNN
F 2 "" H 8800 3000 50  0001 C CNN
F 3 "~" H 8800 3000 50  0001 C CNN
	1    8800 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C?
U 1 1 65589D4A
P 5950 2300
AR Path="/65589D4A" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D4A" Ref="C?"  Part="1" 
F 0 "C?" H 6068 2346 50  0000 L CNN
F 1 "CP" H 6068 2255 50  0000 L CNN
F 2 "" H 5988 2150 50  0001 C CNN
F 3 "~" H 5950 2300 50  0001 C CNN
	1    5950 2300
	-1   0    0    1   
$EndComp
Wire Wire Line
	5950 2650 5950 2450
$Comp
L Device:CP C?
U 1 1 65589D51
P 6350 2300
AR Path="/65589D51" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D51" Ref="C?"  Part="1" 
F 0 "C?" H 6468 2346 50  0000 L CNN
F 1 "CP" H 6468 2255 50  0000 L CNN
F 2 "" H 6388 2150 50  0001 C CNN
F 3 "~" H 6350 2300 50  0001 C CNN
	1    6350 2300
	-1   0    0    1   
$EndComp
$Comp
L Device:CP C?
U 1 1 65589D57
P 6750 2300
AR Path="/65589D57" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D57" Ref="C?"  Part="1" 
F 0 "C?" H 6868 2346 50  0000 L CNN
F 1 "CP" H 6868 2255 50  0000 L CNN
F 2 "" H 6788 2150 50  0001 C CNN
F 3 "~" H 6750 2300 50  0001 C CNN
	1    6750 2300
	-1   0    0    1   
$EndComp
Wire Wire Line
	5650 2650 5950 2650
Wire Wire Line
	6750 2650 6750 2450
Connection ~ 5950 2650
Wire Wire Line
	5950 2650 6350 2650
Wire Wire Line
	6350 2450 6350 2650
Connection ~ 6350 2650
Wire Wire Line
	6350 2650 6750 2650
Wire Wire Line
	6750 2150 6750 1950
Wire Wire Line
	6350 2150 6350 1950
$Comp
L Device:C_Small C?
U 1 1 65589D66
P 9250 3000
AR Path="/65589D66" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D66" Ref="C?"  Part="1" 
F 0 "C?" H 9342 3046 50  0000 L CNN
F 1 "C_Small" H 9342 2955 50  0000 L CNN
F 2 "" H 9250 3000 50  0001 C CNN
F 3 "~" H 9250 3000 50  0001 C CNN
	1    9250 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 65589D6C
P 9650 3000
AR Path="/65589D6C" Ref="C?"  Part="1" 
AR Path="/653FA36F/65589D6C" Ref="C?"  Part="1" 
F 0 "C?" H 9742 3046 50  0000 L CNN
F 1 "C_Small" H 9742 2955 50  0000 L CNN
F 2 "" H 9650 3000 50  0001 C CNN
F 3 "~" H 9650 3000 50  0001 C CNN
	1    9650 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6750 2650 7200 2650
Wire Wire Line
	9650 2650 9650 2900
Connection ~ 6750 2650
Wire Wire Line
	9250 2900 9250 2650
Connection ~ 9250 2650
Wire Wire Line
	9250 2650 9650 2650
Wire Wire Line
	8800 2900 8800 2650
Connection ~ 8800 2650
Wire Wire Line
	8800 2650 9250 2650
Wire Wire Line
	8400 2900 8400 2650
Connection ~ 8400 2650
Wire Wire Line
	8400 2650 8800 2650
Wire Wire Line
	8000 2900 8000 2650
Connection ~ 8000 2650
Wire Wire Line
	8000 2650 8400 2650
Wire Wire Line
	7600 2900 7600 2650
Connection ~ 7600 2650
Wire Wire Line
	7600 2650 8000 2650
Wire Wire Line
	7200 2900 7200 2650
Connection ~ 7200 2650
Wire Wire Line
	7200 2650 7600 2650
Wire Wire Line
	6750 2900 6750 2650
Wire Wire Line
	6350 2900 6350 2650
Wire Wire Line
	5950 2900 5950 2650
Text HLabel 5600 3400 0    118  Input ~ 0
GND
Wire Wire Line
	5600 3400 5950 3400
Wire Wire Line
	5950 3400 5950 3100
Wire Wire Line
	5950 3400 6350 3400
Wire Wire Line
	6350 3400 6350 3100
Connection ~ 5950 3400
Wire Wire Line
	6350 3400 6750 3400
Wire Wire Line
	6750 3400 6750 3100
Connection ~ 6350 3400
Wire Wire Line
	6750 3400 7200 3400
Wire Wire Line
	7200 3400 7200 3100
Connection ~ 6750 3400
Wire Wire Line
	7200 3400 7600 3400
Wire Wire Line
	7600 3400 7600 3100
Connection ~ 7200 3400
Wire Wire Line
	7600 3400 8000 3400
Wire Wire Line
	8000 3400 8000 3100
Connection ~ 7600 3400
Wire Wire Line
	8000 3400 8400 3400
Wire Wire Line
	8400 3400 8400 3100
Connection ~ 8000 3400
Wire Wire Line
	8400 3400 8800 3400
Wire Wire Line
	8800 3400 8800 3100
Connection ~ 8400 3400
Wire Wire Line
	8800 3400 9250 3400
Wire Wire Line
	9250 3400 9250 3100
Connection ~ 8800 3400
Wire Wire Line
	9250 3400 9650 3400
Wire Wire Line
	9650 3400 9650 3100
Connection ~ 9250 3400
Wire Notes Line
	10150 3900 10150 950 
Wire Notes Line
	4800 950  4800 3900
Wire Notes Line
	4800 3900 10150 3900
Wire Notes Line
	4800 950  10150 950 
Text Notes 4850 3850 0    118  ~ 24
Power distribution\n
Text Notes 12850 9800 0    118  ~ 24
Actuator output: 3.3V-40V, 2A
Text HLabel 5950 4300 0    118  Input ~ 0
Serial_in+
Wire Wire Line
	6100 4300 6100 4350
Text HLabel 6250 4300 2    118  Output ~ 0
S_in+
Wire Wire Line
	6250 4300 6100 4300
Wire Wire Line
	6100 4300 5950 4300
Connection ~ 6100 4300
Connection ~ 6100 4700
Wire Wire Line
	6100 4700 5950 4700
Wire Wire Line
	6100 4700 6250 4700
Text HLabel 6250 4700 2    118  Output ~ 0
S_in-
Wire Wire Line
	6100 4700 6100 4650
$Comp
L Device:R R?
U 1 1 65589DB9
P 6100 4500
AR Path="/65589DB9" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589DB9" Ref="R?"  Part="1" 
F 0 "R?" H 6170 4546 50  0000 L CNN
F 1 "R100" H 6170 4455 50  0000 L CNN
F 2 "" V 6030 4500 50  0001 C CNN
F 3 "~" H 6100 4500 50  0001 C CNN
	1    6100 4500
	1    0    0    -1  
$EndComp
Text HLabel 5950 4700 0    118  Input ~ 0
Serial_in-
Text HLabel 8600 4300 2    118  Output ~ 0
Seria_out+
Text HLabel 8600 4700 2    118  Output ~ 0
Serial_out-
$Comp
L Device:R R?
U 1 1 65589DC2
P 8350 4500
AR Path="/65589DC2" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589DC2" Ref="R?"  Part="1" 
F 0 "R?" H 8420 4546 50  0000 L CNN
F 1 "R140" H 8420 4455 50  0000 L CNN
F 2 "" V 8280 4500 50  0001 C CNN
F 3 "~" H 8350 4500 50  0001 C CNN
	1    8350 4500
	1    0    0    -1  
$EndComp
Text HLabel 7900 4700 0    118  Input ~ 0
S_out-
Text HLabel 7900 4300 0    118  Input ~ 0
S_out+
$Comp
L Device:R R?
U 1 1 65589DCA
P 8100 4300
AR Path="/65589DCA" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589DCA" Ref="R?"  Part="1" 
F 0 "R?" V 7893 4300 50  0000 C CNN
F 1 "R158" V 7984 4300 50  0000 C CNN
F 2 "" V 8030 4300 50  0001 C CNN
F 3 "~" H 8100 4300 50  0001 C CNN
	1    8100 4300
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 65589DD0
P 8100 4700
AR Path="/65589DD0" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589DD0" Ref="R?"  Part="1" 
F 0 "R?" V 7893 4700 50  0000 C CNN
F 1 "R158" V 7984 4700 50  0000 C CNN
F 2 "" V 8030 4700 50  0001 C CNN
F 3 "~" H 8100 4700 50  0001 C CNN
	1    8100 4700
	0    1    1    0   
$EndComp
Wire Wire Line
	7900 4300 7950 4300
Wire Wire Line
	7900 4700 7950 4700
Wire Wire Line
	8250 4700 8350 4700
Wire Wire Line
	8350 4700 8350 4650
Wire Wire Line
	8350 4350 8350 4300
Wire Wire Line
	8350 4300 8250 4300
Wire Wire Line
	8600 4300 8350 4300
Connection ~ 8350 4300
Wire Wire Line
	8600 4700 8350 4700
Connection ~ 8350 4700
Wire Notes Line
	4800 4000 10150 4000
Wire Notes Line
	10150 4000 10150 5000
Wire Notes Line
	10150 5000 4800 5000
Wire Notes Line
	4800 5000 4800 4000
Text Notes 7550 5000 0    118  ~ 24
LVDS Serial communication\n
Wire Notes Line
	1100 5100 1100 11050
$Comp
L Device:LED D?
U 1 1 65589DE6
P 3250 3850
AR Path="/65589DE6" Ref="D?"  Part="1" 
AR Path="/653FA36F/65589DE6" Ref="D?"  Part="1" 
F 0 "D?" V 3289 3732 50  0000 R CNN
F 1 "LED" V 3198 3732 50  0000 R CNN
F 2 "" H 3250 3850 50  0001 C CNN
F 3 "~" H 3250 3850 50  0001 C CNN
	1    3250 3850
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 65589DEC
P 3250 4200
AR Path="/65589DEC" Ref="R?"  Part="1" 
AR Path="/653FA36F/65589DEC" Ref="R?"  Part="1" 
F 0 "R?" H 3180 4154 50  0000 R CNN
F 1 "R" H 3180 4245 50  0000 R CNN
F 2 "" V 3180 4200 50  0001 C CNN
F 3 "~" H 3250 4200 50  0001 C CNN
	1    3250 4200
	-1   0    0    1   
$EndComp
Connection ~ 3250 3700
Wire Wire Line
	3250 3700 3700 3700
Wire Wire Line
	3250 4000 3250 4050
Wire Wire Line
	3250 4350 3250 4700
Connection ~ 3250 4700
Wire Wire Line
	3250 4700 3700 4700
Wire Wire Line
	11600 2600 13750 2600
Wire Wire Line
	11600 4700 13750 4700
Wire Wire Line
	11600 6850 13750 6850
Wire Wire Line
	11600 8950 13750 8950
Wire Wire Line
	5100 9550 5200 9550
Wire Wire Line
	5100 8200 5200 8200
Wire Wire Line
	2700 9550 3300 9550
Connection ~ 3300 9550
Wire Wire Line
	2700 10900 3300 10900
Connection ~ 3300 10900
Wire Wire Line
	2700 8200 3300 8200
Connection ~ 3300 8200
Wire Wire Line
	5100 7200 5200 7200
Wire Wire Line
	5100 6850 5200 6850
Wire Wire Line
	5200 6850 5200 7200
Wire Wire Line
	2700 6850 3300 6850
Connection ~ 3300 6850
Wire Notes Line
	1100 5100 10150 5100
Wire Notes Line
	1100 11050 10150 11050
Wire Notes Line
	1100 5000 1100 950 
Wire Notes Line
	1100 950  4550 950 
Wire Notes Line
	1100 5000 4550 5000
Text GLabel 1450 650  0    118  Input ~ 0
POW6V+
Text GLabel 1450 850  0    118  Input ~ 0
POW6V-
Text GLabel 11250 1700 0    118  Input ~ 0
6V_INT
Text GLabel 11250 1500 0    118  Input ~ 0
GND
Text GLabel 11250 3600 0    118  Input ~ 0
GND
Text GLabel 11250 3800 0    118  Input ~ 0
6V_INT
Text GLabel 11250 5750 0    118  Input ~ 0
GND
Text GLabel 11250 5950 0    118  Input ~ 0
6V_INT
Text GLabel 11250 7850 0    118  Input ~ 0
GND
Text GLabel 11250 8050 0    118  Input ~ 0
6V_INT
Text GLabel 3700 1950 2    118  Output ~ 0
6V_INT
Text GLabel 3700 3700 2    118  Output ~ 0
3V3
Text GLabel 5100 5500 0    118  Input ~ 0
3V3
Text GLabel 5100 6850 0    118  Input ~ 0
3V3
Text GLabel 9550 5450 0    118  Input ~ 0
3V3
Wire Wire Line
	9650 5450 9550 5450
Text GLabel 9500 6800 0    118  Input ~ 0
3V3
Text GLabel 5100 8200 0    118  Input ~ 0
3V3
Text GLabel 9450 8150 0    118  Input ~ 0
3V3
Text GLabel 5100 9550 0    118  Input ~ 0
3V3
Text GLabel 9400 9500 0    118  Input ~ 0
3V3
$EndSCHEMATC
