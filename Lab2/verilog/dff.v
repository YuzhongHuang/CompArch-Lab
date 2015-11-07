/* 
 * D-Flip-Flop to hold the serial out from shift register 
*/

module dff
(
    input trigger,
    input enable,
    input       d,
    output reg  q
);
    always @(posedge trigger) begin
        if(enable) begin
            q <= d;
        end
    end
endmodule