vdel - lib work - all
vlib work
vlog -reportprogress 300 -work work testmuxes.t.v
vsim -voptargs="+acc" testMuxes
add wave -position insertpoint  \
sim:/testMuxes/out \
sim:/testMuxes/address1 \
sim:/testMuxes/address \
sim:/testMuxes/in0 \
sim:/testMuxes/in1 \
sim:/testMuxes/in2 \
sim:/testMuxes/in3 
run -all
wave zoom full