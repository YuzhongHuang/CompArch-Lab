//------------------------------------------------------------------------
// Shifter test bench
//------------------------------------------------------------------------
`include "shifter.v"

module testshifter();	
	wire[31:0]    	out;	
	wire[31:0]	in;

	reg		begintest;
	wire		dutpassed;

	shifter dut(.out(out),
			.in(in));

	shiftertestbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
							.address(address),
							.in(in),
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

module shiftertestbench (
	input begintest,
	output reg endtest,
	output reg dutpassed,

	output reg [31:0] in,
	input [31:0] out
);

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		in=32'd126; #1
		if (out != 32'd504) begin
			dutpassed = 0;
			$display("Shifter broken.");
		end
		endtest = 1;
		$finish;
	end

endmodule
