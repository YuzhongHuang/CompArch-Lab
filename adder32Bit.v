`define XOR xor #50
`define AND and #50
`define OR or #50
`define NOT not #50

// 1-bit building block
module oneBitAdder(
	output out,
	output carryout,
	input a,
	input b,
	input carryin
	);
	
	wire a, b, carryin, carryout, out;
	wire x0, a0, a1;

	`XOR(x0, a, b);
	`XOR(out, x0, carryin);

	`AND(a0, x0, carryin);
	`AND(a1, a, b);

	`OR(carryout, a0, a1);
endmodule

// Full 32-bit adder
module FullAdder32bit(
	output[31:0] sum,
	output carryout,
	output overflow,
	input[31:0] a,
	input[31:0] b,
	input carryin
	);

	wire [30:0] cOut;

	oneBitAdder adderBefore(sum[0], cOut[0], a[0], b[0], carryin);
	generate
		genvar i;
		for (i=1; i<31; i=i+1) begin
			oneBitAdder adder(sum[i], cOut[i], a[i], b[i], cOut[i-1]);
		end
	endgenerate
	oneBitAdder adderAfter(sum[31], carryout, a[31], b[31], cOut[30]);

	`XOR(overflow, cOut[30], carryout);
endmodule

// module testAdder();
// 	reg [31:0] a, b;
// 	wire[31:0] sum;
// 	wire carryout, overflow;
// 	reg carryin;

// 	FullAdder32bit adder(sum, carryout, overflow, a, b, carryin);

// 	initial begin
// 		a=32'd50; b=32'd29975; carryin=1; #100000000
// 		$display("a:   %d\nb:   %d\nsum: %d\ncOut: %b, overflow: %b", adder.a, adder.b, adder.sum, carryout, overflow);
// 	end

// endmodule


