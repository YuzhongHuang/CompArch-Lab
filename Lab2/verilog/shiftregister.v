//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
	#(parameter width = 8)
	(
	input               clk,                // FPGA Clock
	input               peripheralClkEdge,  // Edge indicator
	input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
	input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
	input               serialDataIn,       // Load shift reg serially
	output [width-1:0]  parallelDataOut,    // Shift reg data contents
	output              serialDataOut       // Positive edge synchronized
	);

    reg [width-1:0] shiftregistermem;

    always @(posedge clk) begin
        if (peripheralClkEdge == 1) begin
        	if (parallelLoad == 1) begin
        		shiftregistermem = parallelDataIn;
        	end else begin
        		shiftregistermem = shiftregistermem << 1;
        		shiftregistermem[0] = serialDataIn;
        	end
        end
    end

    assign serialDataOut = shiftregistermem[7];
    assign parallelDataOut = shiftregistermem;

endmodule

// module test();
// 	reg clk, peripheralClkEdge, parallelLoad, serialDataIn;
// 	reg [7:0] parallelDataIn;
// 	wire [7:0] parallelDataOut;
// 	wire serialDataOut;

// 	shiftregister shiftreg(clk, peripheralClkEdge, parallelLoad, parallelDataIn, serialDataIn, parallelDataOut, serialDataOut);

// 	initial begin
// 		clk = 0; #10
// 		clk = 1; peripheralClkEdge = 1; parallelLoad = 0; parallelDataIn = 8'b01110011; serialDataIn = 1; #10 
// 		clk = 0; #10 clk = 1; #10 clk = 0; #10 clk = 1; #10
// 		$display("Parallel-in: %b | Serial-out: %b | Parallel-out: %b", shiftreg.parallelDataIn, shiftreg.serialDataOut, shiftreg.parallelDataOut);
// 	end
// endmodule
















