/*
 * Simple tri-state buffer for MISO
 */

module MISObuffer
(
	input d,
	output q,
	input enable,
	input clk
);

	always @(posedge clk) begin
		assign q = enable? d : 'bz;
	end

endmodule