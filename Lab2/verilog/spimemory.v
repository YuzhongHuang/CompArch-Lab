//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

`include "midpoint.v"
`include "inputconditioner.v"
`include "shiftregister.v"
`include "finitestatemachine.v"
`include "addresslatch.v"
`include "datamemory.v"
`include "MISObuffer.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    input           fault_pin,  // For fault injection testing
    output [3:0]    leds        // LEDs for debugging
);

	reg [7:0] parallelIn;
	wire serialOut;
    wire [7:0] parallelOut, outputadrlatch;
	wire [2:0] rising, falling, conditioned;
	wire miso_bufe, dm_we, addr_we, sr_we;
	wire temp_miso_pin;
	
	// assigning the prarlell output to the leds
	// here I displays the four lower significance bit
	assign led = parallelOut[3:0];

	// provides inputs to the three input conditioner
	inputconditioner cond0(clk, mosi_pin, conditioned[0], rising[0], falling[0]);
	inputconditioner cond1(clk, sclk_pin, conditioned[1], rising[1], falling[1]);
	inputconditioner cond2(clk, cs_pin, conditioned[2], rising[2], falling[2]);

	// connect the output of conditioners as described in the lab2
	shiftregister shiftreg(clk, rising[2], falling[0], 8'hA5, conditioned[1], parallelOut, serialOut);

	finitestatemachine fsm(conditioned[2], rising[1], parallelOut[0], miso_bufe, dm_we, addr_we, sr_we);
	addrlatch latch(outputadrlatch, parallelOut, addr_we, clk);
	datamemory dm(clk, parallelIn, outputadrlatch[6:0], dm_we, parallelOut);

	MISObuffer misobuffer(serialOut, temp_miso_pin, falling[1], clk);

	miso_pin = 

endmodule
   
module testSpi();

	reg clk, sclk_pin, cs_pin, mosi_pin, fault_pin;
	wire miso_pin;
	wire [3:0] leds;

	spiMemory spi(clk, sclk_pin, cs_pin, miso_pin, mosi_pin, fault_pin, leds);

	initial begin
		clk = 0; #10
		clk = 1; sclk_pin = 1; cs_pin = 0; #10
		// $display("Sclk: %b | CS: %b | Concatenation: %b | Expected: %b", spi.sclk_pin, spi.cs_pin, spi.switches);
	end

endmodule
