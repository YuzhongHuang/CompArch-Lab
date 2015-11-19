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
		$readmemb("datamemory/YuzhongSelinaHieu.dat", memory);
	end

	assign dout = memory[address];
endmodule

// module testmemory();

// 	wire [31:0] dout;
// 	reg [31:0] din;
// 	reg [31:0] addr;
// 	reg wr_enable, clk;

// 	datamemory dut(dout, din, addr, wr_enable, clk);

// 	always begin
// 		#5 clk = !clk;
// 	end

// 	initial begin
// 		clk=0; wr_enable=0; 

// 		addr=0; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		addr=addr+1; #10;
// 		$display("Addr: %d | WE: %b | Dout: %b", addr, wr_enable, dout);
// 		$finish;
// 	end

// endmodule

