/*==============================================================================================================================================*/
/* License                                                                                                                                      */
/*==============================================================================================================================================*/
// Copyright (c)2021 Jonas Bjurel (jonasbjurel@hotmail.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law and agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
/*================================================================ END License =================================================================*/

/*==============================================================================================================================================*/
/* Description                                                                                                                                  */
/*==============================================================================================================================================*/
// See README.md
/*============================================================== END Description ===============================================================*/

#ifndef SATELLITELIB_H
#define SATELLITELIB_H

/*==============================================================================================================================================*/
/* Include files                                                                                                                                */
/*==============================================================================================================================================*/
#include <cstring>
#include "freertos/FreeRTOS.h"
#include "freertos/timers.h"
#include "driver/rmt.h"
#include "Arduino.h"
class satelliteLink;
class satellite;
/*============================================================= END Include files ==============================================================*/

/*==============================================================================================================================================*/
/* Configuration                                                                                                                                */
/*==============================================================================================================================================*/
#define MAX_NO_OF_SAT_PER_CH        8
/*============================================================= END Configuration ==============================================================*/

/*==============================================================================================================================================*/
/* Library constants                                                                                                                            */
/*==============================================================================================================================================*/
#define CPUFREQ						80000000
#define WS28XX_T0H_NS				250
#define WS28XX_T1H_NS				600
#define WS28XX_CYC_NS				1250
#define WS28XX_GUARD_NS				10000

#define WS28XX_T0H_CYC				20							//WS28XX_T0H_NS*CPUFREQ/1000000000
#define WS28XX_T0H_CYC_MIN			18							//WS28XX_T0H_CYC * 0.9
#define WS28XX_T0H_CYC_MAX			22							//WS28XX_T0H_CYC * 1.1
#define WS28XX_T0L_CYC				(WS28XX_CYC_CYC - WS28XX_T0H_CYC)
#define WS28XX_T1H_CYC				48							//WS28XX_T1H_NS*CPUFREQ/1000000000
#define WS28XX_T1H_CYC_MIN			43							//WS28XX_T1H_CYC * .9
#define WS28XX_T1H_CYC_MAX			53							//WS28XX_T1H_CYC * 1.1
#define WS28XX_T1L_CYC				(WS28XX_CYC_CYC - WS28XX_T1H_CYC)
#define WS28XX_CYC_CYC				100							//WS28XX_CYC_NS*CPUFREQ/1000000000
#define WS28XX_CYC_CYC_MIN			90							//WS28XX_CYC_CYC*0.9
#define WS28XX_CYC_CYC_MAX			110							//WS28XX_CYC_CYC*1.1
#define WS28XX_GUARD_CYC			800							//WS28XX_GUARD_NS*CPUFREQ/1000000000

#define ONE_SEC_US					1000000

#define SATBUF_CRC_BYTE_OFFSET		7

#define NO_OF_ACT					4
#define NO_OF_SENS					8

#define T_REESTABLISH_LINK_MS		20000
/*============================================================= END Library constants ==========================================================*/

/*==============================================================================================================================================*/
/* Data types, structures, and enumurations                                                                                                     */
/*==============================================================================================================================================*/
// Data prototypes
typedef uint64_t satErr_t;
typedef uint8_t satAdmState_t;
typedef uint8_t satOpState_t;
typedef uint8_t actMode_t;

//Call-back prototypes - see README.md
typedef void (*satLinkStateCb_t)(satelliteLink* satelliteLink_p, uint8_t LinkAddr_p, satOpState_t satOpState_p, void* metaData_p);
typedef void (*satLinkScanCb_t)(void* metaData_p);
typedef void (*satStateCb_t)(satellite* satellite_p, uint8_t LinkAddr_p, uint8_t SatAddr_p, satOpState_t satOpState, void* metaData_p);
typedef void (*satSenseCb_t)(satellite* satellite_p, uint8_t LinkAddr_p, uint8_t SatAddr_p, uint8_t senseAddr_p, bool senseVal_p, void* metadata_p);
typedef void (*satDiscoverCb_t)(satellite* satellite_p, uint8_t LinkAddr_p, uint8_t SatAddr_p, bool exists_p, void* metaData_p);
typedef void (*selfTestCb_t)(satellite* satellite_p, uint8_t LinkAddr_p, uint8_t SatAddr_p, satErr_t selftestErr_p);

