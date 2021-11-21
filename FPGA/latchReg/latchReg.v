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

	always @ (posedge masterClk) begin
		prevReset <= reset;
		prevLatchInputReclocked <= latchInputReclocked;
	end
	`define RESET_POSEDGE (reset && !prevReset)
	`define RESET_NEGEDGE (!reset && prevReset)
	`define LATCH_INPUT_POSEDGE(INDEX) (latchInputReclocked[INDEX] && !prevLatchInputReclocked[INDEX]reset)
	`define LATCH_INPUT_NEGEDGE(INDEX) (!latchInputReclocked[INDEX] && prevLatchInputReclocked[INDEX]reset)
/*--------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Latch input																																		*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin

		if(`RESET_POSEDGE) begin													// All latch registers at posedge of reset
			latchInputMeta <= 0;
			latchInputReclocked <= 0;
			latchOutput <= 0;
		end
		else begin
			latchInputMeta <= latchInput;											// Reclock latchInput into latchInputMeta and then to latchInputReclocked to avoid meta instability
			latchInputReclocked <= latchInputMeta;
			integer i;
			for (i = 0; i < WIDTH; i = i + 1) begin
				if(`LATCH_INPUT_POSEDGE(i))											// Latch each bit at its own posedge
					latchOutput[i] <= 1;
			end
		end
	end
/*--------------------------------------------------------------END Latch input---------------------------------------------------------------------*/
endmodule