`define XOR xor #50
`define AND and #50
`define OR or #50
`define NOT not #50

`include "customAndGates.v" 
`include "customOrGates.v" 
`include "customNotGates.v" 
`include "adder32Bit.v"

// working
module mux2to1(
	output [31:0] Y,	
	input [31:0] I,
	input S
	);

	wire [31:0] notS, notI, temp1, temp2;

	notGate1To32 invS(notS, S);
	notGate32 invI(notI, I);

	andGate32 and1(temp1, I, notS);
	andGate1To32 and2(temp2, notI, S);

	orGate32 orgate(Y, temp1, temp2);
endmodule

module ALU(
	output [31:0] out,
	output carryout,
	output overflow,
	output zero,
	input [6:0] LutResults,
	input [31:0] a,
	input [31:0] inputB
	);

	wire [31:0] b, tempAnd, tempOr, tempC;
	wire [31:0] resAnd, resOr, resXor, resSum;
	wire resSLT; // intermediate results
	wire [31:0] validAnd, validOr, validXor, validSum;
	wire validSLT;

	mux2to1 muxB(b, inputB, LutResults[1]);

	// Xor result
	xorGate32 xorGate(resXor, a, b);

	// and result
	andGate32 andGate(tempAnd, a, b);
	mux2to1 muxAnd(resAnd, tempAnd, LutResults[0]);

	// or result
	orGate32 orGate(tempOr, a, b);
	mux2to1 muxOr(resOr, tempOr, LutResults[0]);

	// add/subtract
	FullAdder32bit adder(resSum, carryout, overflow, a, b, LutResults[1]);

	// SLT
	`XOR(resSLT, resSum[31], overflow);

	// Validation
	andGate1To32 sumValid(validSum, resSum, LutResults[6]);
	andGate1To32 xorValid(validXor, resXor, LutResults[5]);
	`AND(validSLT, resSLT, LutResults[4]);
	andGate1To32 andValid(validAnd, resAnd, LutResults[3]);
	andGate1To32 orValid(validOr, resOr, LutResults[2]);

	decidingOrGate final(out, validSum, validXor, validAnd, validOr, validSLT);

endmodule

module test;
	reg [31:0] a, b;
	reg [6:0] LR;
	wire carryout, overflow, zero;
	wire [31:0] out;
	
	ALU alu(out, carryout, overflow, zero, LR, a, b);

	initial begin
		LR = 7'b0010000; // [Add, Xor, SLT, And, Or, InvB, NOT]
		a=31'b10111; b=31'b11110; #1000
		$display("invB: %b, inputb: %b \n------------ \n  a:   %b\n  b:   %b \n------------ \nsum: %b\nxor:   %b\n or:   %b\nand:   %b\nslt: %b\n----------- \nOUT: %b", 
					alu.LutResults[1], b[5:0], a[5:0], alu.b[5:0], alu.validSum[7:0], alu.validXor[5:0], alu.validOr[5:0], alu.validAnd[5:0], alu.validSLT, out);
	end

endmodule