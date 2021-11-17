/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* The ws2811Encoder_TB module encodes is a test bench for the ws2811Encoder																		*/

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`include "../genericIOSateliteEnv.v"
`include "../genericIOSateliteEnv_TB.v"
`include "../ws2811Decoder/ws2811Decoder.v"
`include "ws2811Encoder.v"



// Checks the 4-byte result
`define CHECK_RES(VALUE3, VALUE2, VALUE1, VALUE0) \
	if (result_3 === VALUE3 & result_2 === VALUE2 & result_1 === VALUE1 & result_0 === VALUE0) \
		$display("ws2811Decoder: PASS: results were as expected, %b %b %b %b was expected, and %b %b %b %b was detected", VALUE3, VALUE2, VALUE1, VALUE0, result_3, result_2, result_1, result_0); \
	else begin \
		$display("ws2811Decoder: ERROR: results were not as expected, %b %b %b %b was expected, but %b %b %b %b was detected", VALUE3, VALUE2, VALUE1, VALUE0, result_3, result_2, result_1, result_0); \
		$display("ws2811Decoder: Stopping further simulation..."); \
		$stop; \
	end

module ws2811Encoder_TB ();
	wire masterClk;
	reg ws2811In;
	wire unModulatedIn;
	wire dataClkIn;
	wire ws2811Out;
	wire unmodulatedOut;
	wire dataClkOut;
	wire active;

	reg[7:0] result_0;
	reg[7:0] result_1;
	reg[7:0] result_2;
	reg[7:0] result_3;

	integer shiftIndex, valIndex;

	ws2811Decoder GENERATOR(.masterClk(masterClk), .dataIn(ws2811In), .dataOut(unModulatedIn), .dataClk(dataClkIn), .active());
	ws2811Encoder DUT(.masterClk(masterClk), .dataClk(dataClkIn), .dataIn(unModulatedIn), .dataOut(ws2811Out));
	ws2811Decoder RECEIVER(.masterClk(masterClk), .dataIn(ws2811Out), .dataOut(unmodulatedOut), .dataClk(dataClkOut), .active(active));
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());

	always @(posedge dataClkOut) begin

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
				result_0[0] <= unmodulatedOut;
			end
		end
	end
	
	initial begin
		$display("ws2811Decoder: Initializing simulation for WS2811Decoder");

		$display("ws2811Decoder: Running simulation for nominal dataIn timing, T1H: %d, T1L %d, T0H: %d, T0L", 600, 1240-600, 250, 1240-250); //MAKE PARAMETERS IN THE ENV FILE
		`WS2811_GENERATE(ws2811In, 8'hF0, 0)						//Init Garbage vector
		`WS2811_GENERATE_END(ws2811In)

		`WS2811_GENERATE(ws2811In, 8'h55, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'hAA, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'h00, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'hFF, 0)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE_END(ws2811In)
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)

		$display("ws2811Decoder: Running simulation for maximum positive dataIn skew timing: + %d ns", `MAX_SKEW);
		`WS2811_GENERATE(ws2811In, 8'h55, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'hAA, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'h00, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'hFF, `MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE_END(ws2811In)
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)
		
		$display("ws2811Decoder: Running simulation for maximum negative dataIn skew timing: - %d ns", `MAX_SKEW);
		`WS2811_GENERATE(ws2811In, 8'h55, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'hAA, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'h00, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE(ws2811In, 8'hFF, -`MAX_SKEW)
		`CHECK_ACTIVE(active, 1'b1)
		`WS2811_GENERATE_END(ws2811In)
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)
		#50000
		`CHECK_ACTIVE(active, 1'b0)
		`CHECK_RES(8'h55, 8'hAA, 8'h00, 8'hFF)

		$display("ws2811Decoder: Simulation successfull - stopping");
		$stop;
	end
endmodule