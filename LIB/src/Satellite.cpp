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
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either expressed or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
/*================================================================ END License =================================================================*/

/*==============================================================================================================================================*/
/* Description                                                                                                                                  */
/*==============================================================================================================================================*/
// See README.md
/*============================================================== END Description ===============================================================*/

/*==============================================================================================================================================*/
/* Include files                                                                                                                                */
/*==============================================================================================================================================*/
#include "Satellite.h"
/*============================================================= END Include files ==============================================================*/

/*==============================================================================================================================================*/
/* Function and Class implementation                                                                                                            */
/*==============================================================================================================================================*/
// Common variables
// -

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
satErr_t opStateToStr(satOpState_t opState_p, char* outputStr_p, uint8_t length_p) {
	uint8_t length = 0;

	if (opState_p == SAT_OP_WORKING) {
		if (length_p < sizeof(SAT_OP_WORKING_STR))
			return SAT_ERR_BUFF_SMALL_ERR;
		sprintf(outputStr_p, "%s", SAT_OP_WORKING_STR);
		length += sizeof(SAT_OP_WORKING_STR) - 1;
	}
	if (opState_p & SAT_OP_INIT) {
		if (length_p < length + sizeof(SAT_OP_INIT_STR) + 1)
			return SAT_ERR_BUFF_SMALL_ERR;
		sprintf(outputStr_p + length, "%s%s", (length == 0) ? "" : ",", SAT_OP_INIT_STR);
		length += sizeof(SAT_OP_INIT_STR) - (length == 0);
	}
	if (opState_p & SAT_OP_DISABLE) {
		if (length_p < length + sizeof(SAT_OP_DISABLE_STR) + 1)
			return SAT_ERR_BUFF_SMALL_ERR;
		sprintf(outputStr_p + length, "%s%s", (length == 0) ? "" : ",", SAT_OP_DISABLE_STR);
		length += sizeof(SAT_OP_DISABLE_STR) - (length == 0);
	}
	if (opState_p & SAT_OP_CONTROLBOCK) {
		if (length_p < length + sizeof(SAT_OP_CONTROLBOCK_STR) + 1)
			return SAT_ERR_BUFF_SMALL_ERR;
		sprintf(outputStr_p + length, "%s%s", (length == 0) ? "" : ",", SAT_OP_CONTROLBOCK_STR);
		length += sizeof(SAT_OP_CONTROLBOCK_STR) - (length == 0);
	}
	if (opState_p & SAT_OP_ERR_SEC) {
		if (length_p < length + sizeof(SAT_OP_ERR_SEC_STR) + 1)
			return SAT_ERR_BUFF_SMALL_ERR;
		sprintf(outputStr_p + length, "%s%s", (length == 0) ? "" : ",", SAT_OP_ERR_SEC_STR);
		length += sizeof(SAT_OP_ERR_SEC_STR) - (length == 0);
	}
	if (opState_p & SAT_OP_FAIL) {
		if (length_p < length + sizeof(SAT_OP_FAIL_STR) + 1)
			return SAT_ERR_BUFF_SMALL_ERR;
		sprintf(outputStr_p + length, "%s%s", (length == 0) ? "" : ",", SAT_OP_FAIL_STR);
		length += sizeof(SAT_OP_FAIL_STR) - (length == 0);
	}
	for (uint8_t i = 0; i < length_p - length; i++)
		*(outputStr_p + length + i) = 32;
	return SAT_OK;
}

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
	uint16_t reportItemsMask, bool printHead) {
	uint16_t size = 0;

	if (printHead) {
		if (reportColumnItems & LINK_ADDR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "LinkAddr:");
			size += 11;
		}
		if (reportColumnItems & SAT_ADDR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-10s", "SatAddr:");
			size += 10;
		}
		if (reportColumnItems & RX_SIZE_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-10s", "Sizeerr:");
			size += 10;
		}
		if (reportColumnItems & RX_SYMB_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-12s", "Symbolerr:");
			size += 12;
		}
		if (reportColumnItems & TIMING_VIOLATION_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-12s", "Timingerr:");
			size += 12;
		}
		if (reportColumnItems & TX_UNDERRUN_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-14s", "Underrunerr:");
			size += 14;
		}
		if (reportColumnItems & RX_OVERRRUN_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-13s", "Overrunerr:");
			size += 13;
		}
		if (reportColumnItems & RX_CRC_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "RxCRCerr:");
			size += 11;
		}
		if (reportColumnItems & REMOTE_CRC_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "RmCRCerr:");
			size += 11;
		}
		if (reportColumnItems & WATCHDG_ERR) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-8s", "Wderr:");
			size += 8;
		}
		if (reportColumnItems & ADM_STATE) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "AdmState:");
			size += 11;
		}
		if (reportColumnItems & OP_STATE) {
			sprintf(reportBuffer_p + buffOffset_p + size, "%-40s", "OpState:");
			size += 25;
		}
		sprintf(reportBuffer_p + buffOffset_p + size, "\n");
		size++;
	}

	if (reportColumnItems & LINK_ADDR) {
		if (reportItemsMask & LINK_ADDR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11u", linkAddr_p);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "-");
		size += 11;
	}
	if (reportColumnItems & SAT_ADDR) {
		if (reportItemsMask & SAT_ADDR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-10u", satAddr_p);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-10s", "-");
		size += 10;
	}
	if (reportColumnItems & RX_SIZE_ERR) {
		if (reportItemsMask & RX_SIZE_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-10u", pmdata_p->rxDataSizeErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-10s", "-");
		size += 10;
	}
	if (reportColumnItems & RX_SYMB_ERR) {
		if (reportItemsMask & RX_SYMB_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-12u", pmdata_p->rxSymbolErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-12s", "-");
		size += 12;
	}
	if (reportColumnItems & TIMING_VIOLATION_ERR) {
		if (reportItemsMask & TIMING_VIOLATION_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-12u", pmdata_p->scanTimingViolationErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-12s", "-");
		size += 12;
	}
	if (reportColumnItems & TX_UNDERRUN_ERR) {
		if (reportItemsMask & TX_UNDERRUN_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-14u", pmdata_p->txUnderunErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-14s", "-");
		size += 14;
	}
	if (reportColumnItems & RX_OVERRRUN_ERR) {
		if (reportItemsMask & RX_OVERRRUN_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-13u", pmdata_p->rxOverRunErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-13s", "-");
		size += 13;
	}
	if (reportColumnItems & RX_CRC_ERR) {
		if (reportItemsMask & RX_CRC_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11u", pmdata_p->rxCrcErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "-");
		size += 11;
	}
	if (reportColumnItems & REMOTE_CRC_ERR) {
		if (reportItemsMask & REMOTE_CRC_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11u", pmdata_p->remoteCrcErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "-");
		size += 11;
	}
	if (reportColumnItems & WATCHDG_ERR) {
		if (reportItemsMask & WATCHDG_ERR)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-8u", pmdata_p->wdErr);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-8s", "-");
		size += 8;
	}
	if (reportColumnItems & ADM_STATE) {
		if (reportItemsMask & ADM_STATE)
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", admState_p ? "DISABLE" : "ENABLE");
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-11s", "-");
		size += 11;
	}
	if (reportColumnItems & OP_STATE) {
		if (reportItemsMask & OP_STATE)
			opStateToStr(opState_p, reportBuffer_p + buffOffset_p + size, 40);
		else
			sprintf(reportBuffer_p + buffOffset_p + size, "%-40s", "-");
		size += 25;
	}
	sprintf(reportBuffer_p + buffOffset_p + size, "\n");
	size++;
	sprintf(reportBuffer_p + buffOffset_p + size, "\0");
	*usedBuff_p += size;
	return SAT_OK;
}

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
static void IRAM_ATTR ws28xx_rmt_tx_translator(const void* src, rmt_item32_t* dest, size_t src_size, size_t wanted_num,
	size_t* translated_size, size_t* item_num) {
	//Serial.println("Encoding");
	if (src == NULL || dest == NULL) {
		*translated_size = 0;
		*item_num = 0;
		return;
	}
	const rmt_item32_t bit0 = { {{ WS28XX_T0H_CYC, 1, WS28XX_T0L_CYC, 0 }} }; //Logical 0
	const rmt_item32_t bit1 = { {{ WS28XX_T1H_CYC, 1, WS28XX_T1L_CYC, 0 }} }; //Logical 1
	size_t size = 0;
	size_t num = 0;
	uint8_t* psrc = (uint8_t*)src;
	rmt_item32_t* pdest = dest;
	while (size < src_size && num < wanted_num) {
		for (int i = 0; i < 8; i++) {
			// MSB first
			if (*psrc & (1 << (7 - i))) {
				pdest->val = bit1.val;
			}
			else {
				pdest->val = bit0.val;
			}
			num++;
			pdest++;
		}
		size++;
		psrc++;
	}
	*translated_size = size;
	*item_num = num;
}

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: ws28xx_rmt_rx_translator                                                                                                           */
/* Purpose: ws28xx Decoder                                                                                                                      */
/* Parameters: const rmt_item32_t* src: RMT source items receive buffer                                                                         */
/*             uint8_t* dest: Receive destination buffer.                                                                                       */
/*             uint16_t len: Length of the src buffer (bits to encode)                                                                          */
/* Returns: satErr_t Return code.                                                                                                               */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
satErr_t IRAM_ATTR ws28xx_rmt_rx_translator(const rmt_item32_t* src, uint8_t* dest, uint16_t len) {
	//Serial.println("Parsing");
	if (src->level0 != 1) {
		//Serial.println("Symbol ERR-1");
		return SAT_ERR_SYMBOL_ERR;
	}
	for (uint16_t i = 0; i < len / 8; i++) {
		dest[i] = 0;
		for (uint8_t j = 8; j > 0; j--) {
			//Serial.printf("Duration 0: %d\n", src[i * 8 + 8 - j].duration0);
			if (src[i * 8 + 8 - j].duration0 >= WS28XX_T1H_CYC_MIN && src[i * 8 + 8 - j].duration0 <= WS28XX_T1H_CYC_MAX)
				dest[i] = dest[i] | (0x01 << j - 1);
			else if (src[i * 8 + 8 - j].duration0 < WS28XX_T0H_CYC_MIN || src[i * 8 + 8 - j].duration0 > WS28XX_T0H_CYC_MAX) {
				//Serial.println("Symbol ERR-2");
				return SAT_ERR_SYMBOL_ERR;
			}
			else if ((i != 7 && j != 1) && (src[i * 8 + 8 - j].duration0 + src[i * 8 + 8 - j].duration1 < WS28XX_CYC_CYC_MIN ||
				src[i * 8 + 8 - j].duration0 + src[i * 8 + 8 - j].duration1 > WS28XX_CYC_CYC_MAX)) {
				//Serial.printf("Symbol ERR-3, cycle: %d, i=%d j=%d\n", src[i * 8 + 8 - j].duration0 + src[i * 8 + 8 - j].duration1,i,j);
				return SAT_ERR_SYMBOL_ERR;
			}
		}
	}
	return SAT_OK;
}

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: crc                                                                                                                                */
/* Purpose: Calculates the CRC-4 checksum over a given buffer - ommitting the last 4 bits (which includes or will include the CRC check-sum)    */
/* Parameters: uint8_t* crc_p: Least significant 4 bits holds the resulting CRC-4 check-sum                                                     */
/*             uint8_t* buff_p: Input buffer                                                                                                    */
/*             uint16_t buffSize_p: Size of the input buffer                                                                                    */
/*             bool invalidate_p: If set to true, the CRC checksum is invalidated                                                               */
/* Return: -                                                                                                                                    */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
void crc(uint8_t* crc_p, uint8_t* buff_p, uint16_t buffSize_p, uint8_t satNo_p, bool invalidate_p) {
	uint8_t crc;
	crc = 0x00;
	for (unsigned int buffIndex = 0; buffIndex < buffSize_p; buffIndex++) {
		for (unsigned int bitIndex = 8; bitIndex > 0; bitIndex--) {
			//itob(crc, crcStr);
			//Serial.print(crcStr);
			//Serial.print(" ");
			if (buffIndex != buffSize_p - 1 || bitIndex - 1 > 3) {
				crc = crc << 1;
				if (buff_p[buffIndex] & (1 << (bitIndex - 1)))
					crc = crc ^ 0b00010000;
				if (crc & 0b00010000)
					crc = crc ^ 0b00000011;
			}
		}
	}
	*crc_p = *crc_p & 0xF0;
	if (invalidate_p)
		*crc_p = *crc_p | ((~crc^(satNo_p & 0x0F)^(satNo_p>>4&0x0F)) & 0x0F);
	else
		    *crc_p = *crc_p | ((crc^(satNo_p & 0x0F)^(satNo_p>>4&0x0F)) & 0x0F);
	//Serial.printf("CRC calculation for Satellite %d - %s, Correct CRC-4: %X, Calculated and adjusted CRC-4: %X\n", satNo_p, invalidate_p ? "Invalidate CRC-4":"Validate CRC-4", crc&0x0F, *crc_p);
}

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: returnCode                                                                                                                         */
/* Purpose: Composes a return code from a 8 bit local fault code, and a 32 bit second call return code                                          */
/* Parameters: uint8_t localErr: The local return code                                                                                          */
/*             uint32_t callFnErr:  second call return code                                                                                     */
/* Returns: satErr_t Return code                                                                                                                */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
satErr_t returnCode(uint8_t localErr, uint32_t callFnErr) {
	satErr_t rc = 0;
	rc = callFnErr;
	rc = (rc << 32) | localErr;
	return rc;
}

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: populateSatLinkBuff                                                                                                                */
/* Purpose: Populates the link TX buffer from a TX satWire struct                                                                               */
/* Parameters: satWire_t* satWireStruct_p: TX satWire struct.                                                                                   */
/*             uint8_t* satWireBuff_p: link TX buffer                                                                                           */
/* Returns: -                                                                                                                                   */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
void populateSatLinkBuff(satWire_t* satWireStruct_p, uint8_t* satWireBuff_p) {
	satWireBuff_p[0] = satWireStruct_p->sensorVal;
	satWireBuff_p[1] = satWireStruct_p->actVal[3];
	satWireBuff_p[2] = satWireStruct_p->actVal[2];
	satWireBuff_p[3] = satWireStruct_p->actVal[1];
	satWireBuff_p[4] = satWireStruct_p->actVal[0];
	satWireBuff_p[5] = 0x00;
	satWireBuff_p[5] = satWireBuff_p[5] | (satWireStruct_p->actMode[3] & 0x07) << 5;
	satWireBuff_p[5] = satWireBuff_p[5] | (satWireStruct_p->actMode[2] & 0x07) << 2;
	satWireBuff_p[5] = satWireBuff_p[5] | (satWireStruct_p->actMode[1] & 0x07) >> 1;
	satWireBuff_p[6] = 0x00;
	satWireBuff_p[6] = satWireBuff_p[6] | (satWireStruct_p->actMode[1] & 0x07) << 7;
	satWireBuff_p[6] = satWireBuff_p[6] | (satWireStruct_p->actMode[0] & 0x07) << 4;
	satWireBuff_p[6] = satWireBuff_p[6] | (satWireStruct_p->cmdWdErr & 0x01) << 3;
	satWireBuff_p[6] = satWireBuff_p[6] | (satWireStruct_p->cmdEnable & 0x01) << 2;
	satWireBuff_p[6] = satWireBuff_p[6] | (satWireStruct_p->cmdInvCrc & 0x1) << 1;
	satWireBuff_p[6] = satWireBuff_p[6] | (satWireStruct_p->startMark & 0x01);
	satWireBuff_p[7] = 0x00;
	satWireBuff_p[7] = satWireBuff_p[7] | (satWireStruct_p->fbReserv & 0x3) << 6;
	satWireBuff_p[7] = satWireBuff_p[7] | (satWireStruct_p->fbWdErr & 0x1) << 5;
	satWireBuff_p[7] = satWireBuff_p[7] | (satWireStruct_p->fbRemoteCrcErr & 0x1) << 4;
	satWireBuff_p[7] = satWireBuff_p[7] | (satWireStruct_p->crc & 0xF);
}

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: populateSatWireStruct                                                                                                              */
/* Purpose: Populates a RX satWire struct from the link RX buffer                                                                               */
/* Parameters: satWire_t* satWireStruct_p: RX satWire struct                                                                                    */
/*             uint8_t* satWireBuff_p: link RX buffer                                                                                           */
/* Returns: bool sensChange: Is set to true if the sensor values where changed, otherwise set to false                                          */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
bool populateSatWireStruct(satWire_t* satWireStruct_p, uint8_t* satWireBuff_p) {
	bool sensChange = false;
	if (satWireStruct_p->sensorVal != satWireBuff_p[0])
		sensChange = true;
	satWireStruct_p->sensorVal = satWireBuff_p[0];
	satWireStruct_p->actVal[3] = satWireBuff_p[1];
	satWireStruct_p->actVal[2] = satWireBuff_p[2];
	satWireStruct_p->actVal[1] = satWireBuff_p[3];
	satWireStruct_p->actVal[0] = satWireBuff_p[4];
	satWireStruct_p->actMode[3] = 0x00 | (satWireBuff_p[5] & 0xE0) >> 5;
	satWireStruct_p->actMode[2] = 0x00 | (satWireBuff_p[5] & 0x1C) >> 2;
	satWireStruct_p->actMode[1] = 0x00 | (satWireBuff_p[5] & 0x03) << 1 | (satWireBuff_p[6] & 0x80) >> 7;
	satWireStruct_p->actMode[0] = 0x00 | (satWireBuff_p[6] & 0x70) >> 4;
	satWireStruct_p->cmdWdErr = 0x00 | (satWireBuff_p[6] & 0x08) >> 3;
	satWireStruct_p->cmdEnable = 0x00 | (satWireBuff_p[6] & 0x04) >> 2;
	satWireStruct_p->cmdInvCrc = 0x00 | (satWireBuff_p[6] & 0x02) >> 1;
	satWireStruct_p->startMark = 0x00 | (satWireBuff_p[6] & 0x01);
	satWireStruct_p->fbReserv = 0x00 | (satWireBuff_p[7] & 0xC0) >> 6;
	satWireStruct_p->fbWdErr = 0x00 | (satWireBuff_p[7] & 0x20) >> 5;
	satWireStruct_p->fbRemoteCrcErr = 0x00 | (satWireBuff_p[7] & 0x10) >> 4;
	satWireStruct_p->crc = 0x00 | (satWireBuff_p[7] & 0x0F);
	return sensChange;
}

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Function: clearPerformanceCounters                                                                                                           */
/* Purpose: Clears the performance counters (exept those used for self test)                                                                    */
/* Parameters: satPerformanceCounters_t* performanceCounters_p: Performance counter structure                                                   */
/* Returns: -                                                                                                                                   */
/*----------------------------------------------------------------------------------------------------------------------------------------------*/
void clearPerformanceCounters(satPerformanceCounters_t* performanceCounters_p) {
	//Serial.printf("Clearing stats\n");
	performanceCounters_p->txUnderunErr = 0;
	performanceCounters_p->txUnderunErrSec = 0;
	performanceCounters_p->rxOverRunErr = 0;
	performanceCounters_p->rxOverRunErrSec = 0;
	//Serial.printf("Clearing Timing violation counters\n");
	performanceCounters_p->scanTimingViolationErr = 0;
	performanceCounters_p->scanTimingViolationErrSec = 0;
	performanceCounters_p->rxDataSizeErr = 0;
	performanceCounters_p->rxDataSizeErrSec = 0;
	performanceCounters_p->rxSymbolErr = 0;
	performanceCounters_p->rxSymbolErrSec = 0;
	performanceCounters_p->wdErr = 0;
	performanceCounters_p->wdErrSec = 0;
	performanceCounters_p->rxCrcErr = 0;
	performanceCounters_p->rxCrcErrSec = 0;
	performanceCounters_p->remoteCrcErr = 0;
	performanceCounters_p->remoteCrcErrSec = 0;
}
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

/***** PUBLIC MEMBERS *****/

/*satelliteLink Constructur*/
satelliteLink::satelliteLink(uint8_t address_p, gpio_num_t txPin_p, gpio_num_t rxPin_p, rmt_channel_t txCh_p,
	rmt_channel_t rxCh_p, uint8_t txRmtMemBank_p, uint8_t rxRmtMemBank_p, UBaseType_t pollTaskPrio_p,
	UBaseType_t pollTaskCore_p, uint8_t scanInterval_p) {
	satLinkInfo = new satLinkInfo_t;
	satLinkInfo->performanceCounterLock = xSemaphoreCreateMutex();  // Create lock for PM (needed due to Read-Modify-Write)
	satLinkInfo->actUpdateLock = xSemaphoreCreateMutex();			// Create lock for actuator update
	rmt_config_t rmtTxConfig;                                       // Create RMT RX/TX
	rmt_config_t rmtRxConfig;
	satLinkInfo->address = address_p;                               // Set address, RMT RX/TX pins-, Channels, mem-banks...
	satLinkInfo->txPin = txPin_p;
	satLinkInfo->rxPin = rxPin_p;
	satLinkInfo->txCh = txCh_p;
	satLinkInfo->rxCh = rxCh_p;
	satLinkInfo->txMemblck = txRmtMemBank_p;
	satLinkInfo->rxMemblck = rxRmtMemBank_p;
	satLinkInfo->pollTaskPrio = pollTaskPrio_p;                     // Set the poll/scan task properties
	satLinkInfo->pollTaskCore = pollTaskCore_p;
	satLinkInfo->scanInterval = scanInterval_p;
	satLinkInfo->errThresHigh = 20;                                 // Set default and initial values
	satLinkInfo->errThresLow = 2;
	satLinkInfo->noOfSats = 0;
	satLinkInfo->satSelfTest = NO_TEST;
	satLinkInfo->opState = SAT_OP_DISABLE | SAT_OP_INIT;
	satLinkInfo->admState = SAT_ADM_DISABLE;
	satLinkInfo->satLinkStateCb = NULL;
	satLinkInfo->satLinkStateCbMetadata = NULL;
	satLinkInfo->satDiscoverCb = NULL;
	satLinkInfo->satDiscoverCbMetadata = NULL;
	satLinkInfo->satLinkScanCb = NULL;
	satLinkInfo->satLinkScanCbMetadata = NULL;
	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH + 1; i++) {         // Set satellite default and initial values
		satLinkInfo->serverCrcTst[i] = SAT_CRC_TEST_INACTIVE;
		satLinkInfo->clientCrcTst[i] = SAT_CRC_TEST_INACTIVE;
		satLinkInfo->wdTst[i] = SAT_WD_TEST_INACTIVE;
		satLinkInfo->satelliteHandle[i] = NULL;
		satLinkInfo->txSatStruct[i].enable = false;
		satLinkInfo->txSatStruct[i].setWdErr = false;
		satLinkInfo->txSatStruct[i].invServerCrc = false;
		satLinkInfo->txSatStruct[i].invClientCrc = false;
		satLinkInfo->txSatStruct[i].sensorVal = 0x00;
		satLinkInfo->txSatStruct[i].actVal[0] = 0x00;
		satLinkInfo->txSatStruct[i].actVal[1] = 0x00;
		satLinkInfo->txSatStruct[i].actVal[2] = 0x00;
		satLinkInfo->txSatStruct[i].actVal[3] = 0x00;
		satLinkInfo->txSatStruct[i].actMode[0] = SATMODE_LOW;
		satLinkInfo->txSatStruct[i].actMode[1] = SATMODE_LOW;
		satLinkInfo->txSatStruct[i].actMode[2] = SATMODE_LOW;
		satLinkInfo->txSatStruct[i].actMode[3] = SATMODE_LOW;
		satLinkInfo->txSatStruct[i].cmdWdErr = 0x00;
		satLinkInfo->txSatStruct[i].cmdEnable = 0x00;
		satLinkInfo->txSatStruct[i].cmdInvCrc = 0x00;
		satLinkInfo->txSatStruct[i].startMark = 0x00;
		satLinkInfo->txSatStruct[i].fbReserv = 0x00;
		satLinkInfo->txSatStruct[i].fbWdErr = 0x00;
		satLinkInfo->txSatStruct[i].fbRemoteCrcErr = 0x00;
		satLinkInfo->txSatStruct[i].dirty = true;
		satLinkInfo->satelliteHandle[i] = new satellite(this, i);
	}
	satLinkInfo->scan = false;                                      // Initial scanning is false
	clearPerformanceCounters(&satLinkInfo->performanceCounters);    // Clear all link counters
	satLinkInfo->oneSecTimer = esp_timer_get_time();                // Initialize the one second performance counter
	rmtTxConfig.rmt_mode = RMT_MODE_TX;                             // Initialize the RX/TX RMT channels
	rmtTxConfig.channel = satLinkInfo->txCh;
	rmtTxConfig.gpio_num = satLinkInfo->txPin;
	rmtTxConfig.clk_div = 1;
	rmtTxConfig.mem_block_num = satLinkInfo->txMemblck;
	rmtTxConfig.tx_config.carrier_freq_hz = 38000;
	rmtTxConfig.tx_config.carrier_level = RMT_CARRIER_LEVEL_HIGH;
	rmtTxConfig.tx_config.idle_level = RMT_IDLE_LEVEL_LOW;
	rmtTxConfig.tx_config.carrier_duty_percent = 33;
	rmtTxConfig.tx_config.carrier_en = false;
	rmtTxConfig.tx_config.loop_en = false;
	rmtTxConfig.tx_config.idle_output_en = true;
	esp_err_t rc;
	rc = rmt_config(&rmtTxConfig);
	if (rc != ESP_OK) {
		//Serial.printf("Failed to configure RMT, returned %s\n", esp_err_to_name(rc));
		assert(false);
	}
	rc = rmt_driver_install(satLinkInfo->txCh, 0, 0);
	if (rc != ESP_OK) {
		//Serial.printf("Failed to install RMT driver, returned %s\n", esp_err_to_name(rc));
		assert(false);
	}
	rmt_translator_init(satLinkInfo->txCh, ws28xx_rmt_tx_translator);
	rmtRxConfig.rmt_mode = RMT_MODE_RX;
	rmtRxConfig.channel = satLinkInfo->rxCh;
	rmtRxConfig.gpio_num = satLinkInfo->rxPin;
	rmtRxConfig.clk_div = 1;
	rmtRxConfig.mem_block_num = satLinkInfo->rxMemblck;
	rmtRxConfig.rx_config.filter_en = true;
	rmtRxConfig.rx_config.filter_ticks_thresh = 5;
	rmtRxConfig.rx_config.idle_threshold = WS28XX_GUARD_CYC;
	rmt_config(&rmtRxConfig);
	rmt_driver_install(satLinkInfo->rxCh, 10000, 0);
	rmt_get_ringbuf_handle(satLinkInfo->rxCh, &satLinkInfo->rb);
	satLinkInfo->linkReEstablishTimerHandle = xTimerCreate          // Create (but dont start) the link re-establish timer
		("LinkReEstablishTimer",
			pdMS_TO_TICKS(T_REESTABLISH_LINK_MS),
			pdFALSE, (void*)this, &linkReEstablish);
}