struct satWire_t {
	bool dirty;													// If true the values have been updated
	bool invServerCrc;											// If true, outgoing Server CRC checksum will be invalidated
	bool invClientCrc;											// If true, outgoing SAT CRC checksum will be invalidated
	bool setWdErr;												// If true the satellite with simulate a wd error without disabling the actuators
	bool enable;												// If true the satellite actuators will be enabled
	// Link data representation in transmission order - MSB is sent first
	uint8_t sensorVal;											// 8 bits (MSB). Sensor value, can be written by any one
	uint8_t actVal[4];											// 8 bits x 4
	uint8_t actMode[4];											// 3 bits x 4
	uint8_t cmdWdErr;											// 1 bits
	uint8_t cmdEnable;											// 1 bit
	uint8_t cmdInvCrc;											// 1 bit
	uint8_t startMark;											// 1 bit
	uint8_t fbReserv;											// 2 bit
	uint8_t fbWdErr;											// 1 bit
	uint8_t fbRemoteCrcErr;										// 1 bit
	uint8_t crc;												// 4 bit
};

struct satStatus_t {											// Satellite status - shared mem
	bool dirty;													// dirty is set by the producer (satelliteLink) and cleared by the consumer (satellite)
	bool wdErr;													// Watchdog error - Watchdog error - Latched until dirty is reset
	bool remoteCrcErr;											// Remote CRC error - Latched until dirty is reset
	bool rxCrcErr;												// Receive CRC error - Latched until dirty is reset
	bool rxSymbolErr;											// Receive Symbol error - Latched until dirty is reset
	bool rxDataSizeErr;											// Receive datagram size error - Latched until dirty is reset
};

struct sensor_t {
	satellite* satObj;											// Satellite object - used for the static filter method to access the satellite data structure
	uint8_t address;											// Sensor local address/index
	uint16_t filterTime;										// Sensor filter time
	TimerHandle_t timerHandle;									// Sensor filter timer handle
	bool timerActive;											// True if filtering is active
	bool currentSensorVal;										// Unfiltered sensor value
	bool filteredSensorVal;										// Filtered sensor value
};

struct satPerformanceCounters_t {
	uint32_t txUnderunErr;										// Not implemented
	uint32_t txUnderunErrSec;									// Not implemented
	uint32_t rxOverRunErr;										// Not implemented
	uint32_t rxOverRunErrSec;									// Not implemented
	uint32_t scanTimingViolationErr;							// Counter for link scans which did not finish in time
	uint16_t scanTimingViolationErrSec;							// Counter for link scans which did not finish in time - used for ErrSec
	uint32_t rxDataSizeErr;										// Counter for received datagram which had the wrong size
	uint32_t rxDataSizeErrSec;									// Counter for received datagram which had the wrong size - used for ErrSec
	uint32_t rxSymbolErr;										// Counter for Link master detected a symbol errors
	uint32_t rxSymbolErrSec;									// Counter for Link master detected a symbol errors - used for ErrSec
	uint32_t wdErr;												// Counter for watchdog errors
	uint32_t wdErrSec;											// Counter for watchdog errors - used for ErrSec
	uint32_t rxCrcErr;											// Counter for received CRC errors
	uint32_t rxCrcErrSec;										// Counter for received CRC errors - used for ErrSec
	uint32_t remoteCrcErr;										// Counter for remote CRC errors
	uint32_t remoteCrcErrSec;									// Counter for remote CRC errors - used for ErrSec
	uint32_t testRemoteCrcErr;									// Counter used during self test
	uint32_t testRxCrcErr;										// Counter used during self test
	uint32_t testWdErr;											// Counter used during self test
};

