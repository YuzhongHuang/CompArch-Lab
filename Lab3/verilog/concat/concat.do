vdel - lib work - all
vlib work
vlog -reportprogress 300 -work work testconcat.t.v
vsim -voptargs="+acc" testconcat
add wave -position insertpoint  \
sim:/testShifter/concat \
sim:/testShifter/PC \
sim:/testShifter/dout
run -all
wave zoom full