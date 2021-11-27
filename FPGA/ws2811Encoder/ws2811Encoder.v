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
/* The ws2811Encoder module endecodes the data to the ws2811 physical layer, supported speed is 800 kHhz/800 bps	                                */
/* Input:																																			*/
/* masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/* dataIn: Unmodulated ws2811 signal, latched @ posedge of masterClk																				*/
/* dataClk: clk to latch dataInput, dataInput latched @ posedge of masterClk																		*/
/* output:																																			*/
/* dataOut: WS2811 modulated output data																											*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module ws2811Encoder (input		dataIn,
								dataClk,
								masterClk,
					  output    reg dataOut=1'b0);


	reg[7:0] cnt;																				// Counter to define pulse widths
	reg countEn;																				// Enable counting flag
	reg nextDataOut;

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Signal edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevDataClk;
	always @ (posedge masterClk) begin
		prevDataClk <= dataClk;
	end
	`define ENCODE_DATACLK_POSEDGE (dataClk && !prevDataClk)
	`define ENCODE_DATACLK_NEGEDGE (!dataClk && prevDataClk)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Encoder																																			*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin
		prevDataClk <= dataClk;
		if (`ENCODE_DATACLK_POSEDGE) begin
			nextDataOut <= dataIn;
			dataOut <= 1;
			cnt <= 0;
			countEn <= 1;
		end
		else if (countEn) begin
			cnt <= cnt + 1'b1;
			if (!nextDataOut) begin
				if (cnt == `T0H_CYC) begin
					dataOut <= 0;
					countEn <= 0;
				end
			end
			else begin
				if (cnt == `T1H_CYC) begin
					dataOut <= 0;
					countEn <= 0;
				end
			end
		end
	end
/*---------------------------------------------------------------END Encoder-----------------------------------------------------------------------*/
endmodule