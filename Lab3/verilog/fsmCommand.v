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
`define ADD   6'b100000
`define SUB   6'b100010
`define SLT   6'b101010
`define J     6'b000010
`define JAL   6'b000010
`define JR    6'b001000
`define BNE   6'b000101

module fsmCommand (
	output reg[3:0] next_state, 
  input[3:0] state,
	input[6:0] opcode
	);

/*
 * state encoding
 */
  localparam  STATE_IF = 0,
              STATE_ID_1 = 1,
              STATE_ID_J = 2,
              STATE_ID_BNE = 3,
              STATE_EX_OP_IMM = 4,
              STATE_EX_ADDI = 5,
              STATE_EX_A_OP_B = 6,
              STATE_EX_A_ADD0 = 7,
              STATE_EX_BNE = 8,
              STATE_MEM_READ = 9,
              STATE_MEM_WRITE = 10,
              STATE_WB_XORI = 11,
              STATE_WB_LW = 12,
              STATE_WB_ALU = 13,
              STATE_WB_JAL = 14,
              STATE_WB_JR = 15;

  always @(opcode) begin
    case (opcode)
      // The life cycle of XORI is (STATE_IF -> STATE_ID_1 -> STATE_EX_OP_IMM -> STATE_WB_XORI -> STATE_IF)
      `XORI:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_1;
              end

              STATE_ID_1: begin 
                  next_state <= STATE_EX_OP_IMM;
              end

              STATE_EX_OP_IMM: begin 
                  next_state <= STATE_WB_XORI;
              end

              STATE_WB_XORI: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end 

      // The life cycle of LW is (STATE_IF -> STATE_ID_1 -> STATE_EX_ADDI -> STATE_MEM_READ -> STATE_WB_LW -> STATE_IF)
      `LW:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_1;
              end

              STATE_ID_1: begin 
                  next_state <= STATE_EX_ADDI;
              end

              STATE_EX_ADDI: begin 
                  next_state <= STATE_MEM_READ;
              end

              STATE_MEM_READ: begin 
                  next_state <= STATE_WB_LW;
              end

              STATE_WB_LW: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of SW is (STATE_IF -> STATE_ID_1 -> STATE_EX_ADDI -> STATE_MEM_WRITE -> STATE_IF)
      `SW:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_1;
              end

              STATE_ID_1: begin 
                  next_state <= STATE_EX_ADDI;
              end

              STATE_EX_ADDI: begin 
                  next_state <= STATE_MEM_WRITE;
              end

              STATE_MEM_WRITE: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of ADD is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_OP_B -> STATE_WB_ALU -> STATE_IF)
      `ADD:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_1;
              end

              STATE_ID_1: begin 
                  next_state <= STATE_EX_A_OP_B;
              end

              STATE_EX_A_OP_B: begin 
                  next_state <= STATE_WB_ALU;
              end

              STATE_WB_ALU: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of SUB is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_OP_B -> STATE_WB_ALU -> STATE_IF)
      `SUB:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_1;
              end

              STATE_ID_1: begin 
                  next_state <= STATE_EX_A_OP_B;
              end

              STATE_EX_A_OP_B: begin 
                  next_state <= STATE_WB_ALU;
              end

              STATE_WB_ALU: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of SLT is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_OP_B -> STATE_WB_ALU -> STATE_IF)
      `SLT:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_1;
              end

              STATE_ID_1: begin 
                  next_state <= STATE_EX_A_OP_B;
              end

              STATE_EX_A_OP_B: begin 
                  next_state <= STATE_WB_ALU;
              end

              STATE_WB_ALU: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of J is (STATE_IF -> STATE_ID_J -> STATE_IF)
      `J:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_J;
              end

              STATE_ID_J: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of JAL is (STATE_IF -> STATE_ID_J -> STATE_WB_JAL -> STATE_IF)
      `JAL:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_J;
              end

              STATE_ID_J: begin 
                  next_state <= STATE_WB_JAL;
              end

              STATE_WB_JAL: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of JR is (STATE_IF -> STATE_ID_1 -> STATE_EX_A_ADD0 -> STATE_WB_JR -> STATE_IF)
      `JR:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_1;
              end

              STATE_ID_1: begin 
                  next_state <= STATE_EX_A_ADD0;
              end

              STATE_EX_A_ADD0: begin 
                  next_state <= STATE_WB_JR;
              end

              STATE_WB_JR: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end

      // The life cycle of BNE is (STATE_IF -> STATE_ID_BNE -> STATE_EX_BNE -> STATE_IF)
      `BNE:  begin 
          case (state)
              STATE_IF: begin 
                  next_state <= STATE_ID_BNE;
              end

              STATE_ID_BNE: begin 
                  next_state <= STATE_EX_BNE;
              end

              STATE_EX_BNE: begin 
                  next_state <= STATE_IF;
              end
          endcase    
      end
    endcase
  end
endmodule