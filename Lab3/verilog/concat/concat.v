module concat
(
	output[31:0] concat,
	input[3:0] PC,
	input[25:0] dout,
);

assign concat = {PC, dout, 2'b00};

endmodule
