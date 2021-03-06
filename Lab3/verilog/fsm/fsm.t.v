`include "fsm.v"
`include "fsmCommand.v"

module testFsm();

	wire clk;
	wire zeroflag;
	wire [5:0] instr;
	wire [3:0] currState;
	reg begintest;

    wire PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
				A_WE, B_WE, REG_WE, REG_IN;
	wire [1:0] ALU_SRCB, PC_SRC, DST;
	wire [5:0] ALU_OP;
    
    fsm dut(.clk(clk),
    		.zeroflag(zeroflag),
    		.instr(instr),
    		.currState(currState),
			.PC_WE(PC_WE),
			.MEM_IN(MEM_IN),
			.MEM_WE(MEM_WE),
			.IR_WE(IR_WE),
			.ALU_SRCA(ALU_SRCA),
			.A_WE(A_WE),
			.B_WE(B_WE),
			.REG_WE(REG_WE),
			.REG_IN(REG_IN),
			.ALU_SRCB(ALU_SRCB),
			.PC_SRC(PC_SRC),
			.DST(DST),
			.ALU_OP(ALU_OP));


    fsmtestbench test(.begintest(begintest),
	                    .endtest(endtest),
	                    .dutpassed(dutpassed),
	                    .clk(clk),
	                    .zeroflag(zeroflag),
	                    .instr(instr),
	                    .currState(currState),
	                    .PC_WE(PC_WE),
	                    .MEM_IN(MEM_IN),
                        .MEM_WE(MEM_WE),
                        .IR_WE(IR_WE),
                        .ALU_SRCA(ALU_SRCA),
						.A_WE(A_WE),
						.B_WE(B_WE),
						.REG_WE(REG_WE),
						.REG_IN(REG_IN),
						.ALU_SRCB(ALU_SRCB),
						.PC_SRC(PC_SRC),
						.DST(DST),
						.ALU_OP(ALU_OP));


    // Generate clock (50MHz)
    initial begin
        begintest = 0;
        #10;
        begintest = 1;
        #10000;
    end

    // Display test results ('dutpassed' signal) once 'endtest' goes high
    always @(posedge endtest) begin
        if (dutpassed == 1) begin
            $display("\n\033[32mDUT passed?: %b\033[37m\n", dutpassed);
        end else begin
            $display("\n\033[31mDUT passed?: %b\033[37m\n", dutpassed);
        end
    end
    
endmodule

