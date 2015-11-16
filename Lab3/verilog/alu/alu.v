module alu(
	output reg [31:0] alu_res,
	input [31:0] a, b,
	input [1:0] op,
	input clk
);

always @(posedge clk) begin
	if (op == 0) begin
		assign alu_res = a + b;
	end else if (op == 1) begin
		assign alu_res = a - b;
	end else if (op == 2) begin
		assign alu_res = a ^ b;
	end else if (op == 3) begin
		assign alu_res = (a < b) ? 1 : 0;
	end
end

endmodule

// module testalu();

// 	wire [31:0] alu_res;
// 	reg [31:0] a,b;
// 	reg [1:0] op;
// 	reg clk;

// 	alu dut(alu_res, a, b, op, clk);

// 	always begin
// 		#5 clk = !clk;
// 	end

// 	initial begin
// 		clk=0; a=0; b=2**30; op=0; #10
// 		$display("a: %b | b: %b | res: %b", a, b, alu_res);

// 		a=2**30; b=2**31+2**30+2**29+2**28; op=1; #10;
// 		$display("a: %b | b: %b | res: %b", a, b, alu_res);
// 		$finish;
// 	end

// endmodule