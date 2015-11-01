module midpoint(
	input[0:0] btn,
	input[1:0] sw, 
	output[3:0] led,
	// input parallelIn,
	input clk
	);
    
    wire serialOut;
    wire [7:0] parallelOut;
	wire [2:0] rising, falling, conditioned;
	
	assign led = parallelOut[3:0];

	inputconditioner cond0(clk, btn[0], conditioned[0], rising[0], falling[0]);
	inputconditioner cond1(clk, sw[0], conditioned[1], rising[1], falling[1]);
	inputconditioner cond2(clk, sw[0], conditioned[2], rising[2], falling[2]);

	shiftregister shiftreg(clk, rising[2], falling[0], 8'hA5, conditioned[1], parallelOut, serialOut);
endmodule
