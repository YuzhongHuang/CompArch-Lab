//------------------------------------------------------------------------
// Concat test bench
//------------------------------------------------------------------------
`include "concat.v"

module testconcat();	

	wire[31:0] concat;
	wire[25:0] dout;

	reg		begintest;
	wire	dutpassed;

	concat dut(.concat(concat),
			.dout(dout));

	concattestbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
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

	output reg [25:0] dout,
	input[31:0] concat
);

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		dout=26'd1753; #1
		if (concat != 32'b00000000000000000000011011011001) begin
			dutpassed = 0;
			$display("Concat broken.");
		end
		endtest = 1;
		$finish;
	end

endmodule