/*satelliteLink Destructur*/
satelliteLink::~satelliteLink(void) {                                 // satelliteLink destructor
	satLinkStopScan();                                              // Delete all allocated resources
	assert(satLinkInfo->opState == SAT_OP_DISABLE);
	assert(rmt_driver_uninstall(satLinkInfo->txCh) == ESP_OK);
	assert(rmt_driver_uninstall(satLinkInfo->rxCh) == ESP_OK);
	vSemaphoreDelete(satLinkInfo->performanceCounterLock);
	delete satLinkInfo;
}

/*satelliteLink enableSatLink*/
satErr_t satelliteLink::enableSatLink(void) {
	//Serial.printf("Check satelliteHandle-3 satLinkInfo->satelliteHandle[8], value is now %i\n", satLinkInfo->satelliteHandle[8]);
	esp_err_t rmtRc;
	satErr_t rc;
	if (satLinkInfo->admState != SAT_ADM_DISABLE)                    // Check if already Admin Blocked
		return (returnCode(SAT_ERR_WRONG_STATE_ERR, 0));
	if (rmtRc = rmt_rx_start(satLinkInfo->rxCh, 1) != ESP_OK)        // Start RMT
		return (returnCode(SAT_ERR_RMT_ERR, rmtRc));
	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH + 1; i++) {        // Set up the tx struct data
		satLinkInfo->txSatStruct[i].invServerCrc = false;
		satLinkInfo->txSatStruct[i].invClientCrc = false;
		satLinkInfo->txSatStruct[i].enable = false;
		satLinkInfo->txSatStruct[i].dirty = true;
	}
	if (rc = satLinkStartScan())                                     // Start Link scan
		return (returnCode(rc, 0));
	vTaskDelay(500 / portTICK_PERIOD_MS);
	if (rc = satLinkDiscover())                                      // Start Link discovery
		return (returnCode(rc, 0));
	if (rc = admDeBlock())                                          // Admin deblock
		return (returnCode(rc, 0));
	return (returnCode(SAT_OK, 0));
}

