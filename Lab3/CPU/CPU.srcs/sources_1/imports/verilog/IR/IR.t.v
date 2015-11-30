module IRTest ();
	wire    	IR_WE;	
	wire 		clk;
	wire[31:0]	instr;

	wire[4:0]	Rs;
	wire[4:0]	Rt;
	wire[4:0]	Rd;
	wire[5:0]	funct;
	wire[5:0]	opcode; 
	wire[15:0] 	imm;
	wire[25:0]	J_addr;

	reg		begintest;
	wire	dutpassed;

	IR DUT(.clk(clk),
		   .IR_WE(IR_WE),
		   .instr(instr),
		   .Rs(Rs),
		   .Rt(Rt),
		   .Rd(Rd),
		   .funct(funct),
		   .opcode(opcode),
		   .imm(imm),
		   .J_addr(J_addr));

	IRtestbench test(.begintest(begintest),
						  .endtest(endtest),
						  .dutpassed(dutpassed),
						  .clk(clk),
						  .IR_WE(IR_WE),
						  .instr(instr),
						  .Rs(Rs),
						  .Rt(Rt),
						  .Rd(Rd),
						  .funct(funct),
						  .opcode(opcode),
						  .imm(imm),
						  .J_addr(J_addr));

	initial begin
        begintest = 0;
        #10;
        begintest = 1;
        #10000;
    end

    always @(posedge endtest) begin
        if (dutpassed == 1) begin
            $display("\n\033[32mDUT passed: %b\033[37m\n", dutpassed);
        end else begin
            $display("\n\033[31mDUT passed: %b\033[37m\n", dutpassed);
        end
    end

endmodule

module IRtestbench(
	input 				begintest,
	output reg 			endtest,
	output reg 			dutpassed,

	output reg [31:0]	instr,
	output reg			clk,
	output reg			IR_WE,

	input [4:0]		Rs,
	input [4:0]		Rt,
	input [4:0]		Rd,
	input [5:0]		funct,
	input [5:0]		opcode, 
	input [15:0] 	imm,
	input [25:0]	J_addr
);
	initial begin
		IR_WE = 1;
		clk = 0;
		instr = 32'b0000_0000_0010_0010_0010_0000_0010_0000;
		// instr = 32'b0000_00ss_ssst_tttt_dddd_d000_0010_0000
	end

	always begin
        #5 clk = !clk;
    end

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;

		#5
		if (Rs != 1) begin
			$display("Rs fails");
			dutpassed = 0;
		end

		if (Rt != 2) begin
			$display("Rt fails");
			dutpassed = 0;
		end

		if (Rd != 4) begin
			$display("Rd fails");
			dutpassed = 0;
		end

		if (funct != 32) begin
			$display("funct fails");
			dutpassed = 0;
		end

		if (opcode != 0) begin
			$display("opcode fails");
			dutpassed = 0;
		end

		if (imm != 8224) begin
			$display("imm fails");
			dutpassed = 0;
		end
			
		if ((J_addr != 2236448)) begin
			$display("J_addr fails");
			dutpassed = 0;
		end

		// disable IR_WE and write a new instruction
		IR_WE = 0;
		instr = 32'b1000_1100_0100_0100_0100_0000_0000_0000;
		// instr = 32'b0000_00ss_ssst_tttt_dddd_d000_0010_0000
		#10

		if ((Rs == 2) || (Rt == 4) || (Rd == 8) ||
			(funct == 0) || (opcode == 35) ||
			(imm == 16384) || (J_addr == 4472832)) 
		begin
			$display("IR_WE fails");
			dutpassed = 0;	
		end

		// $display("Rs: %b", Rs);
		// $display("Rt: %b", Rt);
		// $display("Rd: %b", Rd);
		// $display("funct: %b", funct);
		// $display("opcode: %b", opcode);
		// $display("imm: %b", imm);
		// $display("J_addr: %b", J_addr);

		endtest = 1;
		$finish;
	end
endmodule