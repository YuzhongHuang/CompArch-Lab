module addrlatch (q, d, wrenable, clk);
	parameter W = 8;

	output reg [W-1:0] q;
	input [W-1:0] d;
	input wrenable;
	input clk;

	always @(posedge clk) begin
		if (wrenable) begin
			q = d;
		end
	end
endmodule