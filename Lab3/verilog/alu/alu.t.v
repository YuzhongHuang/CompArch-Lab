`include "alu.v"

module testalu();	
	wire [31:0] alu_res, a, b;
	wire [1:0] op;
	wire clk;

	reg	begintest;
	wire dutpassed;

	alu dut(.alu_res(alu_res),
			.a(a),
			.b(b),
			.op(op),
			.clk(clk));

	alutestbench test(.begintest(begintest),
					.endtest(endtest),
					.dutpassed(dutpassed),
					.a(a),
					.b(b),
					.op(op),
					.clk(clk),
					.alu_res(alu_res));

	initial begin
        begintest = 0;
        #10;
        begintest = 1;
        #10000;
    end

    always @(posedge endtest) begin
        if (dutpassed == 1) begin
            $display("\n\033[32mDUT passed.\033[37m\n");
        end else begin
            $display("\n\033[31mDUT not passed.\033[37m\n");
        end
    end
	
endmodule

module alutestbench (
	input begintest,
	output reg endtest,
	output reg dutpassed,

	output reg [31:0] a, b,
	output reg [1:0] op,
	output reg clk,
	input [31:0] alu_res
);

	always begin
        #5 clk = !clk;
    end

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;
		clk = 0;

		// ADDITION TEST CASES
		op=0; 
		a=2**31+2**28; b=2**31+2**29; #10;
		if (alu_res != a+b) begin
			dutpassed = 0;
			$display("Addition: Carryout & overflow failed.");
		end

		a=2**30+2**29; b=2**30; #10;
		if (alu_res != a+b) begin
			dutpassed = 0;
			$display("Addition: !Carryout & overflow failed.");
		end

		a=2**31+2**30; b=2**31+2**30+2**28; #10;
		if (alu_res != a+b) begin
			dutpassed = 0;
			$display("Addition: Carryout & !overflow failed.");
		end

		a=2**28; b=2**30; #10
		if (alu_res != a+b) begin
			dutpassed = 0;
			$display("Addition: !Carryout & !overflow failed.");
		end

		// SUBTRACTION TEST CASES
		op=1; 
		a=2**31+2**28; b=2**30+2**29; #10;
		if (alu_res != a-b) begin
			dutpassed = 0;
			$display("Subtraction: Carryout & overflow failed.");
		end

		a=2**30+2**28; b=2**31+2**29; #10;
		if (alu_res != a-b) begin
			dutpassed = 0;
			$display("Subtraction: !Carryout & overflow failed.");
		end

		a=2**31+2**30+2**29; b=2**30; #10;
		if (alu_res != a-b) begin
			dutpassed = 0;
			$display("Subtraction: Carryout & !overflow failed.");
		end

		a=2**30; b=2**31+2**30+2**29+2**28; #10
		if (alu_res != a-b) begin
			dutpassed = 0;
			$display("Subtraction: !Carryout & !overflow failed.");
		end

		// XOR TEST CASES
		op=2;
		a=0; b=0; #10
		if (alu_res != (a^b)) begin
			dutpassed = 0;
			$display("Xor: 0 ^ 0 failed");
		end

		a=0; b=2**32-1; #10
		if (alu_res != (a^b)) begin
			dutpassed = 0;
			$display("Xor: 0 ^ 1 failed");
		end

		a=2**32-1; b=0; #10
		if (alu_res != (a^b)) begin
			dutpassed = 0;
			$display("Xor: 1 ^ 0 failed");
		end

		a=2**32-1; b=2**32-1; #10
		if (alu_res != (a^b)) begin
			dutpassed = 0;
			$display("Xor: 1 ^ 1 failed");
		end

		// SLT TEST CASES
		op=3;
		a=0; b=0; #10
		if (alu_res != 0) begin
			dutpassed = 0;
			$display("SLT: 0 < 0 failed");
		end

		a=0; b=2**32-1; #10
		if (alu_res != 1) begin
			dutpassed = 0;
			$display("SLT: 0 < 1 failed");
		end

		a=2**32-1; b=0; #10
		if (alu_res != 0) begin
			dutpassed = 0;
			$display("SLT: 1 < 0 failed");
		end

		a=2**32-1; b=2**32-1; #10
		if (alu_res != 0) begin
			dutpassed = 0;
			$display("SLT: 1 < 1 failed");
		end

		endtest = 1;

		$finish;
	end

endmodule