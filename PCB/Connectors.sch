EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 3 4
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
L Connector:RJ45 J?
U 1 1 6407BE30
P 1500 1800
F 0 "J?" H 1557 2467 50  0000 C CNN
F 1 "RJ45" H 1557 2376 50  0000 C CNN
F 2 "" V 1500 1825 50  0001 C CNN
F 3 "~" V 1500 1825 50  0001 C CNN
	1    1500 1800
	1    0    0    -1  
$EndComp
Text HLabel 2200 1300 2    118  Output ~ 0
Serial_in+
Text HLabel 2200 1500 2    118  Output ~ 0
Serial-in-
Wire Wire Line
	1900 1400 2050 1400
Wire Wire Line
	2050 1400 2050 1300
Wire Wire Line
	2050 1300 2200 1300
Wire Wire Line
	1900 1500 2200 1500
Wire Wire Line
	1900 1600 2050 1600
Wire Wire Line
	2050 1600 2050 1800
Wire Wire Line
	2050 1800 1900 1800
Wire Wire Line
	2050 1800 2050 2000
Wire Wire Line
	2050 2000 1900 2000
Connection ~ 2050 1800
Wire Wire Line
	1900 1700 1950 1700
Wire Wire Line
	1950 1700 1950 1900
Wire Wire Line
	1950 1900 1900 1900
Wire Wire Line
	1950 1900 1950 2100
Wire Wire Line
	1950 2100 1900 2100
Connection ~ 1950 1900
Wire Wire Line
	2200 1800 2050 1800
Wire Wire Line
	2200 2100 1950 2100
Connection ~ 1950 2100
$Comp
L Connector:RJ45 J?
U 1 1 6408C45D
P 5500 1600
F 0 "J?" H 5557 2267 50  0000 C CNN
F 1 "RJ45" H 5557 2176 50  0000 C CNN
F 2 "" V 5500 1625 50  0001 C CNN
F 3 "~" V 5500 1625 50  0001 C CNN
	1    5500 1600
	-1   0    0    1   
$EndComp
Text HLabel 4800 2100 0    118  Input ~ 0
Serial_out+
Text HLabel 4800 1900 0    118  Input ~ 0
Serial-out-
Wire Wire Line
	5100 2000 4950 2000
Wire Wire Line
	4950 2000 4950 2100
Wire Wire Line
	4950 2100 4800 2100
Wire Wire Line
	5100 1900 4800 1900
Wire Wire Line
	5100 1800 4950 1800
Wire Wire Line
	4950 1800 4950 1600
Wire Wire Line
	4950 1600 5100 1600
Wire Wire Line
	4950 1600 4950 1400
Wire Wire Line
	4950 1400 5100 1400
Connection ~ 4950 1600
Wire Wire Line
	5100 1700 5050 1700
Wire Wire Line
	5050 1700 5050 1500
Wire Wire Line
	5050 1500 5100 1500
Wire Wire Line
	5050 1500 5050 1300
Wire Wire Line
	5050 1300 5100 1300
Connection ~ 5050 1500
Wire Wire Line
	4800 1600 4950 1600
Wire Wire Line
	4800 1300 5050 1300
Connection ~ 5050 1300
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 640B1C58
P 13750 3650
F 0 "J?" H 13722 3674 50  0000 R CNN
F 1 "Conn_01x03_Male" H 13722 3583 50  0000 R CNN
F 2 "" H 13750 3650 50  0001 C CNN
F 3 "~" H 13750 3650 50  0001 C CNN
	1    13750 3650
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J?
U 1 1 640B4527
P 14600 1450
F 0 "J?" H 14518 1125 50  0000 C CNN
F 1 "Screw_Terminal_01x02" H 14518 1216 50  0000 C CNN
F 2 "" H 14600 1450 50  0001 C CNN
F 3 "~" H 14600 1450 50  0001 C CNN
	1    14600 1450
	1    0    0    -1  
$EndComp
Wire Wire Line
	14400 1450 14300 1450
Text HLabel 12450 3650 0    118  Input ~ 0
ACTOUT-1
Text HLabel 12450 3450 0    118  Output ~ 0
ACT_IN-1
Text HLabel 12450 3850 0    118  Output ~ 0
ACT_GND-1
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 640D44C7
P 12700 3050
F 0 "J?" H 12672 2982 50  0000 R CNN
F 1 "Conn_01x03_Male" H 12672 3073 50  0000 R CNN
F 2 "" H 12700 3050 50  0001 C CNN
F 3 "~" H 12700 3050 50  0001 C CNN
	1    12700 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	12700 3450 12700 3250
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 640F92E8
P 13200 3050
F 0 "J?" H 13172 2982 50  0000 R CNN
F 1 "Conn_01x03_Male" H 13172 3073 50  0000 R CNN
F 2 "" H 13200 3050 50  0001 C CNN
F 3 "~" H 13200 3050 50  0001 C CNN
	1    13200 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	12700 3450 12450 3450
Wire Wire Line
	13200 3250 13200 3850
Wire Wire Line
	13200 3850 12450 3850
Wire Wire Line
	12800 3550 13550 3550
Wire Wire Line
	12800 3250 12800 3550
Wire Wire Line
	13550 3650 12450 3650
Wire Wire Line
	13300 3750 13300 3250
Wire Wire Line
	13300 3750 13550 3750
Wire Wire Line
	14300 1300 14300 1450
Wire Wire Line
	12600 3250 12500 3250
Wire Wire Line
	13100 3250 13000 3250
Wire Notes Line
	12300 2250 12850 2250
Wire Notes Line
	12300 3300 12850 3300
Wire Notes Line
	12300 2250 12300 3300
Wire Notes Line
	12850 2250 12850 3300
Wire Notes Line
	12950 3300 12950 2250
Wire Notes Line
	12950 2250 13500 2250
Wire Notes Line
	13500 2250 13500 3300
Wire Notes Line
	13500 3300 12950 3300
Text Notes 12400 3250 1    39   ~ 0
ACT-1 VCC-Source strap
Text Notes 13450 3250 1    39   ~ 0
ACT-1 GND-Source strap
Wire Notes Line
	13500 3850 13500 3450
Text Notes 14100 3550 0    39   ~ 0
Gen ACT-1 conn. 
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64149099
P 13750 4150
F 0 "J?" H 13722 4174 50  0000 R CNN
F 1 "Conn_01x03_Male" H 13722 4083 50  0000 R CNN
F 2 "" H 13750 4150 50  0001 C CNN
F 3 "~" H 13750 4150 50  0001 C CNN
	1    13750 4150
	-1   0    0    -1  
