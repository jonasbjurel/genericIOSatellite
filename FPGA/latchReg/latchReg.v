/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* The latchReg implements a N-bit monostable latch register														                                */
/* Input:																																			*/
/*		masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz						*/
/*		latchInput: latch input, each individual bit is latched as their respective posedge															*/
/*		reset: Serial latchOutput is reset at posedge of reset																						*/
/* output:																																			*/
/*		latchOutput: Monostable posetive Latched output from latchInput																				*/								
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module latchReg	#(parameter WIDTH = 8)
				(input wire[WIDTH-1:0] latchInput,
				input reset,
				input masterClk,
				output reg[WIDTH-1:0] latchOutput);


	reg[WIDTH-1:0] latchInputMeta;
	reg[WIDTH-1:0] latchInputReclocked;
	reg[WIDTH-1:0] prevLatchInputReclocked;
	reg prevReset;
	reg resetLatchOutput;
	
	integer i;
	
	always @ (posedge masterClk) begin
		prevReset <= reset;
		if(!prevReset && reset) begin													// Reset at posedge of reset
			latchInputMeta <= 0;
			latchInputReclocked <= 0;
			latchOutput <= 0;
		end
		else begin
			latchInputMeta <= latchInput;												// Reclock latchinput into meta- and masterClock domain
			latchInputReclocked <= latchInputMeta;
			prevLatchInputReclocked <= latchInputReclocked;
			for (i=0; i<WIDTH; i=i+1) begin
				if(latchInputReclocked[i] && !prevLatchInputReclocked[i])				// Latch each bit at its own posedge
					latchOutput[i] <= 1;
			end
		end
	end
endmodule