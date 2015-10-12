`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define OR   3'd6
`define NOR  3'd7

module ALUcontrolLUT
(
input[2:0] ALUcommand,
output reg[6:0] ALUsignal
);

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:  begin ALUsignal = 64; end    
      `SUB:  begin ALUsignal = 66; end
      `XOR:  begin ALUsignal = 32; end    
      `SLT:  begin ALUsignal = 18; end
      `AND:  begin ALUsignal = 8; end    
      `NAND: begin ALUsignal = 9; end
      `OR:   begin ALUsignal = 4; end    
      `NOR:  begin ALUsignal = 5; end
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