`timescale 1ns/10ps
`define MAX_SKEW	75														//Alowed Data skew [ns]

`define FEEDBACK_PAD	4'b0
`define RESERVED_PAD	4'b0
`define SENSOR_PAD		8'b0

`define NO_OF_SATELITES			3
`define SAT_BIT_TRAIN_LEN		(`CRC_WD + `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD)
`define TOT_BIT_TRAIN_LEN		`NO_OF_SATELITES*`SAT_BIT_TRAIN_LEN

`define MODE_LOW		3'h0
`define MODE_HIGH		3'h1
`define MODE_PWM125K	3'h2
`define MODE_PWM100		3'h3
`define MODE_PULSE		3'h4
`define MODE_PULSE_INV	3'h5



`define DONT_RESET		0
`define DO_RESET		1
`define CRC_OK			0
`define CRC_BAD			1


`define WS2811_SEND(BUFF, SIZE, ITTER, RESET, CRC_MODE) \
	$display("Send buffer: %b (0x%h)", BUFF, BUFF); \
	$write("genericIOSatelite_TB: INFO: Injecting ws2811 bitstream: "); \
	resetRxCrc4 = 1; \
	#10; \
	resetRxCrc4 = 0; \
	disableRxCrc4Calc = 0; \
	#10; \
	for(ITTER=SIZE; ITTER > 0; ITTER=ITTER-1) begin \
		$write("%b", BUFF[ITTER-1+:1]); \
		ws2811SimGenData = BUFF[ITTER-1+:1]; \
		ws2811SimGenClk = 0; \
		#(`K800_NS/2); \
		ws2811SimGenClk = 1; \
		#(`K800_NS/2); \
	end \
	$write(" (0x%h)", BUFF); \
	$write(" + CRC4: %b (0x%h)", rxCrc4, rxCrc4); \
	if(CRC_MODE != `CRC_OK) \
		$write(" , generating bad CRC4: %b (0x%h)", ~rxCrc4, ~rxCrc4); \
	disableRxCrc4Calc = 1; \
	for(ITTER=4; ITTER > 0; ITTER=ITTER-1) begin \
		if(CRC_MODE == `CRC_OK) \
			ws2811SimGenData = rxCrc4[3]; \
		else \
			ws2811SimGenData = ~rxCrc4[3]; \
		ws2811SimGenClk = 0; \
		#(`K800_NS/2); \
		ws2811SimGenClk = 1; \
		#(`K800_NS/2); \
	end \
	$display(""); \
	if(RESET == `DO_RESET) \
		#(`RESET_NS+100); \
	else \
		#(`RESET_NS-10000); 

// Last else is pure testcode

`define CHK_TX_CRC_ERR(ITTER1, ITTER2, CRC_REG, ERR) \
	ERR=1'b0; \
	for(ITTER1=0; ITTER1<`NO_OF_SATELITES; ITTER1=ITTER1+1) begin \
		CRC_REG = 5'b0; \
		for(ITTER2=(ITTER1+1)*`SAT_BIT_TRAIN_LEN-1; ITTER2>ITTER1*`SAT_BIT_TRAIN_LEN+`CRC_WD-1; ITTER2=ITTER2-1) begin \
			CRC_REG[4] = CRC_REG[3]; \
			CRC_REG[3] = CRC_REG[2]; \
			CRC_REG[2] = CRC_REG[1]; \
			CRC_REG[1] = CRC_REG[4]+CRC_REG[0]+outCheckReg[ITTER2]; \
			CRC_REG[0] = CRC_REG[4]+outCheckReg[ITTER2]; \
		end \
		if(CRC_REG[3:0] != outCheckReg[ITTER2 -:4]) \
			ERR=ERR|1; \
	end 
	