$EndComp
Wire Notes Line
	13500 4350 13500 3950
Text Notes 13900 4050 0    39   ~ 0
PWM/Servo ACT-1 conn. 
Wire Notes Line
	14650 4350 14650 3950
Wire Notes Line
	13500 3950 14650 3950
Wire Notes Line
	13500 4350 14650 4350
Wire Notes Line
	14650 3850 14650 3450
Wire Notes Line
	13500 3450 14650 3450
Wire Notes Line
	13500 3850 14650 3850
Text HLabel 12450 4050 0    118  Input ~ 0
SERVO-1
Wire Wire Line
	12450 4050 13550 4050
Wire Wire Line
	12450 4450 13100 4450
Wire Wire Line
	13100 4450 13100 4250
Wire Wire Line
	13100 4250 13550 4250
Wire Wire Line
	13550 4150 12850 4150
Wire Wire Line
	12850 4150 12850 4250
Wire Wire Line
	12850 4250 12450 4250
Wire Notes Line
	11200 4600 11200 2150
Wire Notes Line
	11200 2150 14750 2150
Wire Notes Line
	14750 2150 14750 4600
Wire Notes Line
	14750 4600 11200 4600
Text Notes 13700 2350 0    118  ~ 24
Actuator-1
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6418778A
P 13750 6550
F 0 "J?" H 13722 6574 50  0000 R CNN
F 1 "Conn_01x03_Male" H 13722 6483 50  0000 R CNN
F 2 "" H 13750 6550 50  0001 C CNN
F 3 "~" H 13750 6550 50  0001 C CNN
	1    13750 6550
	-1   0    0    -1  
$EndComp
Text HLabel 12450 6550 0    118  Input ~ 0
ACTOUT-3
Text HLabel 12450 6350 0    118  Output ~ 0
ACT_IN-3
Text HLabel 12450 6750 0    118  Output ~ 0
ACT_GND-3
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64187793
P 12700 5950
F 0 "J?" H 12672 5882 50  0000 R CNN
F 1 "Conn_01x03_Male" H 12672 5973 50  0000 R CNN
F 2 "" H 12700 5950 50  0001 C CNN
F 3 "~" H 12700 5950 50  0001 C CNN
	1    12700 5950
	0    1    1    0   
$EndComp
Wire Wire Line
	12700 6350 12700 6150
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6418779A
P 13200 5950
F 0 "J?" H 13172 5882 50  0000 R CNN
F 1 "Conn_01x03_Male" H 13172 5973 50  0000 R CNN
F 2 "" H 13200 5950 50  0001 C CNN
F 3 "~" H 13200 5950 50  0001 C CNN
	1    13200 5950
	0    1    1    0   
$EndComp
Wire Wire Line
	12700 6350 12450 6350
Wire Wire Line
	13200 6150 13200 6750
Wire Wire Line
	13200 6750 12450 6750
Wire Wire Line
	12800 6450 13550 6450
Wire Wire Line
	12800 6150 12800 6450
Wire Wire Line
	13550 6550 12450 6550
Wire Wire Line
	13300 6650 13300 6150
Wire Wire Line
	13300 6650 13550 6650
Wire Wire Line
	12600 6150 12500 6150
Wire Wire Line
	13100 6150 13000 6150
Wire Notes Line
	12300 5150 12850 5150
Wire Notes Line
	12300 6200 12850 6200
Wire Notes Line
	12300 5150 12300 6200
Wire Notes Line
	12850 5150 12850 6200
Wire Notes Line
	12950 6200 12950 5150
Wire Notes Line
	12950 5150 13500 5150
Wire Notes Line
	13500 5150 13500 6200
Wire Notes Line
	13500 6200 12950 6200
Text Notes 12400 6150 1    39   ~ 0
ACT-3 VCC-Source strap
Text Notes 13450 6150 1    39   ~ 0
ACT-3 GND-Source strap
Wire Notes Line
	13500 6750 13500 6350
Text Notes 14100 6450 0    39   ~ 0
Gen ACT-3 conn. 
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 641877B7
P 13750 7050
F 0 "J?" H 13722 7074 50  0000 R CNN
F 1 "Conn_01x03_Male" H 13722 6983 50  0000 R CNN
F 2 "" H 13750 7050 50  0001 C CNN
F 3 "~" H 13750 7050 50  0001 C CNN
	1    13750 7050
	-1   0    0    -1  
$EndComp
Wire Notes Line
	13500 7250 13500 6850
Text Notes 13900 6950 0    39   ~ 0
PWM/Servo ACT-3 conn. 
Wire Notes Line
	14650 7250 14650 6850
Wire Notes Line
	13500 6850 14650 6850
Wire Notes Line
	13500 7250 14650 7250
Wire Notes Line
	14650 6750 14650 6350
Wire Notes Line
	13500 6350 14650 6350
Wire Notes Line
	13500 6750 14650 6750
Text HLabel 12450 6950 0    118  Input ~ 0
SERVO-3
Wire Wire Line
	12450 6950 13550 6950
Wire Wire Line
	12450 7350 13100 7350
Wire Wire Line
	13100 7350 13100 7150
Wire Wire Line
	13100 7150 13550 7150
Wire Wire Line
	13550 7050 12850 7050
Wire Wire Line
	12850 7050 12850 7150
Wire Wire Line
	12850 7150 12450 7150
Wire Notes Line
	11200 7500 11200 5050
Wire Notes Line
	11200 5050 14750 5050
Wire Notes Line
	14750 5050 14750 7500
Wire Notes Line
	14750 7500 11200 7500
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6419454A
P 9600 3650
F 0 "J?" H 9572 3674 50  0000 R CNN
F 1 "Conn_01x03_Male" H 9572 3583 50  0000 R CNN
F 2 "" H 9600 3650 50  0001 C CNN
F 3 "~" H 9600 3650 50  0001 C CNN
	1    9600 3650
	-1   0    0    -1  
$EndComp
Text HLabel 8300 3650 0    118  Input ~ 0
ACTOUT-0
Text HLabel 8300 3450 0    118  Output ~ 0
ACT_IN-0
Text HLabel 8300 3850 0    118  Output ~ 0
ACT_GND-0
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64194553
P 8550 3050
F 0 "J?" H 8522 2982 50  0000 R CNN
F 1 "Conn_01x03_Male" H 8522 3073 50  0000 R CNN
F 2 "" H 8550 3050 50  0001 C CNN
F 3 "~" H 8550 3050 50  0001 C CNN
	1    8550 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	8550 3450 8550 3250
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6419455A
P 9050 3050
F 0 "J?" H 9022 2982 50  0000 R CNN
F 1 "Conn_01x03_Male" H 9022 3073 50  0000 R CNN
F 2 "" H 9050 3050 50  0001 C CNN
F 3 "~" H 9050 3050 50  0001 C CNN
	1    9050 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	8550 3450 8300 3450
