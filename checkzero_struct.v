module or_4input(res,input4bit);
input [3:0] input4bit;
output res;
wire re1,re2;
or or1(re1,input4bit[0],input4bit[1]);
or or2(re2,input4bit[2],input4bit[3]);
or or3(res,re1,re2);
endmodule


module checkzero(zero, Result);

//if the Result is 0, output zero is 1
// if the result is not 0, output zero is 0
input [31:0] Result;
wire result1, result2,result3,result4,result5,result6,result7, result8;
output zero;
//using 8 of (4input orgate)
or_4input or_4_1(result1, Result[31:28]);
or_4input or_4_2(result2, Result[27:24]);
or_4input or_4_3(result3,Result[23:20]);
or_4input or_4_4(result4,Result[19:16]);
or_4input or_4_5(result5,Result[15:12]);
or_4input or_4_6(result6,Result[11:8]);
or_4input or_4_7(result7,Result[7:4]);
or_4input or_4_8(result8,Result[3:0]);

//using 2 of (4input orgate)
wire [3:0] result9;
wire [3:0] result10;
assign result9[3]=result1,result9[2]=result2, result9[1]=result3, result9[0]=result4;
assign result10[3]=result5, result10[2]=result6, result10[1]=result7,result10[0]=result8;
wire result11,result12,zero_before;
or_4input or_4_9(result11,result9);
or_4input or_4_10(result12,result10);


//or gate with the final results
or orfinal(zero_before,result11,result12);
not inver(zero,zero_before);
endmodule 

module testdoit;
reg[31:0] a;
wire zero;

checkzero checking(zero,a);


initial begin
a=32'sh00000000;  #1000 

$display("result is %h ", zero);
end
endmodule

