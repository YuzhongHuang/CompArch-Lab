# Lab 1: Hieu Nguyen, Yuzhong Huang, Jake Jung

##Implementation
At first, we tried to build a selector at the entry and only choose to output “1” to the chosen operation and output nothing for the others. In this way, we could potentially save lots of energy. But after check in with ninja, we figure out that is unrealizable. 

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

We have four major pools of test cases, for each pool, there are some sub-pools, divided as follows:

####add 
1. Overflow with carry out
  * 1001 + 1010
  * 1101 + 1010
  * 1110 + 1000
2. No overflow with carry out
  * 1110 + 1100
  * 1110 + 1010
  * 1100 + 1101
3. Overflow with no carry out
  * 0101 + 0110
  * 0110 + 0100
  * 0100 + 0110
4. No overflow with no carry out
  * 0100 + 0001
  * 0101 + 1001
  * 1011 + 0011
5. Positive + negative with no carry out (overflow not possible)
  * 1010 + 0101
  * 0111 + 1010
  * 1011 + 0011
6. Positive + negative with carry out (overflow not possible)
  * 1110 + 0101
  * 0101 + 1111
  * 1111 + 0011
####subtract
1. Overflow with carry out
  * 1001 + 1010
  * 1101 + 1010
  * 1110 + 1000
2. No overflow with carry out
  * 1110 + 1100
  * 1110 + 1010
  * 1100 + 1101
3. Overflow with no carry out
  * 0101 + 0110
  * 0110 + 0100
  * 0100 + 0110
4. No overflow with no carry out
  * 0100 + 0001
  * 0101 + 1001
  * 1011 + 0011
####SLT

####AND & NAND & OR & NOR &XOR

####A list of test case failures and the changes to your design they inspired.

##Timing Analysis

##Work Plan Reflection
![enter image description here](https://lh3.googleusercontent.com/-SDQt45WEFUo/Vh-dJQOAacI/AAAAAAAAAHc/bc1PpNZ1law/s0/work+plan+reflection.png "work plan reflection.png")

1. underestimate the design part and the test bench design and coding
2. overestimate the time to study new things and setup
3. didn't include debugging and connecting the test bench with the code(including testing)