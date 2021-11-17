/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
/* shiftReg is an N-bit wide shift register																		*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/
`include "../genericIOSateliteEnv.v"
`include "../genericIOSateliteEnv_TB.v"
`include "shiftReg.v"

module shiftReg_TB ();
	reg[31:0] parallelInput;
	wire masterClk;
	reg serialInput;
	reg clk;
	reg load;
	reg enableShift;
	wire[31:0] parallelOutput;
	wire serialOutput;
	wire loaded;


	reg[31:0] result;
	reg[31:0] serialGen;

	integer shiftIndex, shiftOutIndex, valIndex;


	shiftReg #(.WIDTH(32)) DUT(.parallelInput(parallelInput), .serialInput(serialInput), .clk(clk), .load(load), .enableShift(enableShift), .masterClk(masterClk), .parallelOutput(parallelOutput), .serialOutput(serialOutput), .loaded(loaded));
	OSCH #(.NOM_FREQ(`OSCH_FREQ)) internal_oscillator_inst (.STDBY(1'b0), .OSC(masterClk), .SEDSTDBY ());

	always @(negedge clk) begin

		for(shiftIndex=31; shiftIndex>0; shiftIndex=shiftIndex-1) begin
				result[shiftIndex] <= result[shiftIndex-1];
		end
		result[0] <= serialOutput;

	end
	
	initial begin
		$display("shiftReg: Running simulation for a 32 bit shift reg");
		$display("ws2811Decoder: Initializing simulation for WS2811Decoder");
		// Initialization
		clk = 1'b0;
		load = 1'b0;
		enableShift = 1'b0;
		serialInput = 1'b0;
		parallelInput = 32'b0;

		//TestCase 1 - Shift in Serial data, check parallel Out data
		`LOAD_SERIAL_GEN_32("shiftReg", serialGen, 8'h55, 8'hAA, 8'h00, 8'hFF)
		enableShift = 1'b1;
		`SHIFT_SERIAL_GEN_32("shiftReg", serialGen, serialInput, shiftOutIndex, clk, `K800_NS)
		enableShift = 1'b0;
		#100;
		`CHECK_WIRE_32("shiftReg", parallelOutput, 8'h55, 8'hAA, 8'h00, 8'hFF)
		#1000;

		//TestCase 2 - Latch in parallel input data and check serial output, shift in serial data and check parallel output
		`SET_WIRE_32("shiftReg", parallelInput, 8'h0F, 8'h1E, 8'h2D, 8'h3C)
		`LOAD_SERIAL_GEN_32("shiftReg", serialGen, 8'hFF, 8'hAA, 8'h55, 8'h00)
		enableShift = 1'b1;
		load = 1'b1;
		#100;
		load = 1'b0;
		`CHECK_WIRE_1("shiftReg", loaded, 1'b1)
		`SHIFT_SERIAL_GEN_32("shiftReg", serialGen, serialInput, shiftOutIndex, clk, `K800_NS)
		enableShift = 1'b0;
		#100;
		`CHECK_WIRE_1("shiftReg", loaded, 1'b0)
		`CHECK_WIRE_32("shiftReg", parallelOutput,  8'hFF, 8'hAA, 8'h55, 8'h00)
		`CHECK_WIRE_32("shiftReg", result,  8'h0F, 8'h1E, 8'h2D, 8'h3C)
		#1000;

		//TestCase 3 - Transparent serial passthrough
		enableShift = 1'b1;
		`LOAD_SERIAL_GEN_32("shiftReg", serialGen, 8'hFF, 8'hAA, 8'h55, 8'h00)
		`SHIFT_SERIAL_GEN_32("shiftReg", serialGen, serialInput, shiftOutIndex, clk, `K800_NS)
		`SHIFT_SERIAL_GEN_32("shiftReg", serialGen, serialInput, shiftOutIndex, clk, `K800_NS)
		enableShift = 1'b0;
		`CHECK_WIRE_32("shiftReg", result,  8'hFF, 8'hAA, 8'h55, 8'h00)
		$display("shiftReg: Simulation successful");
		$stop;
	end
endmodule