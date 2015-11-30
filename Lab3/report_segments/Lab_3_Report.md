# Lab 3 Report

### Yuzhong, Hieu, Selina

## Processor Architecture
![Block diagram of the multicycle CPU implementation](https://github.com/YuzhongHuang/CompArch-Lab/blob/master/Lab3/report_segments/BlockDiagram.PNG)

Above is the block diagram of our multicycle CPU design. This design fetches the instruction from the memory with the PC. It then passes the instruction to the IR to get decoded. The decoded instruction then gets passed to the FSM to generate all the control signals. Depending on the signals the CPU would then go through the EX, MEM, WB phases if needed for excuting the instruction. There is some timing issue with the FSM since the FSM needs input from instruction decoder, however, the IR will not get input from Memory until FSM set MemIn to choose PC. So if we only have IF state, we will enter a deadlock. So we add another default state at the beginning of each instruction before IF state. In this case, we can send out FSM instructions beforehand and solve the problem. 

We have included some RTL here to demonstrate how instructions are implemented.
```
Jump and Link

Default: Setup FSM controls

IF:		IR = Memory[PC]
		MDR = Memory[PC]
		PC = PC+4
ID:		PC = {PC[31:28], IR[25:0], b00}
		set MemIn to 0
WB: 	RegFile[31] = MDR
		set MemIn to PC
```
For the JAL instruction, after we reads the instruction from the Default state, we increment PC in IF state. Then, we concatenate PC to the jump immediate. In the following WB state, we save MDR, which holds the value of PC + 4 to $ra, the 31st register.
```
Load Word

Default: Setup FSM controls

IF: 	IR = Memory[PC]
		PC = PC + 4
ID: 	A = RegFile[rs]
EX:		Result = A + SE(Imm)
MEM:	MDR = Mem[Result]
WB:		RegFile[rt] = DataReg
```
For load word, after the default state, we increments PC in IF state. In ID state, we load the value of register rs to A. And on the EX state, we add A with the sign-extended immediate. Then we save the value from data memory to MDR in the MEM state. Finally, we write back the value to the destination register.
```
Branch if Not Equal

Default: Setup FSM controls

IF: 	Instruction Register = Memory[PC] 
		PC = PC+4
ID:		A = RegFile[rs]
		B = RegFile[rt]
		Res = PC + sign extended immediate
EX:		if(A!=B) PC = Res
```
In BNE, after the default and IF state, we load the value of register rs to A, rt to B, and add PC and sign-extended immediate to ALU res. In EX state, we check A!=B by reading from ALU's zeroflag to PC write enable. In this way, we can decide to overwrite PC with branch address or not. 

## Test Plan
Our test plan was to test the individual components of our CPU with their own test benches first to make sure they all function the way we expect them too. Since we were very careful in designing and writing the subunits, the individual testing didn't take long. Then when we were testing our composed CPU, we decided to write assembly tests that only tested one instruction at a time first so that it's easier to debug. This really helped our a lot with adjusting the timing and also correcting our FSM outputs. After our CPU passed all the one instruction assembly tests, we implemented a complete assembly test that tested all ten instructions and got the expected result. We learned that implementing and testing iteratively was really helpful in catching and fixing bugs early and relatively easy.

## Performance Analysis/Choices made
Having unsuccessfully load our CPU onto the FPGA, we will discuss some design choices made:
- First of all, our ALU does not operate at each clock edge, but whenever the operation changes:
```
always @(op) begin
	...
end
```
This is because we could not get the timing right with posedge or negedge.
- We did not include a shifter in our design since shifting by 2 is unnecessary as our memory stores 4 bytes worth in one word.
- Our FSM updates the control signals on the falling edge of the clock so that all the signals are ready for the next rising edge.
- We also added a default state which acts as a buffer between different instructions so the CPU can "reset" itself, since there were problems going from any state back to the universal IF state.
- In our FSM Look-Up Table, we also added a default case. In the IF state, our CPU has two choices: go to ID_1 (used by most instructions) or ID_J (used by Jump and JAL). The CPU actually does not decide correctly which one to go to, but chooses the one it previously used. Which means it can progress normally going from ADD to SLT, but from SLT to JAL it will have trouble. Therefore, the default cause in the LUT essentially allows the CPU to "start over" with the instruction and actually go to the right state.

## Work Plan Reflection

Designing the components of our multicycle CPU and writing the verilog scripts for each took about the amount of time we expected with the exception of the finite state machine. We originally planned on spending around 3.5 hours on the design, build, and test. We ended up spending about 6 hours due to little errors we made here and there and the long time we spent debugging these errors. We didn't allocate time for integration in our original work plan since we believed that once we get the individual components working the "putting together" part should be really simple. However, integration turned out to be the most time consumimg piece of our lab. We didn't expect timing to be an issue since for the last few labs timing was relatively easy to deal with. Our ID phase was getting instructions too early and our ALU was calculating results too late. We ended up spending a lot of time on adjusting the timing so every component would work nicely together.
