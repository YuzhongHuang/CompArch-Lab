module alu(
	output reg [31:0] alu_res,
	output reg zeroflag,
	input [31:0] a, b,
	input [5:0] op
);

	always @(op) begin
		if (op == 6'b10_0000) begin
			alu_res <= a + b;
		end else if (op == 6'b10_0010) begin
			alu_res <= a - b;
		end else if (op == 6'b00_1110) begin
			alu_res <= a ^ b;
		end else if (op == 6'b10_1010) begin
			alu_res <= (a < b) ? 1 : 0;
		end
		assign zeroflag = (a == b);
	end

endmodule