/*satelliteLink disableSatLink*/
satErr_t satelliteLink::disableSatLink(void) {
	esp_err_t rmtRc;
	satErr_t rc;
	if (satLinkInfo->admState != SAT_ADM_ENABLE)                    // Check if Admstate already blocked
		return (returnCode(SAT_ERR_WRONG_STATE_ERR, 0));
	if (rc = admBlock())                                            // Admstate block
		return (returnCode(rc, 0));
	if (rmtRc = rmt_rx_stop(satLinkInfo->rxCh) != ESP_OK)           // Stop RMT
		return (returnCode(SAT_ERR_RMT_ERR, rmtRc));
	if (rc = satLinkStopScan())                                     // Stop Link scanning
		return (returnCode(rc, 0));

	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {            // Inform satellite users about intention to delete the satellite, and delete it
		if (satLinkInfo->satelliteHandle[i] != NULL) {
			if (satLinkInfo->satDiscoverCb != NULL)
				satLinkInfo->satDiscoverCb(satLinkInfo->satelliteHandle[i], satLinkInfo->address, i, false, satLinkInfo->satDiscoverCbMetadata);
			//delete satLinkInfo->satelliteHandle[i];
			//satLinkInfo->satelliteHandle[i] = NULL;
		}
	}
	return (returnCode(SAT_OK, 0));
}

/*satelliteLink setErrTresh*/
void satelliteLink::setErrTresh(uint16_t p_errThresHigh, uint16_t p_errThresLow) {
	satLinkInfo->errThresHigh = p_errThresHigh;
	satLinkInfo->errThresLow = p_errThresLow;
}

/*satelliteLink satLinkRegStateCb*/
void satelliteLink::satLinkRegStateCb(satLinkStateCb_t satLinkStateCb_p, void* metaData_p) {
	satLinkInfo->satLinkStateCb = satLinkStateCb_p;
	satLinkInfo->satLinkStateCbMetadata = metaData_p;
}

/*satelliteLink satLinkUnRegStateCb*/
void satelliteLink::satLinkUnRegStateCb(void) {
	satLinkInfo->satLinkStateCb = NULL;
}

void satelliteLink::satLinkRegSatDiscoverCb(satDiscoverCb_t satDiscoverCb_p, void* metaData_p) {
	satLinkInfo->satDiscoverCb = satDiscoverCb_p;
	satLinkInfo->satDiscoverCbMetadata = metaData_p;
}

void satelliteLink::satLinkUnRegSatDiscoverCb(void) {
	satLinkInfo->satDiscoverCb = NULL;
}

void satelliteLink::satLinkRegScanCb(satLinkScanCb_t satLinkScanCb_p, void* metaData_p) {
	satLinkInfo->satLinkScanCb = satLinkScanCb_p;
	satLinkInfo->satLinkScanCbMetadata = metaData_p;
}

void satelliteLink::satLinkUnRegScanCb(void) {
	satLinkInfo->satLinkScanCb = NULL;
	satLinkInfo->satLinkScanCbMetadata = NULL;
}

uint8_t satelliteLink::getAddress(void) {
	return satLinkInfo->address;
}

/*satelliteLink getSatLinkNoOfSats*/
uint8_t satelliteLink::getSatLinkNoOfSats(void) {
	return satLinkInfo->noOfSats;
}

satErr_t satelliteLink::getSensorValRaw(uint8_t satAddress_p, uint8_t* sensorVal_p) {
	if (satAddress_p >= satLinkInfo->noOfSats)
		return (returnCode(SAT_ERR_NOT_EXIST_ERR, 0));
	*sensorVal_p = satLinkInfo->rxSatStruct[satAddress_p].sensorVal;
	return (returnCode(SAT_OK, 0));
}

void satelliteLink::getSatStats(satPerformanceCounters_t* satStats_p, bool resetStats) {
	xSemaphoreTake(satLinkInfo->performanceCounterLock, portMAX_DELAY);
	memcpy((void*)satStats_p, (void*)&(satLinkInfo->performanceCounters), sizeof(satPerformanceCounters_t));
	if (resetStats)
		clearPerformanceCounters(&satLinkInfo->performanceCounters);
	xSemaphoreGive(satLinkInfo->performanceCounterLock);
}

void satelliteLink::clearSatStats(void) {
	xSemaphoreTake(satLinkInfo->performanceCounterLock, portMAX_DELAY);
	clearPerformanceCounters(&satLinkInfo->performanceCounters);
	xSemaphoreGive(satLinkInfo->performanceCounterLock);
}

/*satelliteLink getsatRef*/
satellite* satelliteLink::getsatHandle(uint8_t satAddr_p) {
	if (satAddr_p >= satLinkInfo->noOfSats)
		return NULL;
	return satLinkInfo->satelliteHandle[satAddr_p];
}

