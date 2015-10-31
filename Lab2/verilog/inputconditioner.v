//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles
    
    reg [counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;
    
    always @(posedge clk ) begin
        // make sure that positiveedge and negativeedge only last for one clock cycle
        positiveedge <= 0;
        negativeedge <= 0;
        if(conditioned == synchronizer1) begin
            counter <= 0;
        end else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
                positiveedge <= synchronizer1;  // set positiveedge to the value of synchronizer1 
                // under the if statement that synchronizer1 is not equal to conditioned
                negativeedge <= !synchronizer1;  // set negativeedge to the value of not synchronizer1 
                // under the if statement that synchronizer1 is not equal to conditioned
            end
            else begin
                counter <= counter+1;
            end
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end
endmodule
