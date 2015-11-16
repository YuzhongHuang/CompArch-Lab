//------------------------------------------------------------------------
// Concat test bench
//------------------------------------------------------------------------
`include "concat.v"

module testconcat();	

	wire[31:0] concat;
	wire[3:0] PC;
	wire[25:0] dout;

	reg		begintest;
	wire		dutpassed;

	concat dut(.concat(concat),
			.PC(PC),
			.dout(dout));

	concattestbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
							.PC(PC),
							.dout(dout),
							.concat(concat));

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

module concattestbench (
	input begintest,
	output reg endtest,
	output reg dutpassed,

	output reg [3:0] PC,
	output reg [25:0] dout,
	input[31:0] concat
);

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		PC=4'd12; dout=26'd1753; #1
		if (concat != 32'b11000000000000000001101101100100) begin
			dutpassed = 0;
			$display("Concat broken.");
		end
		endtest = 1;
		$finish;
	end

endmodule