/***** PRIVATE MEMBERS *****/
/*satelliteLink satLinkDiscover*/
satErr_t satelliteLink::satLinkDiscover(void) {
	//satellite* satTmp;

	//Serial.printf("Running discovery\n");
	opBlock(SAT_OP_INIT);                                           // Set Link Opstate to INIT
	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH; i++) {            // Delete any existing satellites after having informed their users
		if (satLinkInfo->satelliteHandle[i] != NULL) {
			//Serial.printf("Deleting Sat %d\n", i);
			if (satLinkInfo->satDiscoverCb != NULL)
				satLinkInfo->satDiscoverCb(satLinkInfo->satelliteHandle[i], satLinkInfo->address, i, false, satLinkInfo->satDiscoverCbMetadata);
			//satTmp = satLinkInfo->satelliteHandle[i];
			//satLinkInfo->satelliteHandle[i] = NULL;
			//delete satTmp;
		}
		satLinkInfo->satStatus[i].dirty = false;
	}
	satLinkInfo->noOfSats = MAX_NO_OF_SAT_PER_CH + 1;               //Scan one more sat than max
	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH + 1; i++) {
		//Serial.printf("Ask for inverting CRC for sat %d\n", i);
		satLinkInfo->txSatStruct[i].invServerCrc = true;
		satLinkInfo->txSatStruct[i].dirty = true;
	}
	vTaskDelay(1000 / portTICK_PERIOD_MS);
	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH + 1; i++)
		satLinkInfo->satStatus[i].dirty = false;
	vTaskDelay(1000 / portTICK_PERIOD_MS);
      // satLinkInfo->rxSatStruct[i].fbRemoteCrcErr == 0x01 HOW DOES THIS DIFFER FROM BELOW
	if (satLinkInfo->satStatus[MAX_NO_OF_SAT_PER_CH].remoteCrcErr) {//More than MAX_NO_OF_SAT_PER_CH on the link
		satLinkInfo->noOfSats = 0;
		opBlock(SAT_OP_FAIL);
		opDeBlock(SAT_OP_INIT);
		//Serial.printf("SAT_ERR_EXESSIVE_SATS\n");
		return (returnCode(SAT_ERR_EXESSIVE_SATS, 0));
	}

	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH + 1; i++) {        // Check that satellites on the link is in contigious order
		bool endOfSat = false;                                      // if not there must be a general failure
		if (!satLinkInfo->satStatus[i].remoteCrcErr) {
			endOfSat = true;
			//Serial.printf("EndSatellite %d\n", i);
		}
		if (satLinkInfo->satStatus[i].remoteCrcErr && endOfSat) {
			satLinkInfo->noOfSats = 0;
			opBlock(SAT_OP_FAIL);
			opDeBlock(SAT_OP_INIT);
			//Serial.printf("SAT_ERR_GEN_SATLINK_ERR\n");
			return (returnCode(SAT_ERR_GEN_SATLINK_ERR, 0));
		}
	}

	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH + 1; i++) {        // Check and set numbers of satellites on the link
		satLinkInfo->noOfSats = i;
		if (!satLinkInfo->satStatus[i].remoteCrcErr)
			break;
	}
	//Serial.printf("Discovered %i satellites\n", satLinkInfo->noOfSats);
	for (uint8_t i = 0; i < MAX_NO_OF_SAT_PER_CH + 1; i++) {        // Stop CRC inversion for all satellites
		//Serial.printf("Autodiscover is disabling CRC invert for satellite %i\n", i);
		satLinkInfo->txSatStruct[i].invServerCrc = false;
		satLinkInfo->txSatStruct[i].dirty = true;
	}
	vTaskDelay(1000 / portTICK_PERIOD_MS);

	for (uint8_t i = 0; i < satLinkInfo->noOfSats; i++) {           // Create discovered satellites
		//Serial.printf("Creating satellite %d\n", i);
		//satLinkInfo->satelliteHandle[i] = new satellite(this, i);
		if (satLinkInfo->satDiscoverCb != NULL) {
			satLinkInfo->satDiscoverCb(satLinkInfo->satelliteHandle[i], satLinkInfo->address, i, true, satLinkInfo->satDiscoverCbMetadata);
			//Serial.printf("Sent a discovery callback message for satellite %d\n", i);
		}
		//else
			//Serial.printf("Could not Send a discovery callback message for satellite %d, no callback registered\n", i);
	}
	if (satLinkInfo->noOfSats) {                                     // If satellites were discover - Opstate deblock the link
		opDeBlock(SAT_OP_FAIL);
		opDeBlock(SAT_OP_INIT);
		//Serial.printf("FOUND SATELLITES\n");
	}
	else {
		//Serial.printf("DID NOT FIND ANY SATELLITES\n");
		opBlock(SAT_OP_FAIL);
		opDeBlock(SAT_OP_INIT);
	}
	//Serial.printf("End discovery, %d Satellites discovered\n", satLinkInfo->noOfSats);
	return (returnCode(SAT_OK, 0));
}

/*satelliteLink satLinkStartScan*/
satErr_t satelliteLink::satLinkStartScan(void) {
	BaseType_t taskRc;
	if (satLinkInfo->scan == true)                                   // Check if linkscanning already is active
		return (returnCode(SAT_ERR_WRONG_STATE_ERR, 0));

	taskRc = xTaskCreatePinnedToCore(                               // Start the link scanning task
		satLinkScan,                                                // Task function
		"satLinkScan",                                              // Task function name reference
		10 * 1024,                                                   // Stack size
		this,                                                       // Parameter passing
		satLinkInfo->pollTaskPrio,                                  // Priority 0-24, higher is more
		&(satLinkInfo->scanTaskHandle),                             // Task handle
		satLinkInfo->pollTaskCore);                                 // Task core
	if (taskRc != pdPASS)
		return (returnCode(SAT_ERR_SCANTASK_ERR, 0));
	satLinkInfo->scan = true;
	return (returnCode(SAT_OK, 0));
}

/*satelliteLink satLinkStopScan*/
satErr_t satelliteLink::satLinkStopScan(void) {
	if (satLinkInfo->scan == false)                                 // Check if link scan already is active
		return (returnCode(SAT_ERR_WRONG_STATE_ERR, 0));
  vTaskDelete(satLinkInfo->scanTaskHandle);                       // Stop the link scanning task
	satLinkInfo->scan = false;
	return (returnCode(SAT_OK, 0));
}

