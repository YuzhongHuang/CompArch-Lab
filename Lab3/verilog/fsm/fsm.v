/*
 * simple finite state machine to encode control signals based on states
 */

module fsm 
(
	input clk,
	input zeroflag,
	input [5:0] instr,
	input [5:0] IR_ALU_OP,
	output reg PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
				A_WE, B_WE, REG_WE, REG_IN, CONCAT_WE, SE_WE,
	output reg [1:0] ALU_SRCB, PC_SRC, DST,
	output reg [5:0] ALU_OP
);

// state encoding
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

initial begin
	MEM_IN <= 1;
	IR_WE <= 1;
end

reg[3:0] state;
wire [3:0] next_state;
reg[3:0] counter;

fsmCommand LUT(.next_state(next_state),
			   .state(state), 
			   .opcode(instr),
			   .alu(IR_ALU_OP),
			   .clk(clk));

	always @(posedge clk) begin
	 	PC_WE <= 0; MEM_IN <= 0; MEM_WE <= 0; IR_WE <= 0;
		ALU_SRCA <= 0; ALU_OP <= 0; A_WE <= 0; B_WE <= 0; 
		REG_WE <= 0; REG_IN <= 0; DST <= 0; ALU_SRCB <= 0; PC_SRC <= 0;
		CONCAT_WE <= 0; SE_WE <= 0;

		// case statement to change around states given the situation
		case (state)
			default: begin
				MEM_IN <= 1;
				IR_WE <= 1;
				state <= 0;
				$display("\nfsm default");
			end

			STATE_IF: begin
				PC_WE <= 1;
				MEM_IN <= 1;

				// If next state is BNE, do not allow IR to be overwritten
				if (next_state != STATE_ID_BNE) begin
					// If next state is Jump, Concat needs to be overwritten
					if (next_state == STATE_ID_J) begin
						CONCAT_WE <= 1;
					end else begin
						IR_WE <= 1;
					end
				end

				// If next state is BNE, or the instruction requires the immediate register,
				// allow it to be overwritten
				$display("instr: %d", instr);
				if ((next_state == STATE_ID_BNE) || (next_state == STATE_ID_J)) begin
					SE_WE <= 1;
				end

				ALU_SRCA <= 1;
				PC_SRC <= 1;
				ALU_OP <= 32;
				state <= next_state;
				
				$display("\nfsm IF");
			end

			STATE_ID_1: begin
				// Allow SE to be overwritten for XORI, SW and LW
				if ((instr == 14) || (instr == 43) || (instr == 35)) begin
					SE_WE <= 1;
				end
				A_WE <= 1;
				B_WE <= 1;
				state <= next_state;
				$display("\nfsm ID_1");
			end

			STATE_ID_J: begin
				//PC_WE <= 1;
				if (instr == 3) begin
					state <= STATE_WB_JAL;
					PC_WE <= 1;
				end else begin
					state <= 4'bx;
				end

				$display("\nfsm ID_J");
			end

			STATE_ID_BNE: begin
				PC_SRC <= 1; // chooses ALU out
				A_WE <= 1;
				B_WE <= 1;
				state <= next_state;
				$display("\nfsm ID_BNE");
			end

			STATE_EX_OP_IMM: begin
				ALU_OP <= 14;
				ALU_SRCB <= 2;
				state <= next_state;
				$display("\nfsm EX_OP_IMM");
			end

			STATE_EX_ADDI: begin
				ALU_SRCB <= 2; // chooses SE(Imm)
				ALU_OP <= 32;
				state <= next_state;
				$display("\nfsm EX_ADDI");
			end

			STATE_EX_A_OP_B: begin
				ALU_SRCB <= 1; // chooses Register B
				$display("IR_ALU_OP: %b", IR_ALU_OP);
				ALU_OP <= IR_ALU_OP;
				state <= next_state;
				$display("\nfsm EX_A_OP_B");
			end

			STATE_EX_A_ADD0: begin
				ALU_OP <= 32;
				state <= next_state;
				$display("\nfsm EX_A_ADD0");
			end

			STATE_EX_BNE: begin
				PC_WE <= !zeroflag;
				ALU_SRCA <= 1; // chooses PC
				ALU_SRCB <= 2; // chooses SE(Imm)
				ALU_OP <= 32;
				IR_WE <= 1;
				PC_SRC <= 1; 
				state <= 4'bx;
				$display("\nfsm EX_BNE");
			end

			STATE_MEM_READ: begin
				state <= next_state;
				$display("\nfsm MEM_READ");
			end

			STATE_MEM_WRITE: begin
				MEM_WE <= 1;
				state <= 4'bx;
				$display("\nfsm MEM_WRITE");
			end

			STATE_WB_XORI: begin
				REG_WE <= 1;
				state <= 4'bx;
				$display("\nfsm WB_XORI");
			end

			STATE_WB_LW: begin
				REG_WE <= 1;
				REG_IN <= 1;
				state <= 4'bx;
				$display("\nfsm WB_LW");
			end

			STATE_WB_ALU: begin
				REG_WE <= 1;
				DST <= 1;
				state <= 4'bx;
				$display("\nfsm WB_ALU");
			end

			STATE_WB_JAL: begin
				REG_WE <= 1;
				DST <= 2;
				state <= 4'bx;
				$display("\nfsm WB_JAL");
			end

			STATE_WB_JR: begin
				//PC_WE <= 1;
				PC_SRC <= 2;
				state <= 4'bx;
				$display("\nfsm WB_JR");
			end
		endcase
	end	
endmodule
