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
	`define DATACLK_POSEDGE (dataClk && !prevDataClk)
	`define DATACLK_NEGEDGE (!dataClk && prevDataClk)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Encoder																																			*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin
		prevDataClk <= dataClk;
		if (!prevDataClk && dataClk) begin
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