`include "shiftregister.v"
`include "inputconditioner.v"

module midpoint(
	input button0,
	input switch0, 
	input switch1,
	input parallelIn,
	clk,
	output [7:0] parallelOut,
	output serialOut);

	wire [2:0] rising, falling, conditioned;

	inputconditioner cond0(clk, button0, conditioned[0], rising[0], falling[0]);
	inputconditioner cond1(clk, switch0, conditioned[1], rising[1], falling[1]);
	inputconditioner cond2(clk, switch1, conditioned[2], rising[2], falling[2]);

	shiftregister (#8) shiftreg(clk, rising[2], falling[0], parallelIn, conditioned[1], parallelOut, serialOut);
endmodule