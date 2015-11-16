vdel - lib work - all
vlib work
vlog -reportprogress 300 -work work test4to1mux.t.v
vsim -voptargs="+acc" test4to1mux
add wave -position insertpoint  \
sim:/test4to1mux/out \
sim:/test4to1mux/address \
sim:/test4to1mux/in0 \
sim:/test4to1mux/in1 \
sim:/test4to1mux/in2 \
sim:/test4to1mux/in3 
run -all
wave zoom full