# Lab 2:

#### Yuzhong Huang, Hieu Nguyen

## Introduction

![enter image description here](https://lh3.googleusercontent.com/-vjddJ_ufcxw/VkD05uXSKaI/AAAAAAAAAJA/OoMkSvQFB7M/s0/68747470733a2f2f65333830323365322d612d36326362336131612d732d73697465732e676f6f676c6567726f7570732e636f6d2f736974652f6361313566616c6c2f7265736f75726365732f6c6162322d6d69642e706e67.png "top_level.png")

To make the explanation makes more sense, top level diagram is included.

We followed the suggested implementation steps by building input conditioner, shift register as well as their tests, midpoint file, finite state machine, SPI module, FPGA loading, test cases in c and fault injection in order. We will further explain the details in the following sections.

We read through the whole lab before coming up with an work plan. Compared to what we did last time, we make some progress in planning and estimating work time as we will demonstrate in the retrospective section.

## Implementation

### Input Conditioner

The schematic of our input conditioner design is shown below:

![enter image description here](https://lh3.googleusercontent.com/-8ohC_UM_7hg/VkENLHl_J2I/AAAAAAAAAKY/jN18Fa8jmwM/s0/inputconditioner.jpg "inputconditioner.jpg")

In our input conditioner, there is a counter which wait for three times before output to the conditioned port. The main purpose of the counter is to get rid of the noisy signal in the input. And the clock analysis is included below:

The question is:  If the main system clock is running at 50MHz, what is the maximum length input glitch that will be suppressed by this design for a waittime of 10?

	Given that the initial signal is '0' for a long and stable time, during which the registers synchronizer0, synchronizer1 and conditioned will be 0. Suppose there is a glitch with a certain length 'l' at time T = 0, which inputs '1' to the noisy signal, and each clock cycle takes 't', we will exam step by step to see how long can 'l' be without disturbing the register conditioned.

	1. At T = 0, the noisy signal begins to input glitch '1'. At the same time, the clock arrives at its positive edge. In this case, synchronizer0 becomes 1, synchronizer1 and conditioned stays still.

	2. After the first clock cycle, both synchronizer0 and synchronizer1 becomes 1, and conditioned stays still.

	3. At the third clock cycle, both synchronizer0 and synchronizer1 is 1. And the code enters the 'else' statement since synchronizer1 is not equal to conditioned anymore. But the counter is still '0' at this point, so it increase the counter by 1.

	4. At T = 3t, the code increase the counter to 2 and do nothing.

	5. At T = 4t, the code increase the counter to 3 and do nothing.

	6. At T = 5t, the code increase the counter to 4 and do nothing.

	7. At T = 6t, the code increase the counter to 5 and do nothing.

	8. At T = 7t, the code increase the counter to 6 and do nothing.

	9. At T = 8t, the code increase the counter to 7 and do nothing.

	10. At T = 9t, the code increase the counter to 8 and do nothing.

	11. At T = 10t, the code increase the counter to 9 and do nothing.

	12. At T = 11t, the code increase the counter to 10 and do nothing.

	13. At T = 12t, counter == waittime and enters the code to change register conditioned to 1, which is bad.

	The above shows the steps need to take to allow the noisy signal disturb the input conditioner. Now, let's see which is the furtherest step we can go without disturbing the system. If the signal lasts to step 13, it will not be able to change the fact as well as step 12. Since it takes two clock cycle for the input signal to reach synchronizer1 and one more to check whether synchronizer1 == conditioned is true or not.

	However, if at step 11(at which T = 10t), synchronizer0 changes back to 0 at the end of the cycle and synchronizer1 is still '1'. And then, when counter becomes 10 at the next cycle, synchronizer1 becomes 0. And at the next cycle, the code finds synchronizer1 == conditioned is true and changes counter back to '0' and the disturb is stopped.

	So the longest length of glitch that we could stop is smaller than l = 10t = 10 * (1/50MHZ) = 2 * 10 ^ (-7). Therefore, we are able to filter out glitch shorter than 2 * 10 ^ (-7) at the given situation.

### Shift register test strategy

In the test bench for our shift register, I implements three test cases. The three test cases are to test the serial-in-parallel-out, parallel-in-serial-out modes and peripheralClkEdge respectively. In the first test case, I write our serial input every clock cycle to be 1, 0, 0, 1, 0, 0, 1, 0. I also set the parallel input data to be 8b`01001001(opposite as the serial input). I set '0' to parallelLoad and '1' to peripheralClkEdge, which allows serial input and disables parallel input. After setting all the serial inputs, I begins reading. I verify serial output and parallel output at every clock cycle. If a single output is not expected, a error will be reported and test fails.

In that test, the following broken devices will be detected:
  1. broken parallelLoad (always set to '1')
  2. broken data input (choosing wrong data input)
  3. registers cannot shift correctly
  4. serial output not outputting LSB
  5. broken parallel output

And for the second case, I write our serial input every clock cycle to be 1. I also set the parallel input data to be 8b`00111011(will be different in MSB with serial input). I set '1' to parallel Load and '1' to peripheralClkEdge, which disables serial input and enables parallel input. After setting all the parallel inputs, It begins reading. I verify serial output and parallel output. If a single output is not expected, a error will be reported and test fails.

The third test simulate the case that the positive edge is not triggered. In this case, the shift register should not write anything to its memory. And the output should be the same as that in test 2. Notice that I intentionally set the LSB and MSB to be different in the input of test 2 and test 3, so that it will actually make difference.

### Mid point test sequence

For the FPGA, we will perform two kinds of test: one for serial-in-paralell-out,
and the other for parallel-in-serial-out mode. Since the LED can only show four
bits, we choose to display the four least significant bit, which is from 0 to 3.
So you can think it as an 4-bit shift register. Also, for the midpoint checkin,
we hard-coded paralell input to be xA5(8b'10100101). But for the LEDs, only the
last four bit will show up, which is 0101.

Following are the units we will be using for the test:

	-button 0, which is denoted as btn[0], will enable parallel input when pressed

	-switch 0, which is denoted as sw[0], represents the value of serial data input

	-switch 1, which is denoted as sw[1], will allows the value in sw[0] to be written to the shift register on its rising edge

	-LED(0 to 3), which is denoted as led[3:0], will display the shift register memory(right-most four bits)


1. Serial in -> :
	- The shift register will write serial input on the positive edge of sw[1], so we initially set sw[1] to be 0
	- Change the value of sw[0] to whatever you want to write into the register
	- Pass the data into shift register by changing sw[1] from 0 to 1, and you will see the value you wrote was loaded onto the LED above sw[0]
	- Repeat the process, and the original bits will shift to left, and the new value will appear on led[0]

2. Parallel in -> :
	- Click btn[0] to enable parallel input
	- 0101 should appear on the LEDs

Done

### SPI Memory Testing Strategy

To test the SPI module, we iterated through all 2^7 addresses supported, and inside each address, we wrote 2^8 different value(namely, from 0 to 2^8 - 1) to the address.
And then, we read from the addresses to check whether the value is correct or not. So the test case in theory should cover all the cases that is functional to the spi memory we implemented.

### Fault Injection

We have two fault injectors: inputconditioner_breakable and finitestatemachine_breakble. For the conditioner, we broken the D Flip-Flop that holds the value of "rising" that detects when the conditioner has a positive edge. "Rising" is permanently set to 0.

For the finitestatemachine in the DONE state, we reset the counter to 1 instead of 0.

Below is the diagram of the broken input conditioner:

![enter image description here](https://lh3.googleusercontent.com/-q8-y2AXxRnE/VkENSg_yJtI/AAAAAAAAAKk/F93c1r0CQ7A/s0/inputconditioner_broken.jpg "inputconditioner_broken.jpg")

Testing for failure:
- By setting "rising" to always 0, the shift register will not read the SerialIn data. This essentially will not allow the SPI memory to read or write since it cannot read the MOSI_pin. This will show when we write then try to read data from the memory, as it can only return xxxxxxxx.

- By setting the counter to 1 instead of 0 after we get to state_DONE, we are essentially shifting the input bit stream to the left by 1. This means the address will be either 2 times or 2 times plus 1 the intended address, the input data will be 2 times the intended data, and we are not setting the R/W pin where we thought we are. To test for this, simply try to read from any address and see if we receive the correct data.

## Work Plan Reflection

![enter image description here](https://lh3.googleusercontent.com/-PS0JgYUkAkM/VkEB_DVyBII/AAAAAAAAAJc/Mcb1PE5xKX4/s0/Screenshot+from+2015-11-09+15%253A15%253A40.png "work_plan1.png")
![enter image description here](https://lh3.googleusercontent.com/-kwte-pfRSEA/VkECDzUFqnI/AAAAAAAAAJo/jgSTNvWpzm4/s0/Screenshot+from+2015-11-09+15%253A27%253A17.png "work_plan2.png")
![enter image description here](https://lh3.googleusercontent.com/-KiJ8O3_2pVE/VkECgokwmjI/AAAAAAAAAJ0/DVhCu5O2dFk/s0/Screenshot+from+2015-11-09+15%253A27%253A45.png "work_plan3.png")

Above is our work plan, our estimated time as well as due date for each job.

In the work plan, 'X' and 'O' in the rightmost part means whether the job is overestimated or underestimated('O' is for well-estimated and overestimated; 'X' is for underestimated). And on top of each detailed jobs, we have sections like input conditioner and so on.

As we can see, we well-estimate the whole lab(estimation is 35.5 hours, and the actual time is about 30 hours). And for each sections, we well-estimated input conditioner, midpoint check-in, spi memory test cases and fault injection. But we underestimated shift register and spi memory(especially loading to FPGA part).

Based on the work plan chart, we conclude that we are doing better at estimating jobs that are relatively small, but not particularly good for jobs that are relatively large as well as work that are new to us. So in the next lab, we will probably give more time to large tasks and work we never touched before.

In summary, our work plan did a better job than last time, and we feel we are on the right track for better estimating work flow.
