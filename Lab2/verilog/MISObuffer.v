/*
 * Simple tri-state buffer for MISO
 */

module MISObuffer
(
	input d,
	output q,
	input enable,
);
	assign q = enable? d : 'bz;
endmodule