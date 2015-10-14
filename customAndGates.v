`define AND and #50

module andGate32(
	output [31:0] res,
	input [31:0] a,
	input [31:0] b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`AND andgate(res[index], a[index], b[index]); 
		end
	endgenerate
endmodule

module andGate1To32(
	output [31:0] res,
	input [31:0] a,
	input b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`AND andgate(res[index], a[index], b); 
		end
	endgenerate
endmodule