void satelliteLink::satLinkScan(void* satLinkObj) {
	satLinkInfo_t* satLinkInfo = ((satelliteLink*)satLinkObj)->satLinkInfo;
	int64_t t0;
	bool rxSymbolErr = false;
	bool rxDataSizeErr = false;
	uint16_t tot_rx_size = 0;
	rmt_item32_t* items = NULL;
	size_t rx_size = 0;
	uint8_t index = 0;
	uint8_t crcCalc;
	int64_t nextTime;
	while (true) {                                                   // Link scan loop
		t0 = esp_timer_get_time();
		//Serial.printf("satLinkInfo->noOfSats: %d\n", satLinkInfo->noOfSats);
		if (satLinkInfo->satLinkScanCb)
			satLinkInfo->satLinkScanCb(satLinkInfo->satLinkScanCbMetadata);
		xSemaphoreTake(satLinkInfo->actUpdateLock, portMAX_DELAY);
		for (uint8_t i = 0; i < satLinkInfo->noOfSats; i++) {       // Populate the TX structs with data from all existing satellites
			//for (uint8_t i = 0; i < 1; i++) {
			//Serial.printf("Satellite %d, Inv Server CRC Cmd: %s\n", i, satLinkInfo->txSatStruct[i].invServerCrc ? "true" : "false");                        
			if (i == 0)
				satLinkInfo->txSatStruct[i].startMark = 0x01;       // Satellite 0 should have start mark set
			else
				satLinkInfo->txSatStruct[i].startMark = 0x00;
			if (satLinkInfo->clientCrcTst[i])
				//Serial.printf("Client CRC Test status for Sat %d: %d\n", i, satLinkInfo->clientCrcTst[i]);
			if (satLinkInfo->serverCrcTst[i] != SAT_CRC_TEST_ACTIVE && satLinkInfo->serverCrcTst[i] != SAT_CRC_TEST_INACTIVE)
				satLinkInfo->serverCrcTst[i]--;                    // Decrease from TEST DEACTIVATING to TEST INACTIVE to filter any residual CRC errors
			if (satLinkInfo->clientCrcTst[i] != SAT_CRC_TEST_ACTIVE && satLinkInfo->clientCrcTst[i] != SAT_CRC_TEST_INACTIVE)
				satLinkInfo->clientCrcTst[i]--;                    // Decrease from TEST DEACTIVATING to TEST INACTIVE to filter any residual CRC errors
			if (satLinkInfo->wdTst[i] != SAT_WD_TEST_ACTIVE && satLinkInfo->wdTst[i] != SAT_WD_TEST_INACTIVE)
				satLinkInfo->wdTst[i]--;                           // Decrease from TEST DEACTIVATING to TEST INACTIVE to filter any residual watchdog errors
			if (satLinkInfo->txSatStruct[i].dirty == true) {        // Only update the TX struct if there is new satellite data
				//Serial.printf("Satellite: %i, Actmode[] is: [%d,%d,%d,%d] , ActVal[] is: [%d,%d,%d,%d] \n", i, satLinkInfo->txSatStruct[i].actMode[0], satLinkInfo->txSatStruct[i].actMode[1], satLinkInfo->txSatStruct[i].actMode[2], satLinkInfo->txSatStruct[i].actMode[3], satLinkInfo->txSatStruct[i].actVal[0], satLinkInfo->txSatStruct[i].actVal[1], satLinkInfo->txSatStruct[i].actVal[2], satLinkInfo->txSatStruct[i].actVal[3]);
				if (satLinkInfo->txSatStruct[i].invServerCrc) {
					//Serial.printf("Server CRC Inv ordered\n");
					satLinkInfo->serverCrcTst[i] = SAT_CRC_TEST_ACTIVE;// Set TEST ACTIVE as the satellite has ordered a server CRC test
				}
				else if (!satLinkInfo->txSatStruct[i].invServerCrc && satLinkInfo->serverCrcTst[i] == SAT_CRC_TEST_ACTIVE)
					satLinkInfo->serverCrcTst[i] = SAT_CRC_TEST_DEACTIVATING; // Set TEST DEACTIVATING as the satellite ceased ordered for server CRC test
				if (satLinkInfo->txSatStruct[i].invClientCrc) {
					//Serial.printf("Client CRC Inv ordered for sat %d\n", i);
					satLinkInfo->clientCrcTst[i] = SAT_CRC_TEST_ACTIVE;// Set TEST ACTIVE as the satellite has ordered a client CRC test
					satLinkInfo->txSatStruct[i].cmdInvCrc = true;
				}
				else if (!satLinkInfo->txSatStruct[i].invClientCrc && satLinkInfo->clientCrcTst[i] == SAT_CRC_TEST_ACTIVE) {
					//Serial.printf("Client CRC Inv ceased for sat %d\n", i);
					satLinkInfo->clientCrcTst[i] = SAT_CRC_TEST_DEACTIVATING;// Set TEST DEACTIVATING as the satellite ceased ordered for client CRC test
					satLinkInfo->txSatStruct[i].cmdInvCrc = false;
				}
				if (satLinkInfo->txSatStruct[i].setWdErr) {
					//Serial.printf("WD err ordered\n");
					satLinkInfo->wdTst[i] = SAT_WD_TEST_ACTIVE;// Set TEST ACTIVE as the satellite has ordered a server CRC test
					satLinkInfo->txSatStruct[i].cmdWdErr = true;
				}
				else if (!satLinkInfo->txSatStruct[i].setWdErr && satLinkInfo->wdTst[i] == SAT_WD_TEST_ACTIVE) {
					satLinkInfo->wdTst[i] = SAT_WD_TEST_DEACTIVATING; // Set TEST DEACTIVATING as the satellite has ceased order for watchdog test
					satLinkInfo->txSatStruct[i].cmdWdErr = false;
				}
				if (satLinkInfo->txSatStruct[i].enable)
					satLinkInfo->txSatStruct[i].cmdEnable = 0x01;
				else
					satLinkInfo->txSatStruct[i].cmdEnable = 0x00;
				populateSatLinkBuff(&satLinkInfo->txSatStruct[i], &satLinkInfo->txSatBuff[i * 8]); // Poulate the linkbuffer with ne satellite TX data
				//Serial.printf("IvertCRC for satellite %d : %X\n", i, satLinkInfo->txSatStruct[i].invServerCrc == 0x01);
				crc(&satLinkInfo->txSatBuff[i * 8 + SATBUF_CRC_BYTE_OFFSET], &satLinkInfo->txSatBuff[i * 8], // and calculate the CRC checksum
					8, i, (satLinkInfo->txSatStruct[i].invServerCrc == 0x01));
			}
			//Serial.printf("Transmitbuffer for Satellite %d : ", i);
			//for(uint8_t m = 0; m < 8; m++)
			//Serial.printf("%x:", satLinkInfo->txSatBuff[i * 8 + m]);
			//Serial.printf("\n");
		}
		//if (satLinkInfo->txSatStruct[1].actVal[3] != 0)
			//Serial.printf("Updating\n");
		for (uint8_t i = 0; i < satLinkInfo->noOfSats; i++) {        // Write RMT samples from TX buffer
			rmt_write_sample(satLinkInfo->txCh, &satLinkInfo->txSatBuff[i * 8], (size_t)8, false);
			if (satLinkInfo->txSatStruct[i].dirty) {
				for (uint8_t j = 0; j < NO_OF_ACT; j++) {				// If a pulse, it shouldnt be repeated
					if (satLinkInfo->txSatStruct[i].actMode[j] == SATMODE_PULSE || satLinkInfo->txSatStruct[i].actMode[j] == SATMODE_PULSE_INV)
						satLinkInfo->txSatStruct[i].actVal[j] = 0;
				}
				populateSatLinkBuff(&satLinkInfo->txSatStruct[i], &satLinkInfo->txSatBuff[i * 8]);
				crc(&satLinkInfo->txSatBuff[i * 8 + SATBUF_CRC_BYTE_OFFSET], &satLinkInfo->txSatBuff[i * 8], // and calculate the CRC checksum
					8, i, (satLinkInfo->txSatStruct[i].invServerCrc == 0x01));
				satLinkInfo->txSatStruct[i].dirty = false;
			}
		}
		xSemaphoreGive(satLinkInfo->actUpdateLock);
		tot_rx_size = 0;
		index = 0;
		while (true) {                                              // Read RMT incoming data
			items = (rmt_item32_t*)xRingbufferReceive(satLinkInfo->rb, &rx_size, 1);
			if (items == NULL) {                                    // No more data to read
				//Serial.printf("There is no data\n");
				if (tot_rx_size != satLinkInfo->noOfSats * 8 * 8) { // Size of read data is wrong
					//if (tot_rx_size != 8 * 8) {
					 rxDataSizeErr = true;
					//Serial.printf("Size ERR, size: %d, number of sats: %d\n", tot_rx_size, satLinkInfo->noOfSats);
					break;
				}
				else
					break;
			}
			else {
				//Serial.printf("There is data\n");
																	// Received data
				tot_rx_size += rx_size / 4;                         // Decode the read data
				if (ws28xx_rmt_rx_translator(items, &satLinkInfo->rxSatBuff[index * 8], rx_size / 4)) { // Check if symbol error
					vRingbufferReturnItem(satLinkInfo->rb, (void*)items);
					rxSymbolErr = true;                             // The received data had ws28xx symbol errors
					while (items = (rmt_item32_t*)xRingbufferReceive(satLinkInfo->rb, &rx_size, 10))
						vRingbufferReturnItem(satLinkInfo->rb, (void*)items); // No reason to continue - empty ringbuffer items
					break;
				}
				vRingbufferReturnItem(satLinkInfo->rb, (void*)items); // No new sensor data, return the ringbuffer item
				//Serial.printf("Receivebuffer for Satellite %d : ", index);
				//for(uint8_t m = 0; m < 8; m++)
					//Serial.printf("%x:", satLinkInfo->rxSatBuff[index * 8 + m]);
				//Serial.printf("\n");
			}
			index++;
		}
		//titemstop = esp_timer_get_time()- titem;
		//Serial.printf("Took %d uS to retrieve items \n", titemstop);

		for (uint8_t i = 0; i < satLinkInfo->noOfSats; i++) {       // Check received data for all satellites
			bool senseChange;
			bool statusBad;
			bool rxCrcErr;
			bool remoteCrcErr;
			bool wdErr;

			//Serial.printf("i=%d\n", i);
			senseChange = populateSatWireStruct(&satLinkInfo->rxSatStruct[i], &satLinkInfo->rxSatBuff[i * 8]); // Populate the Satellite rx struct
			crc(&crcCalc, &satLinkInfo->rxSatBuff[i * 8], 8, i, false);  // Check iff correct incomming RX buffer CRC
			rxCrcErr = (crcCalc != satLinkInfo->rxSatStruct[i].crc);
			remoteCrcErr = (satLinkInfo->rxSatStruct[i].fbRemoteCrcErr == 0x01); // Check remote CRC indication
			//Serial.printf("Remote CRC Err from Sat %d: %s:\n", i, remoteCrcErr ? "ERR":"NOERR");
			wdErr = (satLinkInfo->rxSatStruct[i].fbWdErr == 0x01);  // Check Watchdog errors
			//Serial.printf("%s , %s\n", satLinkInfo->satStatus[i].remoteCrcErr ? "true" : "false", remoteCrcErr ? "true" : "false");
			//if (satLinkInfo->satStatus[i].remoteCrcErr != remoteCrcErr)
			//printf("Remote CRC error status changed for satellite %d, now %s\n", i, remoteCrcErr ? "true" : "false");
			statusBad = (rxDataSizeErr || rxSymbolErr || rxCrcErr || remoteCrcErr || wdErr);
			//Serial.printf("Satellite %d Sensors: %x\n", i, satLinkInfo->rxSatStruct[i].sensorVal);
			//Serial.printf("Satellite %d Status - rxCrcErr: %s, remoteCrcErr: %s, wdErr: %s \n", i, rxCrcErr ? "true" : "false", remoteCrcErr ? "true" : "false"  , wdErr ? "true" : "false");
			if (!statusBad) {                                        // If any errors - update performance counters
				if (!satLinkInfo->satStatus[i].dirty){
					satLinkInfo->satStatus[i].rxDataSizeErr = false;
					satLinkInfo->satStatus[i].rxSymbolErr = false;
					satLinkInfo->satStatus[i].rxCrcErr = false;
					satLinkInfo->satStatus[i].remoteCrcErr = false;
					satLinkInfo->satStatus[i].wdErr = false;
				}
			}
			else {
				//Serial.printf("Status is bad for %d\n", i);
				//xSemaphoreTake(satLinkInfo->performanceCounterLock, portMAX_DELAY);
				satLinkInfo->performanceCounters.rxDataSizeErr += rxDataSizeErr;
				satLinkInfo->performanceCounters.rxDataSizeErrSec += rxDataSizeErr;
				satLinkInfo->performanceCounters.rxSymbolErr += rxSymbolErr;
				satLinkInfo->performanceCounters.rxSymbolErrSec += rxSymbolErr;
				if (satLinkInfo->serverCrcTst[i] == SAT_CRC_TEST_INACTIVE) {
					satLinkInfo->performanceCounters.remoteCrcErr += remoteCrcErr;
					satLinkInfo->performanceCounters.remoteCrcErrSec += remoteCrcErr;
				}
				if (satLinkInfo->clientCrcTst[i] == SAT_CRC_TEST_INACTIVE) {
					//Serial.printf("Increasing rxCRCCnt for Sat %d\n", i);
					satLinkInfo->performanceCounters.rxCrcErr += rxCrcErr;
					satLinkInfo->performanceCounters.rxCrcErrSec += rxCrcErr;
				}
				if (satLinkInfo->wdTst[i] == SAT_WD_TEST_INACTIVE) {
					satLinkInfo->performanceCounters.wdErr += wdErr;
					satLinkInfo->performanceCounters.wdErrSec += wdErr;
				}
				//xSemaphoreGive(satLinkInfo->performanceCounterLock);

				//Serial.printf("Bad status:  dirty %i, rxDataSizeErr %i, rxSymbolErr %i, rxCrcErr %i, remoteCrcErr %i, wdErr %i\n", satLinkInfo->satStatus[i].dirty, rxDataSizeErr, rxSymbolErr, rxCrcErr, remoteCrcErr, wdErr);
				if (!satLinkInfo->satStatus[i].dirty) {               // If satStatus has been read by the receiver, clear all status data and fill in new
					satLinkInfo->satStatus[i].rxDataSizeErr = rxDataSizeErr;
					satLinkInfo->satStatus[i].rxSymbolErr = rxSymbolErr;
					satLinkInfo->satStatus[i].rxCrcErr = rxCrcErr;
					//Serial.printf("Dirty - Setting satLinkInfo->satStatus[i].remoteCrcErr for satellite %d to %s\n", i, remoteCrcErr ? "Fault":"No Fault");
					satLinkInfo->satStatus[i].remoteCrcErr = remoteCrcErr;
					satLinkInfo->satStatus[i].wdErr = wdErr;
				}
				else {                                                  // If satStatus has not been read by the receiver, latch old errors, and add new
					if (!satLinkInfo->satStatus[i].rxDataSizeErr)
						satLinkInfo->satStatus[i].rxDataSizeErr = rxDataSizeErr;
					if (!satLinkInfo->satStatus[i].rxSymbolErr)
						satLinkInfo->satStatus[i].rxSymbolErr = rxSymbolErr;
					if (!satLinkInfo->satStatus[i].rxCrcErr)
						satLinkInfo->satStatus[i].rxCrcErr = rxCrcErr;
					if (!satLinkInfo->satStatus[i].remoteCrcErr)
						satLinkInfo->satStatus[i].remoteCrcErr = remoteCrcErr;
					//Serial.printf("After 2 %s , %s\n", satLinkInfo->satStatus[i].remoteCrcErr ? "true" : "false", remoteCrcErr ? "true" : "false");
					if (!satLinkInfo->satStatus[i].wdErr)
						satLinkInfo->satStatus[i].wdErr = wdErr;
					//Serial.printf("Not Dirty - satLinkInfo->satStatus[i].remoteCrcErr for satellite %d to %s\n", i, satLinkInfo->satStatus[i].remoteCrcErr ? "true" : "false");
				}
				satLinkInfo->satStatus[i].dirty = true;
				if (satLinkInfo->satelliteHandle[i] != NULL)
					satLinkInfo->satelliteHandle[i]->statusUpdate(&satLinkInfo->satStatus[i]);
			}
			if (senseChange && (satLinkInfo->satelliteHandle[i] != NULL) && !satLinkInfo->opState && !rxDataSizeErr && !rxSymbolErr && !rxCrcErr)
				satLinkInfo->satelliteHandle[i]->senseUpdate(&satLinkInfo->rxSatStruct[i]);
			//Serial.printf("After 3 %s , %s\n", satLinkInfo->satStatus[i].remoteCrcErr ? "true" : "false", remoteCrcErr ? "true" : "false");

			rxDataSizeErr = false;
			rxSymbolErr = false;
			remoteCrcErr = false;
			rxCrcErr = false;
			remoteCrcErr = false;
			wdErr = false;
		}
		((satelliteLink*)satLinkObj)->chkErrSec();                       // Check if errored second
		if ((nextTime = satLinkInfo->scanInterval - ((esp_timer_get_time() - t0) / 1000)) <= 0) { // Scan timing violation, update performance counters and immediatly start a new scan
			//Serial.printf("Overrun next time %d ms\n", nextTime);
			//Serial.printf("Scan ended-1 took %d us\n", esp_timer_get_time() - t0);
			xSemaphoreTake(satLinkInfo->performanceCounterLock, portMAX_DELAY);
			satLinkInfo->performanceCounters.scanTimingViolationErr++;
			satLinkInfo->performanceCounters.scanTimingViolationErrSec++;
			xSemaphoreGive(satLinkInfo->performanceCounterLock);
		}
		else {                                                           // Start timer for next scan
			//Serial.printf("Scan ended-2 time %d us\n", esp_timer_get_time());
			//Serial.printf("Delaying next scan %d ms, now:%llu \n", nextTime, esp_timer_get_time());
			vTaskDelay(nextTime / (portTICK_PERIOD_MS));
		}
	}
	vTaskDelete(NULL);
}

