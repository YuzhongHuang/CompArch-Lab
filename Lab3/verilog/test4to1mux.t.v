//------------------------------------------------------------------------
// Muxes test bench
//------------------------------------------------------------------------
`include "muxes.v"
module test4to1mux();
	wire[31:0]    	out;
	reg[1:0]	address;
	reg[31:0]	in0, in1, in2, in3;

mux4to1 dut3(.out(out),
			.address(address),
			.in0(in0),
			.in1(in1),
			.in2(in2),
			.in3(in3));

	initial begin
	$display("Testing 4:1 Mux:");
	$display("in0  in1  in3  in4 | address | out | expected out"); // Prints header for truth table
	in0=32'd35; in1=32'd688; in2=32'd193; in3=32'd566; address=2'b00; #1 // Set inputs and address, wait for new update
	$display("%d  %d  %d  %d|  %d  |  %d | 35", in0, in1, in2, in3, address, out);
	in0=32'd722; in1=32'd27; in2=32'd195; in3=32'd275; address=2'b01; #1
	$display("%d  %d  %d  %d|  %d  |  %d | 27", in0, in1, in2, in3, address, out);
	in0=32'd184; in1=32'd356; in2=32'd567; in3=32'd31; address=2'b10; #1
	$display("%d  %d  %d  %d|  %d  |  %d | 567", in0, in1, in2, in3, address, out);
	in0=32'd174; in1=32'd394; in2=32'd542; in3=32'd319; address=2'b11; #1
	$display("%d  %d  %d  %d|  %d  |  %d | 319", in0, in1, in2, in3, address, out);
	end
endmodule