Wire Wire Line
	9050 3250 9050 3850
Wire Wire Line
	9050 3850 8300 3850
Wire Wire Line
	8650 3550 9400 3550
Wire Wire Line
	8650 3250 8650 3550
Wire Wire Line
	9150 3750 9150 3250
Wire Wire Line
	9150 3750 9400 3750
Wire Wire Line
	8450 3250 8350 3250
Wire Wire Line
	8950 3250 8850 3250
Wire Notes Line
	8150 2250 8700 2250
Wire Notes Line
	8150 3300 8700 3300
Wire Notes Line
	8150 2250 8150 3300
Wire Notes Line
	8700 2250 8700 3300
Wire Notes Line
	8800 3300 8800 2250
Wire Notes Line
	8800 2250 9350 2250
Wire Notes Line
	9350 2250 9350 3300
Wire Notes Line
	9350 3300 8800 3300
Text Notes 8250 3250 1    39   ~ 0
ACT-0 VCC-Source strap
Text Notes 9300 3250 1    39   ~ 0
ACT-0 GND-Source strap
Wire Notes Line
	9350 3850 9350 3450
Text Notes 9950 3550 0    39   ~ 0
Gen ACT-0 conn. 
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64194577
P 9600 4150
F 0 "J?" H 9572 4174 50  0000 R CNN
F 1 "Conn_01x03_Male" H 9572 4083 50  0000 R CNN
F 2 "" H 9600 4150 50  0001 C CNN
F 3 "~" H 9600 4150 50  0001 C CNN
	1    9600 4150
	-1   0    0    -1  
$EndComp
Wire Notes Line
	9350 4350 9350 3950
Text Notes 9750 4050 0    39   ~ 0
PWM/Servo ACT-0 conn. 
Wire Notes Line
	10500 4350 10500 3950
Wire Notes Line
	9350 3950 10500 3950
Wire Notes Line
	9350 4350 10500 4350
Wire Notes Line
	10500 3850 10500 3450
Wire Notes Line
	9350 3450 10500 3450
Wire Notes Line
	9350 3850 10500 3850
Text HLabel 8300 4050 0    118  Input ~ 0
SERVO-0
Wire Wire Line
	8300 4050 9400 4050
Wire Wire Line
	8300 4450 8950 4450
Wire Wire Line
	8950 4450 8950 4250
Wire Wire Line
	8950 4250 9400 4250
Wire Wire Line
	9400 4150 8700 4150
Wire Wire Line
	8700 4150 8700 4250
Wire Wire Line
	8700 4250 8300 4250
Wire Wire Line
	8350 3250 8350 1850
Wire Notes Line
	7050 4600 7050 2150
Wire Notes Line
	7050 2150 10600 2150
Wire Notes Line
	10600 2150 10600 4600
Wire Notes Line
	10600 4600 7050 4600
Text Notes 9550 2350 0    118  ~ 24
Actuator-0
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64194595
P 9600 6550
F 0 "J?" H 9572 6574 50  0000 R CNN
F 1 "Conn_01x03_Male" H 9572 6483 50  0000 R CNN
F 2 "" H 9600 6550 50  0001 C CNN
F 3 "~" H 9600 6550 50  0001 C CNN
	1    9600 6550
	-1   0    0    -1  
$EndComp
Text HLabel 8300 6550 0    118  Input ~ 0
ACTOUT-2
Text HLabel 8300 6350 0    118  Output ~ 0
ACT_IN-2
Text HLabel 8300 6750 0    118  Output ~ 0
ACT_GND-2
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6419459E
P 8550 5950
F 0 "J?" H 8522 5882 50  0000 R CNN
F 1 "Conn_01x03_Male" H 8522 5973 50  0000 R CNN
F 2 "" H 8550 5950 50  0001 C CNN
F 3 "~" H 8550 5950 50  0001 C CNN
	1    8550 5950
	0    1    1    0   
$EndComp
Wire Wire Line
	8550 6350 8550 6150
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 641945A5
P 9050 5950
F 0 "J?" H 9022 5882 50  0000 R CNN
F 1 "Conn_01x03_Male" H 9022 5973 50  0000 R CNN
F 2 "" H 9050 5950 50  0001 C CNN
F 3 "~" H 9050 5950 50  0001 C CNN
	1    9050 5950
	0    1    1    0   
$EndComp
Wire Wire Line
	8550 6350 8300 6350
Wire Wire Line
	9050 6150 9050 6750
Wire Wire Line
	9050 6750 8300 6750
Wire Wire Line
	8650 6450 9400 6450
Wire Wire Line
	8650 6150 8650 6450
Wire Wire Line
	9400 6550 8300 6550
Wire Wire Line
	9150 6650 9150 6150
Wire Wire Line
	9150 6650 9400 6650
Wire Wire Line
	8450 6150 8350 6150
Wire Wire Line
	8950 6150 8850 6150
Wire Notes Line
	8150 5150 8700 5150
Wire Notes Line
	8150 6200 8700 6200
Wire Notes Line
	8150 5150 8150 6200
Wire Notes Line
	8700 5150 8700 6200
Wire Notes Line
	8800 6200 8800 5150
Wire Notes Line
	8800 5150 9350 5150
Wire Notes Line
	9350 5150 9350 6200
Wire Notes Line
	9350 6200 8800 6200
Text Notes 8250 6150 1    39   ~ 0
ACT-2 VCC-Source strap
Text Notes 9300 6150 1    39   ~ 0
ACT-2 GND-Source strap
Wire Notes Line
	9350 6750 9350 6350
Text Notes 9950 6450 0    39   ~ 0
Gen ACT-2 conn. 
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 641945C2
P 9600 7050
F 0 "J?" H 9572 7074 50  0000 R CNN
F 1 "Conn_01x03_Male" H 9572 6983 50  0000 R CNN
F 2 "" H 9600 7050 50  0001 C CNN
F 3 "~" H 9600 7050 50  0001 C CNN
	1    9600 7050
	-1   0    0    -1  
$EndComp
Wire Notes Line
	9350 7250 9350 6850
Text Notes 9750 6950 0    39   ~ 0
PWM/Servo ACT-2 conn. 
Wire Notes Line
	10500 7250 10500 6850
Wire Notes Line
	9350 6850 10500 6850
Wire Notes Line
	9350 7250 10500 7250
