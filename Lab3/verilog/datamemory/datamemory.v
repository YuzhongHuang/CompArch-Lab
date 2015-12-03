module datamemory(
	output [31:0] dout,
	input [31:0] din,
	input [31:0] address,
	input wr_enable,
	input clk
);

	reg [31:0] memory [2**15-1:0];

	always @(posedge clk) begin
		if (wr_enable) begin
			memory[address] <= din;
		end
	end

	initial begin
		$readmemb("datamemory/secondtest.dat", memory);
	end

	assign dout = memory[address];
endmodule

