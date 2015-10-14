`define NOT not #50

module notGate32(
	output [31:0] res,
	input [31:0] a
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`NOT notgate(res[index], a[index]); 
		end
	endgenerate
endmodule	

module notGate1To32(
	output [31:0] res,
	input a
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`NOT notgate(res[index], a); 
		end
	endgenerate
endmodule	