Wire Notes Line
	10500 6750 10500 6350
Wire Notes Line
	9350 6350 10500 6350
Wire Notes Line
	9350 6750 10500 6750
Text HLabel 8300 6950 0    118  Input ~ 0
SERVO-2
Wire Wire Line
	8300 6950 9400 6950
Wire Wire Line
	8300 7350 8950 7350
Wire Wire Line
	8950 7350 8950 7150
Wire Wire Line
	8950 7150 9400 7150
Wire Wire Line
	9400 7050 8700 7050
Wire Wire Line
	8700 7050 8700 7150
Wire Wire Line
	8700 7150 8300 7150
Wire Notes Line
	7050 7500 7050 5050
Wire Notes Line
	7050 5050 10600 5050
Wire Notes Line
	10600 5050 10600 7500
Wire Notes Line
	10600 7500 7050 7500
Text Notes 9550 5250 0    118  ~ 24
Actuator-2
Wire Wire Line
	8850 3250 8850 2000
Wire Wire Line
	8850 2000 10750 2000
Wire Wire Line
	10750 2000 10750 4750
Connection ~ 10750 2000
Wire Wire Line
	11050 4900 11050 1850
Connection ~ 11050 1850
Wire Wire Line
	11050 1850 8350 1850
Wire Wire Line
	11050 4900 12500 4900
Connection ~ 11050 4900
Wire Wire Line
	12500 4900 12500 6150
Wire Wire Line
	8350 4900 8350 6150
Wire Wire Line
	8350 4900 11050 4900
Wire Wire Line
	10750 4750 8850 4750
Wire Wire Line
	8850 4750 8850 6150
Wire Wire Line
	10750 4750 13000 4750
Connection ~ 10750 4750
Wire Wire Line
	13000 4750 13000 6150
Text Notes 13700 5250 0    118  ~ 24
Actuator-3
Wire Wire Line
	11050 1850 11050 1550
Connection ~ 11050 1550
Wire Wire Line
	11050 1550 12500 1550
Wire Wire Line
	10750 2000 10750 1300
Connection ~ 10750 1300
Connection ~ 12500 1550
Wire Wire Line
	12500 1550 14400 1550
Wire Wire Line
	13000 2000 13000 3250
Wire Wire Line
	10750 2000 13000 2000
Wire Wire Line
	10750 1300 14300 1300
Wire Wire Line
	12500 1850 12500 1550
Wire Wire Line
	12500 1850 12500 3250
Connection ~ 12500 1850
Wire Wire Line
	12500 1850 11050 1850
Wire Notes Line
	15550 700  15550 7750
Text Notes 14550 950  0    118  ~ 24
Actuators
Wire Notes Line
	6200 700  6200 2450
Text Notes 4100 950  0    118  ~ 24
Serial communication
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6430799C
P 1050 5150
F 0 "J?" H 1158 5431 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 5340 50  0000 C CNN
F 2 "" H 1050 5150 50  0001 C CNN
F 3 "~" H 1050 5150 50  0001 C CNN
	1    1050 5150
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x05_Male J?
U 1 1 64312B1F
P 14000 8500
F 0 "J?" H 13972 8524 50  0000 R CNN
F 1 "Conn_01x05_Male" H 13972 8433 50  0000 R CNN
F 2 "" H 14000 8500 50  0001 C CNN
F 3 "~" H 14000 8500 50  0001 C CNN
	1    14000 8500
	-1   0    0    -1  
$EndComp
Text Notes 13450 8100 0    118  ~ 24
JTAG/PROGRM
Wire Wire Line
	9400 3650 8300 3650
Text HLabel 4200 5050 2    118  Output ~ 0
SENSE-0
$Comp
L Connector:Screw_Terminal_01x02 J?
U 1 1 64959CAE
P 1050 3050
F 0 "J?" H 968 3267 50  0000 C CNN
F 1 "Screw_Terminal_01x02" H 968 3176 50  0000 C CNN
F 2 "" H 1050 3050 50  0001 C CNN
F 3 "~" H 1050 3050 50  0001 C CNN
	1    1050 3050
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8400 1300 10750 1300
Wire Wire Line
	8400 1550 11050 1550
Wire Wire Line
	1250 3050 1650 3050
Wire Wire Line
	1650 3050 1650 2900
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 649FA5E5
P 2350 4150
F 0 "J?" H 2322 4082 50  0000 R CNN
F 1 "Conn_01x03_Male" H 2322 4173 50  0000 R CNN
F 2 "" H 2350 4150 50  0001 C CNN
F 3 "~" H 2350 4150 50  0001 C CNN
	1    2350 4150
	0    1    1    0   
$EndComp
Wire Notes Line
	1950 3350 2500 3350
Wire Notes Line
	1950 4400 2500 4400
Wire Notes Line
	1950 3350 1950 4400
Wire Notes Line
	2500 3350 2500 4400
Text Notes 2050 4350 1    39   ~ 0
SENSE VCC-Source strap
Wire Wire Line
	2250 4350 2250 4500
Wire Wire Line
	2250 4500 1850 4500
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64A9A46D
P 3400 4150
F 0 "J?" H 3372 4082 50  0000 R CNN
F 1 "Conn_01x03_Male" H 3372 4173 50  0000 R CNN
F 2 "" H 3400 4150 50  0001 C CNN
F 3 "~" H 3400 4150 50  0001 C CNN
	1    3400 4150
	0    1    1    0   
$EndComp
Wire Notes Line
	3000 3350 3550 3350
Wire Notes Line
	3000 4400 3550 4400
Wire Notes Line
	3000 3350 3000 4400
Wire Notes Line
	3550 3350 3550 4400
Text Notes 3100 4350 1    39   ~ 0
SENSE GND-Source strap
Wire Wire Line
	3300 4350 3300 4500
Wire Wire Line
	3300 4500 2900 4500
$Comp
L Device:R R?
U 1 1 64B2AC01
P 2150 4900
AR Path="/64B2AC01" Ref="R?"  Part="1" 
AR Path="/64044101/64B2AC01" Ref="R?"  Part="1" 
F 0 "R?" H 2081 4854 50  0000 R CNN
F 1 "R" H 2081 4945 50  0000 R CNN
F 2 "" V 2080 4900 50  0001 C CNN
F 3 "~" H 2150 4900 50  0001 C CNN
	1    2150 4900
	1    0    0    1   
$EndComp
Wire Wire Line
	1950 5150 1950 4750
Wire Wire Line
	1950 4750 2150 4750
Wire Wire Line
	2350 4350 2350 5150
Text HLabel 4200 5250 2    118  Output ~ 0
SENSE_GND-0
Wire Wire Line
	4200 5250 3400 5250