struct satLinkInfo_t {
	uint8_t address;											//satelliteLink Address
	rmt_channel_t txCh;											// Satellite link TX channel
	rmt_channel_t rxCh;											// Satellite link RX channel
	gpio_num_t txPin;											// Satellite link TX Pin
	gpio_num_t rxPin;											// Satellite link RX Pin
	uint8_t txMemblck;											// Satellite link TX RMT Memory block
	uint8_t rxMemblck;											// Satellite link RX RMT Memory block
	RingbufHandle_t rb;											// RMT Receive ring buffer
	UBaseType_t pollTaskPrio;									// Poll/Link scan task prio
	UBaseType_t pollTaskCore;									// Poll/Link scan task core
	uint8_t scanInterval;										// link Scan intervall
	satAdmState_t admState;										// Satellite link administrativ status
	satOpState_t opState;										// Satellite link operational status - a bitmap showing the cause of the operational fault
	satWire_t txSatStruct[MAX_NO_OF_SAT_PER_CH + 1];			// Transmit data struct buffer
	satWire_t rxSatStruct[MAX_NO_OF_SAT_PER_CH + 1];			// Receive data struct buffer
	uint8_t txSatBuff[(MAX_NO_OF_SAT_PER_CH + 1) * 8];			// Transmit buffer
	uint8_t rxSatBuff[(MAX_NO_OF_SAT_PER_CH + 1) * 8];			// Receive buffer
	rmt_item32_t txItems[(MAX_NO_OF_SAT_PER_CH + 1) * 8 * 8];	// Transmit RMT item struct buffer
	rmt_item32_t rxItems[(MAX_NO_OF_SAT_PER_CH + 1) * 8 * 8];	// Receive RMT item struct buffer
	satPerformanceCounters_t performanceCounters;				// Performance counter struct
	SemaphoreHandle_t performanceCounterLock;					// Performance counter lock
	uint32_t errThresHigh;										// Cumulative link error second  threshold (local and remote)
	uint32_t errThresLow;										// Cumulative link error second cease threshold (local and remote)
	int64_t oneSecTimer;										// One secont timer counter for ErrSec evaluation
	uint8_t noOfSats;											// Number of satellites on the link
	uint8_t satSelfTest;										// Indication of a sat selftest ongoing on the link MAYBE WE CAN RUN SELFTESTS IN PARALLEL
	satellite* satelliteHandle[MAX_NO_OF_SAT_PER_CH + 1];			// An array with the satellite object handles
	satStatus_t satStatus[MAX_NO_OF_SAT_PER_CH + 1];			// An array with the sat status structs
	satLinkStateCb_t satLinkStateCb;							// Call-back for link operational status changes
	void* satLinkStateCbMetadata;								// Call-back meta data
	satDiscoverCb_t satDiscoverCb;								// Call-back for discovered and removed satellites
	void* satDiscoverCbMetadata;								// Call-back meta data
	satLinkScanCb_t satLinkScanCb;								// Call-back hook to the scan loop
	void* satLinkScanCbMetadata;								// Call-back meta data
	TaskHandle_t scanTaskHandle;								// Link scan task handle
	TimerHandle_t linkReEstablishTimerHandle;					// Link re-establishment timer handle
	uint8_t serverCrcTst[MAX_NO_OF_SAT_PER_CH + 1];				// Server CRC Test state for each satellite
	uint8_t clientCrcTst[MAX_NO_OF_SAT_PER_CH + 1];				// Client CRC Test state for each satellite
	uint8_t wdTst[MAX_NO_OF_SAT_PER_CH + 1];					// Watchdog test state for each satellite
	bool scan;													// Link scan state
	SemaphoreHandle_t actUpdateLock;							// Actuator update lock
};

struct satInfo_t {
	uint8_t address;											// Satellite local address on the Satellite link
	actMode_t actMode[NO_OF_ACT];								// Satellite Actuators mode array
	uint8_t actVal[NO_OF_ACT];									// Satellite Actuators value array
	sensor_t sensors[NO_OF_SENS];								// Sensor struct array
	satStateCb_t stateCb;										// Call-back function for state changes
	void* stateCbMetadata;
	satSenseCb_t senseCb;										// Call-back function for sensor changes
	void* senseCbMetadata;										// Callback meta data
	selfTestCb_t selfTestCb;									// Call-back function for self-test results
	satPerformanceCounters_t performanceCounters;				// Performance counter struct
	uint8_t serverCrcTest;										// Server CRC Test state
	uint8_t clientCrcTest;										// Client CRC Test state
	uint8_t wdTest;												// Watchdog Test state
	uint8_t selftestPhase;										// Self-test state machine
	TimerHandle_t selfTestTimerHandle;							// Self-test timer handle
	TimerHandle_t oneSecTimerHandle;							// Second timer for ErrSec evaluation
	uint32_t errThresHigh;										// Cumulative link error second  threshold (local and remote)
	uint32_t errThresLow;										// Cumulative link error second cease threshold (local and remote)
	satAdmState_t admState;										// Administrative state
	satOpState_t opState;										// Satellite operational state - a bitmap showing the cause the oerational failure
	satelliteLink* satLinkParent;								// A handle to the parent Satellite link
	SemaphoreHandle_t performanceCounterLock;					// Lock protecting the access of performance counters (Read-Modify-Write)
};

