module PC
(
output reg	q,
input		in,
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