Wire Wire Line
	1950 5150 2350 5150
Wire Wire Line
	2150 5050 4200 5050
Wire Wire Line
	1250 5050 2150 5050
Connection ~ 2150 5050
Wire Wire Line
	1250 3150 1850 3150
Wire Wire Line
	2900 4500 2900 2900
Wire Wire Line
	1850 4500 1850 3150
Wire Wire Line
	3800 4500 3500 4500
Wire Wire Line
	3500 4500 3500 4350
Wire Wire Line
	3800 4250 3800 4500
Connection ~ 3400 5250
Wire Wire Line
	1250 5250 3400 5250
Wire Wire Line
	1650 2900 2900 2900
Wire Wire Line
	3400 4350 3400 5250
Wire Wire Line
	2700 4250 2700 4500
Wire Wire Line
	2700 4500 2450 4500
Wire Wire Line
	2450 4500 2450 4350
$Comp
L Device:Polyfuse F?
U 1 1 64D1C889
P 1600 5150
AR Path="/64D1C889" Ref="F?"  Part="1" 
AR Path="/64044101/64D1C889" Ref="F?"  Part="1" 
F 0 "F?" H 1688 5196 50  0000 L CNN
F 1 "Polyfuse" H 1688 5105 50  0000 L CNN
F 2 "" H 1650 4950 50  0001 L CNN
F 3 "~" H 1600 5150 50  0001 C CNN
	1    1600 5150
	0    1    1    0   
$EndComp
Wire Wire Line
	1250 5150 1450 5150
Wire Wire Line
	1750 5150 1950 5150
Connection ~ 1950 5150
Text Label 3800 2900 0    118  ~ 0
SENSE_COMMON_GND
Text Label 3800 3150 0    118  ~ 0
SENSE_COMMON_VCC
Text GLabel 3800 4250 1    118  Input ~ 0
GND
Text GLabel 2700 4250 1    118  Input ~ 0
6V_INT
Text GLabel 8300 4450 0    118  Input ~ 0
GND
Text GLabel 8300 4250 0    118  Input ~ 0
6V_INT
Text Label 8400 1300 2    118  ~ 0
ACT_COMMON_GND
Text Label 8400 1550 2    118  ~ 0
ACT_COMMON_VCC
Text GLabel 2200 1800 2    118  UnSpc ~ 0
POW6V+
Text GLabel 2200 2100 2    118  UnSpc ~ 0
POW6V-
Text GLabel 4800 1300 0    118  UnSpc ~ 0
POW6V-
Text GLabel 4800 1600 0    118  UnSpc ~ 0
POW6V+
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64EC67B1
P 1050 5950
F 0 "J?" H 1158 6231 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 6140 50  0000 C CNN
F 2 "" H 1050 5950 50  0001 C CNN
F 3 "~" H 1050 5950 50  0001 C CNN
	1    1050 5950
	1    0    0    -1  
$EndComp
Text HLabel 4200 5850 2    118  Output ~ 0
SENSE-1
$Comp
L Device:R R?
U 1 1 64EC67B8
P 2150 5700
AR Path="/64EC67B8" Ref="R?"  Part="1" 
AR Path="/64044101/64EC67B8" Ref="R?"  Part="1" 
F 0 "R?" H 2081 5654 50  0000 R CNN
F 1 "R" H 2081 5745 50  0000 R CNN
F 2 "" V 2080 5700 50  0001 C CNN
F 3 "~" H 2150 5700 50  0001 C CNN
	1    2150 5700
	1    0    0    1   
$EndComp
Wire Wire Line
	1950 5950 1950 5550
Wire Wire Line
	1950 5550 2150 5550
Text HLabel 4200 6050 2    118  Output ~ 0
SENSE_GND-1
Wire Wire Line
	1950 5950 2350 5950
Wire Wire Line
	2150 5850 4200 5850
Wire Wire Line
	1250 5850 2150 5850
Connection ~ 2150 5850
$Comp
L Device:Polyfuse F?
U 1 1 64EC67CA
P 1600 5950
AR Path="/64EC67CA" Ref="F?"  Part="1" 
AR Path="/64044101/64EC67CA" Ref="F?"  Part="1" 
F 0 "F?" H 1688 5996 50  0000 L CNN
F 1 "Polyfuse" H 1688 5905 50  0000 L CNN
F 2 "" H 1650 5750 50  0001 L CNN
F 3 "~" H 1600 5950 50  0001 C CNN
	1    1600 5950
	0    1    1    0   
$EndComp
Wire Wire Line
	1250 5950 1450 5950
Wire Wire Line
	1750 5950 1950 5950
Connection ~ 1950 5950
Wire Wire Line
	1250 6050 3400 6050
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64F14C7B
P 1050 6750
F 0 "J?" H 1158 7031 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 6940 50  0000 C CNN
F 2 "" H 1050 6750 50  0001 C CNN
F 3 "~" H 1050 6750 50  0001 C CNN
	1    1050 6750
	1    0    0    -1  
$EndComp
Text HLabel 4200 6650 2    118  Output ~ 0
SENSE-2
$Comp
L Device:R R?
U 1 1 64F14C82
P 2150 6500
AR Path="/64F14C82" Ref="R?"  Part="1" 
AR Path="/64044101/64F14C82" Ref="R?"  Part="1" 
F 0 "R?" H 2081 6454 50  0000 R CNN
F 1 "R" H 2081 6545 50  0000 R CNN
F 2 "" V 2080 6500 50  0001 C CNN
F 3 "~" H 2150 6500 50  0001 C CNN
	1    2150 6500
	1    0    0    1   
$EndComp
Wire Wire Line
	1950 6750 1950 6350
Wire Wire Line
	1950 6350 2150 6350
Text HLabel 4200 6850 2    118  Output ~ 0
SENSE_GND-2
Wire Wire Line
	1950 6750 2350 6750
Wire Wire Line
	2150 6650 4200 6650
Wire Wire Line
	1250 6650 2150 6650
Connection ~ 2150 6650
$Comp
L Device:Polyfuse F?
U 1 1 64F14C94
P 1600 6750
AR Path="/64F14C94" Ref="F?"  Part="1" 
AR Path="/64044101/64F14C94" Ref="F?"  Part="1" 
F 0 "F?" H 1688 6796 50  0000 L CNN
F 1 "Polyfuse" H 1688 6705 50  0000 L CNN
F 2 "" H 1650 6550 50  0001 L CNN
F 3 "~" H 1600 6750 50  0001 C CNN
	1    1600 6750
	0    1    1    0   
