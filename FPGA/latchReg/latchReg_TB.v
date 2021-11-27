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
/* This is the test-bench for pulse:																												*/
/* latchReg is an N-bit wide monstable latch register																								*/
/* See latchReg.v for more information																												*/
/* No particular comments - read the print-outs to follow the code...																				*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`include "../genericIOSateliteEnv.v"
`include "../genericIOSateliteEnv_TB.v"
`include "latchReg.v"

module latchReg_TB ();
	wire masterClk;
	reg[31:0] latchInput;
	reg reset;
	wire[31:0] latchOutput;
	reg[31:0] latchStimuli;
	reg[31:0] expect;

	integer i;

	latchReg #(.WIDTH(32)) DUT(.masterClk(masterClk), .latchInput(latchInput), .reset(reset), .latchOutput(latchOutput));
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());
	
	initial begin
		$display("latchReg: Running simulation for a 32 bit latch reg");
		$display("latchReg: Initializing simulation for WS2811Decoder");
		// Initialization
		reset = 0;
		latchInput = 32'h0000;
		#100;

		// Testcase-1: Initial rest of the latchReg, and check result for 32'h0000
		reset = 1;
		#100;
		`CHECK_WIRE_32("latchReg", latchOutput, 8'h00, 8'h00, 8'h00, 8'h00)
		#100;

		// Testcase-2 Itterate through latchInput stimuli: ...001, ...010, ...100 and checking expect(ed result): ...001, ...011, ...111, 
		latchStimuli = 32'h0001;
		expect = 32'h0001;
		for(i=0; i<32; i=i+1) begin
			latchInput = latchStimuli;
			#100;
			if(latchOutput === expect)
				$display("latchReg: PASS: latchoutput was as expected, expected: %b, detected: %b", expect, latchOutput);
			else begin
				$display("latchReg: ERROR: latchoutput was not as expected, expected: %b, detected: %b", expect, latchOutput);
				$display("latchReg: Stoping simulation");
				$stop;
			end
			#100;
			latchStimuli = latchStimuli << 1;
			expect = (expect << 1) | 32'h0001;
		end

		// Testcase-3 reseting latchInput, and applying rest, and checking for latchOutput 32'h0000;
		latchInput = 32'h0000;
		reset = 0;
		#100;
		reset = 1;
		#100;
		`CHECK_WIRE_32("latchReg", latchOutput, 8'h00, 8'h00, 8'h00, 8'h00)
		$display("latchReg: Simulation successful");
		$stop;
	end
endmodule