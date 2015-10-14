`include "ALU.v"

module testALU;

	wire[31:0]    result;
	wire          carryout;
	wire          zero;
	wire          overflow;
	reg[31:0]     a;
	reg[31:0]     b;
	reg[2:0]      command;

	ALU alu(result, carryout, overflow, zero, command, a, b);

	initial begin
	//should include the operation and command
	//adder
	//posi+posi
	command=3'd0;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=32'sd2**32-2; b=32'sd1;  #10000000 
	$display("%h  +(Add)   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd2**32-2; b=32'sd2; #10000000 
	$display("%h  +(Add)   %h    |    %h  | overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd2**30;b=32'sd2**30-1; #10000000 
	$display("%h  +(Add)   %h    |    %h  | fffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//positive+negative
	a=32'sd2**31-1;b=-32'sd2**31-1; #10000000
	$display("%h  +(Add)   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd2**31-1;b=-32'sd2**31-2; #10000000 
	$display("%h  +(Add)   %h    |    %h  | 00000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//negative+negative
	a=-32'sd2**31-1; b=-32'sd1;  #10000000 
	$display("%h  +(Add)   %h    |    %h  | 80000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd2**31-1; b=-32'sd2; #10000000 
	$display("%h  +(Add)   %h    |    %h  | overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd2**30;b=-32'sd2**30-1; #10000000 
	$display("%h  +(Add)   %h    |    %h  | 80000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);


	//substract
	//posi-posi
	command=3'd1;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=32'sd2**31-1; b=32'sd2**31-2;  #1000 
	$display("%h  -(Sub)   %h    |    %h  | 00000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd2**31-2; b=32'sd2**31-1; #1000 
	$display("%h  -(Sub)   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//posi-nega
	a=32'sd2**30;b=-32'sd2**30-1; #1000 
	$display("%h  -(Sub)   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd2**30;b=-32'sd2**30; #1000 
	$display("%h  -(Sub)   %h    |    %h  | 80000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd2**30; b=-32'sd2**31-1; #1000 
	$display("%h  -(Sub)   %h    |    %h  | overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//nega-posi
	a=-32'sd1;b=32'sd2**31-1; #1000 
	$display("%h  -(Sub)   %h    |    %h  | 80000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd2;b=32'sd2**31-1; #1000 
	$display("%h  -(Sub)   %h    |    %h  | overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//negative-negative
	a=-32'sd2**31; b=-32'sd2**31-1;  #1000 
	$display("%h  -(Sub)   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd2**31-1; b=-32'sd2**31-1; #1000 
	$display("%h  -(Sub)   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd2**31-1;b=-32'sd2**31; #1000 
	$display("%h  -(Sub)   %h    |    %h  | 00000001  | %b  %b  %b",a, b,result,carryout, overflow, zero);

	//XOR
	command=3'd2;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=-32'sd1; b=-32'sd1;  #1000 
	$display("%h  XOR   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd0; b=32'sd0;  #1000 
	$display("%h  XOR   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=32'sd0;  #1000 
	$display("%h  XOR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd0; b=-32'sd1;  #1000 
	$display("%h  XOR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'shaaaaaaaa; b=32'sh55555555;  #1000  //1010101001... xor 01010101..... 
	$display("%h  XOR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);

	//SLT
	command=3'd3;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=32'sd2**31-1; b=32'sd2**31-2;  #1000 
	$display("%h  SLT   %h    |    %h  | 0  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=32'sd2**31-1; b=32'sd2**31-1;  #1000 
	$display("%h  SLT   %h   |    %h  | 0  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=32'sd2**31-2; b=32'sd2**31-1;  #1000 
	$display("%h  SLT   %h   |    %h  | 1  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=32'sd1; b=-32'sd1;  #1000 
	$display("%h  SLT   %h   |    %h  | 0  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=-32'sd1; b=32'sd1;  #1000 
	$display("%h  SLT   %h   |    %h  | 1  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=-32'sd1; b=-32'sd2;  #1000 
	$display("%h  SLT   %h   |    %h  | 0  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=-32'sd2; b=-32'sd1;  #1000 
	$display("%h  SLT   %h   |    %h  | 1  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	//overflow slt
	a=32'sd2**32; b=32'sd1;  #1000 
	$display("%h  SLT   %h   |    %h  | a=overflow  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=32'sd1; b=32'sd2**32;  #1000 
	$display("%h  SLT   %h   |    %h  | b=overflow  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);
	a=32'sd2**32; b=32'sd2**32;  #1000 
	$display("%h  SLT   %h   |    %h  | a,b=overflow  | %b  %b  %b", a, b,result[0],carryout, overflow, zero);

	//AND 
	command=3'd4;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=32'sd0; b=-32'sd1;  #1000 
	$display("%h  AND   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=32'sd0;  #1000 
	$display("%h  AND   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=-32'sd1;  #1000 
	$display("%h  AND   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd0; b=32'sd0;  #1000 
	$display("%h  AND   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//101010101010/  10101010...
	a=32'shaaaaaaaa; b=32'shaaaaaaaa;  #1000 
	$display("%h  AND   %h    |    %h  | aaaaaaaa  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//1010101010/  0101010101...
	a=32'shaaaaaaaa; b=32'sh55555555;  #1000 
	$display("%h  OR   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//010101010/  0101010....
	a=32'sh55555555; b=32'sh55555555;  #1000 
	$display("%h  OR   %h    |    %h  | 55555555  | %b  %b  %b", a, b,result,carryout, overflow, zero);

	//Nand
	command=3'd5;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=32'sd0; b=-32'sd1;  #1000 
	$display("%h  NOR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=32'sd0;  #1000 
	$display("%h  NOR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=-32'sd1;  #1000 
	$display("%h  NOR   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd0; b=32'sd0;  #1000 
	$display("%h  NOR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//101010101010/  10101010...
	a=32'shaaaaaaaa; b=32'shaaaaaaaa;  #1000 
	$display("%h  NOR   %h    |    %h  | 55555555  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//1010101010/  0101010101...
	a=32'shaaaaaaaa; b=32'sh55555555;  #1000 
	$display("%h  NOR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//010101010/  0101010....
	a=32'sh55555555; b=32'sh55555555;  #1000 
	$display("%h  NOR   %h    |    %h  | aaaaaaaa  | %b  %b  %b", a, b,result,carryout, overflow, zero);

	//OR
	command=3'd6;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=32'sd0; b=-32'sd1;  #1000 
	$display("%h  OR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=32'sd0;  #1000 
	$display("%h  OR   %h    |    %h  | ffffffff  | %b  %b  %b",a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=-32'sd1;  #1000 
	$display("%h  OR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd0; b=32'sd0;  #1000 
	$display("%h  OR   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//101010101010/  10101010...
	a=32'shaaaaaaaa; b=32'shaaaaaaaa;  #1000 
	$display("%h  OR   %h    |    %h  | aaaaaaaa  | %b  %b  %b",a, b,result,carryout, overflow, zero);
	//1010101010/  0101010101...
	a=32'shaaaaaaaa; b=32'sh55555555;  #1000 
	$display("%h  OR   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//010101010/  0101010....
	a=32'sh55555555; b=32'sh55555555;  #1000 
	$display("%h  OR   %h    |    %h  | 55555555  | %b  %b  %b", a, b,result,carryout, overflow, zero);

	//NOR
	command=3'd7;
	$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
	a=32'sd0; b=-32'sd1;  #1000 
	$display("%h  NOR   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=32'sd0;  #1000 
	$display("%h  NOR   %h    |    %h  | 00000000  | %b  %b  %b",a, b,result,carryout, overflow, zero);
	a=-32'sd1; b=-32'sd1;  #1000 
	$display("%h  NOR   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	a=32'sd0; b=32'sd0;  #1000 
	$display("%h  NOR   %h    |    %h  | ffffffff  | %b  %b  %b",a, b,result,carryout, overflow, zero);
	//101010101010/  10101010...
	a=32'shaaaaaaaa; b=32'shaaaaaaaa;  #1000 
	$display("%h  NOR   %h    |    %h  | 55555555  | %b  %b  %b", a, b,result,carryout, overflow, zero);
	//1010101010/  0101010101...
	a=32'shaaaaaaaa; b=32'sh55555555;  #1000 
	$display("%h  NOR   %h    |    %h  | 00000000  | %b  %b  %b",a, b,result,carryout, overflow, zero);
	//010101010/  0101010....
	a=32'sh55555555; b=32'sh55555555;  #1000 
	$display("%h  NOR   %h    |    %h  | aaaaaaaa  | %b  %b  %b", a, b,result,carryout, overflow, zero);

end
endmodule