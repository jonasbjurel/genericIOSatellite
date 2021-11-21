/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* The implements a n bit shift register with parallel inputs and outputs											                                */
/* Input:																																			*/
/* masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/* clk: shiftregister clock, serialInput is latched at posedge, serialOutput shall be latched at negedge											*/
/* serialIn: Serial input																															*/
/* parallelInput: parallel input, is latched into the register at load high and posedge enableShift													*/
/* load: See above																																	*/
/*	enableShift: Enables serial shift																												*/
/* output:																																			*/
/* serialOut: Serial out																															*/
/* paralelOut: latched at negedge enableShift																										*/
/* loaded: high when load finished, reset at negedge enable Shift																				*/
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
	`define CLK_POSEDGE (clk && !prevClk)
	`define CLK_NEGEDGE (!clk && prevClk)
	`define EN_SHIFT_POSEDGE (enableShift && !prevEnableShift)
	`define EN_SHIFT_NEGEDGE (!enableShift && prevEnableShift)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Shiftregister operation																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	assign serialOutput = internal[WIDTH-1];

	always @ (posedge masterClk) begin
		if(load && `EN_SHIFT_POSEDGE) begin											// Load register with parallelInput @ load &  posedge enableShift
			internal <= parallelInput;
			loaded <= 1;
		end
		else if(CLK_POSEDGE && enableShift) begin									// Shift register @ enableShift & posedge clk
			if (WIDTH > 1) begin
				for (i=WIDTH-1; i>0; i=i-1) begin
					internal[i] <= internal[i-1];
				end
			end
			internal[0] <= serialInput;
		end
		else if (`EN_SHIFT_NEGEDGE) begin											// Ouotput register to parallelOutput @ negedge enableShift
			parallelOutput <= internal;
			loaded <= 0;
		end
	end
/*--------------------------------------------------------END Shiftregister operation---------------------------------------------------------------*/
endmodule