/*satelliteLink opBlock*/
void satelliteLink::opBlock(satOpState_t opState_p) {
	//Serial.printf("Satellitelink OP blocked received 0x%x\n", opState_p);
	if (!satLinkInfo->opState)                                          // If there was no earliar Opstate block, controlblock all satellites abot the block
		for (uint8_t i = 0; i < satLinkInfo->noOfSats; i++)
			if (satLinkInfo->satelliteHandle[i] != NULL)
				satLinkInfo->satelliteHandle[i]->opBlock(SAT_OP_CONTROLBOCK);
	satLinkInfo->opState = satLinkInfo->opState | opState_p;            // Set new Opstate
	if (satLinkInfo->satLinkStateCb != NULL)                            // call-back informing about new Opstate
		satLinkInfo->satLinkStateCb(this, satLinkInfo->address, satLinkInfo->opState, satLinkInfo->satLinkStateCbMetadata);

	if (opState_p & SAT_OP_FAIL || opState_p & SAT_OP_ERR_SEC) {         // Start timer for link re-establishment
		assert(xTimerStart(satLinkInfo->linkReEstablishTimerHandle, 10) != pdFAIL);
		//Serial.printf("Starting Re-establish timer\n");
	}
}

/*satelliteLink opDeBlock*/
void satelliteLink::opDeBlock(satOpState_t opState_p) {
	//Serial.printf("Satellitelink OP deblocked received :0x%x\n", opState_p);
	satLinkInfo->opState = satLinkInfo->opState & ~opState_p;
	if (!satLinkInfo->opState) {   //If no more opBleck, control deblock all satellites and clear performance counters
		xSemaphoreTake(satLinkInfo->performanceCounterLock, portMAX_DELAY);
		clearPerformanceCounters(&satLinkInfo->performanceCounters);
		xSemaphoreGive(satLinkInfo->performanceCounterLock);
		for (uint8_t i = 0; i < satLinkInfo->noOfSats; i++)
			if (satLinkInfo->satelliteHandle[i] != NULL)
				satLinkInfo->satelliteHandle[i]->opDeBlock(SAT_OP_CONTROLBOCK);
	}
	if (satLinkInfo->satLinkStateCb != NULL)                            // Call-back to inform about the new Opstate
		satLinkInfo->satLinkStateCb(this, satLinkInfo->address, satLinkInfo->opState, satLinkInfo->satLinkStateCbMetadata);
}

/*satelliteLink getOpState*/
satOpState_t satelliteLink::getOpState(void) {
	return satLinkInfo->opState;
}

/*satelliteLink admBlock*/
satErr_t satelliteLink::admBlock(void) {
	if (satLinkInfo->admState == SAT_ADM_DISABLE) {                       // Check if already Adm blocked
		//Serial.printf("admBlock Wrong state, current state is: %i\n", satLinkInfo->admState);
		return (returnCode(SAT_ERR_WRONG_STATE_ERR, 0));
	}
	for (uint8_t i = 0; i < satLinkInfo->noOfSats; i++) {               // CHeck that all satellites are Adm blocked
		//Serial.printf("Checking if satellite %i is disabled \n", i);
		if (satLinkInfo->satelliteHandle[i]->getAdmState() != SAT_ADM_DISABLE)
			return (returnCode(SAT_ERR_DEP_BLOCK_STATUS_ERR, 0));
	}
	satLinkInfo->admState = SAT_ADM_DISABLE;                            // Set Link to ADM DISABLE
	opBlock(SAT_OP_DISABLE);                                            // OP Block OP_DISABLE
	opDeBlock(SAT_OP_ERR_SEC);
	opDeBlock(SAT_OP_FAIL);
	return (returnCode(SAT_OK, 0));
}

/*satelliteLink admDeBlock*/
satErr_t satelliteLink::admDeBlock(void) {
	if (satLinkInfo->admState == SAT_ADM_ENABLE) {
		//Serial.printf("admDeBlock Wrong state, current state is: %i\n", satLinkInfo->admState);
		return (returnCode(SAT_ERR_DEP_BLOCK_STATUS_ERR, 0));
	}
	satLinkInfo->admState = SAT_ADM_ENABLE;
	opDeBlock(SAT_OP_DISABLE);
	opDeBlock(SAT_OP_ERR_SEC);
	opDeBlock(SAT_OP_FAIL);
	return (returnCode(SAT_OK, 0));
}

/*satelliteLink getAdmState*/
satAdmState_t satelliteLink::getAdmState(void) {
	return satLinkInfo->admState;
}

/*satelliteLink chkErrSec*/
void satelliteLink::chkErrSec(void) {
	uint16_t ErrSum;
	int64_t now;
	if (!satLinkInfo->errThresHigh)
		return;
	ErrSum = satLinkInfo->performanceCounters.rxDataSizeErrSec +
		satLinkInfo->performanceCounters.rxSymbolErrSec +
		satLinkInfo->performanceCounters.rxCrcErrSec +
		satLinkInfo->performanceCounters.remoteCrcErrSec +
		satLinkInfo->performanceCounters.scanTimingViolationErrSec +
		satLinkInfo->performanceCounters.wdErrSec;
	if (!(satLinkInfo->opState & SAT_OP_ERR_SEC) && ErrSum >= satLinkInfo->errThresHigh)
		opBlock(SAT_OP_ERR_SEC);
	if ((now = esp_timer_get_time()) - satLinkInfo->oneSecTimer >= ONE_SEC_US) {
		//Serial.printf("One Second passed, total errors: tot %d, %d, %d, %d, %d, %d, %d\n", 
		//               ErrSum, satLinkInfo->performanceCounters.rxDataSizeErrSec, satLinkInfo->performanceCounters.rxSymbolErrSec, satLinkInfo->performanceCounters.rxCrcErrSec,
		//               satLinkInfo->performanceCounters.remoteCrcErrSec, satLinkInfo->performanceCounters.scanTimingViolationErrSec, satLinkInfo->performanceCounters.wdErrSec);
		satLinkInfo->oneSecTimer = now;
		if ((satLinkInfo->opState & SAT_OP_ERR_SEC) && (ErrSum <= satLinkInfo->errThresLow))
			opDeBlock(SAT_OP_ERR_SEC);
		satLinkInfo->performanceCounters.rxDataSizeErrSec = 0;
		satLinkInfo->performanceCounters.rxSymbolErrSec = 0;
		satLinkInfo->performanceCounters.rxCrcErrSec = 0;
		satLinkInfo->performanceCounters.remoteCrcErrSec = 0;
		satLinkInfo->performanceCounters.scanTimingViolationErrSec = 0;
		satLinkInfo->performanceCounters.wdErrSec = 0;
	}
}

/*satelliteLink linkReEstablish*/
void satelliteLink::linkReEstablish(TimerHandle_t timerHandle) {
	satelliteLink* satelliteLinkObj = (satelliteLink*)pvTimerGetTimerID(timerHandle);
	//Serial.printf("Got ReEstablishTimer, opState is: %x\n", satelliteLinkObj->satLinkInfo->opState);
	//Serial.printf("%x, %x\n", satelliteLinkObj->satLinkInfo->opState & SAT_OP_FAIL, satelliteLinkObj->satLinkInfo->opState & SAT_OP_ERR_SEC);

	if ((satelliteLinkObj->satLinkInfo->opState & SAT_OP_FAIL) != 0x00 || (satelliteLinkObj->satLinkInfo->opState & SAT_OP_ERR_SEC) != 0x00) {
		//Serial.printf("Restarting discovery\n");
		satelliteLinkObj->satLinkDiscover();
	}
}
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

/***** PUBLIC MEMBERS *****/

/*satellite satellite*/
satellite::satellite(satelliteLink* satLink_p, uint8_t satAddr_p) {
	//Serial.printf("Creating Satellite %d\n", satAddr_p);
	satInfo = new satInfo_t;                                            // Creat the satellite data structure
	satInfo->performanceCounterLock = xSemaphoreCreateMutex();          // Lock needed for performance data (Read-Modify-Write)
	satInfo->address = satAddr_p;                                       // Initiat the data structure with initial and default values
	satInfo->satLinkParent = satLink_p;
	for (uint8_t i = 0; i < 4; i++) {
		satInfo->actMode[i] = SATMODE_LOW;
		satInfo->actVal[i] = 0;
	}
	for (uint8_t i = 0; i < 8; i++) {
		satInfo->sensors[i].satObj = this;
		satInfo->sensors[i].address = i;
		satInfo->sensors[i].filterTime = 1;                             // Create filter timers for the sensors
		satInfo->sensors[i].timerHandle = xTimerCreate("SenseTimer", pdMS_TO_TICKS(satInfo->sensors[i].filterTime), pdFALSE, (void*)&(this->satInfo->sensors[i]), &filterExp);
		satInfo->sensors[i].timerActive = false;
		satInfo->sensors[i].currentSensorVal = false;
		satInfo->sensors[i].filteredSensorVal = false;
	}                                                                   // Create timers for ErrSec evaluation and selftest
	satInfo->oneSecTimerHandle = xTimerCreate("oneSecTimer", pdMS_TO_TICKS(1000), pdTRUE, this, &chkErrSec);
	satInfo->selfTestTimerHandle = xTimerCreate("selftestTimer", pdMS_TO_TICKS(satInfo->satLinkParent->satLinkInfo->scanInterval * 50), pdFALSE, this, &selfTestTimeout);
	satInfo->stateCb = NULL;
	satInfo->stateCbMetadata = NULL;
	satInfo->senseCb = NULL;
	satInfo->senseCbMetadata = NULL;
	clearPerformanceCounters(&satInfo->performanceCounters);
	satInfo->performanceCounters.testRemoteCrcErr = 0;
	satInfo->performanceCounters.testRxCrcErr = 0;
	satInfo->performanceCounters.testWdErr = 0;
	satInfo->serverCrcTest = SAT_CRC_TEST_INACTIVE;
	satInfo->clientCrcTest = SAT_CRC_TEST_INACTIVE;
	satInfo->wdTest = SAT_WD_TEST_INACTIVE;
	satInfo->selftestPhase = NO_TEST;
	satInfo->selfTestCb = NULL;
	satInfo->errThresHigh = 10;
	satInfo->errThresLow = 1;
	satInfo->admState = SAT_ADM_DISABLE;
	satInfo->opState = SAT_OP_DISABLE;
	satInfo->selfTestCb = NULL;
}

/*satellite ~satellite*/
satellite::~satellite(void) {
	for (uint8_t i = 0; i < 8; i++)
		xTimerDelete(satInfo->sensors[i].timerHandle, 10);
	xTimerDelete(satInfo->oneSecTimerHandle, 10);
	xTimerDelete(satInfo->selfTestTimerHandle, 10);
	vSemaphoreDelete(satInfo->performanceCounterLock);
	//delete satellite objects
	delete satInfo;
}

/*satellite enableSat*/
satErr_t satellite::enableSat(void) {
	return(returnCode(admDeBlock(), 0));
}

/*satellite disableSat*/
satErr_t satellite::disableSat(void) {
	return(returnCode(admBlock(), 0));
}

/*satellite setErrTresh*/
void satellite::setErrTresh(uint16_t errThresHigh_p, uint16_t errThresLow_p) {
	satInfo->errThresHigh = errThresHigh_p;
	satInfo->errThresLow = errThresLow_p;
}

/*satellite setSatActMode*/
satErr_t satellite::setSatActMode(actMode_t actMode_p, uint8_t actIndex_p) {
	if (actIndex_p > 3 || actMode_p > 5)
		return(returnCode(SAT_ERR_PARAM_ERR, 0));
	satInfo->actMode[actIndex_p] = actMode_p;                           // Inform the satellite link about the new act mode through shared mem
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].actMode[actIndex_p] = actMode_p;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	return(returnCode(SAT_OK, 0));
}

/*satellite setSatActVal*/
satErr_t satellite::setSatActVal(uint8_t actVal_p, uint8_t actIndex_p) {
	//Serial.printf("Seting actuator %i value to %i\n", actIndex_p, actVal_p);
	if (actIndex_p > (NO_OF_ACT - 1)){
		//Serial.printf("satellite::setSatActVal: Satellite port %i out of bounds\n", actIndex_p);
		return(returnCode(SAT_ERR_PARAM_ERR, 0));
	}
	xSemaphoreTake(satInfo->satLinkParent->satLinkInfo->actUpdateLock, portMAX_DELAY);
	satInfo->actVal[actIndex_p] = actVal_p;                             // Inform the satellite link about the new act value through shared mem
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].actVal[actIndex_p] = actVal_p;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	xSemaphoreGive(satInfo->satLinkParent->satLinkInfo->actUpdateLock);
	return(returnCode(SAT_OK, 0));
}

