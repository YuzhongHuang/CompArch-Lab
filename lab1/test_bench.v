module ALU
(
output[31:0]    result,
output          carryout,
output          zero,
output          overflow,
input[31:0]     operandA,
input[31:0]     operandB,
input[2:0]      command
);
    // Your code here
endmodule


module testALU;

wire[31:0]    result;
wire          carryout;
wire          zero;
wire          overflow;
reg[31:0]     a;
reg[31:0]     b;
reg[2:0]      command;

initial begin
//should include the operation and command
//adder
//posi+posi
$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
a=32'sd2**31-2; b=32'sd1;  #1000 
$display("%h  +(Add)   %h    |    %h  | ffffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd2**31-2; b=32'sd2; #1000 
$display("%h  +(Add)   %h    |    %h  | overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd2**30;b=32'sd2**30-1; #1000 
$display("%h  +(Add)   %h    |    %h  | fffffff  | %b  %b  %b", a, b,result,carryout, overflow, zero);
//positive+negative
a=32'sd2**31-1;b=-32'sd2**31-1; #1000
$display("%h  +(Add)   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd2**31-1;b=-32'sd2**31-2; #1000 
$display("%h  +(Add)   %h    |    %h  | 00000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);
//negative+negative
a=-32'sd2**31-1; b=-32'sd1;  #1000 
$display("%h  +(Add)   %h    |    %h  | 80000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=-32'sd2**31-1; b=-32'sd2; #1000 
$display("%h  +(Add)   %h    |    %h  | overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=-32'sd2**30;b=-32'sd2**30-1; #1000 
$display("%h  +(Add)   %h    |    %h  | 80000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);


//substract
//posi-posi
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
$display("A  Operation  B | Result| Estimated result | carryout overflow zero");
a=32'sd2**31-1; b=32'sd2**31-2;  #1000 
$display("%h  SLT   %h    |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd2**31-1; b=32'sd2**31-1;  #1000 
$display("%h  SLT   %h   |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd2**31-2; b=32'sd2**31-1;  #1000 
$display("%h  SLT   %h   |    %h  | 00000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd1; b=-32'sd1;  #1000 
$display("%h  SLT   %h   |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=-32'sd1; b=32'sd1;  #1000 
$display("%h  SLT   %h   |    %h  | 00000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=-32'sd1; b=-32'sd2;  #1000 
$display("%h  SLT   %h   |    %h  | 00000000  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=-32'sd2; b=-32'sd1;  #1000 
$display("%h  SLT   %h   |    %h  | 00000001  | %b  %b  %b", a, b,result,carryout, overflow, zero);
//overflow slt
a=32'sd2**32; b=32'sd1;  #1000 
$display("%h  SLT   %h   |    %h  | a=overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd1; b=32'sd2**32;  #1000 
$display("%h  SLT   %h   |    %h  | b=overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);
a=32'sd2**32; b=32'sd2**32;  #1000 
$display("%h  SLT   %h   |    %h  | a,b=overflow  | %b  %b  %b", a, b,result,carryout, overflow, zero);

//AND 
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
$display("%h  OR   %h    |    %h  | ffffffff  | %b  %b  %b", a, bB,result,carryout, overflow, zero);
//010101010/  0101010....
a=32'sh55555555; b=32'sh55555555;  #1000 
$display("%h  OR   %h    |    %h  | 55555555  | %b  %b  %b", a, b,result,carryout, overflow, zero);

//NOR
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