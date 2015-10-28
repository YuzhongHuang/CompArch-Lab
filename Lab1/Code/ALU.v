`define ADDsignal  3'd0
`define SUBsignal  3'd1
`define XORsignal  3'd2
`define SLTsignal  3'd3
`define ANDsignal  3'd4
`define NANDsignal 3'd5
`define ORsignal   3'd6
`define NORsignal  3'd7

`define XOR xor #10
`define AND and #10
`define OR or #10
`define NOT not #10

`include "customGates.v"
`include "adder32Bit.v"
`include "checkzero_struct.v"

/* 
The ALU control LUT. It takes a 3-bit operation as an input, and outputs a 7-bit command. The bits, in order, are to enable
[Adder, XOR, SLT, AND, OR, invert B, invert AND/OR] 
*/
module ALUcontrolLUT (
	output reg[6:0] ALUsignal, 
	input[2:0] ALUcommand // 3-bit control signal input
	);

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADDsignal:  begin ALUsignal = 64; end //1000000 in binary, enable adder    
      `SUBsignal:  begin ALUsignal = 66; end //1000010 in binary, enable adder and invert B --> subtraction 
      `XORsignal:  begin ALUsignal = 32; end //0100000 in binary, enable XOR    
      `SLTsignal:  begin ALUsignal = 18; end //0010010 in binary, enable SLT and invert B  
      `ANDsignal:  begin ALUsignal = 8; end  //0001000 in binary, enable AND     
      `NANDsignal: begin ALUsignal = 9; end  //0001001 in binary, enable AND and flip the result --> NAND  
      `ORsignal:   begin ALUsignal = 4; end  //0000100 in binary, enable OR     
      `NORsignal:  begin ALUsignal = 5; end  //0000101 in binary, enable OR and flip the result --> NOR
    endcase
  end
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

	// intermediate results
	wire [31:0] b, tempAnd, tempOr, tempC;
	wire [31:0] resAnd, resOr, resXor, resSum;
	wire resSLT; 

	// results after going through enable-gates
	wire [31:0] validAnd, validOr, validXor, validSum;
	wire [6:0] LutResults;
	wire validSLT, carryout, overflow;

	ALUcontrolLUT luTable(LutResults, ALUCommand);
	xorGate1To32 flipB(b, inputB, LutResults[1]);

	// xor result
	xorGate32 xorGate(resXor, a, b);

	// and result
	andGate32 andGate(tempAnd, a, b);
	xorGate1To32 flipAndResult(resAnd, tempAnd, LutResults[0]);

	// or result
	orGate32 orGate(tempOr, a, b);
	xorGate1To32 flipOrResult(resOr, tempOr, LutResults[0]);

	// adder result
	FullAdder32bit adder(resSum, carryout, overflow, a, b, LutResults[1]);

	// SLT result
	`XOR(resSLT, resSum[31], overflow);

	// Enabling
	andGate1To32 enableSum(validSum, resSum, LutResults[6]);
	`AND enableCO(validCarryOut, carryout, LutResults[6]);
	`AND enableOverflow(validOverflow, overflow, LutResults[6]);

	andGate1To32 enableXor(validXor, resXor, LutResults[5]);
	`AND enableSLT(validSLT, resSLT, LutResults[4]);
	andGate1To32 enableAND(validAnd, resAnd, LutResults[3]);
	andGate1To32 enableOR(validOr, resOr, LutResults[2]);

	// Outputting
	decidingOrGate chooseOutput(out, validSum, validXor, validAnd, validOr, validSLT);

	checkzero zeroOutput(zero, out);
endmodule

module test;
	reg [31:0] a, b;
	reg [2:0] ALUCommand;
	wire carryout, overflow, zero;
	wire [31:0] out;
	
	ALU alu(out, carryout, overflow, zero, ALUCommand, a, b);

	initial begin
		$dumpfile("alu.vcd");
		$dumpvars(0, test);
		ALUCommand = 3'd0; a=32'b100111; b=32'b100111; #1500 
		$display("inputb: %b, signal: %b \n------------ \n  a: %b\n  b: %b \n------------ \nsum: %b\nxor: %b\n or: %b\nand: %b\nslt: %b\nzero: %b\n----------- \nOUT: %b", 
					b[5:0], alu.LutResults, alu.a, alu.b, alu.validSum, alu.validXor, alu.validOr, alu.validAnd, alu.validSLT, alu.zero, out);
		$finish;
	end
endmodule