$EndComp
Wire Wire Line
	1250 6750 1450 6750
Wire Wire Line
	1750 6750 1950 6750
Connection ~ 1950 6750
Wire Wire Line
	1250 6850 3400 6850
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64F5B886
P 1050 7550
F 0 "J?" H 1158 7831 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 7740 50  0000 C CNN
F 2 "" H 1050 7550 50  0001 C CNN
F 3 "~" H 1050 7550 50  0001 C CNN
	1    1050 7550
	1    0    0    -1  
$EndComp
Text HLabel 4200 7450 2    118  Output ~ 0
SENSE-3
$Comp
L Device:R R?
U 1 1 64F5B88D
P 2150 7300
AR Path="/64F5B88D" Ref="R?"  Part="1" 
AR Path="/64044101/64F5B88D" Ref="R?"  Part="1" 
F 0 "R?" H 2081 7254 50  0000 R CNN
F 1 "R" H 2081 7345 50  0000 R CNN
F 2 "" V 2080 7300 50  0001 C CNN
F 3 "~" H 2150 7300 50  0001 C CNN
	1    2150 7300
	1    0    0    1   
$EndComp
Wire Wire Line
	1950 7550 1950 7150
Wire Wire Line
	1950 7150 2150 7150
Text HLabel 4200 7650 2    118  Output ~ 0
SENSE_GND-3
Wire Wire Line
	1950 7550 2350 7550
Wire Wire Line
	2150 7450 4200 7450
Wire Wire Line
	1250 7450 2150 7450
Connection ~ 2150 7450
$Comp
L Device:Polyfuse F?
U 1 1 64F5B89F
P 1600 7550
AR Path="/64F5B89F" Ref="F?"  Part="1" 
AR Path="/64044101/64F5B89F" Ref="F?"  Part="1" 
F 0 "F?" H 1688 7596 50  0000 L CNN
F 1 "Polyfuse" H 1688 7505 50  0000 L CNN
F 2 "" H 1650 7350 50  0001 L CNN
F 3 "~" H 1600 7550 50  0001 C CNN
	1    1600 7550
	0    1    1    0   
$EndComp
Wire Wire Line
	1250 7550 1450 7550
Wire Wire Line
	1750 7550 1950 7550
Connection ~ 1950 7550
Wire Wire Line
	1250 7650 3400 7650
Wire Wire Line
	1250 8450 3400 8450
Connection ~ 1950 8350
Wire Wire Line
	1750 8350 1950 8350
Wire Wire Line
	1250 8350 1450 8350
$Comp
L Device:Polyfuse F?
U 1 1 64FB71DF
P 1600 8350
AR Path="/64FB71DF" Ref="F?"  Part="1" 
AR Path="/64044101/64FB71DF" Ref="F?"  Part="1" 
F 0 "F?" H 1688 8396 50  0000 L CNN
F 1 "Polyfuse" H 1688 8305 50  0000 L CNN
F 2 "" H 1650 8150 50  0001 L CNN
F 3 "~" H 1600 8350 50  0001 C CNN
	1    1600 8350
	0    1    1    0   
$EndComp
Connection ~ 2150 8250
Wire Wire Line
	1250 8250 2150 8250
Wire Wire Line
	2150 8250 4200 8250
Wire Wire Line
	1950 8350 2350 8350
Text HLabel 4200 8450 2    118  Output ~ 0
SENSE_GND-4
Wire Wire Line
	1950 7950 2150 7950
Wire Wire Line
	1950 8350 1950 7950
$Comp
L Device:R R?
U 1 1 64FB71CD
P 2150 8100
AR Path="/64FB71CD" Ref="R?"  Part="1" 
AR Path="/64044101/64FB71CD" Ref="R?"  Part="1" 
F 0 "R?" H 2081 8054 50  0000 R CNN
F 1 "R" H 2081 8145 50  0000 R CNN
F 2 "" V 2080 8100 50  0001 C CNN
F 3 "~" H 2150 8100 50  0001 C CNN
	1    2150 8100
	1    0    0    1   
$EndComp
Text HLabel 4200 8250 2    118  Output ~ 0
SENSE-4
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 64FB71C6
P 1050 8350
F 0 "J?" H 1158 8631 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 8540 50  0000 C CNN
F 2 "" H 1050 8350 50  0001 C CNN
F 3 "~" H 1050 8350 50  0001 C CNN
	1    1050 8350
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 9250 3400 9250
Connection ~ 1950 9150
Wire Wire Line
	1750 9150 1950 9150
Wire Wire Line
	1250 9150 1450 9150
$Comp
L Device:Polyfuse F?
U 1 1 6501B3DD
P 1600 9150
AR Path="/6501B3DD" Ref="F?"  Part="1" 
AR Path="/64044101/6501B3DD" Ref="F?"  Part="1" 
F 0 "F?" H 1688 9196 50  0000 L CNN
F 1 "Polyfuse" H 1688 9105 50  0000 L CNN
F 2 "" H 1650 8950 50  0001 L CNN
F 3 "~" H 1600 9150 50  0001 C CNN
	1    1600 9150
	0    1    1    0   
$EndComp
Connection ~ 2150 9050
Wire Wire Line
	1250 9050 2150 9050
Wire Wire Line
	2150 9050 4200 9050
Wire Wire Line
	1950 9150 2350 9150
Text HLabel 4200 9250 2    118  Output ~ 0
SENSE_GND-5
Wire Wire Line
	1950 8750 2150 8750
Wire Wire Line
	1950 9150 1950 8750
$Comp
L Device:R R?
U 1 1 6501B3EA
P 2150 8900
AR Path="/6501B3EA" Ref="R?"  Part="1" 
AR Path="/64044101/6501B3EA" Ref="R?"  Part="1" 
F 0 "R?" H 2081 8854 50  0000 R CNN
F 1 "R" H 2081 8945 50  0000 R CNN
F 2 "" V 2080 8900 50  0001 C CNN
F 3 "~" H 2150 8900 50  0001 C CNN
	1    2150 8900
	1    0    0    1   
$EndComp
Text HLabel 4200 9050 2    118  Output ~ 0
SENSE-5
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6501B3F1
P 1050 9150
F 0 "J?" H 1158 9431 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 9340 50  0000 C CNN
F 2 "" H 1050 9150 50  0001 C CNN
F 3 "~" H 1050 9150 50  0001 C CNN
	1    1050 9150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 10050 3400 10050
Connection ~ 1950 9950
Wire Wire Line
	1750 9950 1950 9950
Wire Wire Line
	1250 9950 1450 9950
