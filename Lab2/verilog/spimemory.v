//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "addresslatch.v"
`include "MISObuffer.v"
`include "dff.v"
`include "inputconditioner.v"
`include "shiftregister.v"
`include "finitestatemachine.v"
`include "datamemory.v"
`include "breakables/inputconditioner_breakable.v"
`include "breakables/finitestatemachine_breakable.v"

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
    // control signals
    wire MISO_BUFF; // MISO enable, 0 if it is write, which will produce a tri-state MISO
    wire DM_WE; // data memory write enable
    wire ADDR_WE; // address latch write enable, will be 1 if got
    wire SR_WE; // shift register write from data memory enable

    // wire declaration
    wire MOSI_conditioned;
    wire SCLK_poeg;
    wire SCLK_neeg;
    wire CS_conditioned;
    wire[7:0] ParallelOut;
    wire Serial_out;
    wire[7:0] memory_out;
    wire[7:0] address_out;
    wire dff_out;

    // MOSI input conditioner
    inputconditioner_breakable MOSI(
                          .clk(clk),
                          .noisysignal(mosi_pin),
                          .fault_pin(fault_pin),
                          .conditioned(MOSI_conditioned),
                          .positiveedge(),
                          .negativeedge()
                          );

    // SCLK input conditioner
    inputconditioner_breakable SCLK(
                          .clk(clk),
                          .noisysignal(sclk_pin),
                          .fault_pin(fault_pin),
                          .conditioned(),
                          .positiveedge(SCLK_poeg),
                          .negativeedge(SCLK_neeg)
                          ); 

    // CS input conditioner 
    inputconditioner_breakable CS(
                        .clk(clk),
                        .noisysignal(sclk_pin),
                        .fault_pin(fault_pin),
                        .conditioned(),
                        .positiveedge(SCLK_poeg),
                        .negativeedge(SCLK_neeg)
                        ); 

    // shift register 
    shiftregister shiftregister(
                                .clk(clk),
                                .peripheralClkEdge(SCLK_poeg),
                                .parallelLoad(SR_WE),
                                .parallelDataIn(memory_out),
                                .serialDataIn(MOSI_conditioned),
                                .parallelDataOut(ParallelOut),
                                .serialDataOut(Serial_out)
                                );

    // finite state machine
    finitestatemachine_breakable fsm(
                           .cs(CS_conditioned),
                           .sclk(SCLK_poeg),
                           .rw(ParallelOut[0]),
                           .MISO_BUFF(MISO_BUFF),
                           .DM_WE(DM_WE),
                           .ADDR_WE(ADDR_WE),
                           .SR_WE(SR_WE)
                           );

    // data memory
    datamemory memory(
                      .clk(clk),
                      .dataOut(memory_out),
                      .address(address_out[6:0]),
                      .writeEnable(DM_WE),
                      .dataIn(ParallelOut)
                      );

    // address latch
    addresslatch addresslatch(
                              .q(address_out),
                              .d(ParallelOut),
                              .wrenable(ADDR_WE),
                              .clk(clk)
                              );

    // DFF
    dff dff(
            .clk(clk),
            .enable(SCLK_neeg),
            .d(Serial_out),
            .q(dff_out)
            );

    // MISObuffer
    MISObuffer MISObuffer(
                          .d(Serial_out),
                          .q(miso_pin),
                          .enable(MISO_BUFF));
endmodule
   
module testSpi();

    reg clk, sclk_pin, cs_pin, mosi_pin, fault_pin;
    wire miso_pin;
    wire [3:0] leds;

    spiMemory spi(clk, sclk_pin, cs_pin, miso_pin, mosi_pin, fault_pin, leds);

    initial begin
        clk = 0; sclk_pin = 1; #10
        clk = 1; cs_pin = 0; sclk_pin = 0; 
    end

endmodule









