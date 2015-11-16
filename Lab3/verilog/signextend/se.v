module signextend(
	output [31:0] se,
	input [15:0] imm
);

	assign se = {{16{imm[15]}}, imm};
endmodule