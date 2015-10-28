/* 
This file contains modified primitive gates for different types of inputs. Naming:
	- [GATE]32 means [GATE] for two 32-bit inputs, yielding a 32-bit output
	- [GATE]1To32 means [GATE] for one 32-bit input, and one 1-bit input, yielding a 32-bit output 
	- decidingOrGate is the gate that takes four 32-bit inputs (adder, (n)and, (n)or, xor), and one 1-bit input (SLT), and or them
all. This yields a 32-bit output.
*/

`define AND32 and #320
`define NOT32 not #320
`define XOR32 xor #320
`define OR32 or #320

module andGate32(
	output [31:0] res,
	input [31:0] a,
	input [31:0] b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`AND32 andgate(res[index], a[index], b[index]);
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
			`AND32 andgate(res[index], a[index], b); 
		end
	endgenerate
endmodule

module notGate32(
	output [31:0] res,
	input [31:0] a
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`NOT32 notgate(res[index], a[index]); 
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
			`NOT32 notgate(res[index], a); 
		end
	endgenerate
endmodule	

module orGate32(
	output [31:0] res,
	input [31:0] a,
	input [31:0] b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`OR32 orgate(res[index], a[index], b[index]); 
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
			`OR32 orgate(res[index], a[index], b); 
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
			`OR32 orgate(res[index], a[index], b[index], c[index], d[index], e); 
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
			`XOR32 xorgate(res[index], a[index], b[index]); 
		end
	endgenerate
endmodule

module xorGate1To32(
	output [31:0] res,
	input [31:0] a,
	input b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`XOR32 xorgate(res[index], a[index], b); 
		end
	endgenerate
endmodule

// module testDelay();

// 	reg [31:0] a, b;
// 	wire [31:0] res;

// 	andGate32 andgate(res, a, b);

// 	initial begin
// 		$dumpfile("customGates.vcd");
// 		$dumpvars(0, testDelay);

// 		a=32'b1011; b=32'b1100; #1000
// 		$display("a: %b, b: %b, res: %b", a[3:0], b[3:0], res[3:0]);

// 		$finish;
// 	end
// endmodule