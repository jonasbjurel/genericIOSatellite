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
/* pwm is a programable pwm generator, generating pwm pulses from 0 % duty cycle (which generates all 0) to 100% duty cycle (which generates all 1) */
/* Input:																																			*/
/* masterClk: A high frequency master clock to wich the module inputs and outputs are synchronized to, frequency > ~30 MHz							*/
/* controlInput(synch): The PWM duty input(0-255)																									*/
/* load(Synch): controlInput loads at posetive edge of load																							*/
/* reset(Synch): At posedge of reset the CRC calculation is restarted																				*/
/* Output:																																			*/
/* pwmOut: pwmOut provides the PWM signal																											*/
/* Module static parameters:																														*/
/* PRESCALE: defines the PWM cycle time, 1: 1,25 Khz, 100: 125 Hz., etc...																			*/
/* Comments: -																																		*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

`ifdef TOP																			// Some vlog tools flatterns the design to one common directory
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
	reg[$clog2(`K1_25_PWM_STEP*PRESCALE)-1:0] cycleCnt = 0;							// cycleCnt is used to create the PWM step 
	reg[7:0] stepCnt = 8'b0;														// stepCnt counts the pwm steps 0-255 (0-100% duty time)

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Signal edge definitions																															*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	reg prevLoad;
	always @(posedge masterClk) begin
		prevLoad <= load;
	end
	`define PWM_LOAD_POSEDGE (load && !prevLoad)
	`define PWM_LOAD_NEGEDGE (!load && prevLoad)
/*-------------------------------------------------------END Signal edge definitions---------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* PWM generation																																	*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
	always @(posedge masterClk) begin
		if(`PWM_LOAD_POSEDGE) begin
			control <= controlInput;												// Latch the control input data
		end
		else if(stepCnt == 8'hFF) begin												// At the full PWM cycle, start the PWM pulse
			cycleCnt <= 0;									
			stepCnt <= 0;
			if(control != 0)
				pwmOut <= 1'b1;
			else
				pwmOut <= 1'b0;
		end
		else if(cycleCnt >= `K1_25_PWM_STEP*PRESCALE) begin							// At the end of a pwm step, increase the stepCnt
			cycleCnt <= 0;
			stepCnt <= stepCnt + 1'b1;			
		end
		else if(stepCnt >= control) begin											// If stepCnt matches the control input, end the pwm pulse
			pwmOut <= 1'b0;
			cycleCnt <= cycleCnt + 1'b1;
		end
		else
			cycleCnt <= cycleCnt + 1'b1;
	end
endmodule