#Lab 3 Report#

##Processor Architecture##
![Block diagram of the multicycle CPU implementation](https://github.com/YuzhongHuang/CompArch-Lab/blob/master/Lab3/report_segments/BlockDiagram.PNG)

Above is the block diagram of our multicycle CPU design. This design fetches the instruction from the memory with the PC. It then passes the instruction to the IR to get decoded. The decoded instruction then gets passed to the FSM to generate all the control signals. Depending on the signals the CPU would then go through the EX, MEM, WB phases if needed for excuting the instruction.

We have included some RTL here to demonstrate how instructions are implemented.
```
Jump and Link

IF:		IR = Memory[PC]
		MDR = Memory[PC]
		PC = PC+4
ID:		PC = {PC[31:28], IR[25:0], b00}
		set MemIn to 0
WB: 	RegFile[31] = MDR
		set MemIn to PC
```
```
Jump Register

IF:		IR = Memory[PC]
		PC = PC+4
ID:		A = RegFile[ra]
EX:		Res = A+0
~~MEM:.~~
WB:		PC = Res
```
```
Branch if Not Equal

IF: 	Instruction Register = Memory[PC] 
		PC = PC+4
ID:		A = RegFile[rs] 
		B = RegFile[rt] 
		Res = PC + sign extended immediate
EX:		if(A!=B) PC = Res
~~MEM:.~~
~~WB:.~~
```

##Test Plan##
Our test plan was to test the individual components of our CPU with their own test benches first to make sure they all function the way we expect them too. Since we were very careful in designing and writing the subunits, the individual testing didn't take long. Then when we were testing our composed CPU, we decided to write assembly tests that only tested one instruction at a time first so that it's easier to debug. This really helped our a lot with adjusting the timing and also correcting our fsm outputs. After our CPU passed all the one instruction assembly tests, we implemented a complete assembly test that tested all ten instructions and got the expected result. We learned that implementing and testing iteraitvely was really helpful in catching and fixing bugs early and relatively easy. 

##Performance Analysis##

##Work Plan Reflection##
Designing the components of our multicycle CPU and writing the verilog scripts for each took about the amount of time we expected with the exception of the finite state machine. We originally planned on spending around 3.5 hours on the design, build, and test. We ended up spending about 6 hours due to little errors we made here and there and the long time we spent debugging these errors. We didn't allocate time for integration in our original work plan since we believed that once we get the individual components working the "putting together" part should be really simple. However, integration turned out to be the most time consumimg piece of our lab. We didn't expect timing to be an issue since for the last few labs timing was relatively easy to deal with. Our ID phase was getting instructions too early and our ALU was calculating results too late. We ended up spending a lot of time on adjusting the timing so every component would work nicely together. 