/*satellite setSenseFilter*/
satErr_t satellite::setSenseFilter(uint16_t senseFilter_p, uint8_t senseIndex_p) {
	if (senseIndex_p > 7 || senseFilter_p == 0)                                                                                   // 0 ms filter is not allowed
		return(returnCode(SAT_ERR_PARAM_ERR, 0));
	satInfo->sensors[senseIndex_p].filterTime = senseFilter_p;
	assert(xTimerChangePeriod(satInfo->sensors[senseIndex_p].timerHandle, pdMS_TO_TICKS(satInfo->sensors[senseIndex_p].filterTime), 10) != pdFAIL);
	assert(xTimerStop(satInfo->sensors[senseIndex_p].timerHandle, 10) != pdFAIL); //Changing timer perid starts the timer, we need to stop it
	return(returnCode(SAT_OK, 0));
}

/*satellite satRegSenseCb*/
void satellite::satRegSenseCb(satSenseCb_t fn, void* metaData_p) {
	satInfo->senseCb = fn;
	satInfo->senseCbMetadata = metaData_p;
	for (uint8_t i = 0; i < 8; i++) {
		satInfo->senseCb(this, satInfo->satLinkParent->getAddress(), satInfo->address, satInfo->sensors[i].address, satInfo->sensors[i].filteredSensorVal, satInfo->senseCbMetadata);
	}
}

/*satellite satUnRegSenseCb*/
void satellite::satUnRegSenseCb(void) {
	satInfo->senseCb = NULL;
	satInfo->senseCbMetadata = NULL;
}

/*satellite satSelfTest*/
satErr_t satellite::satSelfTest(selfTestCb_t selfTestCb_p) {
	//Serial.printf("Entering Selftest for satellite: %d\n", satInfo->address);
	if (satInfo->opState) {
		//Serial.printf("Self-test, satellite %d in wrong state\n", satInfo->address);
		return(returnCode(SAT_ERR_WRONG_STATE_ERR, 0));
	}
	//Serial.printf("Satellite test state: %d, Link satellite test state: %d\n", satInfo->selftestPhase, satInfo->satLinkParent->satLinkInfo->satSelfTest);
	if (satInfo->selftestPhase != NO_TEST || satInfo->satLinkParent->satLinkInfo->satSelfTest != NO_TEST) {
		//Serial.printf("Self-test, satellite %d self test busy\n", satInfo->address);
		return(returnCode(SAT_ERR_BUSY_ERR, 0));
	}
	//Serial.printf("Self-test, satellite %d self test NOT busy - starting\n", satInfo->address);
	satInfo->selfTestCb = selfTestCb_p;
	genServerCrcErr();                              // This will initiate the sequence of all self tests
	return SAT_OK;
}

/*satellite getSenseVal*/
bool satellite::getSenseVal(uint8_t senseAddr) {
	return satInfo->sensors[senseAddr].filteredSensorVal;
}

/*satellite satRegStateCb*/
void satellite::satRegStateCb(satStateCb_t fn, void* p_metadata) {
	satInfo->stateCb = fn;
	satInfo->stateCbMetadata = p_metadata;
	satInfo->stateCb(this, satInfo->satLinkParent->getAddress(), satInfo->address, satInfo->opState, satInfo->stateCbMetadata);
}

/*satellite satUnRegStateCb*/
void satellite::satUnRegStateCb(void) {
	satInfo->stateCb = NULL;
}

/*satellite getAddress*/
uint8_t satellite::getAddress(void) {
	return satInfo->address;
}

/*satellite senseUpdate*/
void satellite::senseUpdate(satWire_t* rxData_p) {
	//Serial.printf("Got a sensor update: 0x%x\n", rxData_p->sensorVal);
	for (uint8_t i = 0; i < 8; i++) {
		satInfo->sensors[i].currentSensorVal = (rxData_p->sensorVal & 0b00000001 << i) > 0;
		if (satInfo->sensors[i].currentSensorVal != satInfo->sensors[i].filteredSensorVal) {
			//Serial.printf("Sensor %d changed value to %s\n", i, satInfo->sensors[i].currentSensorVal ? "Active" : "Inactive");
			assert(xTimerStart(satInfo->sensors[i].timerHandle, 10) != pdFAIL);
			//Serial.printf("Started the filter timer for sensor %d\n", i);
			satInfo->sensors[i].timerActive = true;
		}
		else {
			if (satInfo->sensors[i].timerActive) {
				assert(xTimerStop(satInfo->sensors[i].timerHandle, 10) != pdFAIL);
				satInfo->sensors[i].timerActive = false;
				//Serial.printf("Stoped an ongoing filter timer for sensor %d\n", i);
			}
		}
	}
}

/*satellite statusUpdate*/
void satellite::statusUpdate(satStatus_t* status_p) {                    // New status received from the link through shared mem
	if (status_p->dirty != true)                                        // No new status after all
		return;
	//Serial.printf("Got a Satellite status update with remoteCrc: %s, rxCrc %s, wdErr %s, serverCrcTest %d, clientCrcTest %d, wdTest %d\n", status_p->remoteCrcErr ? "true" : "false", status_p->rxCrcErr ? "true" : "false", status_p->wdErr ? "true" : "false", satInfo->serverCrcTest, satInfo->clientCrcTest,  satInfo->wdTest);
	xSemaphoreTake(satInfo->performanceCounterLock, portMAX_DELAY);     // Update performance counters according to new status
	if (status_p->remoteCrcErr && (satInfo->serverCrcTest == SAT_CRC_TEST_INACTIVE)) {
		satInfo->performanceCounters.remoteCrcErr++;
		satInfo->performanceCounters.remoteCrcErrSec++;
	}
	else if (status_p->remoteCrcErr && satInfo->serverCrcTest == SAT_CRC_TEST_ACTIVE) {
		//Serial.printf("Counting remoteCrc test counters\n");
		satInfo->performanceCounters.testRemoteCrcErr++;
		satInfo->serverCrcTest = SAT_CRC_TEST_DEACTIVATING;
		//Serial.printf("Satellite selftest is disabling Server CRC invert\n");
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].invServerCrc = false;
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	}
	else if (status_p->remoteCrcErr) {
		satInfo->serverCrcTest--;
		satInfo->performanceCounters.testRemoteCrcErr++;
	}
	if (status_p->rxCrcErr && satInfo->clientCrcTest == SAT_CRC_TEST_INACTIVE) {
		//Serial.printf("Counting rxCrc counters: now %d\n", satInfo->performanceCounters.rxCrcErr);
		satInfo->performanceCounters.rxCrcErr++;
		satInfo->performanceCounters.rxCrcErrSec++;
	}
	else if (status_p->rxCrcErr && satInfo->clientCrcTest == SAT_CRC_TEST_ACTIVE) {
		//Serial.printf("Counting rxCrc test counters\n");
		satInfo->performanceCounters.testRxCrcErr++;
		satInfo->clientCrcTest = SAT_CRC_TEST_DEACTIVATING;
		//Serial.printf("Satellite UPDATE - Satellite selftest is disabling Client CRC invert for Sat%d\n", satInfo->address);
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].invClientCrc = false;
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	}
	else if (status_p->rxCrcErr) {
		//Serial.printf("Draining - Counting rxCrc test counters\n");
		satInfo->clientCrcTest--;
		satInfo->performanceCounters.testRxCrcErr++;
	}
	if (status_p->wdErr && satInfo->wdTest == SAT_WD_TEST_INACTIVE) {
		satInfo->performanceCounters.wdErr++;
		satInfo->performanceCounters.wdErrSec++;
	}
	else if (status_p->wdErr && satInfo->wdTest == SAT_WD_TEST_ACTIVE) {
		//Serial.printf("Counting wdErr test counters\n");
		satInfo->performanceCounters.testWdErr++;
		satInfo->wdTest = SAT_WD_TEST_DEACTIVATING;
		//Serial.printf("Satellite selftest is disabling WD test\n");
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].setWdErr = false;
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	}
	else if (status_p->wdErr) {
		satInfo->wdTest--;
		satInfo->performanceCounters.testWdErr++;
	}
	if (status_p->rxSymbolErr) {
		satInfo->performanceCounters.rxSymbolErr++;
		satInfo->performanceCounters.rxSymbolErrSec++;
	}
	if (status_p->rxDataSizeErr) {
		satInfo->performanceCounters.rxDataSizeErr++;
		satInfo->performanceCounters.rxDataSizeErrSec++;
	}
	xSemaphoreGive(satInfo->performanceCounterLock);
	status_p->dirty = false;
}

/*satellite admBlock*/
satErr_t satellite::admBlock(void) {
	if (satInfo->admState == SAT_ADM_DISABLE) {
		//Serial.printf("admBlock Wrong state, current state is: %i\n", satInfo->admState);
		return (returnCode(SAT_ERR_WRONG_STATE_ERR, 0));
	}
	assert(xTimerStop(satInfo->oneSecTimerHandle, 10) != pdFAIL);       // Stop the errSec supervision
	satInfo->admState = SAT_ADM_DISABLE;
	opBlock(SAT_OP_DISABLE);                                            // OpBlock
	opDeBlock(SAT_OP_ERR_SEC);
	opDeBlock(SAT_OP_FAIL);
	//Serial.printf("admBlock OK\n");
	return (returnCode(SAT_OK, 0));
}

/*satellite admDeBlock*/
satErr_t satellite::admDeBlock(void) {
	uint8_t tmpSensorVal;
	if (satInfo->admState == SAT_ADM_ENABLE) {
		//Serial.printf("admDeBlock Wrong state, current state is: %i\n", satInfo->admState);
		return (returnCode(SAT_ERR_WRONG_STATE_ERR, 0));
	}
	if (satInfo->satLinkParent->getAdmState() != SAT_ADM_ENABLE) {        // Check that the parent link is Adm deblocked
		//Serial.printf("admDeBlock Parent in wrong state\n");
		return (returnCode(SAT_ERR_DEP_BLOCK_STATUS_ERR, 0));
	}
	assert(xTimerStart(satInfo->oneSecTimerHandle, 10) != pdFAIL);      // Start the errSec supervision
	satInfo->satLinkParent->getSensorValRaw(satInfo->address, &tmpSensorVal);
	for (uint8_t i = 0; i < 8; i++) {
		satInfo->sensors[i].currentSensorVal = (tmpSensorVal & 0b00000001 << i) > 0;
		satInfo->sensors[i].filteredSensorVal = satInfo->sensors[i].currentSensorVal;
		if (satInfo->senseCb != NULL)                                       // Call-back with current filtered sensor values
			satInfo->senseCb(this, satInfo->satLinkParent->getAddress(), satInfo->address, satInfo->sensors[i].address, satInfo->sensors[i].filteredSensorVal, satInfo->senseCbMetadata);
	}
	opDeBlock(SAT_OP_DISABLE);                                            // Opdeblock
	opDeBlock(SAT_OP_ERR_SEC);
	opDeBlock(SAT_OP_FAIL);
	satInfo->admState = SAT_ADM_ENABLE;
	return (returnCode(SAT_OK, 0));
}

/*satellite getAdmState*/
satAdmState_t satellite::getAdmState(void) {
	return satInfo->admState;
}

