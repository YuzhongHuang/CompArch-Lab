//------------------------------------------------------------------------
// Muxes test bench
//------------------------------------------------------------------------
`include "muxes.v"
module test2to1mux();
	wire[31:0]    	out;	
	reg 		address;
	reg[31:0]	in0, in1;

	mux2to1 dut1(.out(out),
			.address(address),
			.in0(in0),
			.in1(in1));

	initial begin
	$display("Testing 2:1 Mux:");
	$display("in0  in1 | address | out | expected out"); // Prints header for truth table
	in0=32'd107; in1=32'd59; address=0; #10 // Set inputs and address, wait for new update
	$display("%d  %d |  %d  |  %d | 107", in0, in1, address, out);
	in0=32'd67; in1=32'd3; address=1; #10 // Set inputs and address, wait for new update
	$display("%d  %d |  %d  |  %d | 3", in0, in1, address, out);
	end

endmodule
