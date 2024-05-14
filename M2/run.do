vlib work

vlog async_fifo.sv
vlog top.sv

vsim -voptargs=+acc work.top

add wave -r *
run -all