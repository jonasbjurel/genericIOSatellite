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
/* The implements a n bit shift register with parallel inputs and outputs																			*/
/* Input:																																			*/
/* masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/* clk: shiftregister clock, serialInput is latched at posedge, serialOutput shall be latched at negedge											*/
/* serialIn: Serial input																															*/
/* parallelInput: parallel input, is latched into the register at load high and posedge enableShift													*/
/* load: See above																																	*/
/* enableShift: Enables serial shift																												*/
/* output:																																			*/
/* serialOut: Serial out																															*/
/* paralelOut: latched at negedge enableShift																										*/
/* loaded: high when load finished, reset at negedge enable Shift																					*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module shiftReg 	#(parameter WIDTH = 8)
					(input[WIDTH-1:0] parallelInput,
				     input serialInput,
					 input clk,
					 input load,
					 input enableShift,
					 input masterClk,
					 output	reg[WIDTH-1:0] parallelOutput,
					 output wire serialOutput,
					 output reg loaded);

	reg [WIDTH-1:0] internal;
	integer i;

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Signal edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevClk;
	reg prevEnableShift;

	always @ (posedge masterClk) begin
		prevClk <= clk;
		prevEnableShift <= enableShift;
	end
	`define SHIFT_CLK_POSEDGE (clk && !prevClk)
	`define SHIFT_CLK_NEGEDGE (!clk && prevClk)
	`define SHIFT_EN_SHIFT_POSEDGE (enableShift && !prevEnableShift)
	`define SHIFT_EN_SHIFT_NEGEDGE (!enableShift && prevEnableShift)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Shiftregister operation																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	assign serialOutput = internal[WIDTH-1];

	always @ (posedge masterClk) begin
		if(load && `SHIFT_EN_SHIFT_POSEDGE) begin									// Load register with parallelInput @ load &  posedge enableShift
			internal <= parallelInput;
			loaded <= 1;
		end
		else if(`SHIFT_CLK_POSEDGE && enableShift) begin							// Shift register @ enableShift & posedge clk
			if (WIDTH > 1) begin
				for (i=WIDTH-1; i>0; i=i-1) begin
					internal[i] <= internal[i-1];
				end
			end
			internal[0] <= serialInput;
		end
		else if (`SHIFT_EN_SHIFT_NEGEDGE) begin										// Ouotput register to parallelOutput @ negedge enableShift
			parallelOutput <= internal;
			loaded <= 0;
		end
	end
/*--------------------------------------------------------END Shiftregister operation---------------------------------------------------------------*/
endmodule