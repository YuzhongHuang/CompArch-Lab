`include "se.v"

module testse();	
	wire [31:0] se;	
	wire [15:0] imm;

	reg	begintest;
	wire dutpassed;

	signextend dut(.se(se),
			.imm(imm));

	setestbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
							.imm(imm),
							.out(se));

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

module setestbench (
	input begintest,
	output reg endtest,
	output reg dutpassed,

	output reg [15:0] imm,
	input [31:0] out
);


	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		// Write a bunch of data to separate memory addresses
		imm = 2**15; #1
		if (out != {16'b1111_1111_1111_1111, imm}) begin
			dutpassed = 0;
			$display("Sign-Extend 1 failed.");
		end
		imm = 2**14+2**8; #1
		if (out != {16'b0, imm}) begin
			dutpassed = 0;
			$display("Sign-Extend 0 failed.");
		end

		endtest = 1;
		$finish;
	end

endmodule