//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------

`include "inputconditioner.v"

module testConditioner();

    wire clk;
    wire pin;
    wire conditioned;
    wire rising;
    wire falling;

    reg begintest;
    wire dutpassed;
    
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    inputcondtestbench test(.begintest(begintest),
                            .endtest(endtest),
                            .dutpassed(dutpassed),
                            .clk(clk),
                            .pin(pin),
                            .conditioned(conditioned),
                            .rising(rising),
                            .falling(falling));


    // Generate clock (50MHz)
    initial begin
        begintest = 0;
        #10;
        begintest = 1;
        #10000;
    end

    // Display test results ('dutpassed' signal) once 'endtest' goes high
    always @(posedge endtest) begin
        if (dutpassed == 1) begin
            $display("\n\033[32mDUT passed?: %b\033[37m\n", dutpassed);
        end else begin
            $display("\n\033[31mDUT passed?: %b\033[37m\n", dutpassed);
        end
    end
    
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)
    
endmodule

module inputcondtestbench (
    input           begintest,  // Triggers start of testing
    output reg      endtest,    // Raise once test completes
    output reg      dutpassed,  // Signal test result)

    output reg      clk,
    output reg      pin,
    input           conditioned,
    input           rising,
    input           falling);

    initial begin
        $dumpfile("../wave/testConditioner.vcd");
        $dumpvars(0, inputcondtestbench);
        clk = 0;
        pin = 1;
    end

    /* Will test for the following:
        1. Synchronization - change inputs at frequency that is not a multiple of 10. 
        2. Clean - change inputs many times within 3 clock cycles, should output the final value
        3. Preprocess - Change inputs so that we can detect edge changes in conditioned
    */

    always begin
        #5 clk = !clk;
    end

    always @(posedge begintest) begin
        endtest = 0;
        dutpassed = 1;

        // Test Case 2: Change input as follows: 101100 to simulate noise. Output should be 1.
        #5 pin = 0; // sync0 = 1, sync1 = 0, conditioned = x, counter = 0
        #5 pin = 1; 
        #5 pin = 1; // sync0 = 0, sync1 = 1, conditioned = x, counter = 1
        #5 pin = 0;
        #5 pin = 0; #60 // sync0 = 1, sync1 = 0, conditioned = x, counter = 2

        /* What happens at every posedge: 
            - sync0 = 1, sync1 = 1, conditioned = x, counter = 3
            - sync0 = 1, sync1 = 1, conditioned = x, counter = 0
            - sync0 = 1, sync1 = 1, conditioned = x, counter = 1
            - sync0 = 1, sync1 = 1, conditioned = x, counter = 2
            - sync0 = 1, sync1 = 1, conditioned = x, counter = 3
            - sync0 = 1, sync1 = 1, conditioned = 1, counter = 0
        */
        // $display("CONDITIONED: %b | RISING: %b | FALLING: %b", conditioned, rising, falling);
        if ((conditioned != 0) || (rising != 0) || (falling != 0)) begin
            dutpassed = 0;
            $display("Test Case 1 Failed"); 
        end

        // Test Case 3: Change input as follows: 0 then hold until conditioned changes, then input = 1 then hold until conditioned changes
        #5 pin = 1; #65 // wait until correct clock rise

        // $display("CONDITIONED: %b | RISING: %b | FALLING: %b", conditioned, rising, falling);
        if ((conditioned != 1) || (rising != 1) || (falling != 0)) begin
            dutpassed = 0;
            $display("Test Case 2 Failed"); 
        end

        #5 pin = 0; #65 // wait until correct clock rise

        // $display("CONDITIONED: %b | RISING: %b | FALLING: %b", conditioned, rising, falling);
        if ((conditioned != 0) || (rising != 0) || (falling != 1)) begin
            dutpassed = 0;
            $display("Test Case 3 Failed"); 
        end

        // Test Case 1: Change input at frequency of 3
        #3 pin = 0; #3 pin = 1; #3 pin = 0; #3 pin = 1; #3 pin = 0; #3 pin = 1; #57 // wait in total 75 seconds

        if ((conditioned != 1)) begin
            dutpassed = 0;
            $display("Test Case 1 Failed"); 
        end

        #5 endtest = 1;
        $finish;
    end

endmodule

















