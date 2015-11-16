//------------------------------------------------------------------------
// Muxes test bench
//------------------------------------------------------------------------
`include "muxes.v"
module testMuxes();
	wire[31:0]    	out;	
	reg 		address1;
	reg[1:0]	address;
	reg[31:0]	in0, in1, in2, in3;

	mux2to1 dut1(.out(out),
			.address(address1),
			.in0(in0),
			.in1(in1));

	initial begin
	$display("Testing 2:1 Mux:");
	$display("in0  in1 | address | out | expected out"); // Prints header for truth table
	in0=32'd107; in1=32'd59; address1=0; #10 // Set inputs and address, wait for new update
	$display("%d  %d |  %d  |  %d | 107", in0, in1, address1, out);
	in0=32'd67; in1=32'd3; address1=1; #10 // Set inputs and address, wait for new update
	$display("%d  %d |  %d  |  %d | 3", in0, in1, address1, out);
	end

	// mux3to1 dut2(.out(out),
	// 		.address(address),
	// 		.in0(in0),
	// 		.in1(in1),
	// 		.in2(in2));

	// initial begin
	// $display("Testing 3:1 Mux:");
	// $display("in0  in1  in3| address | out | expected out"); // Prints header for truth table
	// in0=32'b1; in1=32'b0; in2=32'b0; address=2'b00; #1 // Set inputs and address, wait for new update
	// $display("%b  %b  %b|  %b  |  %b | 1", in0, in1, in2, address, out);
	// in0=32'b0; in1=32'b1; in2=32'b0; address=2'b01; #1
	// $display("%b  %b  %b|  %b  |  %b | 1", in0, in1, in2, address, out);
	// in0=32'b0; in1=32'b0; in2=32'b1; address=2'b10; #1
	// $display("%b  %b  %b|  %b  |  %b | 1", in0, in1, in2, address, out);
	// end

	// mux4to1 dut3(.out(out),
	// 		.address(address),
	// 		.in0(in0),
	// 		.in1(in1),
	// 		.in2(in2),
	// 		.in3(in3));

	// initial begin
	// $display("Testing 4:1 Mux:");
	// $display("in0  in1  in3  in4 | address | out | expected out"); // Prints header for truth table
	// in0=32'b1; in1=32'b0; in2=32'b0; in3=32'b0; address=2'b00; #1 // Set inputs and address, wait for new update
	// $display("%b  %b  %b  %b|  %b  |  %b | 1", in0, in1, in2, in3, address, out);
	// in0=32'b0; in1=32'b1; in2=32'b0; in3=32'b0; address=2'b01; #1
	// $display("%b  %b  %b  %b|  %b  |  %b | 1", in0, in1, in2, in3, address, out);
	// in0=32'b0; in1=32'b0; in2=32'b1; in3=32'b0; address=2'b10; #1
	// $display("%b  %b  %b  %b|  %b  |  %b | 1", in0, in1, in2, in3, address, out);
	// in0=32'b0; in1=32'b0; in2=32'b0; in3=32'b1; address=2'b11; #1
	// $display("%b  %b  %b  %b|  %b  |  %b | 1", in0, in1, in2, in3, address, out);
	// end

endmodule
