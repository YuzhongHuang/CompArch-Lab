/* 
 * D-Flip-Flop to hold the serial out from shift register 
*/

module dff
(
    input clk,
    input enable,
    input       d,
    output reg  q
);
    always @(posedge clk) begin
        if(enable) begin
            q <= d;
        end
    end
endmodule