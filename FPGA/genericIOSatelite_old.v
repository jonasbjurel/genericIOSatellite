/* Description
You push in following:
n*{[3:0] [7:0]actuatorcontrol, [3:0] [3:0] actuatormode, [3:0] rxCrc4}
out comes:
{n*{[7:0] sensordata, [2:0] reserved, remoteCrcError, [3:0] txCrc4}, n*{[X:Y] Garbage}}

*/

//`define TOP	1
`include "genericIOSateliteEnv.v"
`include "pulse/pulse.v"
`include "pwm/pwm.v"
`include "latchReg/latchReg.v"
`include "shiftReg/shiftReg.v"
`include "ws2811Decoder/ws2811Decoder.v"
`include "ws2811Encoder/ws2811Encoder.v"
`include "crc4/crc4.v"

module actuatorPin (input serialIn,
					input serialClk,
					input enableShift,
					input wire[2:0] mode,
					input masterClk,
					output reg actuator,
					output serialOut);

	`define LOW			0
	`define HIGH		1
	`define PWM1_25K	2
	`define PWM100		3
	`define PULSE		4
	`define PULSE_INV	5

	wire[7:0] actuatorData;
	wire PWM1_25KOutput;
	wire pwm100Output;
	wire pulseOutput;
	wire pulseInvOutput;
	reg prevEnableShift;
	reg[1:0] actuatorLoadDelay;
	wire actuatorLoad;

	shiftReg #(.WIDTH(8)) actuatorShift(.serialInput(serialIn), .clk(serialClk), .load(1'b0), .loaded(), .enableShift(enableShift), .masterClk(masterClk), .parallelInput(8'b0), .parallelOutput(actuatorData), .serialOutput(serialOut));
	pwm #(.PRESCALE(1)) actuatorPwm1_25K(.controlInput(actuatorData), .load(actuatorLoad), .masterClk(masterClk), .pwmOut(pwm1_25KOutput));
	pwm #(.PRESCALE(12)) actuatorPwm100(.controlInput(actuatorData), .load(actuatorLoad), .masterClk(masterClk), .pwmOut(pwm100Output));
	pulse actuatorPulse(.pulseLength(actuatorData), .trigger(actuatorLoad && (mode == `PULSE || mode == `PULSE_INV)), .masterClk(masterClk), .pulse(pulseOutput), .pulseInv(pulseInvOutput));
	
	always @ (posedge masterClk) begin
		prevEnableShift <= enableShift;
		if(!enableShift && prevEnableShift)
			actuatorLoadDelay <= 2'b0;
		else if(actuatorLoadDelay != 2'b11)
			actuatorLoadDelay <= actuatorLoadDelay + 1'b1;
	end
	assign actuatorLoad = actuatorLoadDelay[1] & actuatorLoadDelay[0];
	always @ (*) begin
		case (mode)
			`LOW : actuator <= 0;
			`HIGH : actuator<=1;
			`PWM1_25K : actuator<=pwm1_25KOutput;
			`PWM100 : actuator<=pwm100Output;
			`PULSE : actuator<=pulseOutput;
			`PULSE_INV : actuator<=pulseInvOutput;
			default : actuator<=0;
		endcase
	end
endmodule

module actuators(input serialDataIn,
				 input serialClk,
				 input enableShift,
				 input masterClk,
				 input disableActuators,
				 output wire[3:0] actuator,
				 output wire serialDataOut);

	wire serial_1;
	wire serial_2;
	wire serial_3;
	wire serial_4;
	wire serial_5;

	wire[3:0] modeRegHalfByte_0;
	wire[7:0] modeRegByte_1;

	wire[2:0] mode_0;
	wire[2:0] mode_1;
	wire[2:0] mode_2;
	wire[2:0] mode_3;
	
	assign mode_0 = modeRegHalfByte_0[2:0];
	assign mode_1 = {modeRegByte_1[1:0], modeRegHalfByte_0[3]};
	assign mode_2 = modeRegByte_1[4:2];
	assign mode_3 = modeRegByte_1[7:5];

	shiftReg #(.WIDTH(4)) modeReg_0(.serialInput (serialDataIn), .clk (serialClk), .load (1'b0), .loaded (), .enableShift (enableShift | disableActuators), .masterClk (masterClk), .parallelInput (4'b0), .parallelOutput (modeRegHalfByte_0), .serialOutput (serial_1));
	shiftReg #(.WIDTH(8)) modeReg_1(.serialInput (serial_1), .clk (serialClk), .load (1'b0), .loaded (), .enableShift (enableShift | disableActuators), .masterClk (masterClk), .parallelInput (8'b0), .parallelOutput (modeRegByte_1), .serialOutput (serial_2));
	actuatorPin actuator_0(.serialIn (serial_2), .serialClk (serialClk), .enableShift (enableShift | disableActuators), .mode (mode_0), .masterClk (masterClk), .actuator (actuator[0]), .serialOut (serial_3));
	actuatorPin actuator_1(.serialIn (serial_3), .serialClk (serialClk), .enableShift (enableShift | disableActuators), .mode (mode_1), .masterClk (masterClk), .actuator (actuator[1]), .serialOut (serial_4));
	actuatorPin actuator_2(.serialIn (serial_4), .serialClk (serialClk), .enableShift (enableShift | disableActuators), .mode (mode_2), .masterClk (masterClk), .actuator (actuator[2]), .serialOut (serial_5));
	actuatorPin actuator_3(.serialIn (serial_5), .serialClk (serialClk), .enableShift (enableShift | disableActuators), .mode (mode_3), .masterClk (masterClk), .actuator (actuator[3]), .serialOut (serialDataOut));

endmodule

module sensors(input serialDataIn,
			   input serialClk,
			   input enableShift,
			   input[7:0] sense,
			   input masterClk,
			   output serialDataOut);

	wire loaded;
	wire[7:0] senseLatched;
	
	latchReg #(.WIDTH(8)) senseLatch(.latchInput (sense), .reset (loaded), .masterClk (masterClk), .latchOutput (senseLatched));
	shiftReg #(.WIDTH(8)) senseReg(.parallelInput (senseLatched), .serialInput(serialDataIn), .clk (serialClk), .load (enableShift), .parallelOutput(), .enableShift (enableShift), .masterClk (masterClk), .serialOutput (serialDataOut), .loaded (loaded));
endmodule

module logictop(input ws2811wireIn,					//Device independent top level
	input[7:0] sensorInput,
	input masterClk,
	output[3:0] actuators,
	output ws2811wireOut,
	output wire active,
	output reg crcRxErr,
	output reg wdDisableActuators);

	wire serialDataIn;
	wire serialClk;
	reg prevSerialClk;
	reg prevActive;
	wire serialDataOut;
	reg[3:0] crcRxShift;
	reg[3:0] command;
	reg[3:0] feedback;
	reg[6:0] rxCnt;
	reg[6:0] txCnt;
	wire[3:0] crcTxCalcRes;
	wire[3:0] crcRxCalcRes;
	reg freezeRxCrcCalc;
	reg freezeTxCrcCalc;
	reg crcRxReset;
	reg crcTxReset;
	reg shiftCrcTx;
	wire serialAct2Sens;
	reg[($clog2(`WATCHDOG_TIMEOUT_CYC))-1:0] watchdogReg = 0;
	wire[3:0] preWdActuators;
	reg cmdInverseCrc;
	reg cmdEnable;

	always @ (posedge masterClk) begin							//Procedure to detect active and serial clk edges
		prevSerialClk <= serialClk;
		prevActive <= active;
	end
	`define SERIALCLK_POSEDGE serialClk && !prevSerialClk
	`define SERIALCLK_NEGEDGE !prevSerialClk && prevSerialClk
	`define ACTIVE_POSEDGE active && !prevActive
	`define ACTIVE_NEGEDGE !active && prevActive

	// 500 ms Watchdog
	always @ (posedge masterClk) begin
		if (`ACTIVE_POSEDGE) begin
			watchdogReg <= 0;
			wdDisableActuators <= 1'b0;
		end
		else if(watchdogReg<`WATCHDOG_TIMEOUT_CYC)
			watchdogReg <= watchdogReg + 1'b1;
		else if(watchdogReg>=`WATCHDOG_TIMEOUT_CYC)
			wdDisableActuators <= 1'b1;
	end


	always @ (posedge masterClk) begin							//Procedure to detect active and serial clk edges
		if (`ACTIVE_POSEDGE) begin
			if(crcRxErr)
				feedback <= feedback | `FEEDBACK_REMOTECRCERR;	// Latch in any remote CRC error from RX CRC evaluation
			else
				feedback <= feedback & ~`FEEDBACK_REMOTECRCERR;	// Latch in any remote CRC error from RX CRC evaluation

		end
		else if(`SERIALCLK_POSEDGE) begin
			crcRxShift[0] <= serialDataIn;
			crcRxShift[1] <= crcRxShift[0];
			crcRxShift[2] <= crcRxShift[1];
			crcRxShift[3] <= crcRxShift[2];
			feedback[0] <= crcRxShift[3];
			feedback[1] <= feedback[0];
			feedback[2] <= feedback[1];
			feedback[3] <= feedback[2];
			command[0] <= feedback[3];
			command[1] <= command[0];
			command[2] <= command[1];
			command[3] <= command[2];

		end
	end


	always @ (posedge masterClk) begin							// RX CRC validation
		if(`ACTIVE_POSEDGE) begin								// @ posedge active, start of a new ws2811 transaction
																// Load rxCnt with full satelite shift register length
			rxCnt <= `CRC_WD + `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD;
			freezeRxCrcCalc <= 1'b0;							// Reset CRC4 calculation register and start CRC4 calculation of received bit train
			crcRxReset <= 1'b1;
		end
		else if(`SERIALCLK_POSEDGE) begin						// @ posedge activeserialClk
			if(rxCnt>`CRC_WD + 1'b1) begin						// Trailing CRC4 checksum not yet being shifting in
				rxCnt <= rxCnt - 1'b1;
				crcRxReset <= 0;
			end
			else if(rxCnt == `CRC_WD + 1'b1) begin				// Start of CRC4 shift in, stop CRC calculation
				freezeRxCrcCalc <= 1'b1;
				rxCnt <= rxCnt - 1'b1;
			end
																//Shift in all 4 CRC4 checksum bits, stop counting and evaluate - see top of this procedure
			else if( rxCnt < `CRC_WD + 1'b1 && rxCnt > 7'b0) begin
				rxCnt <= rxCnt - 1'b1;
			end
		end
		if(rxCnt == 7'b0) begin									// Alignment with a full satelite shift register length 
			if(crcRxCalcRes == crcRxShift)						// Set CRC error depending on received and calculated CRC4 check sum
				crcRxErr <= 1'b0;
			else
				crcRxErr <= 1'b1;
																// Load rxCnt with full satelite shift register length 
			rxCnt <= `CRC_WD + `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD;
			freezeRxCrcCalc <= 1'b0;							// Reset CRC4 calculation register and start CRC4 calculation of received bit train
			crcRxReset <= 1'b1;
		end
	end


	always @ (posedge masterClk) begin							// TX CRC calculation
		if(`ACTIVE_POSEDGE) begin								// New WS2811 session
																// Load txCnt with full satelite shift register length
			txCnt <= `CRC_WD + `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD;
			crcTxReset <= 1'b1;									// Reset the TX CRC4 registers for a new CRC calculation
			freezeTxCrcCalc <= 1'b0;							// Enable CRC calculation
			shiftCrcTx <= 0;									// Disable shift out of CRC4 results
		end
		else if(`SERIALCLK_POSEDGE) begin						// @ (posedge serialClk)
			if(txCnt>`CRC_WD + 1'b1) begin						// All sensors and feedBackReg's have been shifted out, CRC checksum calcs complete, freeze further CRC calc, and shift out the 4 bit CRC check-sum
				txCnt <= txCnt - 1'b1;
				crcTxReset <= 1'b0;
			end
			else if(txCnt == `CRC_WD + 1'b1) begin				// Start of CRC4 shift out, stop CRC calculation
				txCnt <= txCnt - 1'b1;
				freezeTxCrcCalc <= 1'b1;
				shiftCrcTx <= 1'b1;
			end
			else if( txCnt < `CRC_WD + 1'b1 && txCnt > 7'b0) begin
				txCnt <= txCnt - 1'b1;
			end
			//else if( txCnt == 7'b0) begin
				//shiftCrcTx <= 1'b0;
				//freezeTxCrcCalc <= 1'b1;
			//end
		end
		else if(txCnt == 7'b0)
			shiftCrcTx <= 1'b0;
	end

	always @ (posedge masterClk) begin							// Latch commands
		if(`ACTIVE_NEGEDGE) begin
			if (crcRxErr)
				cmdInverseCrc <= 1'b0;
			else begin
				cmdInverseCrc <= command[1];
				cmdEnable <= command[2];
			end
		end
	end


	ws2811Decoder ws2811Decoder_0(.masterClk (masterClk), .dataIn (ws2811wireIn), .dataOut (serialDataIn), .dataClk (serialClk), .active (active));
	crc4 crcRxCalc(.serialData(serialDataIn), .serialClk(serialClk & ~freezeRxCrcCalc), .reset(crcRxReset), .enable(1'b1), .masterClk(masterClk), .crc4(crcRxCalcRes));
	actuators actuators_0(.serialDataIn (command[3]), .serialClk (serialClk), .enableShift (active), .masterClk (masterClk), .disableActuators(crcRxErr), .actuator (preWdActuators), .serialDataOut(serialAct2Sens));
	sensors sensors_0(.serialDataIn (serialAct2Sens), .serialClk (serialClk), .enableShift (active), .sense (sensorInput), .masterClk (masterClk), .serialDataOut (serialDataOut));
	crc4 crcTxCalc(.serialData(serialDataOut), .serialClk(serialClk), .reset(crcRxReset), .enable(~freezeTxCrcCalc), .masterClk(masterClk), .crc4(crcTxCalcRes));
	ws2811Encoder ws2811Encoder_0(.dataIn (~shiftCrcTx & serialDataOut | shiftCrcTx & (crcTxCalcRes[3]^cmdInverseCrc)), .dataClk (serialClk), .masterClk (masterClk), .dataOut (ws2811wireOut));
	assign actuators = {preWdActuators[3] & ~wdDisableActuators & cmdEnable, preWdActuators[2] & ~wdDisableActuators & cmdEnable, preWdActuators[1] & ~wdDisableActuators & cmdEnable, preWdActuators[0] & ~wdDisableActuators & cmdEnable};
endmodule

//Device dependant modules
module sysClkGen(output masterClk);
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());
endmodule

module designtop (input ws2811wireIn, input[7:0] sensorInput, output ws2811wireOut, output[3:0] actuators, output active, output err);

	wire masterClk;
	wire crcRxErr;
	wire wdDisableActuators;
	
	sysClkGen sysClck(.masterClk (masterClk));
	logictop satelite(.ws2811wireIn (ws2811wireIn), .masterClk (masterClk), .sensorInput (sensorInput), .actuators (actuators), .ws2811wireOut (ws2811wireOut), .active (active), .crcRxErr (crcRxErr), .wdDisableActuators (wdDisableActuators));
	assign err = crcRxErr | wdDisableActuators;
endmodule