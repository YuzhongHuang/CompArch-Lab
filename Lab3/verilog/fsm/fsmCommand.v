/* 
 * The FSM command LUT takes a 6-bit opcode and a 4-bit current state as inputs, and outputs a 4-bit command as the next 
 * state. 
 *
 * The state encoding are listed below:
 *
 * STATE_IF = 0,
 * STATE_ID_1 = 1,
 * STATE_ID_J = 2,
 * STATE_ID_BNE = 3,
 * STATE_EX_OP_IMM = 4,
 * STATE_EX_ADDI = 5,
 * STATE_EX_A_OP_B = 6,
 * STATE_EX_A_ADD0 = 7,
 * STATE_EX_BNE = 8,
 * STATE_MEM_READ = 9,
 * STATE_MEM_WRITE = 10,
 * STATE_WB_XORI = 11,
 * STATE_WB_LW = 12,
 * STATE_WB_ALU = 13,
 * STATE_WB_JAL = 14,
 * STATE_WB_JR = 15;
 * 
 */


/*
 * opcode encoding
 */
`define XORI  6'b001110
`define LW    6'b100011
`define SW    6'b101011
`define ADD   6'b000000
`define SUB   6'b000000
`define SLT   6'b000000
`define J     6'b000010
`define JAL   6'b000011
`define JR    6'b001000
`define BNE   6'b000101

`define STATE_IF          4'b0000
`define STATE_ID_1        4'b0001
`define STATE_ID_J        4'b0010
`define STATE_ID_BNE      4'b0011
`define STATE_EX_OP_IMM   4'b0100
`define STATE_EX_ADDI     4'b0101
`define STATE_EX_A_OP_B   4'b0110
`define STATE_EX_A_ADD0   4'b0111 
`define STATE_EX_BNE      4'b1000
`define STATE_MEM_READ    4'b1001
`define STATE_MEM_WRITE   4'b1010
`define STATE_WB_XORI     4'b1011
`define STATE_WB_LW       4'b1100
`define STATE_WB_ALU      4'b1101
`define STATE_WB_JAL      4'b1110
`define STATE_WB_JR       4'b1111

