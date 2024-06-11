vlib work
vdel -all
vlib work

vlog interface.sv

vlog syncw2r.sv
vlog syncr2w.sv
vlog write_ptr.sv
vlog read_ptr.sv
vlog fifo_memory.sv
vlog top.sv

vlog environment.sv
vlog test.sv
vlog testbench.sv


vsim  work.testbench 


run -all
