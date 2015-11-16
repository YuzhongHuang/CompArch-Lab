vlog -reportprogress 300 -work work testregfile.t.v
vsim -voptargs="+acc" regfiletestbenchharness

add wave -position insertpoint  \
sim:/regfiletestbenchharness/ReadData1 \
sim:/regfiletestbenchharness/ReadData2 \
sim:/regfiletestbenchharness/WriteData \
sim:/regfiletestbenchharness/ReadRegister1 \
sim:/regfiletestbenchharness/ReadRegister2 \
sim:/regfiletestbenchharness/WriteRegister \
sim:/regfiletestbenchharness/RegWrite \
sim:/regfiletestbenchharness/Clk \
sim:/regfiletestbenchharness/begintest \
sim:/regfiletestbenchharness/endtest \
sim:/regfiletestbenchharness/dutpassed
run -all

wave zoom full