module finitestatemachine 
(
	input cs; // conditioned output from chip select
	input sclk; // positive edge of the serial clock 
	input rw; // shift register out[0], the R/W bit to decide between read1 & write 1

	output MISO_BUFF; // MISO enable, 0 if it is write, which will produce a tri-state MISO
	output DM_WE; // data memory write enable
	output ADDR_WE; // address latch write enable, will be 1 if got
	output SR_WE; // shift register write from data memory enable
);

/*
 * state encoding
 */
localparam STATE_Get = 0,
		   STATE_Got = 1,
		   STATE_Read1 = 2,
		   STATE_Read2 = 3,
		   STATE_Read3 = 4,
		   STATE_Write1 = 5,
		   STATE_Write2 = 6,
		   STATE_Done = 7;

/*
 * state reg declaration
 */

 reg[2:0] CurrentState;
 reg[2:0] NextState;

 
