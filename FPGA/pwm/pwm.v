/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* pwm is a programable pwm generator, generating pwm pulses from 0 % duty cycle (which does not generate a pulse) to 100% duty cycle				*/
/* See pulse.v for more information																													*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

`ifdef TOP
	`include "genericIOSateliteEnv.v"
`else
	`include "../genericIOSateliteEnv.v"
`endif

module pwm	#(parameter PRESCALE = 1)
			(input wire[7:0] controlInput,
			 input load,
			 input masterClk,
			 output reg pwmOut);

	reg[7:0] control = 8'b0;
	reg[$clog2(`K1_25_PWM_STEP*PRESCALE)-1:0] cycleCnt = 0;	// cycleCnt is used to create the PWM step 
	reg[7:0] stepCnt = 8'b0;								// stepCnt counts the pwm steps 0-255 (0-100% duty time)
	reg prevLoad;

	always @(posedge masterClk) begin
		prevLoad <= load;
		if(!prevLoad && load) begin							// @ posetive edge of load
			control <= controlInput;						// Latch the control input data
		end
		else if(stepCnt == 8'hFF) begin						// At the full PWM cycle, start the PWM pulse
			cycleCnt <= 0;									
			stepCnt <= 0;
			if(control != 0)
				pwmOut <= 1'b1;
			else
				pwmOut <= 1'b0;
		end
		else if(cycleCnt >= `K1_25_PWM_STEP*PRESCALE) begin	// At the end of a pwm step, increase the stepCnt
			cycleCnt <= 0;
			stepCnt <= stepCnt + 1'b1;			
		end
		else if(stepCnt >= control) begin					// If stepCnt matches the control input, end the pwm pulse
			pwmOut <= 1'b0;
			cycleCnt <= cycleCnt + 1'b1;
		end
		else
			cycleCnt <= cycleCnt + 1'b1;
	end
endmodule