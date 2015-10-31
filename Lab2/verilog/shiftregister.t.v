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
        $dumpfile("testShiftRegister.vcd");
        $dumpvars(0, shiftregtestbench);
        clk = 0;
        peripheralClkEdge = 0;
        parallelLoad = 0;
        parallelDataIn = 0;
        serialDataIn = 0;
    end

    always begin
        #5clk = !clk;
    end

    // Once 'begintest' is asserted, start running test cases
    always @(posedge begintest) begin
        endtest = 0;
        dutpassed = 1;
        #10

// Test Case 1: 

        //  Write 1 - 0 - 0 - 1 - 0 - 0 - 1 - 0 to the serial input
        //  Write 0 - 1 - 1 - 0 - 1 - 1 - 0 - 1 to the paralell input 
        //  (opposite as serial so that we can see if there is a problem)
        //  Set peripheralClkEdge to '1' and parallelLoad to '0'
        //  Verify with the serivalDataout and ParallelDataout
        //
        //  In this test, DUT are expected to be a fully perfect 
        //  serial-in-paralell-out 8-bit shift register. 
        //
        //  Device described as the following will be reported as error:
        //  1. broken parallelLoad (always set to '1')
        //  2. broken data input (choosing wrong data input)
        //  3. registers cannot shift correctly 
        //  4. serial output not outputing LSB
        //  5. broken paralell output
        peripheralClkEdge = 1;
        parallelLoad = 0;
        parallelDataIn = 146;
        serialDataIn = 1;

        // Generate single clock pulse and set serial data input
        #10 serialDataIn = 0;
        #10 serialDataIn = 0;
        #10 serialDataIn = 1;
        #10 serialDataIn = 0;
        #10 serialDataIn = 0;
        #10 serialDataIn = 1;
        #10 serialDataIn = 0;

        #10 // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 1, the first number we write
        //   the parallel output should be 10010100, which is 146
        if((serialDataOut != 1) || (parallelDataOut != 146)) begin  
          dutpassed = 0;  
          // $display("%d", parallelDataOut);
          $display("Test Case 1.1 Failed");
        end

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 0, the second number we write
        //   the parallel output should be 00100100, which is 36
        if((serialDataOut != 0) || (parallelDataOut != 36)) begin  
          dutpassed = 0;  
          $display("Test Case 1.2 Failed");
        end

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 0, the third number we write
        //   the parallel output should be 01001000, which is 18
        if((serialDataOut != 0) || (parallelDataOut != 72)) begin  
          dutpassed = 0;  
          $display("Test Case 1.3 Failed");
        end

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 1, the fourth number we write
        //   the parallel output should be 10010000, which is 9
        if((serialDataOut != 1) || (parallelDataOut != 144)) begin  
          dutpassed = 0;  
          $display("Test Case 1.4 Failed");
        end

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 0, the fifth number we write
        //   the parallel output should be 00100000, which is 4
        if((serialDataOut != 0) || (parallelDataOut != 32)) begin  
          dutpassed = 0;  
          $display("Test Case 1.5 Failed");
        end

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 0, the sixth number we write
        //   the parallel output should be 01000000, which is 2
        if((serialDataOut != 0) || (parallelDataOut != 64)) begin  
          dutpassed = 0;  
          $display("Test Case 1.6 Failed");
        end

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 1, the seventh number we write
        //   the parallel output should be 10000000, which is 1
        if((serialDataOut != 1) || (parallelDataOut != 128)) begin  
          dutpassed = 0;  
          $display("Test Case 1.7 Failed");
        end

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 0, the eighth number we write
        //   the parallel output should be 0000000, which is 0
        if((serialDataOut != 0) || (parallelDataOut != 0)) begin  
          dutpassed = 0;  
          $display("Test Case 1.8 Failed");
        end

        #5

// Test Case 2: 

        //  Write 1 to the serial input (oppsite MSB as paralell)
        //  Write 0 - 0 - 1 - 1 - 1 - 0 - 1 - 1 to the paralell input
        //  Set peripheralClkEdge to '1' and parallelLoad to '1'
        //  Verify with the serivalDataout and ParallelDataout
        //
        //  In this test, DUT are expected to be a fully perfect 
        //  paralell-in-serial-out 8-bit shift register. 
        //
        //  Device described as the following will be reported as error:
        //  1. broken parallelLoad (always set to '0')
        //  2. broken data input (choosing wrong data input)
        //  3. registers cannot shift correctly 
        //  4. serial output not outputing LSB
        //  5. broken paralell output
        peripheralClkEdge = 1;
        parallelLoad = 1;
        parallelDataIn = 59;
        serialDataIn = 1;

        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 1, the LSB in paralell input
        //   the parallel output should be 00111011, which is 59
        if((serialDataOut != 0) || (parallelDataOut != 59)) begin  
          dutpassed = 0;  
          $display("Test Case 2.1 Failed");
        end

// Test Case 3: 

        //  Write 1 to the serial input (oppsite MSB as paralell)
        //  Write 1 - 0 - 0 - 0 - 0 - 0 - 0 - 0 to the paralell input
        //  Set peripheralClkEdge to '0' and parallelLoad to '1'(doesn't matter)
        //  Verify with the serivalDataout and ParallelDataout
        //
        //  In this test, DUT are expected to be a fully perfect 
        //  register that only change value on the positive rise edge. 
        //
        //  Device described as the following will be reported as error:
        //  1. broken peripheralClkEdge (always set to '1')
        peripheralClkEdge = 0;
        parallelLoad = 1;
        parallelDataIn = 128;
        serialDataIn = 1;


        #10  // Generate single clock pulse
        // Verify expectations and report test result
        //   at this point, the serial output should be 1, same as 
        //   we assigned in test 2 because we should not change it here
        //   the parallel output should be 00111011, which is 59, same as the last test
        if((serialDataOut != 0) || (parallelDataOut != 59)) begin  
          dutpassed = 0;  
          $display("%d, %d", serialDataOut, parallelDataOut);
          $display("Test Case 3.1 Failed");
        end

        #5
        endtest = 1;
        $finish;
    end

endmodule

