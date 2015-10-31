//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

module testshiftregister();

    wire             clk;
    wire             peripheralClkEdge;
    wire             parallelLoad;
    wire[7:0]        parallelDataOut;
    wire             serialDataOut;
    wire[7:0]        parallelDataIn;
    wire             serialDataIn; 
    
    reg     begintest;  // Set High to begin testing register file
    wire      dutpassed;  // Indicates whether register file passed tests

    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut));

    // Instantiate test bench to test the DUT
    shiftregtestbench test(.begintest(begintest),
                        .endtest(endtest), 
                        .dutpassed(dutpassed),
                        .clk(clk),
                        .peripheralClkEdge(peripheralClkEdge),
                        .parallelLoad(parallelLoad), 
                        .parallelDataIn(parallelDataIn), 
                        .serialDataIn(serialDataIn), 
                        .parallelDataOut(parallelDataOut), 
                        .serialDataOut(serialDataOut));
    
    initial begin
    	begintest=0;
        #10;
        begintest=1;
        #10000;
    end

    // Display test results ('dutpassed' signal) once 'endtest' goes high
    always @(posedge endtest) begin
        $display("DUT passed?: %b", dutpassed);
    end

endmodule

module shiftregtestbench 
(
// Test bench driver signal connections
input           begintest,  // Triggers start of testing
output reg      endtest,    // Raise once test completes
output reg      dutpassed,  // Signal test result

input                  serialDataOut,      // Positive edge synchronized
input [7:0]            parallelDataOut,    // Shift reg data contents
output reg             clk,                // FPGA Clock
output reg             peripheralClkEdge,  // Edge indicator
output reg             parallelLoad,       // 1 = Load shift reg with parallelDataIn
output reg[7:0]        parallelDataIn,     // Load shift reg in parallel
output reg             serialDataIn        // Load shift reg serially
);

    // Initialize register driver signals
    initial begin
        clk = 0;
        peripheralClkEdge = 0;
        parallelLoad = 0;
        parallelDataIn = 0;
        serialDataIn = 0;
    end

        // Once 'begintest' is asserted, start running test cases
    always @(posedge begintest) begin
        endtest = 0;
        dutpassed = 1;
        #10

        // Test Case 1: 
        //   Write '42' to register 2, verify with Read Ports 1 and 2
        //   (Passes because example register file is hardwired to return 42)
        peripheralClkEdge = 1;
        parallelLoad = 0;
        parallelDataIn = 0;
        serialDataIn = 1;


        #5 clk=1; #5 clk=0;   // Generate single clock pulse

        // Verify expectations and report test result
        if((serialDataOut != 0) || (parallelDataOut != 0)) begin
          dutpassed = 0;  
          $display("Test Case 1 Failed");
        end

        #5
        endtest = 1;
    end

endmodule

