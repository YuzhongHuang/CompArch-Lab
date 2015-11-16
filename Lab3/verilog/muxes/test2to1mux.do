
vlog -reportprogress 300 -work work test2to1mux.t.v
vsim -voptargs="+acc" test2to1mux
add wave -position insertpoint  \
sim:/test2to1mux/out \
sim:/test2to1mux/address \
sim:/test2to1mux/in0 \
sim:/test2to1mux/in1
run -all
wave zoom full