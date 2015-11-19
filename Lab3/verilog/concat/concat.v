module concat
(
	output [31:0] concat,
	input [31:0] PC,
	input [25:0] dout
);

assign concat = {PC[31:28], dout, 2'b00};

endmodule