// Adminastrive states
#define SAT_ADM_ENABLE					0						// The ADMIN state ENABLE
#define SAT_ADM_DISABLE					1						// The ADMIN state DISABLE, 

// Operative states and causes
#define SAT_OP_WORKING					0x0000					// The OP state is set to working, the object is working
#define SAT_OP_WORKING_STR				"WORKING"
#define SAT_OP_INIT						0x0001					// The OP state has the atribute INIT - initializing.
#define SAT_OP_INIT_STR					"INIT"
#define SAT_OP_DISABLE					0x0002					// The OP state has the atribute DISABLE - disbled by the administrative state of the object.
#define SAT_OP_DISABLE_STR				"DISABLE"
#define SAT_OP_CONTROLBOCK				0x0004					// The OP state has the atribute CONTROLBLOCK - disbled by the operational state of a higher order object.
#define SAT_OP_CONTROLBOCK_STR			"CTRLBLCK"
#define SAT_OP_ERR_SEC					0x0008					// The OP state has the atribute ERRSEC - the object has experienced errors over the past second exceeding set treshold.
#define SAT_OP_ERR_SEC_STR				"ERRSEC"
#define SAT_OP_FAIL						0x0010					// The OP state has the atribute FAIL - the object has experienced a general error.
#define SAT_OP_FAIL_STR					"FAIL"

// Return/Error codes (Least significant byte of the return code)
#define SAT_OK							0x00					// Success
#define SAT_ERR_SYMBOL_ERR				0x01					// Link symbol error
#define SAT_ERR_EXESSIVE_SATS_ERR		0x02					// Too many errors
#define SAT_ERR_GEN_SATLINK_ERR			0x03					// General satellite error
#define SAT_ERR_WRONG_STATE_ERR			0x04					// The order could not be performed because the object is in the wrong state
#define SAT_ERR_DEP_BLOCK_STATUS_ERR	0x05					// The order could not be performed because a related object is in the wrong state
#define SAT_ERR_PARAM_ERR				0x06					// Parameters does not conform to what is expected
#define SAT_ERR_RMT_ERR					0x07					// RMT error
#define SAT_ERR_EXESSIVE_SATS			0x08					// Too many satellites on the link
#define SAT_ERR_SCANTASK_ERR			0x09					// The scan task could not be started
#define SAT_ERR_NOT_EXIST_ERR			0x0A					// The resource does not exist
#define SAT_ERR_BUFF_SMALL_ERR			0x0B					// Buffer too small
#define SAT_ERR_BUSY_ERR				0x0C					// Function is busy
#define SAT_SELFTEST_SERVER_CRC_ERR		0x0D					// Selftest failed - Server TX CRC error not detected
#define SAT_SELFTEST_CLIENT_CRC_ERR		0x0E					// Selftest failed - Client/Satellite TX CRC error not detected
#define SAT_SELFTEST_WD_ERR				0x0F					// Selftest failed - Watchdog error not detected

// PM report format items - see README.md
#define LINK_ADDR						0x0001
#define SAT_ADDR						0x0002
#define RX_SIZE_ERR						0x0004
#define RX_SYMB_ERR						0x0008
#define TIMING_VIOLATION_ERR			0x0010
#define TX_UNDERRUN_ERR					0x0020
#define RX_OVERRRUN_ERR					0x0040
#define RX_CRC_ERR						0x0080
#define REMOTE_CRC_ERR					0x0100
#define WATCHDG_ERR						0x0200
#define ADM_STATE						0x0400
#define OP_STATE						0x0800

//Satellite modes - see README.md
#define SATMODE_LOW						0x00
#define SATMODE_HIGH					0x01
#define SATMODE_PWM1_25K				0x02
#define SATMODE_PWM100					0x03
#define SATMODE_PULSE					0x04
#define SATMODE_PULSE_INV				0x05

