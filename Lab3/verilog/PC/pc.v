module PC
(
output reg	pc,
input		in,
input		pc_we,
input		clk
);
    initial begin
      pc <= 0;
    end
    always @(posedge clk) begin
        if (pc_we) begin
            pc <= in;
        end
    end
endmodule

