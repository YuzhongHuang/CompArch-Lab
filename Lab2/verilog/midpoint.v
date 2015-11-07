`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint(
	// input button, switches and LEDs for FPGA testing
	input btn,
	input[1:0] sw, 
	output[3:0] led,
	input clk
	);
    
    wire serialOut;
    wire [7:0] parallelOut;
	wire [2:0] rising, falling, conditioned;
	
	// assigning the prarlell output to the leds
	// here I displays the four lower significance bit
	assign led = parallelOut[3:0];

	// provides inputs to the three input conditioner
	inputconditioner cond0(clk, btn, conditioned[0], rising[0], falling[0]);
	inputconditioner cond1(clk, sw[0], conditioned[1], rising[1], falling[1]);
	inputconditioner cond2(clk, sw[1], conditioned[2], rising[2], falling[2]);

	// connect the output of conditioners as described in the lab2
	shiftregister shiftreg(clk, rising[2], falling[0], 8'hA5, conditioned[1], parallelOut, serialOut);
endmodule
