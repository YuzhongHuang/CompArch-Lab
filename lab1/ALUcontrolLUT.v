//Define the 3-bit control signal to be readable
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define OR   3'd6
`define NOR  3'd7

//The ALU control LUT
module ALUcontrolLUT
(
input[2:0] ALUcommand, //3-bit control signal input
output reg[6:0] ALUsignal 
//7-bit signal output to the ALU, inwhich 
//the most significant bit represents "enable add(subtract)"
//the second bit represents "enable XOR"
//the third bit represents "enable SLT"
//the fourth bit represents "enable AND"
//the fifth bit represents "enable OR"
//the sixth bit represents "invert B"
//the seventh bit represents "flip the result(for NAND & NOR)"
);

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:  begin ALUsignal = 64; end //1000000 in binary, which represents enable add(sub)    
      `SUB:  begin ALUsignal = 66; end //1000010 in binary, which represents enable add(sub) and invert B  
      `XOR:  begin ALUsignal = 32; end //0100000 in binary, which represents enable XOR    
      `SLT:  begin ALUsignal = 18; end //0010010 in binary, which represents enable SLT and invert B  
      `AND:  begin ALUsignal = 8; end  //0001000 in binary, which represents enable AND     
      `NAND: begin ALUsignal = 9; end  //0001001 in binary, which represents enable AND and flip the result  
      `OR:   begin ALUsignal = 4; end  //0000100 in binary, which represents enable OR     
      `NOR:  begin ALUsignal = 5; end  //0000101 in binary, which represents enable OR and flip the result  
    endcase
  end
endmodule

module testALUcontrolLUT; 
reg[2:0] ALUcommand;
wire[6:0] ALUsignal;
ALUcontrolLUT test(ALUcommand, ALUsignal);

initial begin
ALUcommand = 0; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 1; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 2; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 3; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 4; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 5; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 6; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 7; #1000 
$display("%b  ", ALUsignal);
ALUcommand = 8; #1000 
$display("%b  ", ALUsignal);
end
endmodule