$Comp
L Device:Polyfuse F?
U 1 1 6502CC01
P 1600 9950
AR Path="/6502CC01" Ref="F?"  Part="1" 
AR Path="/64044101/6502CC01" Ref="F?"  Part="1" 
F 0 "F?" H 1688 9996 50  0000 L CNN
F 1 "Polyfuse" H 1688 9905 50  0000 L CNN
F 2 "" H 1650 9750 50  0001 L CNN
F 3 "~" H 1600 9950 50  0001 C CNN
	1    1600 9950
	0    1    1    0   
$EndComp
Connection ~ 2150 9850
Wire Wire Line
	1250 9850 2150 9850
Wire Wire Line
	2150 9850 4200 9850
Wire Wire Line
	1950 9950 2350 9950
Text HLabel 4200 10050 2    118  Output ~ 0
SENSE_GND-6
Wire Wire Line
	1950 9550 2150 9550
Wire Wire Line
	1950 9950 1950 9550
$Comp
L Device:R R?
U 1 1 6502CC0E
P 2150 9700
AR Path="/6502CC0E" Ref="R?"  Part="1" 
AR Path="/64044101/6502CC0E" Ref="R?"  Part="1" 
F 0 "R?" H 2081 9654 50  0000 R CNN
F 1 "R" H 2081 9745 50  0000 R CNN
F 2 "" V 2080 9700 50  0001 C CNN
F 3 "~" H 2150 9700 50  0001 C CNN
	1    2150 9700
	1    0    0    1   
$EndComp
Text HLabel 4200 9850 2    118  Output ~ 0
SENSE-6
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 6502CC15
P 1050 9950
F 0 "J?" H 1158 10231 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 10140 50  0000 C CNN
F 2 "" H 1050 9950 50  0001 C CNN
F 3 "~" H 1050 9950 50  0001 C CNN
	1    1050 9950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 10850 3400 10850
Connection ~ 1950 10750
Wire Wire Line
	1750 10750 1950 10750
Wire Wire Line
	1250 10750 1450 10750
$Comp
L Device:Polyfuse F?
U 1 1 65040B29
P 1600 10750
AR Path="/65040B29" Ref="F?"  Part="1" 
AR Path="/64044101/65040B29" Ref="F?"  Part="1" 
F 0 "F?" H 1688 10796 50  0000 L CNN
F 1 "Polyfuse" H 1688 10705 50  0000 L CNN
F 2 "" H 1650 10550 50  0001 L CNN
F 3 "~" H 1600 10750 50  0001 C CNN
	1    1600 10750
	0    1    1    0   
$EndComp
Connection ~ 2150 10650
Wire Wire Line
	1250 10650 2150 10650
Wire Wire Line
	2150 10650 4200 10650
Wire Wire Line
	1950 10750 2350 10750
Text HLabel 4200 10850 2    118  Output ~ 0
SENSE_GND-7
Wire Wire Line
	1950 10350 2150 10350
Wire Wire Line
	1950 10750 1950 10350
$Comp
L Device:R R?
U 1 1 65040B36
P 2150 10500
AR Path="/65040B36" Ref="R?"  Part="1" 
AR Path="/64044101/65040B36" Ref="R?"  Part="1" 
F 0 "R?" H 2081 10454 50  0000 R CNN
F 1 "R" H 2081 10545 50  0000 R CNN
F 2 "" V 2080 10500 50  0001 C CNN
F 3 "~" H 2150 10500 50  0001 C CNN
	1    2150 10500
	1    0    0    1   
$EndComp
Text HLabel 4200 10650 2    118  Output ~ 0
SENSE-7
$Comp
L Connector:Conn_01x03_Male J?
U 1 1 65040B3D
P 1050 10750
F 0 "J?" H 1158 11031 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1158 10940 50  0000 C CNN
F 2 "" H 1050 10750 50  0001 C CNN
F 3 "~" H 1050 10750 50  0001 C CNN
	1    1050 10750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 5150 2350 5950
Wire Wire Line
	2350 5950 2350 6750
Connection ~ 2350 5150
Connection ~ 2350 5950
Wire Wire Line
	2350 7550 2350 6750
Connection ~ 2350 6750
Wire Wire Line
	2350 7550 2350 8350
Connection ~ 2350 7550
Wire Wire Line
	2350 8350 2350 9150
Connection ~ 2350 8350
Wire Wire Line
	2350 9150 2350 9950
Connection ~ 2350 9150
Wire Wire Line
	2350 9950 2350 10750
Connection ~ 2350 9950
Wire Wire Line
	3400 5250 3400 6050
Connection ~ 3400 6050
Wire Wire Line
	3400 6050 4200 6050
Wire Wire Line
	3400 6050 3400 6850
Connection ~ 3400 6850
Wire Wire Line
	3400 6850 4200 6850
Wire Wire Line
	3400 6850 3400 7650
Connection ~ 3400 7650
Wire Wire Line
	3400 7650 4200 7650
Wire Wire Line
	3400 7650 3400 8450
Connection ~ 3400 8450
Wire Wire Line
	3400 8450 4200 8450
Wire Wire Line
	3400 8450 3400 9250
Connection ~ 3400 9250
Wire Wire Line
	3400 9250 4200 9250
Wire Wire Line
	3400 9250 3400 10050
Connection ~ 3400 10050
Wire Wire Line
	3400 10050 4200 10050
Wire Wire Line
	3400 10050 3400 10850
Connection ~ 3400 10850
Wire Wire Line
	3400 10850 4200 10850
Text GLabel 8300 7150 0    118  Input ~ 0
6V_INT
Text GLabel 8300 7350 0    118  Input ~ 0
GND
Text GLabel 12450 7150 0    118  Input ~ 0
6V_INT
Text GLabel 12450 7350 0    118  Input ~ 0
GND
Text GLabel 12450 4450 0    118  Input ~ 0
GND
Text GLabel 12450 4250 0    118  Input ~ 0
6V_INT
Text GLabel 12900 8300 0    118  Input ~ 0
TMS
Text GLabel 12400 8400 0    118  Input ~ 0
TCK
Text GLabel 12900 8500 0    118  Input ~ 0
TDI
Text GLabel 12400 8600 0    118  UnSpc ~ 0
GND
Text GLabel 12900 8700 0    118  Output ~ 0
TDO
Wire Wire Line
	12900 8700 13800 8700
Wire Wire Line
	13800 8600 12400 8600
Wire Wire Line
	12900 8500 13800 8500
Wire Wire Line
	13800 8400 12400 8400
Wire Wire Line
	12900 8300 13800 8300
Wire Notes Line
	11800 7900 11800 8900