module fsmCommand (
	output reg[3:0] next_state, 
  input[3:0] state,
	input[5:0] opcode,
  input clk
	);

  always @(negedge clk) begin
    case ({opcode, state})
      // The life cycle of XORI is (STATE_IF -> STATE_ID_1 -> STATE_EX_OP_IMM -> STATE_WB_XORI -> STATE_IF)
      {`XORI, `STATE_IF}:  begin 
        next_state = `STATE_ID_1;
      end

      {`XORI, `STATE_ID_1}:  begin 
        next_state = `STATE_EX_OP_IMM;
      end

      {`XORI, `STATE_EX_OP_IMM}:  begin 
        next_state = `STATE_WB_XORI;
      end

      {`XORI, `STATE_WB_XORI}:  begin 
        next_state = `STATE_IF;
      end

      // The life cycle of LW is (STATE_IF -> STATE_ID_1 -> STATE_EX_ADDI -> STATE_MEM_READ -> STATE_WB_LW -> STATE_IF)
      {`LW, `STATE_IF}: begin
        next_state = `STATE_ID_1;
      end

      {`LW, `STATE_ID_1}: begin
        next_state = `STATE_EX_ADDI;
      end

      {`LW, `STATE_EX_ADDI}: begin
        next_state = `STATE_MEM_READ;
      end

      {`LW, `STATE_MEM_READ}: begin
        next_state = `STATE_WB_LW;
      end

      {`LW, `STATE_WB_LW}: begin
        next_state = `STATE_IF;
      end

      // The life cycle of SW is (STATE_IF -> STATE_ID_1 -> STATE_EX_ADDI -> STATE_MEM_WRITE -> STATE_IF)
      {`SW, `STATE_IF}: begin
        next_state = `STATE_ID_1;
      end

      {`SW, `STATE_ID_1}: begin
        next_state = `STATE_EX_ADDI;
      end

      {`SW, `STATE_EX_ADDI}: begin
        next_state = `STATE_MEM_WRITE;
      end

      {`SW, `STATE_MEM_WRITE}: begin
        next_state = `STATE_IF;
      end

      // The life cycle of ADD is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_OP_B -> STATE_WB_ALU -> STATE_IF)
      {`ADD, `STATE_IF}: begin
        next_state = `STATE_ID_1;
      end

      {`ADD, `STATE_ID_1}: begin
        next_state = `STATE_EX_A_OP_B;
        $display("nextState: %b | instr: %b", next_state, opcode);
      end

      {`ADD, `STATE_EX_A_OP_B}: begin
        next_state = `STATE_WB_ALU;
      end

      {`ADD, `STATE_WB_ALU}: begin
        next_state = `STATE_IF;
      end

      // // The life cycle of SUB is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_OP_B -> STATE_WB_ALU -> STATE_IF)
      // {`SUB, `STATE_IF}: begin
      //   next_state = `STATE_ID_1;
      // end

      // {`SUB, `STATE_ID_1}: begin
      //   next_state = `STATE_EX_A_OP_B;
      // end

      // {`SUB, `STATE_EX_A_OP_B}: begin
      //   next_state = `STATE_WB_ALU;
      // end

      // {`SUB, `STATE_WB_ALU}: begin
      //   next_state = `STATE_IF;
      // end

      // // The life cycle of SLT is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_OP_B -> STATE_WB_ALU -> STATE_IF)
      // {`SLT, `STATE_IF}: begin
      //   next_state = `STATE_ID_1;
      // end

      // {`SLT, `STATE_ID_1}: begin
      //   next_state = `STATE_EX_A_OP_B;
      // end

      // {`SLT, `STATE_EX_A_OP_B}: begin
      //   next_state = `STATE_WB_ALU;
      // end

      // {`SLT, `STATE_WB_ALU}: begin
      //   next_state = `STATE_IF;
      // end

      // The life cycle of J is (STATE_IF -> STATE_ID_J -> STATE_IF)
      {`J, `STATE_IF}: begin
        next_state = `STATE_ID_J;
      end

      {`J, `STATE_ID_J}: begin
        next_state = 4'bx;
      end

      // The life cycle of JAL is (STATE_IF -> STATE_ID_J -> STATE_WB_JAL -> STATE_IF)
      {`JAL, `STATE_IF}: begin
        next_state = `STATE_ID_J;
      end

      {`JAL, `STATE_ID_J}: begin
        next_state = `STATE_WB_JAL;
      end

      {`JAL, `STATE_WB_JAL}: begin
        next_state = `STATE_IF;
      end

      // The life cycle of JR is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_ADD0 -> STATE_WB_JR -> STATE_IF)
      {`JR, `STATE_IF}: begin
        next_state = `STATE_ID_1;
      end

      {`JR, `STATE_ID_1}: begin
        next_state = `STATE_EX_A_ADD0;
      end

      {`JR, `STATE_EX_A_ADD0}: begin
        next_state = `STATE_WB_JR;
      end

      {`JR, `STATE_WB_JR}: begin
        next_state = `STATE_IF;
      end

      // The life cycle of BNE is (STATE_IF -> STATE_ID_BNE -> STATE_EX_BNE -> STATE_IF)
      {`BNE, `STATE_IF}: begin
        next_state = `STATE_ID_BNE;
      end

      {`BNE, `STATE_ID_BNE}: begin
        next_state = `STATE_EX_BNE;
      end

      {`BNE, `STATE_EX_BNE}: begin
        next_state = `STATE_IF;
      end
    endcase
  end
endmodule

// module test();
  
//   wire [3:0] next_state;
//   reg [3:0] state;
//   reg [5:0] instr;

//   initial begin
//     state = 4'b1000;
//     instr = 6'b000101;
//   end

//   fsmCommand DUT(next_state, state, instr);

//   initial begin
//     #10
//     $display("%b, %b, %b", next_state, state, instr);
//   end

// endmodule