// Test status and phases
#define SAT_CRC_TEST_ACTIVE				0xFF					// The object has a CRC test ongoing - CRC performance counters shall not be updated
#define SAT_CRC_TEST_DEACTIVATING		0x0F					// The object has a stopped a CRC test but to avoid capturing residues of the test the CRC counters shall not be updated
#define SAT_CRC_TEST_INACTIVE			0x00					// until CRC_TEST has reached CRC_TEST_INACTIVE (gets decremented for each link scan)
#define SAT_WD_TEST_ACTIVE				0xFF					// The object has a Watchdog test ongoing - same mechanism as for CRC tests
#define SAT_WD_TEST_DEACTIVATING		0x0F
#define SAT_WD_TEST_INACTIVE			0x00
#define NO_TEST							0x00					// There is no self-test ongoing
#define SERVER_CRC_TEST					0x01					// Self-test is excersising Server CRC invalidation
#define CLIENT_CRC_TEST					0x02					// Self-test is excersising Client CRC invalidation
#define WD_TEST							0x03					// Self-test is excersising the watchdog
/*==================================================== END Data structures and enumurations ====================================================*/

/*==============================================================================================================================================*/
/* Function and Class prototypes                                                                                                                */
/*==============================================================================================================================================*/

/*==============================================================================================================================================*/
/* Helper functions                                                                                                                             */
/*==============================================================================================================================================*/

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: opStateToStr()                                                                                                                     */
/* Purpose: Provides a clear text return code string from a return code without string termination.                                             */
/* Parameters: satOpState_t opState_p: Operational state input.                                                                                 */
/*             char* outputStr_p: String.                                                                                                       */
/*             uint8_t length_p: String length.                                                                                                 */
/* Returns: satErr_t Return code.                                                                                                               */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
satErr_t opStateToStr(satOpState_t opState_p, char* outputStr_p, uint8_t length_p);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: formatSatStat()                                                                                                                    */
/* Purpose: Provides formated performance counter table report string. The reportColumnItems decides what performance counter columns that      */
/*          should be included, while the `reportItemsMask` decides what of those counters that should be included.                             */
/*          printhead` defines if the table heading should be included.                                                                         */
/* Parameters: char* reportBuffer_p: Output string buffer.                                                                                      */
/*             uint16_t buffSize_p: String buffer size.                                                                                         */
/*             uint16_t* usedBuff_p: How much of the buffer was used.                                                                           */
/*             uint16_t buffOffset_p: Offset for filling in the buffer.                                                                         */
/*             uint8_t linkAddr_p: Link address for the report.                                                                                 */
/*             uint8_t satAddr_p`*: Satellite address for the report.                                                                            */
/*             satAdmState_t admState_p: Administrative state for the object being reported (satelliteLink or satellite).                         */
/*             satOpState_t opState_p: Operational state for the object being reported (satelliteLink or satellite).                              */
/*             satPerformanceCounters_t* pmdata_p: Performance data structure.                                                                  */
/*             uint16_t reportColumnItems: What pm data columns to include - see the format directives below.                                   */
/*             uint16_t reportItemsMask: What pm data to report on.                                                                             */
/*             bool printHead: If true, the table head is included.                                                                             */
/* Returns: satErr_t Return code.                                                                                                               */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
satErr_t formatSatStat(char* reportBuffer_p, uint16_t buffSize_p, uint16_t* usedBuff_p, uint16_t buffOffset_p, uint8_t linkAddr_p,
	uint8_t satAddr_p, satAdmState_t admState_p, satOpState_t opState_p, satPerformanceCounters_t* pmdata_p, uint16_t reportColumnItems,
	uint16_t reportItemsMask, bool printHead);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: ws28xx_rmt_tx_translator                                                                                                           */
/* Purpose: ws28xx Encoder                                                                                                                      */
/* Parameters: const void* src: Transmit source buffer                                                                                          */
/*             rmt_item32_t* dest: Transmit destination RMT structure buffer.                                                                   */
/*             size_t wanted_num:  Nuber of bytes to be encoded                                                                                 */
/*             size_t* translated_size: Number of decoded bytes                                                                                 */
/*             size_t* item_num: Nuber of encoded RMT items (bits)                                                                              */
/* Returns: -                                                                                                                                   */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
static void IRAM_ATTR ws28xx_rmt_tx_translator(const void* src, rmt_item32_t* dest, size_t src_size,
	size_t wanted_num, size_t* translated_size, size_t* item_num);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: ws28xx_rmt_rx_translator                                                                                                           */
