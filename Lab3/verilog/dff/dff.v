module DFF
(
output reg [31:0] q,
input [31:0] in,
input		wr_enable,
input		clk
);
    initial begin
      q <= 0;
    end
    always @(posedge clk) begin
        if (wr_enable) begin
            q <= in;
        end
    end
endmodule

module DFFneg
(
output reg [31:0] q,
input [31:0] in,
input		wr_enable,
input		clk
);
    initial begin
      q <= 0;
    end
    always @(negedge clk) begin
        if (wr_enable) begin
            q <= in;
        end
    end
endmodule

