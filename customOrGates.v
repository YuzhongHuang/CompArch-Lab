`define XOR xor #50
`define OR or #50

module orGate32(
	output [31:0] res,
	input [31:0] a,
	input [31:0] b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`OR orgate(res[index], a[index], b[index]); 
		end
	endgenerate
endmodule	

module orGate1To32(
	output [31:0] res,
	input [31:0] a,
	input b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`OR orgate(res[index], a[index], b); 
		end
	endgenerate
endmodule

module decidingOrGate(
	output [31:0] res,
	input [31:0] a,
	input [31:0] b,
	input [31:0] c,
	input [31:0] d,
	input e
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`OR orgate(res[index], a[index], b[index], c[index], d[index], e); 
		end
	endgenerate
endmodule	

module xorGate32(
	output [31:0] res,
	input [31:0] a,
	input [31:0] b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`XOR xorgate(res[index], a[index], b[index]); 
		end
	endgenerate
endmodule