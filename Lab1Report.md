# Lab 1: Hieu Nguyen, Yuzhong Huang, Jake Jung

##Implementation
At first, we tried to build a selector at the entry and only choose to output “1” to the chosen operation and output nothing for the others. In this way, we could potentially save lots of energy. But after check in with ninja, we figure out that is unreachable. 

Then, we came up with the idea of a big Look up table that has all the 8 operations within a one-bit-ALU. And then connect 32 of them together. Also, we added check-ZERO, SLT, overflow in the last ALU. By adapting bit-slice approach, we can reuse some of the gates(the XOR gate are shared by the adder as well as the XOR operation)

Below is our diagram
/*
 * diagram goes here
 */

/*
 * further explanation of the diagram goes here
 */

During the development, we also make some changes:

combine some of the output from the look up table(we combine of & co, add & sub, nand&and, Cin&invB and so on);
choose AND and OR gate instead of MUX at the end for the sake of area;
choose XOR instead of MUX for invB selector for the same reason;

In summary, we improve our design along the way, especially for the reduction of area.
### Explanation of your test case strategy
The majority of our tests only test with the four most significant bits, because we think the most significant four bit are enough to cover most of the interest area. But we do include full bit test in out test bench.

We have four major pools of test cases, for each pool, there are some sub-pools, divided as follows:

####add 
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

####subtract
1. Overflow with carry out

2. No overflow with carry out

3. Overflow with no carry out

4. No overflow with no carry out

And together for the add and subtract, we test carryin and carryout with and without overflow for every bit:

   * (2^32-1) + 1
   * (2^31-1) + 1
 
And zero test for zero as well

####SLT
For the SLT test, we focus on overflow and the most significant bit of the outcome

1. Overflow with the first bit to be 1

2. Overflow with the first bit to be 0

3. No overflow with the first bit to be 1

4. No overflow with the first bit to be 0

####AND & NAND & OR & NOR &XOR

For these single bit operation that are independent of other bits, we include four test cases for every bit.

1. "1" and "0" 
   * (2^32-1) and 0
2. "1" and "1"
   * (2^32-1) and (2^32-1)
3. "0" and "1"
   * 0 and (2^32-1)
4. "0" and "0"     
   * 0 and 0

###A list of test case failures and the changes to your design they inspired.
we didn't run into any test case failures. But we do figure out some calculation error in our test benches. Our design changes are basically inspired by the idea of reducing area. As for the testing, we implement the test bench code according to our design, one test pool after another.

###Test cases along the way
we made some changes to our test cases while testing. A major one would be combing the test cases of XOR, AND, NAND, OR, NOR since they are operations that are independent of the other bits, we just need to perform four test cases for all of them at every bit level. 

We also adds ZERO test, and the test of all carryin and carryout for ADD to increase our test cases coverage. 

##Timing Analysis

##Work Plan Reflection
![enter image description here](https://lh3.googleusercontent.com/-SDQt45WEFUo/Vh-dJQOAacI/AAAAAAAAAHc/bc1PpNZ1law/s0/work+plan+reflection.png "work plan reflection.png")

Above is our work plan as well as our estimated time for each job. 

We underestimate the design part. The design of the device actually takes a lot longer than we think. Part of the design involves consulting ninjas and communicating with teammates. And both the consulting and communication saves great amount of time for the coding part. So for the next time, we would separate these two actions from the design to make tasks more specific. 

We also underestimate the test bench design, which also include transform designs into code. So for the next time, we would add one more task to code for the test benches.

What we have overestimate is the time we need to spent on setup work and study new stuff(for this lab, LUT and bit-slice method). But the overestimation is not significant. So we will probably keep them there.

Also, in our original plan, we didn't include connection coding(for example, connect test cases with our ALU) and debugging for the whole system, which takes significant amount of time. So we will include these two for the next lab's work plan.

In summary, our work plan underestimates the amount of work we need to spend on lab1. In that case, we will give more flexibility for each job in the future.