/* Purpose: ws28xx Decoder                                                                                                                      */
/* Parameters: const rmt_item32_t* src: RMT source items receive buffer                                                                         */
/*             uint8_t* dest: Receive destination buffer.                                                                                       */
/*             uint16_t len: Length of the src buffer (bits to encode)                                                                          */
/* Returns: satErr_t Return code.                                                                                                               */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
satErr_t IRAM_ATTR ws28xx_rmt_rx_translator(const rmt_item32_t* src, uint8_t* dest, uint16_t len);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: crc                                                                                                                                */
/* Purpose: Calculates the CRC-4 checksum over a given buffer - ommitting the last 4 bits (which includes or will include the CRC check-sum)    */
/* Parameters: uint8_t* p_crc: Least significant 4 bits holds the resulting CRC-4 check-sum                                                     */
/*             uint8_t* p_buff: Input buffer                                                                                                    */
/*             uint16_t p_buffSize: Size of the input buffer                                                                                    */
/*             bool p_invalidate: If set to true, the CRC checksum is invalidated                                                               */
/* Return: -                                                                                                                                    */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
void crc(uint8_t* crc_p, uint8_t* buff_p, uint16_t buffSize_p, uint8_t satNo_p, bool invalidate_p);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: returnCode                                                                                                                         */
/* Purpose: Composes a return code from a 8 bit local fault code, and a 32 bit second call return code                                          */
/* Parameters: uint8_t localErr: The local return code                                                                                          */
/*             uint32_t callFnErr:  second call return code                                                                                     */
/* Returns: satErr_t Return code                                                                                                                */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
satErr_t returnCode(uint8_t localErr, uint32_t callFnErr);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: populateSatLinkBuff                                                                                                                */
/* Purpose: Populates the link TX buffer from a TX satWire struct                                                                               */
/* Parameters: satWire_t* satWireStruct_p: TX satWire struct.                                                                                   */
/*             uint8_t* satWireBuff_p: link TX buffer                                                                                           */
/* Returns: -                                                                                                                                   */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
void populateSatLinkBuff(satWire_t* satWireStruct_p, uint8_t* satWireBuff_p);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: populateSatWireStruct                                                                                                              */
/* Purpose: Populates a RX satWire struct from the link RX buffer                                                                               */
/* Parameters: satWire_t* satWireStruct_p: RX satWire struct                                                                                    */
/*             uint8_t* satWireBuff_p: link RX buffer                                                                                           */
/* Returns: bool sensChange: Is set to true if the sensor values where changed, otherwise set to false                                          */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
bool populateSatWireStruct(satWire_t* satWireStruct_p, uint8_t* satWireBuff_p);

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: clearPerformanceCounters                                                                                                           */
/* Purpose: Clears the performance counters (exept those used for self test)                                                                    */
/* Parameters: satPerformanceCounters_t* performanceCounters_p: Performance counter structure                                                   */
/* Returns: -                                                                                                                                   */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
void clearPerformanceCounters(satPerformanceCounters_t* performanceCounters_p);
/*=========================================================== END Helper functions =============================================================*/


/*==============================================================================================================================================*/
/* Class: satelliteLink                                                                                                                          */
/* Purpose: The satelliteLink class manages the low-level Satellite link (I.e. OSI L1, L2 and L3). It is responsible for discovery-, and          */
/* topology management of Satellites sitting on the Satellite link, but also responsible for scanning the link (providing instructions and        */
/* pulling results from all the Satellites on a Satellite link), as well as responsible for the integrity of the link. It interchanges raw data   */
/* from/to the satellite class objects of the Satellite link.                                                                                     */
/* Methods: See README.md                                                                                                                       */
/* Data structures: See Satellite.h                                                                                                              */
/*==============================================================================================================================================*/
class satelliteLink {
public:
	//methods
	satelliteLink(uint8_t address_p, gpio_num_t txPin_p, gpio_num_t rxPin_p, rmt_channel_t txCh_p, rmt_channel_t rxCh_p, uint8_t txRmtMemBank_p,
		uint8_t rxRmtMemBank_p, UBaseType_t pollTaskPrio_p, UBaseType_t pollTaskCore_p, uint8_t scanInterval_p);
	~satelliteLink(void);
	satErr_t enableSatLink(void);
	satErr_t disableSatLink(void);
	void setErrTresh(uint16_t p_errThresHigh, uint16_t p_errThresLow);
	void satLinkRegStateCb(satLinkStateCb_t satLinkStateCb_p, void* metadata_p);
	void satLinkUnRegStateCb(void);
	void satLinkRegSatDiscoverCb(satDiscoverCb_t satDiscoverCb_p, void* metaData_p);
	void satLinkUnRegSatDiscoverCb(void);
	void satLinkRegScanCb(satLinkScanCb_t satLinkScanCb_p, void* metaData_p);
	void satLinkUnRegScanCb(void);
	uint8_t getAddress(void);
	uint8_t getSatLinkNoOfSats(void);
	satErr_t getSensorValRaw(uint8_t satAddress_p, uint8_t* sensorVal_p);
	void getSatStats(satPerformanceCounters_t* satStats_p, bool resetStats);
	void clearSatStats(void);
	satellite* getsatHandle(uint8_t satAddr_p);
	satAdmState_t getAdmState(void);
	satOpState_t getOpState(void);
	void opBlock(satOpState_t opState_p);
	void opDeBlock(satOpState_t opState_p);

