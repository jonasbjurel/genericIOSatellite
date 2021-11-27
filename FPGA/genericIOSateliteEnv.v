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

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
/* Module: genericIOSateliteEnv																													*/
/* Purpose: This is genericIOSatelite(Satellite) part of the genericJMRI project - see README-md for detaild information						*/
/*----------------------------------------------------------------------------------------------------------------------------------------------*/

//Edit these Params to change master frequency or pulselengths, or other timing parameters:
`define	OSCH_FREQ				"66.50"
`define MASTER_CLK_CYC_PER_MS	66500			// `OSCH_FREQ*1000
`define K1_25_PWM_CYC			53200			// `OSCH_FREQ*100000/125
`define K1_25_PWM_STEP			208				// `OSCH_FREQ*100000/(125*256)
`define T1H_CYC					40				//	T1H_NS*`MASTER_CLK_FREQ_M/1000 (600 ns)
`define T0H_CYC					17				//	K0H_NS*`MASTER_CLK_FREQ_M/1000 (250 ns)
`define K800_CYC				83				//	TK800_NS*`MASTER_CLK_FREQ_M/1000 (1250 ns)
`define K800_HALF_CYC			41				// `K800_CYC/2
`define T1HTRES_CYC				28				// (T1H_NS+T0H_NS)/2*`MASTER_CLK_FREQ_M/1000 (425 ns)
`define RESET_CYC				6650			// `RESET_NS*`MASTER_CLK_FREQ_M/1000 (50000 ns)
`define WATCHDOG_TIMEOUT_CYC	33250000		// `WATCHDOG_TIMEOUT_NS*`MASTER_CLK_FREQ_M/1000 (500000000 ns/500ms)
`define K800_NS					1250			// 800 KHz ws28xx cycle time (ns)
`define K800_HALF_NS			625				// 800 KHz half ws28xx cycle time (ns)
`define T1H_NS					600				// ws28xx T1H (ns)
`define T0H_NS					250				// ws28xx T0H (ns)
`define T1HTRES_NS				425				// ws28xx T1H treashold (ns)
`define RESET_NS				100000			// ws28xx RESET (ns)
`define WATCHDOG_TIMEOUT_NS		500000000		// watchdog timeout (ns)

// Timing constants for simulation:
`define K1_25_NS				800000			// 1,25 KHz PWM cycle time (ns)
`define HZ100_NS				10000000		// 100 Hz PWM cycle time (ns)
`define MS_NS					1000000
`define US_NS					1000

// Actuator modes 
`define LOW						0
`define HIGH					1
`define PWM1_25K				2
`define PWM100					3
`define PULSE					4
`define PULSE_INV				5

// Sizing parameters
`define NO_ACTUATORS			4
`define CRC_WD					4
`define FEEDBACK_WD				4
`define COMMAND_WD				4
`define MODE_WD					3
`define ACTUATOR_WD				8
`define SENSOR_WD				8

// Satellite fedback bits
`define FEEDBACK_REMOTECRCERR	0
`define FEEDBACK_WDERR			1

// Satellite command bits
`define COMMAND_ADDR_ZERO		0
`define COMMAND_INVCRC			1
`define COMMAND_ENABLE			2
`define COMMAND_WD_ERR			3
