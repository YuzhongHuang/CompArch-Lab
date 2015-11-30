module testCPU();
	reg clk;
	integer index;
	CPU ourCpu(clk);

	initial begin
		$dumpfile("cpu.vcd");
		$dumpvars(0, testCPU);
		clk = 0;
		#800;
		for (index = 0; index < 32; index = index + 1) begin: registerGen
            $display("Register %d: %b", index, ourCpu.RegisterFile.data[index]);
        end
		$finish;
	end

	always begin
		#5 clk = !clk;
	end
	
endmodule