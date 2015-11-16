//------------------------------------------------------------------------
// PC test bench
//------------------------------------------------------------------------
`include "pc.v"

module testPC();	
	wire[31:0]    	pc;	
	wire[31:0]	in;
	wire		pc_we,
	wire		clk

	reg		begintest;
	wire		dutpassed;

	PC dut(.pc(pc),
		.in(in),
		.pc_we(pc_we),
		.clk(clk));

	PCtestbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
							.in(in),
							.pc_we(pc_we),
							.clk(clk)
							.pc(pc));

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
	output reg pc_we,
	output reg clk,
	input [31:0] pc
);

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		in=32'd126; #10
		if (out != in) begin
			dutpassed = 0;
			$display("PC broken.");
		end
		endtest = 1;
		$finish;
	end

endmodule