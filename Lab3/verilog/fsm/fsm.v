/*
 * simple finite state machine to encode control signals based on states
 */

module fsm 
(
	input 		clk, // positive edge of the serial clock 
	input 		zeroflag,
	input [5:0] instr,
	input [5:0] IR_ALU_OP,
	// output reg 	[3:0] currState,
	output reg 	PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
				A_WE, B_WE, REG_WE, REG_IN,
	output reg 	[1:0] ALU_SRCB, PC_SRC, DST,
	output reg 	[5:0] ALU_OP
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

/*
* state reg declaration
*/

// TODO: Decode Instruction Sequence for ALU Operation
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
			   .clk(clk));

	always @(posedge clk) begin
	 	PC_WE <= 0; MEM_IN <= 0; MEM_WE <= 0; IR_WE <= 0;
		ALU_SRCA <= 0; ALU_OP <= 0; A_WE <= 0; B_WE <= 0; 
		REG_WE <= 0; REG_IN <= 0; DST <= 0; ALU_SRCB <= 0; PC_SRC <= 0;
		// $display("Instruction: %b", instr);
		// $display("state: %b", state);
		// $display("next state: %b", next_state);
		/*
		 * case statement to change around states given the situation
		 */
		case (state)
			default: begin
				MEM_IN <= 1;
				IR_WE <= 1;
				state <= 0;
				$display("\nfsm default");
			end

			STATE_IF: begin // read address bits from MOSI
				PC_WE <= 1;
				MEM_IN <= 1;
				IR_WE <= 1;
				ALU_SRCA <= 1;
				PC_SRC <= 1;
				ALU_OP <= 32;
				state <= next_state;
				$display("\nfsm IF");
			end

			STATE_ID_1: begin
				A_WE <= 1;
				B_WE <= 1;
				state <= next_state;
				$display("\nfsm ID_1");
			end

			STATE_ID_J: begin
				PC_WE <= 1;
				state <= next_state;
				$display("\nfsm ID_J");
			end

			STATE_ID_BNE: begin
				ALU_SRCA <= 1; //PC
				ALU_SRCB <= 2;//SE(Imm)
				PC_SRC <= 1; //ALU
				A_WE <= 1;
				B_WE <= 1;
				state <= 4'bx;
				$display("\nfsm ID_BNE");
			end

			STATE_EX_OP_IMM: begin
				ALU_OP <= 14;
				ALU_SRCB <= 2;
				state <= next_state;
				$display("instr: %b", instr);
				$display("NEXT STATE: %b", next_state);
				$display("\nfsm EX_OP_IMM");
			end

			STATE_EX_ADDI: begin
				ALU_SRCB <= 2; //SE(Imm)
				ALU_OP <= 32;
				state <= next_state;
				$display("\nfsm EX_ADDI");
			end

			STATE_EX_A_OP_B: begin
				ALU_SRCB <= 1; // B
				$display("IR_ALU_OP: %b", IR_ALU_OP);
				ALU_OP <= IR_ALU_OP;
				//ALU_OP <= 32;
				state <= next_state;
				$display("\nfsm EX_A_OP_B");
			end

			STATE_EX_A_ADD0: begin
				ALU_OP <= 32;
				state <= next_state;
				// GO TO NEXT STATE
				$display("\nfsm EX_A_ADD0");
			end

			STATE_EX_BNE: begin
				PC_WE <= !zeroflag;
				ALU_SRCB <= 1;
				ALU_OP <= 34;
				PC_SRC <= 2; 
				state <= next_state;
				$display("\nfsm EX_BNE");
			end

			STATE_MEM_READ: begin
				state <= next_state;
				// GO TO NEXT STATE
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
				PC_WE <= 1;
				PC_SRC <= 2;
				state <= 4'bx;
				$display("\nfsm WB_JR");
			end
		endcase
		// currState <= state;
		$display("ALU_OP: %b", ALU_OP);
	end	
endmodule


// module testfsm();

// 	reg clk, zeroflag;
// 	wire PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
// 				A_WE, B_WE, REG_WE, REG_IN;
// 	wire [1:0] ALU_SRCB, PC_SRC, DST;
// 	wire [2:0] ALU_OP;

// 	fsm myFsm(clk, zeroflag, PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
// 				A_WE, B_WE, REG_WE, REG_IN, ALU_SRCB, PC_SRC, DST, ALU_OP);

// 	always begin
// 		#5 clk = !clk;
// 	end

// 	always @(myFsm.state, myFsm.clk) begin
// 		$display("STATE: %b", myFsm.state);
// 	end

// 	initial begin 
// 		clk=0; #20;
// 		$display("PC_WE: %b", myFsm.PC_WE);
// 		$finish;
// 	end

// endmodule
 
