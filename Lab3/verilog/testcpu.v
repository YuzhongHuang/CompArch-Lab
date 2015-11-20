module testCPU();
	integer index;
	reg clk;
	CPU ourCpu(clk);

	initial begin
		$display("Hi from testCPU");
		clk = 0; #5
		$display("Hi from testCPU");
		clk = 1; #5
		$display("Hi from testCPU");
		clk = 0; #5
		$display("Hi from testCPU");
		clk = 1; #5
		$display("Hi from testCPU");
		clk = 0; #5
		$display("Hi from testCPU");
		clk = 1; #5
		$display("Hi from testCPU");
	end

	// always begin
	// 	#5 clk = !clk;
	// end
	
endmodule