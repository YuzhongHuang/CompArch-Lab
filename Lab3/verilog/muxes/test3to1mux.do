vdel - lib work - all
vlib work
vlog -reportprogress 300 -work work test3to1mux.t.v
vsim -voptargs="+acc" test3to1mux
add wave -position insertpoint  \
sim:/test3to1mux/out \
sim:/test3to1mux/address \
sim:/test3to1mux/in0 \
sim:/test3to1mux/in1 \
sim:/test3to1mux/in2
run -all
wave zoom full