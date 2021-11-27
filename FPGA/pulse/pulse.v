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
/* pulse implements a 0-255 ms pulse generator																		                                */
/* Input:																																			*/
/* masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/* pulseLength: (Sync) An 8-bit control register for the pulse length (ms)																			*/
/* trigger: (Sync) Trigger for the pulse, @posedge latches the pulseLength and starts the pulse, captured on negedge of masterClk					*/
/* output:																																			*/
/* pulse: Resulting 0-255 ms long pulse																												*/
/* pulseInv: 1 complement to pulse																													*/
/* Comments: While a pulse is active, a new pulse will not be triggered																				*/
/*			 All inputs are expected to be synchronous with the master clock, and changes are expected close to negedge of that clock, and never	*/
/*			 close to posedge.																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module pulse (input wire[7:0] pulseLength,
			  input trigger,
			  input masterClk,
			  output reg pulse,
			  output reg pulseInv);
 
	reg [$clog2(`MASTER_CLK_CYC_PER_MS)-1:0] cnt1k = 0;								// 1 ms counter
	reg [7:0] pulseCnt = 0;															// N*1ms counter
	reg active = 0;																	// If set a pulse is ongoing, which can not be interrupted by a new pulse

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Signal edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevTrigger = 0;
	always @ (posedge masterClk) begin
		prevTrigger <= trigger;
	end
	`define PULSE_TRIGGER_POSEDGE (trigger && !prevTrigger)
	`define PULSE_TRIGGER_NEGEDGE (!trigger && prevTrigger)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Generate pulse																																	*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin
		if(`PULSE_TRIGGER_POSEDGE && !active && pulseLength!=8'h00) begin			// Initiata a new pulse @ posedge of trigger providing that no previous pulse is running and only if the pulseLengt > 0
			pulse <= 1'b1;															// Set pulse active
			pulseInv <= 1'b0;														// Set pulseInv inactive
			cnt1k <= 0;																// ms Cnt reset.
			pulseCnt <= pulseLength;												// Set pulse length
			active <= 1'b1;															// Set active flag, while this flag is set so no new pulse sessions can be activated
		end
		else if(cnt1k >= `MASTER_CLK_CYC_PER_MS) begin								// 1ms expired, reload the ms counter, and decrease the pulseCnt)
			cnt1k <= 0;
			pulseCnt <= pulseCnt - 1'b1;
			if (pulseCnt <= 8'h01) begin											// If the pulse length has expired, pulse is loweset to inactive and the and the active flag is cleared - enabling new pulse orders
				pulse <= 1'b0;
				pulseInv <= 1'b1;
				active <= 1'b0;
			end
		end
		else begin
			cnt1k <= cnt1k + 1'b1;													// Count the 1ms counter
		end
	end
/*------------------------------------------------------------END Generate pulse--------------------------------------------------------------------*/
endmodule