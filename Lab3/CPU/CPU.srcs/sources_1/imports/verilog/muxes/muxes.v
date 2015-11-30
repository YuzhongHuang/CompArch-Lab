module mux4to1
	(
		output[31:0] 	out,
		input[1:0] 	address,
		input[31:0] 	in0, in1, in2, in3
	);
	wire[31:0] inputs[3:0];
	assign inputs[0] = in0;
	assign inputs[1] = in1;
	assign inputs[2] = in2;
	assign inputs[3] = in3;
	assign out = inputs[address];
endmodule

module mux3to1
	(
		output[31:0] 	out,
		input[1:0] 	address,
		input[31:0] 	in0, in1, in2
	);
	wire[31:0] inputs[2:0];
	assign inputs[0] = in0;
	assign inputs[1] = in1;
	assign inputs[2] = in2;
	assign out = inputs[address];
endmodule

module mux2to1
	(
		output[31:0] 	out,
		input  		address,
		input[31:0] 	in0, in1
	);
	wire [31:0] inputs[1:0];
	assign inputs[0] = in0;
	assign inputs[1] = in1;
	assign out = inputs[address];
endmodule

module mux3to1dst
	(
		output[4:0] 	out,
		input[1:0] 	address,
		input[4:0] 	in0, in1, in2
	);
	wire[4:0] inputs[2:0];
	assign inputs[0] = in0;
	assign inputs[1] = in1;
	assign inputs[2] = in2;
	assign out = inputs[address];
endmodule

