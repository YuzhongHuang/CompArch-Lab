`define AND and #50

module andGate32Bit(
	output [31:0] res,
	input [31:0] a,
	input [31:0] b
	);

	genvar index;

	generate
		for (index = 0; index<32; index = index + 1) begin
			`AND andgate(res[index], a[index], b[index]); 
		end
	endgenerate

endmodule	

module test;
	reg [31:0] a, b;
	wire [31:0] sum;
	
	andGate32Bit andgate(sum, a, b);

	initial begin
		a = 32'b01001; b = 32'b01010;
		$display("A: %b | B: %b | Res: %b", a, b, sum);
	end

endmodule