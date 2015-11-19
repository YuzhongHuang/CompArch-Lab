vdel - lib work - all
vlib work
vlog -reportprogress 300 -work work pc.t.v
vsim -voptargs="+acc" testPC
add wave -position insertpoint  \
sim:/testShifter/pc \
sim:/testShifter/in \
sim:/testShifter/pc_we \
sim:/testShifter/clk
run -all
wave zoom full