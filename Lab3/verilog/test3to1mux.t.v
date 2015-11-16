module test3to1mux();	
	wire[31:0]    	out;	
	wire[1:0]	address;
	wire[31:0]	in0, in1, in2;

	reg		begintest;
	wire		dutpassed;

mux3to1 dut2(.out(out),
			.address(address),
			.in0(in0),
			.in1(in1),
			.in2(in2));
	initial begin
	// $display("Testing 3:1 Mux:");
	// $display("in0  in1  in3| address | out | expected out"); // Prints header for truth table
	in0=32'd126; in1=32'd53; in2=32'd178; address=2'b00; #1 // Set inputs and address, wait for new update
	// $display("%d  %d  %d|  %d  |  %d | 126", in0, in1, in2, address, out);
	in0=32'd135; in1=32'd97; in2=32'd14; address=2'b01; #1
	// $display("%d  %d  %d|  %d  |  %d | 97", in0, in1, in2, address, out);
	in0=32'd49; in1=32'd299; in2=32'd28; address=2'b10; #1
	// $display("%d  %d  %d|  %d  |  %d | 28", in0, in1, in2, address, out);
	end
endmodule

module 3to1testbench
(