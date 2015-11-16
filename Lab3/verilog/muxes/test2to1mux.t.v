//------------------------------------------------------------------------
// 2:1 mux test bench
//------------------------------------------------------------------------
`include "muxes.v"

module test3to1mux();	
	wire[31:0]    	out;	
	wire		address;
	wire[31:0]	in0, in1;

	reg		begintest;
	wire		dutpassed;

	mux2to1 dut(.out(out),
			.address(address),
			.in0(in0),
			.in1(in1));

	mux2to1testbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
							.address(address),
							.in0(in0),
							.in1(in1),
							.out(out));

	initial begin
        begintest = 0;
        #10;
        begintest = 1;
        #10000;
    end

    always @(posedge endtest) begin
        if (dutpassed == 1) begin
            $display("\n\033[32mDUT passed: %b\033[37m\n", dutpassed);
        end else begin
            $display("\n\033[31mDUT passed: %b\033[37m\n", dutpassed);
        end
    end
	
endmodule

module mux2to1testbench (
	input begintest,
	output reg endtest,
	output reg dutpassed,

	output reg address,
	output reg [31:0] in0, in1,
	input [31:0] out
);

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		// Test Case 1 (picks in0)
		in0=32'd126; in1=32'd53; address=0; #1
		if (out != in0) begin
			dutpassed = 0;
			$display("2 to 1 Mux: Select in0 broken.");
		end

		// Test Case 2 (picks in1)
		address=1; #1
		if (out != in1) begin
			dutpassed = 0;
			$display("2 to 1 Mux: Select in1 broken.");
		end
		$finish;
	end

endmodule
