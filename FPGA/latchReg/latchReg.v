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
/* The latchReg implements a N-bit monostable latch register														                                */
/* Input:																																			*/
/* masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/* latchInput: (Async) Each individual bit is latched at their respective posedge, only to be reset at rest posedge									*/
/* reset: Serial (latchOutput is reset at posedge of reset																							*/
/* Module static parameters:																														*/
/* WIDTH: defines the width of the latchReg																											*/
/* Output:																																			*/
/* latchOutput: Monostable posetive Latched output from latchInput																					*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module latchReg	#(parameter WIDTH = 8)
				(input wire[WIDTH-1:0] latchInput,
				input reset,
				input masterClk,
				output reg[WIDTH-1:0] latchOutput);

	reg[WIDTH-1:0] latchInputMeta;													//Metastable latch input reclocked from latchInput
	reg[WIDTH-1:0] latchInputReclocked;												//(Hopefully) stable latch input - reclocked twice (latchInput->latchInputMeta->latchInputReclocked)
	
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Signal edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevReset;
	reg[WIDTH-1:0] prevLatchInputReclocked;
	integer i;

	always @ (posedge masterClk) begin
		prevReset <= reset;
		prevLatchInputReclocked <= latchInputReclocked;
	end
	`define LATCH_RESET_POSEDGE (reset && !prevReset)
	`define LATCH_RESET_NEGEDGE (!reset && prevReset)
	`define LATCH_INPUT_POSEDGE(INDEX) (latchInputReclocked[INDEX] && !prevLatchInputReclocked[INDEX])
	`define LATCH_INPUT_NEGEDGE(INDEX) (!latchInputReclocked[INDEX] && prevLatchInputReclocked[INDEX])
/*--------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Latch input																																		*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin
		if(`LATCH_RESET_POSEDGE) begin													// All latch registers at posedge of reset
			latchInputMeta <= 0;
			latchInputReclocked <= 0;
			latchOutput <= 0;
		end
		else begin
			latchInputMeta <= latchInput;											// Reclock latchInput into latchInputMeta and then to latchInputReclocked to avoid meta instability
			latchInputReclocked <= latchInputMeta;
			for (i = 0; i < WIDTH; i = i + 1) begin
				if(`LATCH_INPUT_POSEDGE(i))											// Latch each bit at its own posedge
					latchOutput[i] <= 1;
			end
		end
	end
/*--------------------------------------------------------------END Latch input---------------------------------------------------------------------*/
endmodule