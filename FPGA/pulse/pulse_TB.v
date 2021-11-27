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
/* pulse is a programming pulsegenerator, generating pulses from 0 ms(which does not generate a pulse) to 255 ms +/- 10%							*/
/* See pulse.v for more information																													*/
/* No particular comments - read the print-outs to follow the code...																				*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`include "../genericIOSateliteEnv.v"
`include "../genericIOSateliteEnv_TB.v"
`include "pulse.v"

module pulse_TB ();
	reg[7:0] pulseLength;
	reg trigger;
	wire masterClk;
	wire pulse;

	integer setPulseLength, t0, progress;

	pulse DUT(.pulseLength(pulseLength), .trigger(trigger), .masterClk(masterClk), .pulse(pulse));
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());
	
	initial begin
		$display("pulse: Running simulation for a pulse generator");
		$display("pulse: Initializing simulation for WS2811Decoder");

		// TestCase initialization
		trigger = 1'b0;
		#(`US_NS);
		pulseLength=8'h01;
		#(`US_NS);
		trigger = 1'b1;
		#(`US_NS);
		trigger = 1'b0;
		#(`MS_NS + `MS_NS*0.05);

		//TestCase 1A - Sweeping all pulse lengths from 1 to 255 with 32 ms increments, expected +/- 1 % accuarcy
		$display("pulse: Running TestCase 1A (TC-1A): Sweeping all pulse lengths from 1 to 255, with 32 ms increments, expected +/- 1 %% accuarcy");
		pulseLength=8'h01;
		#(`US_NS);
		for(setPulseLength=1; setPulseLength<256; setPulseLength=setPulseLength+16) begin
			trigger=1'b1;
			t0 = $time;
			#(`US_NS);
			while (pulse != 1'b1) begin
				#1;
				if($time - t0 > 100) begin
					$display("pulse: ERROR: TC-1A: pulse did not trigger as expected");
					$display("pulse: TC-1A: ERROR: stopping simulation...");
					$stop;
				end
			end
			progress = 0;
			while (pulse != 1'b0) begin
				#1;
				if (progress == 1000000) begin
					$write(".");
					progress = 0;
				end
				else
					progress = progress + 1;
				if($time-t0 > setPulseLength*`MS_NS+setPulseLength*`MS_NS*0.01) begin
					$display("pulse: TC-1A: ERROR: pulse length was more than 1 %% longer than expected nominal: %d ms, allowed accuracy +/- %d ns, breaking at %d ns", setPulseLength, setPulseLength*`MS_NS*0.01, $time-t0);
					$display("pulse: TC-1A: ERROR: stopping simulation...");
					$stop;
				end
			end
			$display("");
			if($time-t0 < setPulseLength*`MS_NS-setPulseLength*`MS_NS*0.01) begin
				$display("pulse: ERROR: TC-1A: pulse > 1 %% shorter than expected, expected nominal %d ms, allowed accuracy +/- %d ns, actual pulselength: %d ns", setPulseLength, setPulseLength*`MS_NS*0.01, $time-t0);
				$display("pulse: ERROR: TC-1A: stopping simulation...");
				$stop;
			end
			else begin
				$display("pulse: PASS: TC-1A: pulse was as long as expected (+/- 1 %%), expected nominal: %d ms, allowed accuracy +/- %d ns, actual pulselength: %d ns", setPulseLength, setPulseLength*`MS_NS*0.01, $time-t0);
				trigger=1'b0;
				pulseLength = pulseLength + 8'h10;
				#(`US_NS);

			end
		end
		$display("pulse: PASS TC-1A: Sweeping all pulse lengths from 1  with 32 ms increments, expected +/- 0.1 percent accuarcy has passed");

		//TestCase 1B - Checking pulse length 0
		$display("pulse: Running TestCase 1B (TC-1B): Checking that pulseLength = 8'h00 does not generate any pulse");
		pulseLength=8'h00;
		#(`US_NS);
		trigger=1'b1;
		t0 = $time;
		while($time-t0 < 100) begin
			if (pulse === 1'b1) begin
				$display("pulse: ERROR: TC-1B: Did not expect pulse to trigger for pulsLength 8'h00");
				$display("pulse: ERROR: TC-1B: stopping simulation...");
				$stop;
			end
			#1;
		end
		trigger = 1'b0;
		$display("pulse: PASS: TC-1B: pulseLength = 8'h00 did not trigger a pulse");
		#(`US_NS);

		//TestCase 1C - Checking pulse length 255 ms ,  expected +/- 1 percent accuarcy
		$display("pulse: Running TestCase 1C (TC-1C): Checking pulse length 255 ms,  expected +/- 1 percent accuarcy");
		pulseLength=8'hFF;
		#(`US_NS);
		trigger = 1'b1;
		t0 = $time;
		#(`US_NS);
		progress = 0;
		while (pulse != 1'b0) begin
			#1;
			if (progress == 1000000) begin
				$write(".");
				progress = 0;
			end
			else
				progress = progress + 1;
			if($time-t0 > 255*`MS_NS+255*`MS_NS*0.01) begin
				$display("pulse: ERROR: TC-1C: pulse length was more than 1 %% longer than expected nominal: %d ms, allowed accuracy +/- %d ns, breaking at %d ns", 255, 255*`MS_NS*0.01, $time-t0);
				$display("pulse: ERROR: TC-1C: stopping simulation...");
				$stop;
			end
		end
		$display("");
		if($time-t0 < 255*`MS_NS-255*`MS_NS*0.01) begin
			$display("pulse: ERROR: TC-1C: pulse > 1 %% shorter than expected, expected nominal %d ms, allowed accuracy +/- %d ns, actual pulselength: %d ns", 255, 255*`MS_NS*0.01, $time-t0);
			$display("pulse: ERROR: TC-1C: stopping simulation...");
			$stop;
		end
		else begin
			$display("pulse: PASS: TC-1C: pulse was as long as expected (+/- 1 %%), expected nominal: %d ms, allowed accuracy +/- %d ns, actual pulselength: %d ns", 255, 255*`MS_NS*0.01, $time-t0);
			trigger=1'b0;
			#(`US_NS);
		end
		$display("pulse: PASS: TC-1C: Checking pulse length 255 ms,  expected +/- 1 percent accuarcy has passed");
		trigger = 1'b0;
		#(`US_NS);

		//TestCase 2 - Checking that pulse is not retriggered while active
		$display("pulse: Running TestCase 2 (TC-2): Checking that pulse is not retriggered while active");
		pulseLength = 8'h01;
		#(`US_NS);
		trigger = 1'b1;
		#(`US_NS);
		trigger = 1'b0;
		pulseLength = 8'hFF;
		#(`US_NS);
		trigger = 1'b1;
		#(`MS_NS + `MS_NS*0.01);
		if(pulse === 1'b1) begin
			$display("pulse: TC-2: ERROR: pulse seems to have been retriggered despite it was already active");
			$display("pulse: TC-2: ERROR: stopping simulation...");
			$stop;
		end
		$display("pulse: PASS: TC-2: Checking that pulse is not retriggered while active was successful");
		trigger = 0;
		#(`US_NS);
		$display("pulse: SUCCESS: pulse simulation was successful!!!");
		$stop;
	end
endmodule