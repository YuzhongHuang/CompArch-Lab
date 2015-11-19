//------------------------------------------------------------------------
// PC test bench
//------------------------------------------------------------------------
`include "dff.v"

module testDFF();	
	wire[31:0]    	q;	
	wire[31:0]	in;
	wire		wr_enable;
	wire		clk;

	reg		begintest;
	wire		dutpassed;

	DFF dut(.q(q),
		.in(in),
		.wr_enable(wr_enable),
		.clk(clk));

	PCtestbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
							.in(in),
							.wr_enable(wr_enable),
							.clk(clk),
							.q(q));

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

module PCtestbench (
	input begintest,
	output reg endtest,
	output reg dutpassed,

	output reg [31:0] in,
	output reg wr_enable,
	output reg clk,
	input [31:0] q
);

	always begin
		#5 clk = !clk;
	end

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		clk=0; wr_enable=1; in=126; #10
		if (q != in) begin
			dutpassed = 0;
			$display("PC broken.");
		end

		wr_enable=0; in=4000; #10
		if (q != 126) begin
			dutpassed = 0;
			$display("PC broken.");
		end
		endtest = 1;
		$finish;
	end

endmodule