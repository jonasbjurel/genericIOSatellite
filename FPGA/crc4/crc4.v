/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* pulse implements a 0-255 ms pulse generator																		                                */
/* Input:																																			*/
/*																																					*/
/* output:																																			*/
/*		crc4																																		*/
/* Comments:																																		*/
/*																																					*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`ifdef TOP
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

reg prevSerialClk;
reg prevReset;


	// CRC4 Polynom x[4]+X[1]+X[0]

	always @ (posedge masterClk) begin
		prevSerialClk <= serialClk;
		prevReset <= reset;

		if(reset && !prevReset)
			crc4 <= 4'b0000;
		else if(serialClk && !prevSerialClk) begin
			if(enable) begin
				crc4[0] <= serialData + crc4[3];
				crc4[1] <= serialData + crc4[3] + crc4[0];
				crc4[2] <= crc4[1];
				crc4[3] <= crc4[2];
			end
			else begin
				crc4[0] <= 1'b0;
				crc4[1] <= crc4[0];
				crc4[2] <= crc4[1];
				crc4[3] <= crc4[2];
			end
		end
	end
endmodule