module fsmtestbench (
    input           begintest,  // Triggers start of testing
    output reg      endtest,    // Raise once test completes
    output reg      dutpassed,  // Signal test result)

    output reg      clk, zeroflag,
    output reg[5:0] instr,
    input [3:0]     currState,
    input           PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
					A_WE, B_WE, REG_WE, REG_IN,
    input [1:0] 	ALU_SRCB, PC_SRC, DST,
    input [5:0] 	ALU_OP);

    initial begin
        // $dumpfile("../wave/testConditioner.vcd");
        // $dumpvars(0, inputcondtestbench);
        instr = 6'b001110;
        zeroflag = 0;
        clk = 0;
        #10
        $display("XORI IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end
    end

    reg [17:0] outputs; 

    always begin
        #5 clk = !clk;
    end

    always @(instr, currState) begin
    	assign outputs = {PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
					A_WE, B_WE, REG_WE, REG_IN, ALU_SRCB, PC_SRC, DST, ALU_OP};
        
    	// $display("Current state: %b", currState);
    	// $display("Outputs: %b", outputs);
    end

    always @(posedge begintest) begin
        endtest = 0;
        dutpassed = 1;
        #10
        // $display("XORI ID");
        if ((currState == 1) && (outputs != 21'b00_0001_1000_0000_0000_000)) begin
        	dutpassed = 0;
        	$display("XORI ID phase broken.");
        end

        #10;
        // $display("XORI EX");
        if ((currState == 4) && (outputs != 21'b00_0000_0000_0000_0000_010)) begin
        	dutpassed = 0;
        	$display("XORI EX phase broken.");
       	end

        #10;
        // $display("XORI WB");
        if ((currState == 11) && (outputs != 21'b00_0000_0100_0000_0000_000)) begin
       		dutpassed = 0;
       		$display("XORI WB phase broken.");
   		end



        // LW
        instr = 6'b100011; 
        #10
        // $display("LW IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end

        #10
        // $display("LW ID");
        if ((currState == 1) && (outputs != 21'b00_0001_1000_0000_0000_000)) begin
            dutpassed = 0;
            $display("LW ID phase broken.");
        end
        #10 
        // $display("LW EX");
        if ((currState == 5) && (outputs != 21'b00_0000_0001_0000_0000_000)) begin
            dutpassed = 0;
            $display("LW EX phase broken.");
        end
        #10 
        // $display("LW MEM");
        if ((currState == 9) && (outputs != 0)) begin
            dutpassed = 0;
            $display("LW MEM phase broken.");
        end 
        #10 
        // $display("LW WB");
        if ((currState == 12) && (outputs != 21'b00_0000_0110_0000_0000_000)) begin
            dutpassed = 0;
            $display("LW WB phase broken.");
        end



        // SW
        instr = 6'b101011; 
        #10
        // $display("SW IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10
        // $display("SW ID");
        if ((currState == 1) && (outputs != 21'b00_0001_1000_0000_0000_000)) begin
            dutpassed = 0;
            $display("SW ID phase broken.");
        end 
        #10
        // $display("SW EX");
        if ((currState == 5) && (outputs != 21'b00_0000_0001_0000_0000_000)) begin
            dutpassed = 0;
            $display("SW EX phase broken.");
        end 
        #10
        // $display("SW MEM");
        if ((currState == 10) && (outputs != 21'b00_1000_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("SW MEM phase broken.");
        end



        // ADD
        instr = 6'b100000; 
        #10;
        // $display("ADD IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10;
        // $display("ADD ID");
        if ((currState == 1) && (outputs != 21'b00_0001_1000_0000_0000_000)) begin
            dutpassed = 0;
            $display("ADD ID phase broken.");
        end 
        #10;
        // $display("ADD EX");
        if ((currState == 6) && (outputs != 21'b00_0000_0001_0000_0000_000)) begin
            dutpassed = 0;
            $display("ADD EX phase broken.");
        end 
        #10;
        // $display("ADD WB");
        if ((currState == 13) && (outputs != 21'b00_0000_0100_0000_1000_000)) begin
            dutpassed = 0;
            $display("ADD WB phase broken.");
        end

        // SUB
        instr = 6'b100010; 
        #10
        // $display("SUB IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10
        // $display("SUB ID");
        if ((currState == 1) && (outputs != 21'b00_0001_1000_0000_0000_000)) begin
            dutpassed = 0;
            $display("SUB ID phase broken.");
        end 
        #10
        // $display("SUB EX");
        if ((currState == 6) && (outputs != 21'b00_0000_0001_0000_0000_000)) begin
            dutpassed = 0;
            $display("SUB EX phase broken.");
        end 
        #10
        // $display("SUB WB");
        if ((currState == 13) && (outputs != 21'b00_0000_0100_0000_1000_000)) begin
            dutpassed = 0;
            $display("SUB WB phase broken.");
        end



        // SLT
        instr = 6'b101010; 
        #10
        // $display("SLT IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10
        // $display("SLT ID");
        if ((currState == 1) && (outputs != 21'b00_0001_1000_0000_0000_000)) begin
            dutpassed = 0;
            $display("SLT ID phase broken.");
        end 
        #10
        // $display("SLT EX");
        if ((currState == 6) && (outputs != 21'b00_0000_0001_0000_0000_000)) begin
            dutpassed = 0;
            $display("SLT EX phase broken.");
        end 
        #10
        // $display("SLT WB");
        if ((currState == 13) && (outputs != 21'b00_0000_0100_0000_1000_000)) begin
            dutpassed = 0;
            $display("SLT WB phase broken.");
        end



        // JUMP
        instr = 6'b000010; 
        #10
        // $display("J IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10
        // $display("J ID");
        if ((currState == 2) && (outputs != 21'b10_0000_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("JUMP ID phase broken.");
        end



        // JUMP AND LINK
        instr = 6'b000011; 
        #10
        // $display("JAL IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10
        // $display("JAL ID");
        if ((currState == 2) && (outputs != 21'b10_0000_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("JAL ID phase broken.");
        end 
        #10
        // $display("JAL WB");
        if ((currState == 14) && (outputs != 21'b00_0000_0110_0001_0000_000)) begin
            dutpassed = 0;
            $display("JAL WB phase broken.");
        end



        // JUMP REGISTER
        instr = 6'b001000; 
        #10
        // $display("JR IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10
        // $display("JR ID");
        if ((currState == 1) && (outputs != 21'b00_0001_1000_0000_0000_000)) begin
            dutpassed = 0;
            $display("JR ID phase broken.");
        end 
        #10
        // $display("JR EX");
        if ((currState == 7) && (outputs != 0)) begin
            dutpassed = 0;
            $display("JR EX phase broken.");
        end 
        #10
        // $display("JR WB");
        if ((currState == 15) && (outputs != 21'b10_0000_0000_0100_0000_000)) begin
            dutpassed = 0;
            $display("JR WB phase broken.");
        end



        // BNE
        instr = 6'b000101; 
        #10
        // $display("BNE IF");
        if ((currState == 0) && (outputs != 21'b11_0110_0000_0000_0000_000)) begin
            dutpassed = 0;
            $display("IF phase broken.");
        end 
        #10
        // $display("BNE ID");
        if ((currState == 3) && (outputs != 21'b00_0011_1001_0010_0000_000)) begin
            dutpassed = 0;
            $display("BNE ID phase broken.");
        end 
        #10
        // $display("BNE EX");
        if ((currState == 8) && (outputs != {!zeroflag, 20'b0_0000_0000_1100_0000_011})) begin
            dutpassed = 0;
            $display("BNE EX phase broken.");
        end

        endtest = 1;
        $finish;
    end

endmodule












