iverilog -o testcpu testcpu.v cpu.v alu/alu.v concat/concat.v datamemory/datamemory.v fsm/fsm.v IR/IR.v muxes/muxes.v dff/dff.v  regfile/regfile.v signextend/se.v fsm/fsmCommand.v && ./testcpu
