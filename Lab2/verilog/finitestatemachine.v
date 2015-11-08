/*
 * simple finite state machine to encode control signals based on states
 */
module finitestatemachine 
(
	input cs, // conditioned output from chip select
	input sclk, // positive edge of the serial clock 
	input rw, // shift register out[0], the R/W bit to decide between read1 & write 1

	output reg MISO_BUFF, // MISO enable, 0 if it is write, which will produce a tri-state MISO
	output reg DM_WE, // data memory write enable
	output reg ADDR_WE, // address latch write enable, will be 1 if got
	output reg SR_WE // shift register write from data memory enable
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
 reg[3:0] counter;

 always @(posedge sclk) begin
 	if (cs) begin // reset if cs is high
 		CurrentState <= 0;
 		counter <= 0;
 	end
 	else begin // reset control signals 
 		MISO_BUFF <= 0;
 		DM_WE <= 0;
 		ADDR_WE <= 0;
 		SR_WE <= 0;

 		/*
 		 * case statement to change around states given the situation
 		 */
 		case (CurrentState)
 			STATE_Get: begin // read address bits from MOSI
 				if (counter == 8) begin
 					CurrentState <= STATE_Got; 
 				end else begin
 					counter <= counter + 1; 
 				end
 			end

 			STATE_Got: begin // branch to read or write based on r/w and enable address latch
 				counter <= 0;
 				ADDR_WE <= 1;
 				if (rw) begin
 					CurrentState <= STATE_Read1;
 				end else begin
 					CurrentState <= STATE_Write1;
 				end
 			end

 			STATE_Read1: begin // wait one cycle to start reading
 				CurrentState <= STATE_Read2;
 			end

 			STATE_Read2: begin // enable shift register write and load data
 				SR_WE <= 1;
 				CurrentState <= STATE_Read3;
 			end

 			STATE_Read3: begin // start MISO
 				MISO_BUFF <= 1;
 				if (counter == 8) begin
 					CurrentState <= STATE_Done;
 				end else begin
 					counter <= counter + 1;
 				end
 			end

 			STATE_Write1: begin // read 8-bit data from MOSI
 				if (counter == 8) begin
 					CurrentState <= STATE_Write2;
 				end else begin
 					counter <= counter + 1;
 				end
 			end

 			STATE_Write2: begin // parallel out to data memory
 				DM_WE <= 1;
 				CurrentState <= STATE_Done;
 			end

 			STATE_Done: begin // done and reset counter
 				counter <= 0;
 			end
 		endcase
 	end
 end
endmodule

 
