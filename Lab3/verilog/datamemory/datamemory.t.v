`include "datamemory.v"

module testdatamemory();	
	wire [31:0] dout;	
	wire [31:0] address;
	wire [31:0] din;
	wire wr_enable, clk;

	reg	begintest;
	wire dutpassed;

	datamemory dut(.dout(dout),
			.din(din),
			.address(address),
			.wr_enable(wr_enable),
			.clk(clk));

	datamemorytestbench test(.begintest(begintest),
							.endtest(endtest),
							.dutpassed(dutpassed),
							.address(address),
							.din(din),
							.wr_enable(wr_enable),
							.clk(clk),
							.dout(dout));

	initial begin
        begintest = 0;
        #10;
        begintest = 1;
        #10000;
    end

    always @(posedge endtest) begin
        if (dutpassed == 1) begin
            $display("\n\033[32mDUT passed: %b\033[37m\n", dutpassed);
        end else begin
            $display("\n\033[31mDUT passed: %b\033[37m\n", dutpassed);
        end
    end
	
endmodule

module datamemorytestbench (
	input begintest,
	output reg endtest,
	output reg dutpassed,

	output reg [31:0] address,
	output reg [31:0] din,
	output reg wr_enable, clk,
	input [31:0] dout
);

	always begin
        #5 clk = !clk;
    end

	always @(posedge begintest) begin
		endtest = 0;
		dutpassed = 1;
		clk = 0;

		// Write a bunch of data to separate memory addresses
		wr_enable=1; 
		address=25; din=1407; #10;
		address=1789; din=85; #10;
		address=2**12-1; din=20; #10;
		address=0; din=2**32-1; #10;

		// Then read from each written address
		wr_enable=0; 
		address=25; #10;
		if (dout != 1407) begin
			dutpassed = 0;
			$display("Port %d broken", address);
		end

		address=1789; #10;
		if (dout != 85) begin
			dutpassed = 0;
			$display("Port %d broken", address);
		end

		address=2**12-1; #10;
		if (dout != 20) begin
			dutpassed = 0;
			$display("Port %d broken", address);
		end

		address=0; #10;
		if (dout != 2**32-1) begin
			dutpassed = 0;
			$display("Port %d broken", address);
		end

		endtest = 1;
		$finish;
	end

endmodule