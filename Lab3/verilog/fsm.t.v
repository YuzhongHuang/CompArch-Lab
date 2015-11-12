`include "fsm.v"

module testFsm();

	wire clk;
	wire zeroflag;
	wire [3:0] instr;
	wire [3:0] currState;
	reg begintest;

    wire PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
				A_WE, B_WE, REG_WE, REG_IN;
	wire [1:0] ALU_SRCB, PC_SRC, DST;
	wire [2:0] ALU_OP;
    
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
    
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)
    
endmodule

module fsmtestbench (
    input           begintest,  // Triggers start of testing
    output reg      endtest,    // Raise once test completes
    output reg      dutpassed,  // Signal test result)

    output reg      clk, zeroflag,
    output reg[3:0] instr, currState,
    input           PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
					A_WE, B_WE, REG_WE, REG_IN,
    input [1:0] 	ALU_SRCB, PC_SRC, DST,
    input [2:0] 	ALU_OP);

    initial begin
        // $dumpfile("../wave/testConditioner.vcd");
        // $dumpvars(0, inputcondtestbench);
        clk = 0;
        currState = 0; // IF
    end

    reg [17:0] outputs; 

    always begin
        #5 clk = !clk;
    end

    always @(instr, currState) begin
    	assign outputs = {PC_WE, MEM_IN, MEM_WE, IR_WE, ALU_SRCA,
					A_WE, B_WE, REG_WE, REG_IN, ALU_SRCB, PC_SRC, DST, ALU_OP};
    	$display("Current state: %b", currState);
    	$display("Outputs: %b", outputs);
    end

    always @(posedge begintest) begin
        endtest = 0;
        dutpassed = 1;

        // XORI
        instr = 0; #10;
        if ((currState == 0) && (outputs != 18'b11_0110_0000_0000_0000)) begin
        	dutpassed = 0;
        	$display("IF phase broken.");
        end else if ((currState == 1) && (outputs != 18'b00_0001_1000_0000_0000)) begin
        	dutpassed = 0;
        	$display("XORI ID phase broken.");
        end else if ((currState == 4) && (outputs != 18'b00_0000_0000_0000_0010)) begin
        	dutpassed = 0;
        	$display("XORI EX phase broken.");
       	end else if ((currState == 11) && (outputs != 18'b00_0000_0100_0000_0000)) begin
       		dutpassed = 0;
       		$display("XORI WB phase broken.");
   		end	

   		// LW
   		instr = 1; #10;
   		if ((currState == 0) && (outputs != 18'b11_0110_0000_0000_0000)) begin
        	dutpassed = 0;
        	$display("IF phase broken.");
        end else if ((currState == 1) && (outputs != 18'b00_0001_1000_0000_0000)) begin
        	dutpassed = 0;
        	$display("LW ID phase broken.");
        end else if ((currState == 5) && (outputs != 18'b00_0000_0001_0000_0000)) begin
        	dutpassed = 0;
        	$display("LW EX phase broken.");
       	end else if ((currState == 9) && (outputs != 18'b00_1000_0000_0000_0000)) begin
       		dutpassed = 0;
       		$display("LW MEM phase broken.");
   		end	else if ((currState == 12) && (outputs != 18'b00_0000_0110_0000_0000)) begin
   			dutpassed = 0;
   			$display("LW WB phase broken.");
   		end

   		

        $finish;
    end

endmodule






