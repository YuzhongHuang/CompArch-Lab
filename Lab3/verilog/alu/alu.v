module alu(
	output reg [31:0] alu_res,
	output reg zeroflag,
	input [31:0] a, b,
	input [5:0] op,
	input clk
);

always @(posedge clk) begin
	if (op == 6'b10_0000) begin
		assign alu_res = a + b;
	end else if (op == 6'b10_0010) begin
		assign alu_res = a - b;
	end else if (op == 6'b00_1110) begin
		assign alu_res = a ^ b;
	end else if (op == 6'b10_1010) begin
		assign alu_res = (a < b) ? 1 : 0;
	end
	assign zeroflag = (a == b);
end

endmodule

// module testalu();

// 	wire [31:0] alu_res;
// 	wire zeroflag;
// 	reg [31:0] a,b;
// 	reg [5:0] op;
// 	reg clk;

// 	alu dut(alu_res, zeroflag, a, b, op, clk);

// 	always begin
// 		#5 clk = !clk;
// 	end

// 	initial begin
// 		clk=0; a=5; b=5; op=6'b10_0000; #10
// 		$display("a: %b | b: %b | res: %b | zero: ", a, b, alu_res, zeroflag);

// 		$finish;
// 	end

// endmodule