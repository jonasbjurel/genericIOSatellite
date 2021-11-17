/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* pulse implements a 0-255 ms pulse generator																		                                */
/* Input:																																			*/
/*		masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz						*/
/*		pulseLength: An 8-bit control register for the pulse length																					*/
/*		trigger: The trigger for the pulse, @posedge latches the pulseLength and generates the pulse, should happen on negedge of masterClk		    */
/* output:																																			*/
/*		pulse: resulting 0-255 ms long pulse																										*/
/* Comments: While a pulse is active, a new pulse will not be triggered																				*/
/*			 All inputs are expected to be synchronous with the master clock, and changes are expected close to negedge of that clock, and never    */
/*           close to posedge.																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif


module pulse (input wire[7:0] pulseLength,
			  input trigger,
			  input masterClk,
			  output reg pulse,
			  output reg pulseInv);
 
	reg [$clog2(`MASTER_CLK_CYC_PER_MS)-1:0] cnt1k = 0;									// 1 ms counter
	reg [7:0] pulseCnt = 0;																// N*1ms counter
	reg prevTrigger = 0;
	reg active = 0;

	always @ (posedge masterClk) begin
		prevTrigger <= trigger;															
		if(!prevTrigger && trigger && !active && pulseLength!=8'h00) begin				// posedge of trigger @ which pulse is raised and counters are preset,
			pulse <= 1'b1;																// and only if the pulseLengt > 0 and therere is no ongoing pulse sesion (active)
			pulseInv <= 1'b0;															// a new pulse will be generated
			cnt1k <= 0;																	
			pulseCnt <= pulseLength;
			active <= 1'b1;																// Set active flag, while this flag is set no new pulse sessions can be activated
		end
		else if(cnt1k >= `MASTER_CLK_CYC_PER_MS) begin									// 1ms expired, reload the ms counter
			cnt1k <= 0;
			pulseCnt <= pulseCnt - 1'b1;												// Decrese 1ms pulse count
			if (pulseCnt <= 8'h01) begin												// If the pulse length has expired, pulse is lowered and the and the active flag is cleared
				pulse <= 1'b0;															//  preventing further pulse sessions to be started 
				pulseInv <= 1'b1;
				active <= 1'b0;
			end																			
		end
		else begin
			cnt1k <= cnt1k + 1'b1;														// Count the 1ms counter
		end
	end
endmodule