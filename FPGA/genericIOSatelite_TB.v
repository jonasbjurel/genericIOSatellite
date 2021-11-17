/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* pulse is a programming pulsegenerator, generating pulses from 0 ms(which does not generate a pulse) to 255 ms +/- 10%							*/
/* See pulse.v for more information																													*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`include "genericIOSateliteEnv.v"
`include "genericIOSateliteEnv_TB.v"
`include "genericIOSatelite.v"
//`include "ws2811Encoder/ws2811Encoder.v"


module genericIOSatelite_TB ();
	wire masterClk;
	reg ws2811SimGenData = 1'b0;
	reg ws2811SimGenClk = 1'b0;
	wire ws2811wireIn;
	wire ws2811wire01;
	wire ws2811wire12;
	wire ws2811wire23;
	wire ws2811wireOut;
	reg[7:0] sensorInput[2:0];
	wire[3:0] actuators[2:0];

	wire evalSerialOutData;
	wire evalSerialOutClk;
	reg[`CRC_WD + `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD-1:0] ws2811SendBuff;
	wire[3*(`CRC_WD + `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD)-1:0] outCheckReg;
	reg[7:0] sweep;
	reg resetRxCrc4 = 1'b0;
	reg disableRxCrc4Calc = 1'b0;
	wire[3:0] rxCrc4;
	reg[4:0] txCrc4;
	reg txCrcErr;

	reg[7:0] probeType[11:0];
	reg probeTriggerEdge[11:0];
	reg[63:0] probeTimeout[11:0];
	reg probeArm[11:0];
	wire[7:0] probeState[11:0];
	wire[7:0] probeErrCause[11:0];
	wire[63:0] probePulseTime[11:0];
	wire[63:0] probeTimeToTrigger[11:0];
	wire[63:0] probeCycleTime[11:0];

	time i, t0, triggerPulse, tPulse, tPulsePos, triggerPulseInv, tPulseInv, tPulseInvPos, max1, min1, max2, min2;

	integer genIndex, genIndex2, genIndex3; // move to top
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());
	crc4 ws2811SimGenCrc4(.serialData(ws2811SimGenData), .serialClk(ws2811SimGenClk), .reset(resetRxCrc4), .enable(~disableRxCrc4Calc), .masterClk(masterClk), .crc4(rxCrc4));
	ws2811Encoder ws2811SimGen(.dataIn(ws2811SimGenData), .dataClk(ws2811SimGenClk), .masterClk(masterClk), .dataOut(ws2811wireIn));
	designtop DUT0(.ws2811wireIn(ws2811wireIn), .sensorInput(sensorInput[0]), .ws2811wireOut(ws2811wire01), .actuators(actuators[0]));
	designtop DUT1(.ws2811wireIn(ws2811wire01), .sensorInput(sensorInput[1]), .ws2811wireOut(ws2811wire12), .actuators(actuators[1]));
	designtop DUT2(.ws2811wireIn(ws2811wire12), .sensorInput(sensorInput[2]), .ws2811wireOut(ws2811wireOut), .actuators(actuators[2]));
	ws2811Decoder ws2811SimEval(.masterClk( masterClk), .dataIn(ws2811wireOut), .dataOut(evalSerialOutData), .dataClk(evalSerialOutClk), .active(evalSerialOutActive));
	shiftReg #(.WIDTH(3*(`CRC_WD + `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD))) serialOutCheckReg(.parallelInput(0), .serialInput(evalSerialOutData), .clk(evalSerialOutClk), .load(1'b0), .enableShift(evalSerialOutActive), .masterClk(masterClk), .parallelOutput(outCheckReg), .serialOutput(), .loaded());

	genvar probeIndex0, probeIndex1;
	generate
		for (probeIndex0=0; probeIndex0 < 4; probeIndex0=probeIndex0+1) begin
			for (probeIndex1=0; probeIndex1 < 3; probeIndex1=probeIndex1+1) begin
				PROBE probe (.type_p(probeType[probeIndex0*3+probeIndex1]),
							 .pin(actuators[probeIndex1][probeIndex0]),
							 .triggerEdge_p(probeTriggerEdge[probeIndex0*3+probeIndex1]),
							 .timeout_p(probeTimeout[probeIndex0*3+probeIndex1]),
							 .arm(probeArm[probeIndex0*3+probeIndex1]),
							 .masterClk(masterClk),
							 .state(probeState[probeIndex0*3+probeIndex1]),
							 .errCause(probeErrCause[probeIndex0*3+probeIndex1]),
							 .pulseTime(probePulseTime[probeIndex0*3+probeIndex1]),
							 .timeToTrigger(probeTimeToTrigger[probeIndex0*3+probeIndex1]),
							 .cycleTime(probeCycleTime[probeIndex0*3+probeIndex1]));
			end
		end
	endgenerate

	initial begin
		// Initialize system verification, washing oun x's

		$display("genericIOSatelite_TB: INFO: Initializing top level simulation");
		t0=$time;
		
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1)
			probeArm[genIndex] = 0;

		sensorInput[0] = 8'h00;
		sensorInput[1] = 8'h00;
		sensorInput[2] = 8'h00;

		ws2811SendBuff = {`SENSOR_PAD, 8'h01, 8'h01, 8'h01, 8'h01, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		ws2811SendBuff = {`SENSOR_PAD, 8'h01, 8'h01, 8'h01, 8'h01, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		ws2811SendBuff = {`SENSOR_PAD, 8'h01, 8'h01, 8'h01, 8'h01, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK) //Initialize
		#1000000;
		ws2811SendBuff = {`SENSOR_PAD, 8'h10, 8'h10, 8'h10, 8'h10, `MODE_PULSE, `MODE_PWM100, `MODE_PULSE_INV, `MODE_PWM125K, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		ws2811SendBuff = {`SENSOR_PAD, 8'h10, 8'h10, 8'h10, 8'h10, `MODE_PULSE, `MODE_PWM100, `MODE_PULSE_INV, `MODE_PWM125K, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		ws2811SendBuff = {`SENSOR_PAD, 8'h10, 8'h10, 8'h10, 8'h10, `MODE_PULSE, `MODE_PWM100, `MODE_PULSE_INV, `MODE_PWM125K, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK) //Initialize

		#1000000;
		ws2811SendBuff = {`SENSOR_PAD, 8'h01, 8'h01, 8'h01, 8'h01, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		ws2811SendBuff = {`SENSOR_PAD, 8'h01, 8'h01, 8'h01, 8'h01, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		ws2811SendBuff = {`SENSOR_PAD, 8'h01, 8'h01, 8'h01, 8'h01, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK) //Initialize
		#20000000;
		
		// Testcase-0, Sweeping sensor input and verifying serial output
		$display("genericIOSatelite_TB: INFO: Running testcase-0 (TC-1A), Sweeping sensor input and verifying serial output");
		sweep=8'h0;
		for(genIndex=0; genIndex<=255; genIndex=genIndex + 1) begin
			$display("genericIOSatelite_TB: INFO: New TC-0 itteration, sweep: %d", sweep);
			sensorInput[0] = sweep;
			sensorInput[1] = sweep;
			sensorInput[2] = sweep;
			#100;
			sensorInput[0] = 8'h00;
			sensorInput[1] = 8'h00;
			sensorInput[2] = 8'h00;
			#10;
			ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_LOW, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
			#(25000+3*1500);
			$display("genericIOSatelite_TB: INFO: OutCheck Reg: %d, 0x%h", outCheckReg, outCheckReg);
			$write("genericIOSatelite_TB - TC-0: ");
			`CHECK_SENSORS(sweep, genIndex2)
			`CHK_TX_CRC_ERR(genIndex2, genIndex3, txCrc4, txCrcErr)
			if(txCrcErr) begin
				$display("genericIOSatelite_TB - TC-0: TX CRC error detected - stopping...");
				$stop;
			end
			#100;
			sweep = sweep + 8'h01;
		end
		
		// Testcase-1A, Sweeping PWMs and pulse generators upwards, as well as capturing sensor data
		$display("genericIOSatelite_TB: INFO: Running testcase-1A (TC-1A), Verifying Sweep of PWMs and pulse generators upwards, as well as capturing sweep of sensor data");
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			if(genIndex < 3) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 35000000;
			end
			else if(genIndex < 6) begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_NEG;
				probeTimeout[genIndex] = 300000000;
			end
			else if(genIndex < 9) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 25000000;
			end
			else begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 300000000;
			end
		end

		for(sweep=8'h10; sweep<8'hF0; sweep=sweep + 8'h10) begin									//Less than 16  or greater than 250 creates too small tollerances to measure
			$display("genericIOSatelite_TB: INFO: New TC-1A itteration, sweep: %d", sweep);
			//				               acc_3  acc_2  acc_1  acc_0	 acc_3	    acc_2	    acc_1      acc_0
			ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_LOW, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK) //Initialize
			#(3*1500);

			sensorInput[0] = sweep;
			sensorInput[1] = sweep;
			sensorInput[2] = sweep;
			#100;
			sensorInput[0] = 8'h00;
			sensorInput[1] = 8'h00;
			sensorInput[2] = 8'h00;
			#10;

			//				               acc_3  acc_2  acc_1  acc_0	   acc_3	    acc_2		  acc_1            acc_0
			ws2811SendBuff = {`SENSOR_PAD, sweep, sweep, sweep, sweep, `MODE_PULSE, `MODE_PWM100, `MODE_PULSE_INV, `MODE_PWM125K, `RESERVED_PAD, `FEEDBACK_PAD};

			for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
				probeArm[genIndex] = 1;
				#100;
				probeArm[genIndex] = 0;
			end

			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
			#(25000+3*1500);

			for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
				$display("genericIOSatelite_TB: INFO: TC-1A Waiting for probe %d, which is in state %d" , genIndex, probeState[genIndex]);
				while(probeState[genIndex] != `PROBE_READY && probeState[genIndex] != `PROBE_ERR)
					#1;
				if(probeState[genIndex] == `PROBE_ERR) begin
					$display("genericIOSatelite_TB - TC-1A: ERROR: Probe error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), error cause: %d, error causes: %s - stoping simulation...", genIndex, probeErrCause[genIndex], `ERR_CAUSE_DESC);
					$stop;
				end
			end

			for(genIndex = 0; genIndex < 3; genIndex = genIndex + 1) begin
				if(probePulseTime[genIndex] > sweep*(`K1_25_NS/256) + sweep*(`K1_25_NS/(256)*0.05) || probePulseTime[genIndex] < sweep*(`K1_25_NS/256) - sweep*(`K1_25_NS/(256)*0.05) || probeCycleTime[genIndex] > `K1_25_NS + `K1_25_NS*0.05 || probeCycleTime[genIndex] < `K1_25_NS - `K1_25_NS*0.05) begin
					$display("genericIOSatelite_TB - TC-1A: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: %d (expected: %d +/- 5%% - %d) stoping simulation...", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1A: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%%: %d), cycleTime: %d (expected: %d +/- 5%%: %d)", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);

				if(probePulseTime[genIndex+3] > sweep*`MS_NS + sweep*`MS_NS*0.05 || probePulseTime[genIndex+3] < sweep*`MS_NS - sweep*`MS_NS*0.05 || probeTimeToTrigger[genIndex+3] > 500000) begin
					$display("genericIOSatelite_TB - TC-1A: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+3, probeTimeToTrigger[genIndex+3], probePulseTime[genIndex+3], sweep*`MS_NS, sweep*`MS_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1A: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+3, probeTimeToTrigger[genIndex+3], probePulseTime[genIndex+3], sweep*`MS_NS, sweep*`MS_NS*0.05);

				if(probePulseTime[genIndex+6] > sweep*(`HZ100_NS/256) + sweep*(`HZ100_NS/(256)*0.05) || probePulseTime[genIndex+6] < sweep*(`HZ100_NS/256) - sweep*(`HZ100_NS/(256)*0.05) || probeCycleTime[genIndex+6] > `HZ100_NS + `HZ100_NS*0.05 || probeCycleTime[genIndex+6] < `HZ100_NS - `HZ100_NS*0.05) begin
					$display("genericIOSatelite_TB - TC-1A: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: %d (expected: %d +/- 5%% - %d) stoping simulation...", genIndex+6, probeTimeToTrigger[genIndex+6], probePulseTime[genIndex+6], sweep*(`HZ100_NS/256), sweep*(`HZ100_NS/256)*0.05, probeCycleTime[genIndex+6], `HZ100_NS, `HZ100_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1A: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%%: %d), cycleTime: %d (expected: %d +/- 5%%: %d)", genIndex+6, probeTimeToTrigger[genIndex+6], probePulseTime[genIndex+6], sweep*(`HZ100_NS/256), sweep*(`HZ100_NS/256)*0.05, probeCycleTime[genIndex+6], `HZ100_NS, `HZ100_NS*0.05);

				if(probePulseTime[genIndex+9] > sweep*`MS_NS + sweep*`MS_NS*0.05 || probePulseTime[genIndex+9] < sweep*`MS_NS - sweep*`MS_NS*0.05 || probeTimeToTrigger[genIndex+9] > 500000) begin
					$display("genericIOSatelite_TB - TC-1A: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+9, probeTimeToTrigger[genIndex+9], probePulseTime[genIndex+9], sweep*`MS_NS, sweep*`MS_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1A: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+9, probeTimeToTrigger[genIndex+9], probePulseTime[genIndex+9], sweep*`MS_NS, sweep*`MS_NS*0.05);
			end
			$write("genericIOSatelite_TB - TC-1A: ");
			`CHECK_SENSORS(sweep, genIndex2)
			`CHK_TX_CRC_ERR(genIndex2, genIndex3, txCrc4, txCrcErr)
			if(txCrcErr) begin
				$display("genericIOSatelite_TB - TC-0: TX CRC error detected - stopping...");
				$stop;
			end
			#100;
		end 
		
		// Testcase-1B, Sweeping PWMs and pulse generators downwords as well as capturing sensor data
		$display("genericIOSatelite_TB: INFO: Running testcase-1B (TC-1B), Verifying grossgrained Sweep of PWMs and pulse generators downwords as well as capturing sensor data");
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			if(genIndex < 3) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 35000000;
			end
			else if(genIndex < 6) begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_NEG;
				probeTimeout[genIndex] = 300000000;
			end
			else if(genIndex < 9) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 25000000;
			end
			else begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 300000000;
			end
		end
		for(sweep=8'hF0; sweep>8'h40; sweep=sweep-8'h40) begin									//Less than 16  or greater than 250 creates too small tollerances to measure								//Less than 16  or greater than 250 creates too small tollerances to measure
			$display("genericIOSatelite_TB: INFO: New TC-1B itteration, sweep: %d", sweep);
			//				               acc_3  acc_2  acc_1  acc_0	 acc_3	    acc_2	    acc_1      acc_0
			ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_LOW, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK) //Initialize
			#(3*1500);

			sensorInput[0] = sweep;
			sensorInput[1] = sweep;
			sensorInput[2] = sweep;
			#100;
			sensorInput[0] = 8'h00;
			sensorInput[1] = 8'h00;
			sensorInput[2] = 8'h00;
			#10;

			//				               acc_3  acc_2  acc_1  acc_0	   acc_3	    acc_2		  acc_1            acc_0
			ws2811SendBuff = {`SENSOR_PAD, sweep, sweep, sweep, sweep, `MODE_PULSE, `MODE_PWM100, `MODE_PULSE_INV, `MODE_PWM125K, `RESERVED_PAD, `FEEDBACK_PAD};

			for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
				probeArm[genIndex] = 1;
				#100;
				probeArm[genIndex] = 0;
			end

			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
			`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
			#(25000+3*1500);

			for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
				$display("genericIOSatelite_TB: INFO: TC-1B Waiting for probe %d, which is in state %d" , genIndex, probeState[genIndex]);
				while(probeState[genIndex] != `PROBE_READY && probeState[genIndex] != `PROBE_ERR)
					#1;
				if(probeState[genIndex] == `PROBE_ERR) begin
					$display("genericIOSatelite_TB - TC-1B: ERROR: Probe error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), error cause: %d, error causes: %s - stoping simulation...", genIndex, probeErrCause[genIndex], `ERR_CAUSE_DESC);
					$stop;
				end
			end

			for(genIndex = 0; genIndex < 3; genIndex = genIndex + 1) begin
				if(probePulseTime[genIndex] > sweep*(`K1_25_NS/256) + sweep*(`K1_25_NS/(256)*0.05) || probePulseTime[genIndex] < sweep*(`K1_25_NS/256) - sweep*(`K1_25_NS/(256)*0.05) || probeCycleTime[genIndex] > `K1_25_NS + `K1_25_NS*0.05 || probeCycleTime[genIndex] < `K1_25_NS - `K1_25_NS*0.05) begin
					$display("genericIOSatelite_TB - TC-1B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: %d (expected: %d +/- 5%% - %d) stoping simulation...", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%%: %d), cycleTime: %d (expected: %d +/- 5%%: %d)", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);

				if(probePulseTime[genIndex+3] > sweep*`MS_NS + sweep*`MS_NS*0.05 || probePulseTime[genIndex+3] < sweep*`MS_NS - sweep*`MS_NS*0.05 || probeTimeToTrigger[genIndex+3] > 500000) begin
					$display("genericIOSatelite_TB - TC-1B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+3, probeTimeToTrigger[genIndex+3], probePulseTime[genIndex+3], sweep*`MS_NS, sweep*`MS_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+3, probeTimeToTrigger[genIndex+3], probePulseTime[genIndex+3], sweep*`MS_NS, sweep*`MS_NS*0.05);

				if(probePulseTime[genIndex+6] > sweep*(`HZ100_NS/256) + sweep*(`HZ100_NS/(256)*0.05) || probePulseTime[genIndex+6] < sweep*(`HZ100_NS/256) - sweep*(`HZ100_NS/(256)*0.05) || probeCycleTime[genIndex+6] > `HZ100_NS + `HZ100_NS*0.05 || probeCycleTime[genIndex+6] < `HZ100_NS - `HZ100_NS*0.05) begin
					$display("genericIOSatelite_TB - TC-1B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: %d (expected: %d +/- 5%% - %d) stoping simulation...", genIndex+6, probeTimeToTrigger[genIndex+6], probePulseTime[genIndex+6], sweep*(`HZ100_NS/256), sweep*(`HZ100_NS/256)*0.05, probeCycleTime[genIndex+6], `HZ100_NS, `HZ100_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%%: %d), cycleTime: %d (expected: %d +/- 5%%: %d)", genIndex+6, probeTimeToTrigger[genIndex+6], probePulseTime[genIndex+6], sweep*(`HZ100_NS/256), sweep*(`HZ100_NS/256)*0.05, probeCycleTime[genIndex+6], `HZ100_NS, `HZ100_NS*0.05);

				if(probePulseTime[genIndex+9] > sweep*`MS_NS + sweep*`MS_NS*0.05 || probePulseTime[genIndex+9] < sweep*`MS_NS - sweep*`MS_NS*0.05 || probeTimeToTrigger[genIndex+9] > 500000) begin
					$display("genericIOSatelite_TB - TC-1B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+9, probeTimeToTrigger[genIndex+9], probePulseTime[genIndex+9], sweep*`MS_NS, sweep*`MS_NS*0.05);
					$stop;
				end
				else
					$display("genericIOSatelite_TB - TC-1B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+9, probeTimeToTrigger[genIndex+9], probePulseTime[genIndex+9], sweep*`MS_NS, sweep*`MS_NS*0.05);
			end
			$write("genericIOSatelite_TB - TC-1B: ");
			`CHECK_SENSORS(sweep, genIndex2)
			`CHK_TX_CRC_ERR(genIndex2, genIndex3, txCrc4, txCrcErr)
			if(txCrcErr) begin
				$display("genericIOSatelite_TB - TC-1B: TX CRC error detected - stopping...");
				$stop;
			end
			#100;
		end 
		
		// Testcase-2, Checking PWM and pulse generators Extreme corners 0x00/0xFF
		$display("genericIOSatelite_TB: INFO: Running testcase-2 (TC-2), Verifying PWM and pulse generators Extreme corners 0x0/0xFF");
				
		// Testcase-2A, Checking PWM and pulse generators Extreme corners 0x00
		$display("genericIOSatelite_TB: INFO: Running testcase-2A (TC-2A), Verifying PWM and pulse generators Extreme corners 0x00");

		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			if(genIndex < 3) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 30000000;
			end
			else if(genIndex < 6) begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_NEG;
				probeTimeout[genIndex] = 30000000;
			end
			else if(genIndex < 9) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 30000000;
			end
			else begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 30000000;
			end
		end
		//				               acc_3  acc_2  acc_1  acc_0	 acc_3	    acc_2	    acc_1      acc_0
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_LOW, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK) //Initialize
		#(3*1500);

		//				               acc_3  acc_2  acc_1  acc_0	   acc_3	    acc_2		  acc_1            acc_0
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_PULSE, `MODE_PWM100, `MODE_PULSE_INV, `MODE_PWM125K, `RESERVED_PAD, `FEEDBACK_PAD};

		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			probeArm[genIndex] = 1;
			#100;
			probeArm[genIndex] = 0;
		end

		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(25000+3*1500);

		#25000000;

		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			if(probeState[genIndex] != `PROBE_ARMED) begin
				$display("genericIOSatelite_TB - TC-2A: ERROR: Probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100) was triggered despite that the actuator value was 0 - stoping simulation...", genIndex);
				$stop;
			end
		end
		$display("genericIOSatelite_TB: PASS: TC-2A, Verifying PWM and pulse generators Extreme corners 0x00 wass successful");

		// Testcase-2B, Checking PWM and pulse generators Extreme corners 0xFF
		$display("genericIOSatelite_TB: INFO: Running testcase-2B (TC-2B), Verifying PWM and pulse generators Extreme corners 0x00");
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			if(genIndex < 3) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 300000000;
			end
			else if(genIndex < 6) begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_NEG;
				probeTimeout[genIndex] = 300000000;
			end
			else if(genIndex < 9) begin
				probeType[genIndex] = `PROBE_TYPE_PWM;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 300000000;
			end
			else begin
				probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
				probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
				probeTimeout[genIndex] = 300000000;
			end
		end
		sweep=8'hFE;
		$display("genericIOSatelite_TB: INFO: New TC-2B itteration, sweep: %d", sweep);
		//				               acc_3  acc_2  acc_1  acc_0	 acc_3	    acc_2	    acc_1      acc_0
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_LOW, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK) //Initialize
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK) //Initialize
		#(3*1500);

		sensorInput[0] = sweep;
		sensorInput[1] = sweep;
		sensorInput[2] = sweep;
		#100;
		sensorInput[0] = 8'h00;
		sensorInput[1] = 8'h00;
		sensorInput[2] = 8'h00;
		#10;

		//				               acc_3  acc_2  acc_1  acc_0	   acc_3	    acc_2		  acc_1            acc_0
		ws2811SendBuff = {`SENSOR_PAD, sweep, sweep, sweep, sweep, `MODE_PULSE, `MODE_PWM100, `MODE_PULSE_INV, `MODE_PWM125K, `RESERVED_PAD, `FEEDBACK_PAD};

		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			probeArm[genIndex] = 1;
			#100;
			probeArm[genIndex] = 0;
		end

		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(25000+3*1500);

		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			$display("genericIOSatelite_TB: INFO: TC-2B Waiting for probe %d, which is in state %d" , genIndex, probeState[genIndex]);
			while(probeState[genIndex] != `PROBE_READY && probeState[genIndex] != `PROBE_ERR)
				#1;
			if(probeState[genIndex] == `PROBE_ERR) begin
				$display("genericIOSatelite_TB - TC-2B: ERROR: Probe error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), error cause: %d, error causes: %s - stoping simulation...", genIndex, probeErrCause[genIndex], `ERR_CAUSE_DESC);
				$stop;
			end
		end

		for(genIndex = 0; genIndex < 3; genIndex = genIndex + 1) begin
			if(probePulseTime[genIndex] > sweep*(`K1_25_NS/256) + sweep*(`K1_25_NS/(256)*0.05) || probePulseTime[genIndex] < sweep*(`K1_25_NS/256) - sweep*(`K1_25_NS/(256)*0.05) || probeCycleTime[genIndex] > `K1_25_NS + `K1_25_NS*0.05 || probeCycleTime[genIndex] < `K1_25_NS - `K1_25_NS*0.05) begin
				$display("genericIOSatelite_TB - TC-2B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: %d (expected: %d +/- 5%% - %d) stoping simulation...", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);
				$stop;
			end
			else
				$display("genericIOSatelite_TB - TC-2B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%%: %d), cycleTime: %d (expected: %d +/- 5%%: %d)", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);

			if(probePulseTime[genIndex+3] > sweep*`MS_NS + sweep*`MS_NS*0.05 || probePulseTime[genIndex+3] < sweep*`MS_NS - sweep*`MS_NS*0.05 || probeTimeToTrigger[genIndex+3] > 500000) begin
				$display("genericIOSatelite_TB - TC-2B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+3, probeTimeToTrigger[genIndex+3], probePulseTime[genIndex+3], sweep*`MS_NS, sweep*`MS_NS*0.05);
				$stop;
			end
			else
				$display("genericIOSatelite_TB - TC-2B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+3, probeTimeToTrigger[genIndex+3], probePulseTime[genIndex+3], sweep*`MS_NS, sweep*`MS_NS*0.05);

			if(probePulseTime[genIndex+6] > sweep*(`HZ100_NS/256) + sweep*(`HZ100_NS/(256)*0.05) || probePulseTime[genIndex+6] < sweep*(`HZ100_NS/256) - sweep*(`HZ100_NS/(256)*0.05) || probeCycleTime[genIndex+6] > `HZ100_NS + `HZ100_NS*0.05 || probeCycleTime[genIndex+6] < `HZ100_NS - `HZ100_NS*0.05) begin
				$display("genericIOSatelite_TB - TC-2B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: %d (expected: %d +/- 5%% - %d) stoping simulation...", genIndex+6, probeTimeToTrigger[genIndex+6], probePulseTime[genIndex+6], sweep*(`HZ100_NS/256), sweep*(`HZ100_NS/256)*0.05, probeCycleTime[genIndex+6], `HZ100_NS, `HZ100_NS*0.05);
				$stop;
			end
			else
				$display("genericIOSatelite_TB - TC-2B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%%: %d), cycleTime: %d (expected: %d +/- 5%%: %d)", genIndex+6, probeTimeToTrigger[genIndex+6], probePulseTime[genIndex+6], sweep*(`HZ100_NS/256), sweep*(`HZ100_NS/256)*0.05, probeCycleTime[genIndex+6], `HZ100_NS, `HZ100_NS*0.05);

			if(probePulseTime[genIndex+9] > sweep*`MS_NS + sweep*`MS_NS*0.05 || probePulseTime[genIndex+9] < sweep*`MS_NS - sweep*`MS_NS*0.05 || probeTimeToTrigger[genIndex+9] > 500000) begin
				$display("genericIOSatelite_TB - TC-2B: ERROR: Timing error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+9, probeTimeToTrigger[genIndex+9], probePulseTime[genIndex+9], sweep*`MS_NS, sweep*`MS_NS*0.05);
				$stop;
			end
			else
				$display("genericIOSatelite_TB - TC-2B: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: ~500000), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: - (expected: - +/- 5%%: -) stoping simulation...", genIndex+9, probeTimeToTrigger[genIndex+9], probePulseTime[genIndex+9], sweep*`MS_NS, sweep*`MS_NS*0.05);
		end
		$write("genericIOSatelite_TB - TC-2B: ");
		`CHECK_SENSORS(sweep, genIndex2)
		`CHK_TX_CRC_ERR(genIndex2, genIndex3, txCrc4, txCrcErr)
		if(txCrcErr) begin
			$display("genericIOSatelite_TB - TC-2B: TX CRC error detected - stopping...");
			$stop;
		end
		#100; 
		
		$display("genericIOSatelite_TB: PASS: TC-2B, Verifying PWM and pulse generators Extreme corners 0xFF wass successful");


		// Testcase-3, Verifying actuator HIGH/LOW Mode
	
		$display("genericIOSatelite_TB: INFO: Running testcase-3 (TC-3), Verifying actuator HIGH/LOW Mode");
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_HIGH, `MODE_HIGH, `MODE_HIGH, `MODE_HIGH, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(3*1500);
		for(i=0; i<10000000; i=i+1) begin
			if(actuators[0] != 4'hF || actuators[1] != 4'hF || actuators[2] != 4'hF) begin
				$display("genericIOSatelite_TB: ERROR: TC-3, Actuators were detected non high");
				$stop;
			end
			#1;
		end
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(3*1500);
		for(i=0; i<10000000; i=i+1) begin
			if(actuators[0] != 4'h0 || actuators[1] != 4'h0 || actuators[2] != 4'h0) begin
				$display("genericIOSatelite_TB: ERROR: TC-3, Actuators were detected non low");
				$stop;
			end
			#1;
		end
		$display("genericIOSatelite_TB: PASS: TC-3, Verification of actuator HIGH/LOW Mode was successful");


		// Testcase-4, Verifying that pulsegenerators dont restart while active
		
		$display("genericIOSatelite_TB: INFO: Running testcase-4 (TC-4), Verifying that pulsegenerators dont restart while active");
		ws2811SendBuff = {`SENSOR_PAD, 8'h01, 8'h01, 8'h01, 8'h01, `MODE_PULSE, `MODE_PULSE_INV, `MODE_PULSE, `MODE_PULSE_INV, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(25000+3*1500);
		ws2811SendBuff = {`SENSOR_PAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, `MODE_PULSE, `MODE_PULSE_INV, `MODE_PULSE, `MODE_PULSE_INV, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(3*1500 + 25000);
		#(`MS_NS + `MS_NS*0.05);
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][0], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][0], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][0], 1)
		$display("genericIOSatelite_TB: PASS: Testcase-4 (TC-4), Verification of that pulsegenerators dont restart while active was successful");

		
		// Testcase-5, Verifying CRC4 checksum functionality
		$display("genericIOSatelite_TB: INFO: Running testcase-5 (TC-5), Verifying CRC4 checksum functionality");
		// Testcase-5A, Verifying RX CRC calculation
		
		$display("genericIOSatelite_TB: INFO: Running testcase-5A (TC-5A), Verifying RX CRC calculation");
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h55, 8'hAA, 8'hFF, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h55, 8'hAA, 8'hFF, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h55, 8'hAA, 8'hFF, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][3], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][2], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][1], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][0], 0)
		#1500;
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][3], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][2], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][1], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][0], 0)
		#1500;
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][3], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][2], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][1], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][0], 0)
		ws2811SendBuff = {`SENSOR_PAD, 8'hFF, 8'hAA, 8'h55, 8'h00, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		ws2811SendBuff = {`SENSOR_PAD, 8'hFF, 8'hAA, 8'h55, 8'h00, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		ws2811SendBuff = {`SENSOR_PAD, 8'hFF, 8'hAA, 8'h55, 8'h00, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][0], 1)
		#1500;
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][0], 1)
		#1500;
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][0], 1)
		$display("genericIOSatelite_TB: PASS: TC-5A, RX CRC calculation verified");

		// Testcase-5B, Verifying that CRC4 checksum error is detected and inhibits manouvering of Actuators and that a remote checksum error is sent
		$display("genericIOSatelite_TB: INFO: Running testcase-5B (TC-5B), Verifying that a RX CRC4 checksum error is detected and inhibits manouvering of Actuators and that a remote checksum error is sent");
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h55, 8'hAA, 8'hFF, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_BAD)
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h55, 8'hAA, 8'hFF, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h55, 8'hAA, 8'hFF, `MODE_HIGH, `MODE_LOW, `MODE_HIGH, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_BAD)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[0][0], 1)
		#1500;
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][3], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][2], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][1], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[1][0], 0)
		#1500;
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][3], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][2], 1)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][1], 0)
		`CHECK_WIRE_1("genericIOSatelite_TB", actuators[2][0], 1)
		$display("genericIOSatelite_TB: PASS: TC-5B, actuators were not manouvered because of CRC error");
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_BAD)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(3*1500+25000);
		if(!`REMOTE_CRC_ERR(0) || `REMOTE_CRC_ERR(1) || !`REMOTE_CRC_ERR(2)) begin
			$display("genericIOSatelite_TB: ERROR: TC-5B, Remote CRC pattern not as expected - stoping simulation");
			$stop;
		end
		else
			$display("genericIOSatelite_TB: PASS: TC-5B, Remote CRC error pattern was as expected");

		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(3*1500 + 25000);
		if(`REMOTE_CRC_ERR(0) || !`REMOTE_CRC_ERR(1) || `REMOTE_CRC_ERR(2)) begin
			$display("genericIOSatelite_TB: ERROR: TC-5B, Remote CRC was not as expected - stoping simulation");
			$stop;
		end
		else
			$display("genericIOSatelite_TB: PASS: TC-5B,  Remote CRC error pattern was as expected");

		// Testcase-6, Verifying Watchdog
		$display("genericIOSatelite_TB: INFO: Running testcase-6 (TC-6), Verifying watchdog: %d ns", `WATCHDOG_TIMEOUT_NS);
		ws2811SendBuff = {`SENSOR_PAD, 8'h00, 8'h00, 8'h00, 8'h00, `MODE_LOW, `MODE_LOW, `MODE_LOW, `MODE_LOW, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(25000+3*1500);
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			probeType[genIndex] = `PROBE_TYPE_PULSE_LENGTH;
			probeTriggerEdge[genIndex] = `TRIGGER_EDGE_POS;
			probeTimeout[genIndex] = `WATCHDOG_TIMEOUT_NS + `WATCHDOG_TIMEOUT_NS*0.1;
		end
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			probeArm[genIndex] = 1;
			#100;
			probeArm[genIndex] = 0;
		end
		ws2811SendBuff = {`SENSOR_PAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, `MODE_HIGH, `MODE_HIGH, `MODE_HIGH, `MODE_HIGH, `RESERVED_PAD, `FEEDBACK_PAD};
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DONT_RESET, `CRC_OK)
		`WS2811_SEND(ws2811SendBuff, `FEEDBACK_WD + `RESERVED_WD + `NO_ACTUATORS*`MODE_WD + `NO_ACTUATORS*`ACTUATOR_WD + `SENSOR_WD, i, `DO_RESET, `CRC_OK)
		#(3*1500 + 25000);
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			$display("genericIOSatelite_TB: INFO: TC-6 Waiting for probe %d, which is in state %d" , genIndex, probeState[genIndex]);
			while(probeState[genIndex] != `PROBE_READY && probeState[genIndex] != `PROBE_ERR)
				#1;
			if(probeState[genIndex] == `PROBE_ERR) begin
				$display("genericIOSatelite_TB - TC-6: ERROR: Probe error for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), error cause: %d, error causes: %s - stoping simulation...", genIndex, probeErrCause[genIndex], `ERR_CAUSE_DESC);
				$stop;
			end
		end
		for(genIndex = 0; genIndex < 12; genIndex = genIndex + 1) begin
			if(probePulseTime[genIndex] > `WATCHDOG_TIMEOUT_NS + `WATCHDOG_TIMEOUT_NS*0.05 || probePulseTime[genIndex] < `WATCHDOG_TIMEOUT_NS - `WATCHDOG_TIMEOUT_NS*0.05) begin
				$display("genericIOSatelite_TB - TC-6: ERROR: Timing error for probe index: %d (0-11: MODE_PULSE), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%% - %d), cycleTime: %d (expected: %d +/- 5%% - %d) stoping simulation...", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);
				$stop;
			end
			else
				$display("genericIOSatelite_TB - TC-6: PASS: Timing OK for probe index: %d (0-2: MODE_PWM125K, 3-5: MODE_PULSE_INV 6-8: MODE_PWM100, 9-11: MODE_PWM100), timeToTrigger: %d (expected: - +/- 5%%: -), pulseTime: %d (expected: %d +/- 5%%: %d), cycleTime: %d (expected: %d +/- 5%%: %d)", genIndex, probeTimeToTrigger[genIndex], probePulseTime[genIndex], sweep*(`K1_25_NS/256), sweep*(`K1_25_NS/256)*0.05, probeCycleTime[genIndex], `K1_25_NS, `K1_25_NS*0.05);
		end
		$display("genericIOSatelite_TB: PASS: TC-6 Verification of Watchdog successful");


		$display("genericIOSatelite_TB: SUCCESS: The full top simulation was successful, simulated time(ms):%d", ($time-t0)/1000000);
		$stop;
	end
endmodule