module PC
(
output reg	q,
input		in,
input		wr_enable,
input		clk
);
    initial begin
      q <= 0;
	  $display("Hi from PC");     
    end

    always @(posedge clk) begin
    	$display("Hi from PC with clk, %d", q); 
        if (wr_enable) begin
            q <= in;
        end
    end
endmodule

