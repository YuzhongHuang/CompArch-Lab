module testCPU();
	reg clk;
	integer index;
	CPU ourCpu(clk);

	initial begin
		$dumpfile("cpu.vcd");
		$dumpvars(0, testCPU);
		clk = 0;
		#1000;
		for (index = 0; index < 32; index = index + 1) begin: registerGen
            $display("Register %d: %b", index, ourCpu.RegisterFile.data[index]);
        end
		$finish;
	end

	always @(ourCpu.FSM.instr) begin
		if (ourCpu.FSM.instr == 6'b000101) begin
			for (index = 0; index < 32; index = index + 1) begin: sup
	            $display("Register %d: %b", index, ourCpu.RegisterFile.data[index]);
	        end
		end
	end

	always begin
		#5 clk = !clk;
	end
	
endmodule