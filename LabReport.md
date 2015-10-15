# Lab 1: Hieu Nguyen, Yuzhong Huang, Jake Jung

For the decoder, Verilog code is in the file **decoder.v**, compiled code is in **decoder.vvp**, variables are in **decoder.vcd**.

To see results in a UNIX terminal, run **vvp decoder.vvp**.


### Waveforms showing full adder stabilizing after changing inputs

A, B and Sum represented in hex:

![Alt Text](images/Lab0Waveforms.jpg)

Individual bits waveforms:

![Alt Text](images/Lab0Waveforms1.jpg)

Test Bench:

![Alt Text](images/test bench.png)

**Worst case delays**

With each gate having a delay of 50 units of time, the worst case delay (in a 1-bit adder) for the sum is 50 and for the carry out is 150 units. Therefore for a 4-bit adder, the worst case delay for:

* The sum is (3 x 150) + 50 = 500
* The carry out is 4 x 150 = 600
* The overflow is 600 + 50 = 650 (since there is an extra XOR gate to determine overflow)

### Explanation of your test case strategy

We have six pools of test cases, divided as follows:

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
  * 0111 + 1000
  * 1011 + 0011
6. Positive + negative with carry out (overflow not possible)
  * 1110 + 0101
  * 0101 + 1111
  * 1111 + 0011

### A list of test case failures and the changes to your design they inspired.

We did not run into test case failures. We implemented our design incrementally, testing that the first bit adder worked, then the second bit, and so on.

### A summary of testing performed on the FPGA board

We carried out all 18 of our test cases on the FPGA. Below are the photos for our 8th test case in the list above:

A (0101):

![Alt Text](images/a.jpg)

B (0100):

![Alt Text](images/b.jpg)

Sum (1001):

![Alt Text](images/sum.jpg)

Overflow (1) and Carryout (0):

![Alt Text](images/overflow.jpg)

### Summary statistics of your synthesized design (Propagation Delay, Resources Used, etc)

![Alt Text](images/statistics.png)