	//Data structures
	satLinkInfo_t* satLinkInfo;

private:
	// methods
	satErr_t admBlock(void);
	satErr_t admDeBlock(void);
	satErr_t satLinkDiscover(void);
	satErr_t satLinkStartScan(void);
	satErr_t satLinkStopScan(void);
	static void satLinkScan(void* satLinkObj);
	void chkErrSec(void);
	static void linkReEstablish(TimerHandle_t timerHandle);

	// Data structures
	// -
};
/*===================================================== END Class satelliteLink =================================================================*/



/*==============================================================================================================================================*/
/* Class: satellite                                                                                                                              */
/* Purpose: The satellite class is responsible for the higher-level functionality of each satellite (OSI L4-L7). Each satellite class object gets  */
/* created through its parent satelliteLink class object after the satelliteLink Auto discovery process, Satellite users get informed about the    */
/* existence of a satellite through call-backs registered through the parent satelliteLink class object.The satellite class objects have methods   */
/* for setting the actuators, receiving sensor values, and supervising the functionality and the integrity of each satellite.                    */
/* Methods: See README.md                                                                                                                       */
/* Data structures: See Satellite.h                                                                                                              */
/*==============================================================================================================================================*/
class satellite {
public:
	// Methods
	satellite(satelliteLink* satLink_p, uint8_t satAddr_p);
	~satellite(void);
	satErr_t enableSat(void);
	satErr_t disableSat(void);
	void setErrTresh(uint16_t errThresHigh_p, uint16_t errThresLow_p);
	satErr_t setSatActMode(actMode_t actMode_p, uint8_t actIndex_p);
	satErr_t setSatActVal(uint8_t actVal_p, uint8_t actIndex_p);
	satErr_t setSenseFilter(uint16_t senseFilter_p, uint8_t senseIndex_p);
	void getSatStats(satPerformanceCounters_t* satStats_p, bool resetStats);
	void clearSatStats(void);
	void satRegSenseCb(satSenseCb_t fn, void* metaData_p);
	void satUnRegSenseCb(void);
	satErr_t satSelfTest(selfTestCb_t selfTestCb_p);
	bool getSenseVal(uint8_t senseAddr);
	void satRegStateCb(satStateCb_t p_fn, void* p_metadata);
	void satUnRegStateCb(void);
	uint8_t getAddress(void);
	void senseUpdate(satWire_t* rxData);
	void statusUpdate(satStatus_t* status_p);
	satAdmState_t getAdmState(void);
	satOpState_t getOpState(void);
	void opBlock(satOpState_t opState_p);
	void opDeBlock(satOpState_t opState_p);
	// Data structures
	satInfo_t* satInfo;

private:
	// Methods
	satErr_t admBlock(void);
	satErr_t admDeBlock(void);
	static void chkErrSec(TimerHandle_t timerHandle);
	static void filterExp(TimerHandle_t timerHandle);
	void genServerCrcErr(void);
	void genClientCrcErr(void);
	void genWdErr(void);
	static void selfTestTimeout(TimerHandle_t timerHandle);
	static void selftestRes(satellite* satHandle_p, uint8_t satLinkAddr_p, uint8_t satAddr_p, satErr_t err_p);

	// Data structures
	// -
};
/*======================================================= END Class satellite ===================================================================*/

/*================================================ END Function and Class prototypes ===========================================================*/
#endif /*SATELLITELIB_H*/
