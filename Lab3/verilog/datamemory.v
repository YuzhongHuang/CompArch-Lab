module datamemory(
	output reg [31:0] dout,
	input [31:0] din,
	input [2**17-1:0] addr,
	input wr_enable,
	input clk
);

reg [31:0] memory [2**17-1:0];

always @(posedge clk) begin
	if (wr_enable) begin
		memory[addr] = din;
	end else begin
		dout = memory[addr];
	end
end

endmodule

module testmemory();

	wire [31:0] dout;
	reg [31:0] din;
	reg [2**17-1:0] addr;
	reg wr_enable, clk;

	datamemory dut(dout, din, addr, wr_enable, clk);

	always begin
		#5 clk = !clk;
	end

	initial begin
		clk=0; wr_enable=1; addr=25; din=1407; #10;
		$display("Addr: %d | WE: %b | Din: %d | Dout: %d", addr, wr_enable, din, dout);
		clk=0; wr_enable=0; addr=25; #10;
		$display("Addr: %d | WE: %b | Din: %d | Dout: %d", addr, wr_enable, din, dout);
		$finish;
	end

endmodule

