/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* The ws2811Decoder module decodes the ws2811 physical layer and provides resulting data and recovered clock, supported speed is 800 kHhz/800 bps	*/
/* Input:																																			*/
/*masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/*dataIn:(Async) Modulated ws2811 signal - T1H 600 nS, T1L 250 nS +/- 75 nS																			*/
/* output:																																			*/
/* dataOut: Demodulated output data, shall be latched at posedge of dataClk																	*/
/* dataClk: Data clck, dataOut shall be latched at posedge of this clock																		*/
/* active: An active transaction is ongoing, the transaction is ended by a 25uS long low period on the line									*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif


module ws2811Decoder (input masterClk,
					  input dataIn,
					  output reg dataOut,
					  output reg dataClk,
					  output reg active);

	reg[15:0] cnt1 = 0;																// Counter for tracking the pulse lengths CREATE A MACRO DEFINING THE SIZE OF THE CNT BASED ON MASTER FREQ
	reg[15:0] cnt2 = 0;																// Counter for tracking the inactivity/low/Reset lengths CREATE A MACRO DEFINING THE SIZE OF THE CNT BASED ON MASTER FREQ

	reg dataInMeta = 1'b0;															// Meta stable domain for dataIn reclocking
	reg dataInReclocked = 1'b0;														// Fully reclocked dataIn
	reg prevDataInReclocked = 1'b0;													// previous dataIn used for edge detection
	
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Signal edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevDataInReclocked = 1'b0;													// previous dataIn used for edge detection

	always @ (posedge masterClk) begin
		prevDataInReclocked <= dataInReclocked;
	end
	
	`define DATAIN_RECLOCKED_POSEDGE (dataInReclocked && !prevDataInReclocked)
	`define DATAIN_RECLOCKED_NEGEDGE (!dataInReclocked && prevDataInReclocked)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Decoder																																			*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin
		dataInMeta <= dataIn;														// Synchronizing asyncronous dataIn with the master clock
		dataInReclocked <= dataInMeta;
		prevDataInReclocked <= dataInReclocked;

		if(`DATAIN_RECLOCKED_POSEDGE) begin											// posedge dataIn
			active <= 1;															// activate the session unless not already active
			cnt1 <= 0;																// Reset cnt1 for future evaluation of pulse length T1H/T0H
		end
		else if (active)
			cnt1 <= cnt1 + 1'b1;

		if(dataInReclocked)
			cnt2 <= 0;																// Reset cnt2 used to detect reset based on low period whenever dataIn is high
		else if(cnt2 > `RESET_CYC) begin											// When dataIn has been low for RESET period, the session is over and active is set to 0
			active <= 0;
			cnt2 <= 0;
		end
		else if(active)
			cnt2 <= cnt2 + 1'b1;

		if(`DATAIN_RECLOCKED_NEGEDGE) begin											// negedge dataIn
			if(cnt1 > `T1HTRES_CYC)													// Check cnt for dataOut high or low and set dataOut accordingly
				dataOut <= 1;
			else
				dataOut <= 0;
		end
		if(cnt1 >= `K800_HALF_CYC)													// At half 800kHz period, set dataClk low
			dataClk <= 0;
		if(cnt1 > `K800_CYC || cnt1 < `K800_HALF_CYC) begin							// If a full 800kHz period, set dataClk high (this is the point to latch dataOut)
			dataClk <= 1;
		end
	end
/*---------------------------------------------------------------END Decoder-----------------------------------------------------------------------*/
endmodule