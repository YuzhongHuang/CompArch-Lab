//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 7,
    parameter depth         = 2**addresswidth,
    parameter width         = 8
)
(
    input 		                clk,
    output reg [width-1:0]      dataOut,
    input [addresswidth-1:0]    address,
    input                       writeEnable,
    input [width-1:0]           dataIn
);

    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(writeEnable)
            memory[address] <= dataIn;
        dataOut <= memory[address];
    end

endmodule

module testDM();

    reg clk, wr_en;
    wire [7:0] dOut;
    reg [7:0] dIn;
    reg [6:0] addr;

    datamemory DM(clk, dOut, addr, wr_en, dIn);

    always begin
        #5 clk = !clk;
    end

    initial begin
        clk = 0; #10 wr_en=1; addr=7'd20; dIn=8'd104; #10
        $display("dIn: %b | addr: %b | wr_en: %b | dOut: %b", DM.dataIn, DM.address, DM.writeEnable, DM.memory[DM.address]);
        wr_en=1; addr=7'd40; dIn=8'd52; #10
        $display("dIn: %b | addr: %b | wr_en: %b | dOut: %b", DM.dataIn, DM.address, DM.writeEnable, DM.memory[DM.address]);
        wr_en=0; addr=7'd20; #10
        $display("dIn: %b | addr: %b | wr_en: %b | dOut: %b", DM.dataIn, DM.address, DM.writeEnable, DM.memory[DM.address]); 
        wr_en=0; addr=7'd40; #10
        $display("dIn: %b | addr: %b | wr_en: %b | dOut: %b", DM.dataIn, DM.address, DM.writeEnable, DM.memory[DM.address]); 
        $finish;
    end

endmodule
