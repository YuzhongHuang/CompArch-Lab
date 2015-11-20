module CPU(
	input clk
	);

	// control signals
	wire PC_WE;
	wire MEMIN;
	wire MEM_WE;
	wire IR_WE;
	wire ALU_SRCA;
	wire [1:0] ALU_SRCB;
	wire [5:0] ALUOP;
	wire [1:0] PC_SRC;
	wire [1:0] DST;
	wire REGIN;
	wire REG_WE;
	wire A_WE;
	wire B_WE;

	// all wires naming: fromSource_toSource
	wire [31:0] PC_out;

	wire [31:0] MemMux_DM;
	wire [31:0] DM_out;

	wire [25:0] IR_Concat;
	wire [4:0] IR_Rd;
	wire [4:0] IR_Rt;
	wire [15:0] IR_Imm16;
	wire [4:0] IR_Rs;
	wire [5:0] IR_FSM_opcode;
	wire [5:0] IR_FSM_funct;

	wire [31:0] SEImm_out;
	wire [31:0] Shifter_AluMuxB;

	wire [4:0]  DstMux_RegFile;
	wire [31:0] MDR_RegMux;
	wire [31:0] RegMux_RegFile;
	wire [31:0] RegFile_A;
	wire [31:0] RegFile_B;

	wire [31:0] A_AluMuxA;
	wire [31:0] B_out;

	wire [31:0] AluMuxA_Alu;
	wire [31:0] AluMuxB_Alu;

	wire [31:0] Alu_out;
	wire [31:0] AluRes_out;
	wire [31:0] Concat_PCMux;
	wire [31:0] PCMux_PC;

	wire zeroflag;

	//finite state machine
	fsm FSM(.zeroflag(zeroflag),
			.instr(IR_FSM_opcode),
			.IR_ALU_OP(ALUOP),
			.PC_WE(PC_WE),
			.MEM_IN(MEMIN),
			.MEM_WE(MEM_WE),
			.IR_WE(IR_WE),
			.ALU_SRCA(ALU_SRCA),
			.A_WE(A_WE),
			.B_WE(B_WE),
			.REG_WE(REG_WE),
			.REG_IN(REGIN),
			.ALU_SRCB(ALU_SRCB),
			.PC_SRC(PC_SRC),
			.DST(DST),
			.ALU_OP(ALUOP),
			.clk(clk));

	// Registers
	PC PC(.q(PC_out),
		.in(PCMux_PC),
		.wr_enable(PC_WE),
		.clk(clk)
		);

	DFF MDR(
		.q(MDR_RegMux),
		.in(DM_out),
		.wr_enable(1),
		.clk(clk)
		);

	DFF A(
		.q(A_AluMuxA),
		.in(RegFile_A),
		.wr_enable(1),
		.clk(clk)
		);

	DFF B(
		.q(B_out),
		.in(RegFile_B),
		.wr_enable(1),
		.clk(clk)
		);

	DFF Alu_Res(
		.q(AluRes_out),
		.in(Alu_out),
		.wr_enable(1),
		.clk(clk)
		);

	datamemory DM(.dout(DM_out),
				.din(B_out),
				.address(MemMux_DM),
				.wr_enable(MEM_WE),
				.clk(clk)
				);

	IR IR(.clk(clk),
		.IR_WE(IR_WE),
		.instr(DM_out),
		.Rs(IR_Rs),
		.Rt(IR_Rt),
		.Rd(IR_Rd),
		.funct(IR_FSM_funct),
		.opcode(IR_FSM_opcode),
		.imm(IR_Imm16),
		.J_addr(IR_Concat)
		);

	concat Concat(
		.concat(Concat_PCMux),
		.PC(PC_out),
		.dout(IR_Concat)
		);

	signextend SignExtend(
		.se(SEImm_out),
		.imm(IR_Imm16)
		);

	shifter ShifterLeft2(
		.out(Shifter_AluMuxB),
		.in(SEImm_out)
		);

	regfile RegisterFile(
		.ReadData1(RegFile_A),
		.ReadData2(RegFile_B),
		.WriteData(RegMux_RegFile),
		.ReadRegister1(IR_Rs),
		.ReadRegister2(IR_Rt),
		.WriteRegister(DstMux_RegFile),
		.RegWrite(REG_WE),
		.Clk(clk)
		);

	alu ALU(
		.alu_res(Alu_out),
		.zeroflag(zeroflag),
		.a(AluMuxA_Alu),
		.b(AluMuxB_Alu),
		.op(ALUOP),
		.clk(clk)
		);

	// All Muxes

	mux2to1 MemMux(
		.out(MemMux_DM),
		.address(MEMIN),
		.in0(AluRes_out),
		.in1(PC_out)
		);

	mux2to1 RegMux(
		.out(RegMux_RegFile),
		.address(REGIN),
		.in0(AluRes_out),
		.in1(MDR_RegMux)
		);

	mux3to1dst DstMux(
		.out(DstMux_RegFile),
		.address(DST),
		.in0(IR_Rt),
		.in1(IR_Rd),
		.in2(31)
		);

	mux2to1 AluMuxA(
		.out(AluMuxA_Alu),
		.address(ALU_SRCA),
		.in0(A_AluMuxA),
		.in1(PC_out)
		);

	mux4to1 AluMuxB(
		.out(AluMuxB_Alu),
		.address(ALU_SRCB),
		.in0(1),
		.in1(B_out),
		.in2(SEImm_out),
		.in3(Shifter_AluMuxB)
		);

	mux3to1 PCMux(
		.out(PCMux_PC),
		.address(PC_SRC),
		.in0(Concat_PCMux),
		.in1(Alu_out),
		.in2(AluRes_out)
		);
endmodule

































