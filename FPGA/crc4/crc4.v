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

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* crc4 implements a CRC-4 checksum calculator.																										*/
/* Input:																																			*/
/* masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/* serialClk(synch): serialData input is captured @ posedge of seriaClk																				*/
/* serialData(Synch): Input data subject for CRC calculation																						*/
/* reset(Synch): At posedge of reset the CRC calculation is restarted																				*/
/* enable(SemiAsynch): If enable is set the CRC calculation continues and the crc4 output reflects current results; if unset the calculation is		*/
/*					   halted and the crc4 register is shifting towards MSB (crc4[3]) @ every posedge of seriaClk									*/
/* Output:																																			*/
/* reg[3:0] crc4: When enable is set the crc 4 output shows current reminder of the CRC-4 calculation, when enable is unset the CRC-4 calculation	*/
/*			is disabled and the CRC-4 calculation reminder is now shifting towards MSB (crc4[3]) for every serialClk posedge						*/
/* Comments:																																		*/
/*	CRC-4 polynom: (X^4)(+)(X^1)(+)(X^0)																											*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module crc4 (input serialClk,
			  input serialData,
			  input reset,
			  input enable,
			  input masterClk,
			  output reg[3:0] crc4);

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Signal edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevSerialClk;
	reg prevReset;
	always @ (posedge masterClk) begin
		prevSerialClk <= serialClk;
		prevReset <= reset;
	end
	`define CRC_SERIALCLK_POSEDGE (serialClk && !prevSerialClk)
	`define CRC_SERIALCLK_NEGEDGE (!prevSerialClk && prevSerialClk)
	`define CRC_RESET_POSEDGE (reset && !prevReset)
	`define CRC_RESET_NEGEDGE (!reset && prevreset)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Calculate CRC-4 checksum																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin
		if(`CRC_RESET_POSEDGE)
			crc4 <= 4'b0000;
		else if(`CRC_SERIALCLK_POSEDGE) begin
			if(enable) begin														// If enble - calculate checksum
				crc4[0] <= serialData + crc4[3];
				crc4[1] <= serialData + crc4[3] + crc4[0];
				crc4[2] <= crc4[1];
				crc4[3] <= crc4[2];
			end
			else begin																// If not enble - do not calculate checksum, but shift it out
				crc4[0] <= 1'b0;
				crc4[1] <= crc4[0];
				crc4[2] <= crc4[1];
				crc4[3] <= crc4[2];
			end
		end
	end
/*------------------------------------------------------END Calculate CRC-4 checksum----------------------------------------------------------------*/
endmodule