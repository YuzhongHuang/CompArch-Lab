//------------------------------------------------------------------------
// Shifter test bench
//------------------------------------------------------------------------
`include "shifter.v"
module testShifter();
	wire[31:0]	out;
	reg[29:0]	in;

	shifter dut(.out(out),
			.in(in));

	initial begin
	$display("Testing shifter:");
	$display("input | output | expected output"); // Prints header for truth table
	in = 30'd147895263; #1
	$display(" %b | %b | 00100011010000101100111101111100", in, out);
	in = 30'd318724965; #1
	$display(" %b | %b | 01001011111111010110110110010100", in, out);
	end
endmodule
