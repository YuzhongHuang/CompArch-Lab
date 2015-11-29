// D Flip Flop that updates on posedge of clk
module DFF (
    output reg [31:0] q,
    input [31:0] in,
    input wr_enable,
    input clk
);
    initial q <= 0;
    always @(posedge clk) begin
        if (wr_enable) begin
            q <= in;
        end
    end
endmodule

// D Flip Flop that updates on negedge of clk
module DFFneg (
    output reg [31:0] q,
    input [31:0] in,
    input wr_enable,
    input clk
);
    initial q <= 0;
    always @(negedge clk) begin
        if (wr_enable) begin
            q <= in;
        end
    end
endmodule