`define GEN_TX_CRC_ERR(ITTER1, ITTER2, CRC_REG, ERR) \
	outCheckReg[$urandom%`SAT_BIT_TRAIN_LEN] = outCheckReg[$urandom%`SAT_BIT_TRAIN_LEN]+1;


`define REMOTE_CRC_ERR(SATELITE) \
	outCheckReg[SATELITE*(`SAT_BIT_TRAIN_LEN) + `CRC_WD + `FEEDBACK_WD-1 -:`FEEDBACK_WD] & `FEEDBACK_REMOTECRCERR

`define CHECK_SENSORS(VALUE, ITTER) \
	for(ITTER=0; ITTER<`NO_OF_SATELITES; ITTER=ITTER+1) begin \
		if(outCheckReg[(ITTER+1)*`SAT_BIT_TRAIN_LEN-1 -:8] != VALUE) begin \
			$write("ERROR: Sensor data: %d for satelite %d was not expected, expected %d - stopping...", outCheckReg[(ITTER+1)*`TOT_BIT_TRAIN_LEN/3-1 -:8], ITTER, VALUE ); \
			$stop; \
		end \
		else \
			$write("PASS: Sensor data: %d for satelite %d was as expected  ", outCheckReg[(ITTER+1)*`SAT_BIT_TRAIN_LEN-1 -:8], ITTER); \
	end \
	$display("");

//Generates a ws2811 value on dataIn, with defined skew
`define WS2811_GENERATE(WIRE, VALUE, SKEW) \
	for(valIndex=0; valIndex<8; valIndex=valIndex+1) begin \
		WIRE = 1'b1; \
		if(VALUE & 8'b10000000 >> valIndex) begin \
			#(`T1H_NS+SKEW); \
			WIRE = 1'b0; \
			#(2*`K800_HALF_NS-`T1H_NS-(SKEW)); \
		end \
		else begin \
			#(`T0H_NS+SKEW); \
			WIRE = 1'b0; \
			#(2*`K800_HALF_NS-`T0H_NS-(SKEW)); \
		end \
	end

// Generates a ws2811 reset pulse
`define WS2811_GENERATE_END(WIRE) \
	WIRE = 1'b0; \
	#(`RESET_NS + 1000);

// Checks the ws2811Decoder active pin state
`define CHECK_ACTIVE(WIRE, VALUE) \
	if (WIRE === VALUE) \
		$display("ws2811Decoder: PASS: active was as expected, %b was expected and %b was detected", VALUE, WIRE); \
	else begin \
		$display("ws2811Decoder: ERROR: active was not as expected, %b was expected, but %b was detected", VALUE, WIRE); \
		$display("ws2811Decoder: Stopping further simulation..."); \
		$stop; \
	end

`define SET_WIRE_32(MODULE, REG, VALUE3, VALUE2, VALUE1, VALUE0) \
	REG[31:24] = VALUE3; \
	REG[23:16] = VALUE2; \
	REG[15:8] = VALUE1; \
	REG[7:0] = VALUE0;

`define CHECK_WIRE_32(MODULE, WIRE, VALUE3, VALUE2, VALUE1, VALUE0) \
	if (WIRE[31:24]===VALUE3 && WIRE[23:16]===VALUE2 && WIRE[15:8]===VALUE1 && WIRE[7:0]===VALUE0) \
		$display("%s: PASS: %s results were as expected, %b %b %b %b was expected, and %b %b %b %b was detected", MODULE, WIRE, VALUE3, VALUE2, VALUE1, VALUE0, WIRE[31:24], WIRE[23:16], WIRE[15:8], WIRE[7:0]); \
	else begin \
		$display("%s: ERROR: %s results were not as expected, %b %b %b %b was expected, but %b %b %b %b was detected", MODULE, WIRE, VALUE3, VALUE2, VALUE1, VALUE0, WIRE[31:24], WIRE[23:16], WIRE[15:8], WIRE[7:0]); \
		$display("%s: Stopping further simulation...", MODULE); \
		$stop; \
	end

`define CHECK_WIRE_1(MODULE, WIRE, VALUE) \
	if (WIRE===VALUE) \
		$display("%s: PASS: %s results were as expected, %b was expected, and %b was detected", MODULE, WIRE, VALUE, WIRE); \
	else begin \
		$display("%s: ERROR: %s results were not as expected, %b was expected, was detected", MODULE, WIRE, VALUE, WIRE); \
		$display("%s: Stopping further simulation...", MODULE); \
		$stop; \
	end

`define LOAD_SERIAL_GEN_32(MODULE, REG, VALUE3, VALUE2, VALUE1, VALUE0) \
	`SET_WIRE_32(MODULE, REG, VALUE3, VALUE2, VALUE1, VALUE0)

