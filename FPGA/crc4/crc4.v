/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* crc4 implements a CRC-4 checksum calculator.																										*/
/* Input:																																			*/
/* serialClk(synch): serialData input is captured @ posedge of seriaClk																				*/
/* serialData(Synch): Input data subject for CRC calculation																						*/
/* reset(synch): At posedge of reset the CRC calculation is restarted																				*/
/* enable(SemiAsynch): If enable is set the CRC calculation continues and the crc4 output reflects current results; if unset the calculation is		*/
/*					   halted and the crc4 register is shifting towards MSB (crc4[3]) @ every posedge of seriaClk									*/
/* Output:																																			*/
/* reg[3:0] crc4: When enable is set the crc 4 output shows current reminder of the CRC-4 calculation, when enable is unset the CRC-4 calculation	*/
/*			is disabled and the CRC-4 calculation reminder is now shifting towards MSB (crc4[3]) for every serialClk posedge						*/
/* Comments:																																		*/
/*			CRC-4 polynom: (X^4)(+)(X^1)(+)(X^0)																									*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module crc4 (input serialClk,
			  input serialData,
			  input reset,
			  input enable,
			  input masterClk,
			  output reg[3:0] crc4);

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Clock edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevSerialClk;
	reg prevReset;
	always @ (posedge masterClk) begin
		prevSerialClk <= serialClk;
		prevReset <= reset;
	end
	`define SERIALCLK_POSEDGE serialClk && !prevSerialClk
	`define SERIALCLK_NEGEDGE !prevSerialClk && prevSerialClk
	`define RESET_POSEDGE reset && !prevReset
	`define RESET_NEGEDGE !reset && prevreset
/*-------------------------------------------------------END Clock edge definitions-----------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Calculate CRC-4 checksum																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @ (posedge masterClk) begin
		if(`RESET_POSEDGE)
			crc4 <= 4'b0000;
		else if(`SERIALCLK_POSEDGE) begin
			if(enable) begin														// If enble - calculate checksum
				crc4[0] <= serialData + crc4[3];
				crc4[1] <= serialData + crc4[3] + crc4[0];
				crc4[2] <= crc4[1];
				crc4[3] <= crc4[2];
			end
			else begin																// If not enble - do not calculate checksum, but shift it out
				crc4[0] <= 1'b0;
				crc4[1] <= crc4[0];
				crc4[2] <= crc4[1];
				crc4[3] <= crc4[2];
			end
		end
	end
/*------------------------------------------------------END Calculate CRC-4 checksum----------------------------------------------------------------*/
endmodule