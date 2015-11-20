/*
 * Instruction decoder register that outputs Rs, Rt, Rd, funct, opcode, immediate and J_addr.
 *
 * Note that we don't include the shamt for R-type since we are not implementing shift in our CPU
 */

// opcode encoding

`define XORI  6'b001110
`define LW    6'b100011
`define SW    6'b101011
`define ADD   6'b100000
`define SUB   6'b100010
`define SLT   6'b101010
`define J     6'b000010
`define JAL   6'b000011
`define JR    6'b001000
`define BNE   6'b000101

module IR (
	input 				clk,
	input 				IR_WE,
	input		[31:0] 	instr,
	output reg	[4:0]	Rs,
	output reg	[4:0]	Rt,
	output reg	[4:0]	Rd,
	output reg 	[5:0]	funct,
	output reg	[5:0]	opcode, 
	output reg	[15:0] 	imm,
	output reg	[25:0]	J_addr
);

always @(posedge clk) begin
	$display("Hi from IR, %b", instr);
	if (IR_WE) begin
		funct <= instr[5:0];
		Rd <= instr[15:11]; 
		Rt <= instr[20:16]; 
		Rs <= instr[25:21]; 
		opcode <= instr[31:26];
		imm <= instr[15:0];
		J_addr <= instr[25:0];
	end
end

endmodule