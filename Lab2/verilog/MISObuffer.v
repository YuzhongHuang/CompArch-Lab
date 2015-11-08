/*
 * Simple tri-state buffer for MISO
 */

module MISObuffer
(
	input d,
	input enable,
	output q
);
	assign q = enable? d : 'bz;
endmodule