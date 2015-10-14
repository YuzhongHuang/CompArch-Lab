`define XOR xor #50
`define AND and #50
`define OR or #50
`define NOT not #50
`define ADDsignal  3'd0
`define SUBsignal  3'd1
`define XORsignal  3'd2
`define SLTsignal  3'd3
`define ANDsignal  3'd4
`define NANDsignal 3'd5
`define ORsignal   3'd6
`define NORsignal  3'd7

`include "customAndGates.v" 
`include "customOrGates.v" 
`include "customNotGates.v" 
`include "adder32Bit.v"
`include "checkzero_struct.v"

//The ALU control LUT
module ALUcontrolLUT (
	output reg[6:0] ALUsignal, 
	input[2:0] ALUcommand //3-bit control signal input
	//7-bit signal output to the ALU, inwhich 
	//the most significant bit represents "enable add(subtract)"
	//the second bit represents "enable XOR"
	//the third bit represents "enable SLT"
	//the fourth bit represents "enable AND"
	//the fifth bit represents "enable OR"
	//the sixth bit represents "invert B"
	//the seventh bit represents "flip the result(for NAND & NOR)"
	);

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADDsignal:  begin ALUsignal = 64; end //1000000 in binary, which represents enable add(sub)    
      `SUBsignal:  begin ALUsignal = 66; end //1000010 in binary, which represents enable add(sub) and invert B  
      `XORsignal:  begin ALUsignal = 32; end //0100000 in binary, which represents enable XOR    
      `SLTsignal:  begin ALUsignal = 18; end //0010010 in binary, which represents enable SLT and invert B  
      `ANDsignal:  begin ALUsignal = 8; end  //0001000 in binary, which represents enable AND     
      `NANDsignal: begin ALUsignal = 9; end  //0001001 in binary, which represents enable AND and flip the result  
      `ORsignal:   begin ALUsignal = 4; end  //0000100 in binary, which represents enable OR     
      `NORsignal:  begin ALUsignal = 5; end  //0000101 in binary, which represents enable OR and flip the result  
    endcase
  end
endmodule

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
	output validCarryOut,
	output validOverflow,
	output zero,
	input [2:0] ALUCommand,
	input [31:0] a,
	input [31:0] inputB
	);

	wire [31:0] b, tempAnd, tempOr, tempC;
	wire [31:0] resAnd, resOr, resXor, resSum;
	wire resSLT; // intermediate results
	wire [31:0] validAnd, validOr, validXor, validSum;
	wire [6:0] LutResults;
	wire validSLT, carryout, overflow;

	ALUcontrolLUT luTable(LutResults, ALUCommand);
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
	`AND(validCarryOut, carryout, LutResults[6]);
	`AND(validOverflow, overflow, LutResults[6]);
	andGate1To32 xorValid(validXor, resXor, LutResults[5]);
	`AND(validSLT, resSLT, LutResults[4]);
	andGate1To32 andValid(validAnd, resAnd, LutResults[3]);
	andGate1To32 orValid(validOr, resOr, LutResults[2]);

	decidingOrGate final(out, validSum, validXor, validAnd, validOr, validSLT);

	checkzero zeroOutput(zero, out);

endmodule

module test;
	reg [31:0] a, b;
	//wire [6:0] LutResults;
	reg [2:0] ALUCommand;
	wire carryout, overflow, zero;
	wire [31:0] out;
	
	ALU alu(out, carryout, overflow, zero, ALUCommand, a, b);

	initial begin
		ALUCommand = 3'd3; #1000
		//$display("Command: %b | Signal: %b", ALUCommand, LutResults);
		// ALUCommand = 7'b0000111; // [Add, Xor, SLT, And, Or, InvB, NOT]
		//a=31'b10111; b=31'b11110; #1000
		a=32'sd2**31-1; b=32'sd2**31-2;  #1000000 
		$display("inputb: %b, signal: %b \n------------ \n  a: %b\n  b: %b \n------------ \nsum: %b\nxor: %b\n or: %b\nand: %b\nslt: %b\nzero: %b\n----------- \nOUT: %h", 
					b[5:0], alu.LutResults, alu.a, alu.b, alu.validSum, alu.validXor, alu.validOr, alu.validAnd, alu.validSLT, alu.zero, out);
	end

endmodule