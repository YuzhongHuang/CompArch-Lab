vdel - lib work - all
vlib work
vlog -reportprogress 300 -work work testshifter.t.v
vsim -voptargs="+acc" testShifter
add wave -position insertpoint  \
sim:/testShifter/out \
sim:/testShifter/in 
run -all
wave zoom full