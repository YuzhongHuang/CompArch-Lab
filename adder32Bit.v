`define XOR xor #50
`define AND and #50
`define OR or #50
`define NOT not #50

// 1-bit building block
module oneBitAdder(
	output out,
	output carryout,
	input a,
	input b,
	input carryin
	);
	
	wire a, b, carryin, carryout, out;
	wire x0, a0, a1;

	`XOR(x0, a, b);
	`XOR(out, x0, carryin);

	`AND(a0, x0, carryin);
	`AND(a1, a, b);

	`OR(carryout, a0, a1);
endmodule

// 4-bit building block: 4 1-bit units
module FullAdder4bit(
	output[3:0] sum,
	output carryout,
	input[3:0] a,
	input[3:0] b,
	input carryin
	);

	wire c0, c1, c2;

	oneBitAdder adder0 (sum[0], c0, a[0], b[0], carryin);
	oneBitAdder adder1 (sum[1], c1, a[1], b[1], c0);
	oneBitAdder adder2 (sum[2], c2, a[2], b[2], c1);
	oneBitAdder adder3 (sum[3], carryout, a[3], b[3], c2);
endmodule

// Full 32-bit adder
module FullAdder32bit(
	output[31:0] sum,
	output carryout,
	output overflow,
	input[31:0] a,
	input[31:0] b,
	input carryin
	);

	integer first, last;
	wire c0, c1, c2, c3, c4, c5, c6;

	FullAdder4bit adder0 (sum[3:0], c0, a[3:0], b[3:0], carryin);
	FullAdder4bit adder1 (sum[7:4], c1, a[7:4], b[7:4], c0);
	FullAdder4bit adder2 (sum[11:8], c2, a[11:8], b[11:8], c1);
	FullAdder4bit adder3 (sum[15:12], c3, a[15:12], b[15:12], c2);
	FullAdder4bit adder4 (sum[19:16], c4, a[19:16], b[19:16], c3);
	FullAdder4bit adder5 (sum[23:20], c5, a[23:20], b[23:20], c4);
	FullAdder4bit adder6 (sum[27:24], c6, a[27:24], b[27:24], c5);
	FullAdder4bit adder7 (sum[31:28], carryout, a[31:28], b[31:28], c6);

	`XOR(overflow, c6, carryout);
endmodule