module concat
(
	output [31:0] concat,
	input [25:0] dout
);

assign concat = {6'b0, dout};

endmodule
