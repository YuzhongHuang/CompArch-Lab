# Lab 1: Hieu Nguyen, Yuzhong Huang, Jake Jung

## Implementation
Initially, our plan was to use a decoder on the operation signal and output Z to the 7 operations that we wouldn't need to use; this method would have saved a lot of energy. However, after talking to a ninja, we realized this could not be done.

As a result, we settled on the idea of a big Look-Up Table that takes a 3 bit signal and outputs a 7-bit signal, explained here:

ALU output = [adder, xor, slt, and, or, invertB, invert AND/OR]

We first designed a schematic for a one-bit ALU. All the operations would take place regardless of what the true operation was, and the final results will be "filtered" by all the enable signals which will zero all the undesired outputs. We then developed the bit-slice design into a full 32-bit operation seen below:

![Alt Text](images/ALU.jpg)

During development, we also made some decisions:

* Combine two/three signals into one bit to minimize the width of the LUT's output e.g. we combined the enabling bit of carryout, overflow, addition and subtraction into the first bit, or carryin and invertB.
* Using an XOR gate instead of a mux when choosing between B and ~B to save time

In summary, we improve our design along the way, especially for the reduction of area.

### Explanation of your test case strategy
The majority of our tests only test with the four most significant bits, because we think the most significant four bit are enough to cover most of the interest area. But we do include full bit test in out test bench.

Run the file run.sh to see our very nice test bench in the terminal.

We have four major pools of test cases, for each pool, there are some sub-pools, divided as follows:

#### add
1. Overflow with carry out
  * 1001 + 1010
  * 1101 + 1010
2. No overflow with carry out
  * 1110 + 1100
  * 1110 + 1010
3. Overflow with no carry out
  * 0101 + 0110
  * 0110 + 0100
4. No overflow with no carry out
  * 0100 + 0001
  * 0101 + 1001
5. Positive + negative with no carry out (overflow not possible)
  * 1010 + 0101
  * 0111 + 1010
6. Positive + negative with carry out (overflow not possible)
  * 1110 + 0101
  * 0101 + 1111

#### subtract
1. Overflow with carry out
  * 1001 - 0110
  * 1101 - 0110
2. No overflow with carry out
  * 0101 - 1010
  * 0110 - 1100
3. Overflow with no carry out
  * 1110 - 0100
  * 1100 - 0011
4. No overflow with no carry out
  * 0100 - 1111
  * 0101 - 0111

And together for the add and subtract, we test carryin and carryout with and without overflow for every bit:

   * A = (2^32-1), B = 1; A+B
   * A = (2^31-1), B = 1; A+B

####SLT
For the SLT test, we focus on overflow and the most significant bit of the outcome
>>>>>>> e861fec66310aad7c4d9ad1515ea24f7c6f55e51

1. Overflow = 0, R[31] = 0

2. Overflow = 0, R[31] = 1

3. Overflow = 1, R[31] = 0

4. Overflow = 1, R[31] = 1

#### AND, NAND, OR, NOR, XOR

For these single bitwise operations that are independent of other bits, we included four test cases for all of them:

1. "1" and "0"
   * A = (2^32-1), B = 0
2. "1" and "1"
   * A = (2^32-1), B = (2^32-1)
3. "0" and "1"
   * A = 0, B = (2^32-1)
4. "0" and "0"     
<<<<<<< HEAD
   * A = 0, B = 0

### A list of test case failures and the changes to your design they inspired.
we didn't run into any test case failures. But we do figure out some calculation error in our test benches. Our design changes are basically inspired by the idea of reducing area. As for the testing, we implement the test bench code according to our design, one test pool after another.

## Timing Analysis

Below is the timing for one test case for our ALU. Because of the fact that every operation has to be carried out before we can decide on the output, the ALU is bottlenecked by the slowest module: the 32-bit adder. Even after that, it has to carry out 32-bit and/or operations on all the results, which is why it is so much more delayed after the "validSum" value is produced. "Zero" is limited by output, because it can only be calculated once "out" is calculated. However, our design ensures that the maximum timing delay will be 1000s, regardless of the inputs/operation.

![Alt Text](images/aluWaveforms.PNG)

## Work Plan Reflection
![enter image description here](https://lh3.googleusercontent.com/-SDQt45WEFUo/Vh-dJQOAacI/AAAAAAAAAHc/bc1PpNZ1law/s0/work+plan+reflection.png "work plan reflection.png")

Above is our work plan as well as our estimated time for each job.

We underestimate the design part. The design of the device actually takes a lot longer than we think. Part of the design involves consulting ninjas and communicating with teammates. And both the consulting and communication saves great amount of time for the coding part. So for the next time, we would separate these two actions from the design to make tasks more specific.

We also underestimate the test bench design, which also include transform designs into code. So for the next time, we would add one more task to code for the test benches.

What we have overestimate is the time we need to spent on setup work and study new stuff(for this lab, LUT and bit-slice method). But the overestimation is not significant. So we will probably keep them there.

Also, in our original plan, we didn't include connection coding(for example, connect test cases with our ALU) and debugging for the whole system, which takes significant amount of time. So we will include these two for the next lab's work plan.

In summary, our work plan underestimates the amount of work we need to spend on lab1. In that case, we will give more flexibility for each job in the future.