Wire Notes Line
	11800 8900 14750 8900
Wire Notes Line
	14750 7900 14750 8900
Wire Notes Line
	11800 7900 14750 7900
Text Notes 2350 3350 2    118  ~ 24
S1
Text Notes 3400 3350 2    118  ~ 24
S2
Wire Notes Line
	800  4700 5650 4700
Wire Notes Line
	5650 4700 5650 5350
Text Notes 4750 4900 0    118  ~ 24
Sensor-0
Wire Notes Line
	800  4700 800  5350
Wire Notes Line
	800  5350 5650 5350
Wire Notes Line
	800  5500 5650 5500
Wire Notes Line
	5650 5500 5650 6150
Text Notes 4750 5700 0    118  ~ 24
Sensor-1
Wire Notes Line
	800  5500 800  6150
Wire Notes Line
	800  6150 5650 6150
Wire Notes Line
	800  6300 5650 6300
Wire Notes Line
	5650 6300 5650 6950
Text Notes 4750 6500 0    118  ~ 24
Sensor-2
Wire Notes Line
	800  6300 800  6950
Wire Notes Line
	800  6950 5650 6950
Wire Notes Line
	800  7100 5650 7100
Wire Notes Line
	5650 7100 5650 7750
Text Notes 4750 7300 0    118  ~ 24
Sensor-3
Wire Notes Line
	800  7100 800  7750
Wire Notes Line
	800  7750 5650 7750
Wire Notes Line
	800  7900 5650 7900
Wire Notes Line
	5650 7900 5650 8550
Text Notes 4750 8100 0    118  ~ 24
Sensor-4
Wire Notes Line
	800  7900 800  8550
Wire Notes Line
	800  8550 5650 8550
Wire Notes Line
	800  8750 5650 8750
Wire Notes Line
	5650 8750 5650 9400
Text Notes 4750 8950 0    118  ~ 24
Sensor-5
Wire Notes Line
	800  8750 800  9400
Wire Notes Line
	800  9400 5650 9400
Wire Notes Line
	800  9500 5650 9500
Wire Notes Line
	5650 9500 5650 10150
Text Notes 4750 9700 0    118  ~ 24
Sensor-6
Wire Notes Line
	800  9500 800  10150
Wire Notes Line
	800  10150 5650 10150
Wire Notes Line
	800  10300 5650 10300
Wire Notes Line
	5650 10300 5650 10950
Text Notes 4750 10500 0    118  ~ 24
Sensor-7
Wire Notes Line
	800  10300 800  10950
Wire Notes Line
	800  10950 5650 10950
Wire Wire Line
	2900 2900 3800 2900
Connection ~ 2900 2900
Wire Wire Line
	1850 3150 3800 3150
Connection ~ 1850 3150
Wire Notes Line
	6200 2600 6200 11100
Wire Notes Line
	6200 11100 600  11100
Wire Notes Line
	600  11100 600  2600
Wire Notes Line
	600  2600 6200 2600
Wire Notes Line
	600  2450 600  700 
Wire Notes Line
	600  2450 6200 2450
Wire Notes Line
	600  700  6200 700 
Text Notes 6100 3400 1    118  ~ 24
Sensors
Text Notes 7400 8150 2    118  ~ 24
S1
Text Notes 7950 8650 2    79   ~ 0
1-2: Internal power 
Text Notes 7900 8300 2    79   ~ 0
(Sensor Power feed)
Text Notes 1200 3450 2    118  ~ 24
C1
Text Notes 7750 8800 2    79   ~ 0
No isolation
Text Notes 8250 9050 2    79   ~ 0
2-3: External power (C1)
Text Notes 7550 9200 2    79   ~ 0
Isolation
Text Notes 7350 9600 2    118  ~ 24
S2
Text Notes 7800 10100 2    79   ~ 0
1-2: Internal GND
Text Notes 7650 9750 2    79   ~ 0
(Sensor GND)
Text Notes 7750 10250 2    79   ~ 0
No isolation
Text Notes 8150 10500 2    79   ~ 0
2-3: External GND (C1)
Text Notes 7550 10650 2    79   ~ 0
Isolation
Text Notes 8100 2500 3    118  ~ 24
S3-0
Text Notes 9550 2500 3    118  ~ 24
S4-0
Text Notes 12250 2500 3    118  ~ 24
S3-1
Text Notes 13700 2500 3    118  ~ 24
S4-1
Text Notes 8100 5450 3    118  ~ 24
S3-2
Text Notes 9550 5450 3    118  ~ 24
S4-2
Text Notes 12250 5450 3    118  ~ 24
S3-3
Text Notes 13700 5400 3    118  ~ 24
S4-3
Text Notes 7950 8450 2    79   ~ 0
(Common for sensors)
Text Notes 8000 9900 2    79   ~ 0
(Common for sensors)
Text Notes 9450 8150 2    118  ~ 24
S3X
Text Notes 10300 8650 2    79   ~ 0
1-2: Individually provided
Text Notes 10050 8300 2    79   ~ 0
(Actuator source - VCC)
Text Notes 9950 8800 2    79   ~ 0
(full Isolation)
Text Notes 10550 9050 2    79   ~ 0
2-3: Commonly provided (C2)
Text Notes 9950 9200 2    79   ~ 0
(full Isolation)
Text Notes 9750 8450 2    79   ~ 0
(Per actuator)
Text Notes 9450 9600 2    118  ~ 24
S4X
Text Notes 10950 10100 2    79   ~ 0
1-2: Individually connected GND *1)
Text Notes 9750 9750 2    79   ~ 0
(Actuator GND)
Text Notes 9950 10250 2    79   ~ 0
(full Isolation)
Text Notes 11200 10500 2    79   ~ 0
2-3: Commonly connected GND (C2) *1)
Text Notes 9950 10650 2    79   ~ 0
(full Isolation)
Text Notes 9750 9900 2    79   ~ 0
(Per actuator)
Text Notes 11250 10850 2    79   ~ 0
*1) GND is not provided, but if connected
Text Notes 11250 10950 2    79   ~ 0
coil overvoltage protection is enabled
Wire Notes Line
	11600 7900 11600 11100
Wire Notes Line
	11600 11100 6500 11100
Wire Notes Line
	6500 11100 6500 7900
Wire Notes Line
	6500 7900 11600 7900
Text Notes 10650 8100 0    118  ~ 24
Strapping
Wire Notes Line
	6500 7750 6500 700 
Wire Notes Line
	6500 7750 15550 7750
Wire Notes Line
	6500 700  15550 700 
Text Notes 14700 1300 2    118  ~ 24
C2
$EndSCHEMATC
