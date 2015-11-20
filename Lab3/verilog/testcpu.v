module testCPU();
// <<<<<<< HEAD
// 	wire clk;
// 	reg begintest;
// 	wire dutpassed;

// 	CPU dut(.clk(clk));

// 	CPUtestbench test(
// 		.begintest(begintest),
// 		.endtest(endtest),
// 		.dutpassed(dutpassed),
// 		.clk(clk));

// 	initial begin
// 		begintest = 0;
// 		#10;
// 		begintest = 1;
// 		#10000;
// 	end

// 	integer index;

// 	always @(posedge endtest) begin
// 		for (index = 0; index < 32; index = index + 1) begin: registerGen
//             $display("%d: %d", index, ourCpu.RegisterFile.data[index]);
//         end
// 	end
// endmodule

// module CPUtestbench(
// 	input begintest,
// 	output reg endtest,
// 	output reg dutpassed,

// 	output reg clk
// );

// 	always begin
// 		#5 clk = !clk;
// 	end

// 	always @(posedge begintest) begin
// 		endtest = 0;
// 		dutpassed = 1;

// 		clk = 0; #50;

// 		endtest = 1;
// 		$finish;
// 	end

// =======
	reg clk;
	integer index;
	CPU ourCpu(clk);

	initial begin
		$dumpfile("cpu.vcd");
		$dumpvars(0, testCPU);
		clk = 0;
		#120;
		// for (index = 0; index < 32; index = index + 1) begin: registerGen
  //           $display("Register %d: %b", index, ourCpu.RegisterFile.data[index]);
  //       end
		$finish;
	end

	always @(ourCpu.PC.q) begin
		$display("CPU Q: %b", ourCpu.PC.q);
	end

	always @(ourCpu.IR.instr) begin
		$display("IR instr: %b", ourCpu.IR.instr);
	end

	always begin
		#5 clk = !clk;
	end
	
endmodule