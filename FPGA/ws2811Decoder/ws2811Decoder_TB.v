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
/* The ws2811Decoder_ module decodes is a test bench for the ws2811Decoder																			*/
/* No particular comments - read the print-outs to follow the code...																				*/
/* See ws2811Decoder.v for more information																											*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`include "../genericIOSateliteEnv.v"
`include "../genericIOSateliteEnv_TB.v"
`include "ws2811Decoder.v"

// Checks the 4-byte result
`define CHECK_RES(VALUE3, VALUE2, VALUE1, VALUE0) \
	if (result_3 === VALUE3 & result_2 === VALUE2 & result_1 === VALUE1 & result_0 === VALUE0) \
		$display("ws2811Decoder: PASS: results were as expected, %b %b %b %b was expected, and %b %b %b %b was detected", VALUE3, VALUE2, VALUE1, VALUE0, result_3, result_2, result_1, result_0); \
	else begin \
		$display("ws2811Decoder: ERROR: results were not as expected, %b %b %b %b was expected, but %b %b %b %b was detected", VALUE3, VALUE2, VALUE1, VALUE0, result_3, result_2, result_1, result_0); \
		$display("ws2811Decoder: Stopping further simulation..."); \
		$stop; \
	end

module ws2811Decoder_TB ();
	wire masterClk;
	reg dataIn;
	wire dataOut;
	wire dataClk;
	wire active;
	reg[7:0] result_0;
	reg[7:0] result_1;
	reg[7:0] result_2;
	reg[7:0] result_3;

	integer shiftIndex, valIndex;


	ws2811Decoder DUT(.masterClk(masterClk), .dataIn(dataIn), .dataOut(dataOut), .dataClk(dataClk), .active(active));
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());

	always @(posedge dataClk) begin

		for(shiftIndex=7; shiftIndex>=0; shiftIndex=shiftIndex-1) begin
			if(shiftIndex != 0) begin
				result_3[shiftIndex] <= result_3[shiftIndex-1];
				result_2[shiftIndex] <= result_2[shiftIndex-1];
				result_1[shiftIndex] <= result_1[shiftIndex-1];
				result_0[shiftIndex] <= result_0[shiftIndex-1];
			end
			else begin
				result_3[0] <= result_2[7];
				result_2[0] <= result_1[7];
				result_1[0] <= result_0[7];
				result_0[0] <= dataOut;
			end
		end
	end
	
	initial begin
		$display("ws2811Decoder: Initializing simulation for WS2811Decoder");

		$display("ws2811Decoder: Running simulation for nominal dataIn timing, T1H: %d, T1L %d, T0H: %d, T0L", 600, 1240-600, 250, 1240-250); //MAKE PARAMETERS IN THE ENV FILE
		`WS2811_GENERATE(dataIn, 8'hF0, 0)						//Init Garbage vector
		`WS2811_GENERATE_END(dataIn)

		`WS2811_GENERATE(dataIn, 8'h55, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'hAA, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'h00, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'hFF, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE_END(dataIn)
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)

		$display("ws2811Decoder: Running simulation for maximum positive dataIn skew timing: + %d ns", `MAX_SKEW);
		`WS2811_GENERATE(dataIn, 8'h55, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'hAA, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'h00, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'hFF, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE_END(dataIn)
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)
		
		$display("ws2811Decoder: Running simulation for maximum negative dataIn skew timing: - %d ns", `MAX_SKEW);
		`WS2811_GENERATE(dataIn, 8'h55, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'hAA, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'h00, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(dataIn, 8'hFF, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE_END(dataIn)
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)
		#50000
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)

		$display("ws2811Decoder: Simulation successfull - stopping");
		$stop;
	end
endmodule