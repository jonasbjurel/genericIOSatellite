/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* pwm is a programable pwm generator, generating pwm pulses from 0 % duty cycle (which does not generate a pulse) to 100% duty cycle				*/
/* See pulse.v for more information																													*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`include "../genericIOSateliteEnv.v"
`include "../genericIOSateliteEnv_TB.v"
`include "pwm.v"

`define SIMPRESCALE	10

module pwm_TB ();
	reg[7:0] controlInput;
	reg load;
	wire masterClk;
	wire pwmOut;

	integer setcontrolInput, t0, progress, i;

	pwm #(.PRESCALE(`SIMPRESCALE)) DUT(.controlInput(controlInput), .load(load), .masterClk(masterClk), .pwmOut(pwmOut));
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());
	
	initial begin
		$display("pwm: Running simulation for a pwm generator @ 125 Hz");
		$display("pwm: Initializing simulation for WS2811Decoder");

		// TestCase initialization
		load = 1'b0;
		#(`US_NS);
		controlInput=8'h00;
		#(`US_NS);
		load = 1'b1;
		#(`US_NS);
		load = 1'b0;
		#(`US_NS);

		//TestCase 1A - Sweeping all pwm duty-cycles from 1 to 255 with 32 ms increments, expected +/- 1 % accuarcy
		$display("pwm: Running TC-1A: Sweeping all pwm duty-cycles from 1 to 255 with increments of 16, expected +/- 1 %% accuarcy");
		controlInput=8'h01;
		#(`US_NS);
		for(setcontrolInput=1; setcontrolInput<256; setcontrolInput=setcontrolInput+16) begin
			$display("pwm: INFO: Simulating PWM duty cycle %d %%", setcontrolInput*100/256 );
			load=1'b1;
			t0 = $time;
			#10;
			while (pwmOut != 1'b0) begin
				#1;
				if($time - t0 > 1000*`MS_NS/125*1.01) begin
					$display("pwm: ERROR: pwm did not trigger as expected");
					$display("pwm: ERROR: stopping simulation...");
					$stop;
				end
			end
			t0 = $time;
			while (pwmOut != 1'b1) begin
				#1;
				if($time - t0 > 1000*`MS_NS/125*1.01) begin
					$display("pwm: ERROR: pwm did not trigger as expected");
					$display("pwm: ERROR: stopping simulation...");
					$stop;
				end
			end
			t0 = $time;

			progress = 0;
			while (pwmOut != 1'b0) begin
				#1;
				if (progress == 1000000) begin
					$write(".");
					progress = 0;
				end
				else
					progress = progress + 1;

				if($time-t0 > setcontrolInput*`K1_25_NS*`SIMPRESCALE/256+setcontrolInput*`K1_25_NS*`SIMPRESCALE/256*0.01) begin					// 0.1%  accuracy expected
					$display("pwm: ERROR: pwm pulse length was more than 1 %% longer than expected nominal: %d ns, allowed accuracy +/- %d ns, breaking at %d ns", setcontrolInput*`K1_25_NS*`SIMPRESCALE/256, setcontrolInput*`K1_25_NS*`SIMPRESCALE/256*0.01, $time-t0);
					$display("pwm: ERROR: stopping simulation...");
					$stop;
				end
			end
			$display("");
			if($time-t0 < setcontrolInput*`K1_25_NS*`SIMPRESCALE/256-setcontrolInput*`K1_25_NS*`SIMPRESCALE/256*0.01) begin						// 0.1 % accuracy expected
				$display("pulse: ERROR: pwm pulse > 1 %% shorter than expected, expected nominal %d ns, allowed accuracy +/- %d ns, actual pulselength: %d ns", setcontrolInput*`K1_25_NS*`SIMPRESCALE/256, setcontrolInput*`K1_25_NS*`SIMPRESCALE/256*1000*0.01, $time-t0);
				$display("pulse: ERROR: stopping simulation...");
				$stop;
			end

			while (pwmOut != 1'b1) begin
				#1;
				if (progress == 1000000) begin
					$write(".");
					progress = 0;
				end
				else
					progress = progress + 1;
				if($time-t0 > `K1_25_NS*`SIMPRESCALE+`K1_25_NS*`SIMPRESCALE*0.01) begin					// 1%  accuracy expected
					$display("pwm: ERROR: pwm cycle length was more than 1 %% longer than expected nominal: %d ns, allowed minimum: %d ns, breaking at %d ns", `K1_25_NS*`SIMPRESCALE, `K1_25_NS*`SIMPRESCALE*0.01, $time-t0);
					$display("pwm: ERROR: stopping simulation...");
					$stop;
				end
			end
			$display("");
			if($time-t0 < `K1_25_NS*`SIMPRESCALE-`K1_25_NS*`SIMPRESCALE*0.01) begin						// 0.1 % accuracy expected
				$display("pwm: ERROR: pwm cycle length > 1 %% shorter than expected, expected nominal %d ns, allowed minimum: %d ns, actual pulselength: %d ns", `K1_25_NS*`SIMPRESCALE, `K1_25_NS*`SIMPRESCALE-`K1_25_NS*`SIMPRESCALE*0.01, $time-t0);
				$display("pwm: ERROR: stopping simulation...");
				$stop;
			end
			t0 = $time;


			$display("pwm: PASS: pwm duty cycle and repitition was as expected (+/- 1 %%), duty-cycle: %d percent", setcontrolInput*100/256);
			controlInput = controlInput + 8'h10;
			load <= 1'b0;
			#(`US_NS);
		end
		$display("pwm: PASS TC-1A: Sweeping all pwm duty-cycles from 1 to 255 with increments of 16, expected +/- 1 %% accuarcy has passed");
		$stop;
	end
endmodule