/*`define SHIFT_SERIAL_GEN_32(MODULE, REG, WIRE, ITTER, CLK, CYC_NS) \
	CLK = 0; \
	#(CYC_NS/2); \
	for (ITTER=32; ITTER>0; ITTER=ITTER-1) begin \
		WIRE = REG[ITTER-1]; \
		CLK = 1; \
		#(CYC_NS/2); \
		CLK = 0; \
		#(CYC_NS/2); \
	end*/

	`define SHIFT_SERIAL_GEN_32(MODULE, REG, WIRE, ITTER, CLK, CYC_NS) \
	for (ITTER=32; ITTER>0; ITTER=ITTER-1) begin \
		CLK = 0; \
		#(CYC_NS/2); \
		WIRE = REG[ITTER-1]; \
		CLK = 1; \
		#(CYC_NS/2); \
	end

	`define PROBE_TYPE_PWM						0
	`define PROBE_TYPE_PULSE_LENGTH				1

	`define PROBE_READY							0
	`define PROBE_ARMED							1
	`define PROBE_TRIGGERED1					2
	`define PROBE_TRIGGERED2					3
	`define PROBE_ERR							255

	`define ERR_CAUSE_NONE						0
	`define ERR_CAUSE_TRIGGER1_TIMEOUT			1
	`define ERR_CAUSE_TRIGGER2_TIMEOUT			2
	`define ERR_CAUSE_READY_TIMEOUT				3
	`define ERR_CAUSE_DESC						"1: TRIGGER1_TIMEOUT, 2: TRIGGER2_TIMEOUT, 3: READY_TIMEOUT"

	`define TRIGGER_EDGE_POS					0
	`define TRIGGER_EDGE_NEG					1





	module PROBE(input wire[7:0] type_p, input wire pin, input wire triggerEdge_p, input wire[63:0] timeout_p, input wire arm, input wire masterClk, output reg[7:0] state = `PROBE_READY, output reg[7:0] errCause = `ERR_CAUSE_NONE, output reg[63:0] pulseTime = 0, output reg[63:0] timeToTrigger = 0, output reg[63:0] cycleTime = 0);	
		reg triggerEdge, prevArm, prevPin;
		reg[7:0] type;
		reg[63:0] timeout;
		time t0;

		always @ (posedge masterClk) begin 
			prevArm <= arm;
			prevPin <= pin;
			if(arm && !prevArm) begin
				t0 = $time;
				state = `PROBE_ARMED;
				errCause = `ERR_CAUSE_NONE;
				type = type_p;
				triggerEdge = triggerEdge_p;
				timeout = timeout_p;
				pulseTime = 0;
				cycleTime = 0;
			end
			else if(timeout && $time-t0 > timeout && state != `PROBE_READY) begin
				if(state == `PROBE_ARMED)
					errCause = `ERR_CAUSE_TRIGGER1_TIMEOUT;
				else if(state == `PROBE_TRIGGERED1)
					errCause = `ERR_CAUSE_TRIGGER2_TIMEOUT;
				else if(state == `PROBE_TRIGGERED2)
					errCause = `ERR_CAUSE_READY_TIMEOUT;
				state = `PROBE_ERR;
			end
			else if(state == `PROBE_ARMED) begin
				if(triggerEdge == `TRIGGER_EDGE_POS && pin && !prevPin) begin
					state = `PROBE_TRIGGERED1;
					timeToTrigger = $time - t0;
				end
				else if(triggerEdge == `TRIGGER_EDGE_NEG && !pin && prevPin) begin
					state = `PROBE_TRIGGERED1;
					timeToTrigger = $time - t0;
				end
			end
			else if(state == `PROBE_TRIGGERED1) begin
				if(triggerEdge == `TRIGGER_EDGE_POS && !pin && prevPin) begin
					pulseTime = $time - t0 - timeToTrigger;
					if(type == `PROBE_TYPE_PWM)
						state = `PROBE_TRIGGERED2;
					else
						state = `PROBE_READY;
				end
				else if(triggerEdge == `TRIGGER_EDGE_NEG && pin && !prevPin) begin
					pulseTime = $time - t0 - timeToTrigger;
					if(type == `PROBE_TYPE_PWM)
						state = `PROBE_TRIGGERED2;
					else
						state = `PROBE_READY;
				end
			end
			else if (state == `PROBE_TRIGGERED2) begin
				if(triggerEdge == `TRIGGER_EDGE_POS && pin && !prevPin) begin
					cycleTime = $time - t0 - timeToTrigger;
					state = `PROBE_READY;
				end
				else if(triggerEdge == `TRIGGER_EDGE_NEG && !pin && prevPin) begin
					cycleTime = $time - t0 - timeToTrigger;
					state = `PROBE_READY;
				end
			end
		end
	endmodule