/*satellite opBlock*/
void satellite::opBlock(satOpState_t opState_p) {
	//Serial.printf("Satellite OP blocked received for satellite %d, requesting OpState: 0x%x, previous OpState: 0x%x\n", satInfo->address, opState_p, satInfo->opState);
	satInfo->opState = satInfo->opState | opState_p;
	if ((satInfo->opState & SAT_OP_INIT) || (satInfo->opState & SAT_OP_DISABLE) || (satInfo->opState & SAT_OP_CONTROLBOCK)) {
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].enable = false; // Disable the satellite
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	}
	if (satInfo->stateCb != NULL) {                                       // Call-back with the new Opstate
		satInfo->stateCb(this, satInfo->satLinkParent->getAddress(), satInfo->address, satInfo->opState, satInfo->stateCbMetadata);
	}
}

/*satellite opDeBlock*/
void satellite::opDeBlock(satOpState_t opState_p) {
	//Serial.printf("Satellite OP deblocked received - resetting :0x%x\n", opState_p);
	satInfo->opState = satInfo->opState & ~opState_p;
	if (!(satInfo->opState & ~SAT_OP_ERR_SEC & ~SAT_OP_FAIL)) {
		while (satSelfTest(&selftestRes) == SAT_ERR_BUSY_ERR) 
			vTaskDelay(10 / portTICK_PERIOD_MS);
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].enable = true; // Enable the satellite
		for (uint8_t i = 0; i < NO_OF_ACT; i++)                              // Set actuator mode
			satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].actMode[i] = satInfo->actMode[i];
		satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	}
	xSemaphoreTake(satInfo->performanceCounterLock, portMAX_DELAY);
	clearPerformanceCounters(&satInfo->performanceCounters);            // Clear the performance counters
	xSemaphoreGive(satInfo->performanceCounterLock);
	//Serial.printf("Cleared all perf counters %u\n", satInfo->performanceCounters.rxCrcErr);
	if (satInfo->stateCb != NULL) {                                       // Call-back with the new Opstate
		satInfo->stateCb(this, satInfo->satLinkParent->getAddress(), satInfo->address, satInfo->opState, satInfo->stateCbMetadata);
	}
}

/*satellite getOpState*/
satOpState_t satellite::getOpState(void) {
	return satInfo->opState;
}

/*satellite getSatStats*/
void satellite::getSatStats(satPerformanceCounters_t* satStats_p, bool resetStats) {
	xSemaphoreTake(satInfo->performanceCounterLock, portMAX_DELAY);
	memcpy((void*)satStats_p, (void*)&(satInfo->performanceCounters), sizeof(satPerformanceCounters_t));
	if (resetStats)
		clearPerformanceCounters(&satInfo->performanceCounters);
	xSemaphoreGive(satInfo->performanceCounterLock);
}

/*satellite clearSatStats*/
void satellite::clearSatStats(void) {
	xSemaphoreTake(satInfo->performanceCounterLock, portMAX_DELAY);
	clearPerformanceCounters(&satInfo->performanceCounters);
	xSemaphoreGive(satInfo->performanceCounterLock);
}

/***** PRIVATE MEMBERS *****/

/*satellite chkErrSec*/
void satellite::chkErrSec(TimerHandle_t timerHandle) {
	uint16_t ErrSum;
	satellite* satObj;

	satObj = (satellite*)pvTimerGetTimerID(timerHandle);
	//Serial.printf("CRC Check %u\n", satObj->satInfo->performanceCounters.rxCrcErr);
	if (!satObj->satInfo->errThresHigh)
		return;
	//Serial.printf("Check Satellite errored second\n");
	xSemaphoreTake(satObj->satInfo->performanceCounterLock, portMAX_DELAY);
	ErrSum = satObj->satInfo->performanceCounters.rxCrcErrSec +
		satObj->satInfo->performanceCounters.remoteCrcErrSec +
		satObj->satInfo->performanceCounters.wdErrSec;
	satObj->satInfo->performanceCounters.rxDataSizeErrSec = 0;
	satObj->satInfo->performanceCounters.rxSymbolErrSec = 0;
	satObj->satInfo->performanceCounters.rxCrcErrSec = 0;
	satObj->satInfo->performanceCounters.remoteCrcErrSec = 0;
	satObj->satInfo->performanceCounters.wdErrSec = 0;
	xSemaphoreGive(satObj->satInfo->performanceCounterLock);
	if (!(satObj->satInfo->opState & SAT_OP_ERR_SEC) && ErrSum >= satObj->satInfo->errThresHigh)
		satObj->opBlock(SAT_OP_ERR_SEC);
	if ((satObj->satInfo->opState & SAT_OP_ERR_SEC) && ErrSum <= satObj->satInfo->errThresLow)
		satObj->opDeBlock(SAT_OP_ERR_SEC);
}

/*satellite filterExp*/
void satellite::filterExp(TimerHandle_t timerHandle) {
	sensor_t* sensor;
	sensor = (sensor_t*)pvTimerGetTimerID(timerHandle);
	sensor->timerActive = false;
	//Serial.printf("Filter timer expired for sensor %d\n", sensor->address);
	if (sensor->currentSensorVal != sensor->filteredSensorVal) {
		sensor->filteredSensorVal = sensor->currentSensorVal;
		if (sensor->satObj->satInfo->senseCb)
			sensor->satObj->satInfo->senseCb(sensor->satObj, sensor->satObj->satInfo->satLinkParent->getAddress(), sensor->satObj->getAddress(), sensor->address, sensor->filteredSensorVal, sensor->satObj->satInfo->senseCbMetadata);
		//else
			//Serial.printf("satellite::filterExp: No callback registered\n");
	}
}

/*satellite genServerCrcErr*/
void satellite::genServerCrcErr(void) {
	//Serial.printf("Generating Server CRC Error for satellite: %d\n", satInfo->address);
	xSemaphoreTake(satInfo->satLinkParent->satLinkInfo->actUpdateLock, portMAX_DELAY);
	satInfo->performanceCounters.testRemoteCrcErr = 0;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].invServerCrc = true;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	satInfo->serverCrcTest = SAT_CRC_TEST_ACTIVE;
	satInfo->selftestPhase = SERVER_CRC_TEST;
	satInfo->satLinkParent->satLinkInfo->satSelfTest = SERVER_CRC_TEST;
	xSemaphoreGive(satInfo->satLinkParent->satLinkInfo->actUpdateLock);
	assert(xTimerStart(satInfo->selfTestTimerHandle, 10) != pdFAIL);
}

/*satellite genClientCrcErr*/
void satellite::genClientCrcErr(void) {
	//Serial.printf("Generating Client CRC Error for satellite: %d\n", satInfo->address);
	xSemaphoreTake(satInfo->satLinkParent->satLinkInfo->actUpdateLock, portMAX_DELAY);
	satInfo->performanceCounters.testRxCrcErr = 0;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].invClientCrc = true;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	satInfo->clientCrcTest = SAT_CRC_TEST_ACTIVE;
	satInfo->selftestPhase = CLIENT_CRC_TEST;
	satInfo->satLinkParent->satLinkInfo->satSelfTest = CLIENT_CRC_TEST;
	xSemaphoreGive(satInfo->satLinkParent->satLinkInfo->actUpdateLock);
	assert(xTimerStart(satInfo->selfTestTimerHandle, 10) != pdFAIL);
}

/*satellite genWdErr*/
void satellite::genWdErr(void) {
	//Serial.printf("Generating WD Errorfor satellite: %d\n", satInfo->address);
	xSemaphoreTake(satInfo->satLinkParent->satLinkInfo->actUpdateLock, portMAX_DELAY);
	satInfo->performanceCounters.testWdErr = 0;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].setWdErr = true;
	satInfo->satLinkParent->satLinkInfo->txSatStruct[satInfo->address].dirty = true;
	satInfo->wdTest = SAT_WD_TEST_ACTIVE;
	satInfo->selftestPhase = WD_TEST;
	satInfo->satLinkParent->satLinkInfo->satSelfTest = WD_TEST;
	xSemaphoreGive(satInfo->satLinkParent->satLinkInfo->actUpdateLock);
	assert(xTimerStart(satInfo->selfTestTimerHandle, 10) != pdFAIL);
}

/*satellite selfTestTimeout*/
void satellite::selfTestTimeout(TimerHandle_t timerHandle) {
	satellite* satObj = (satellite*)pvTimerGetTimerID(timerHandle);

	switch (satObj->satInfo->selftestPhase) {
	case SERVER_CRC_TEST:
		if (!satObj->satInfo->performanceCounters.testRemoteCrcErr) {
			//Serial.printf("Selftest expected remote CRC errors but got none for satellite: %d\n", satObj->satInfo->address);
			satObj->satInfo->selfTestCb(satObj, satObj->satInfo->satLinkParent->satLinkInfo->address, satObj->satInfo->address, SAT_SELFTEST_SERVER_CRC_ERR);
			satObj->satInfo->serverCrcTest = SAT_CRC_TEST_INACTIVE;
			satObj->satInfo->selftestPhase = NO_TEST;
			satObj->satInfo->satLinkParent->satLinkInfo->satSelfTest = NO_TEST;
		}
		else {
			//Serial.printf("Selftest got %d remote CRC errors for satellite: %d\n", satObj->satInfo->performanceCounters.testRemoteCrcErr, satObj->satInfo->address);
			satObj->satInfo->serverCrcTest = SAT_CRC_TEST_INACTIVE;
			satObj->genClientCrcErr();
		}
		break;

	case CLIENT_CRC_TEST:
		if (!satObj->satInfo->performanceCounters.testRxCrcErr) {
			//Serial.printf("Selftest expected RX CRC errors but got none for satellite: %d\n", satObj->satInfo->address);
			satObj->satInfo->selfTestCb(satObj, satObj->satInfo->satLinkParent->satLinkInfo->address, satObj->satInfo->address, SAT_SELFTEST_CLIENT_CRC_ERR);
			satObj->satInfo->clientCrcTest = SAT_CRC_TEST_INACTIVE;
			satObj->satInfo->selftestPhase = NO_TEST;
			satObj->satInfo->satLinkParent->satLinkInfo->satSelfTest = NO_TEST;
		}
		else {
			//Serial.printf("Selftest got %d rx CRC errors for satellite: %d\n", satObj->satInfo->performanceCounters.testRxCrcErr, satObj->satInfo->address);
			satObj->satInfo->clientCrcTest = SAT_CRC_TEST_INACTIVE;
			satObj->genWdErr();
		}
		break;

	case WD_TEST:
		if (!satObj->satInfo->performanceCounters.testWdErr) {
			//Serial.printf("Selftest expected WD errors but got none for satellite: %d\n", satObj->satInfo->address);
			satObj->satInfo->selfTestCb(satObj, satObj->satInfo->satLinkParent->satLinkInfo->address, satObj->satInfo->address, SAT_SELFTEST_WD_ERR);
			satObj->satInfo->wdTest = SAT_WD_TEST_INACTIVE;
			satObj->satInfo->selftestPhase = NO_TEST;
			satObj->satInfo->satLinkParent->satLinkInfo->satSelfTest = NO_TEST;
		}
		else {
			//Serial.printf("Selftest ENDED!!! got %d wd errors for satellite: %d\n", satObj->satInfo->performanceCounters.testWdErr, satObj->satInfo->address);
			satObj->satInfo->selfTestCb(satObj, satObj->satInfo->satLinkParent->satLinkInfo->address, satObj->satInfo->address, SAT_OK);
			satObj->satInfo->wdTest = SAT_WD_TEST_INACTIVE;
			satObj->satInfo->selftestPhase = NO_TEST;
			satObj->satInfo->satLinkParent->satLinkInfo->satSelfTest = NO_TEST;
		}
		break;

	default:
		assert(true == false);
		break;
	}
}

/*satellite selftestRes*/
void satellite::selftestRes(satellite* satHandle_p, uint8_t satLinkAddr_p, uint8_t satAddr_p, satErr_t err_p) {
	if (err_p)
		satHandle_p->opBlock(SAT_OP_FAIL);
	//Serial.printf("Selftest executed\n");
	return;
}
/*======================================================= END Class satellite ===================================================================*/

/*============================================= END Function and Class implementation ==========================================================*/
