vlib work
vdel -all
vlib work

vlog interface.sv    	+acc -sv

vlog syncw2r.sv			+acc -sv
vlog syncr2w.sv			+acc -sv
vlog write_ptr.sv		+acc -sv
vlog read_ptr.sv		+acc -sv
vlog fifo_memory.sv		+acc -sv
vlog top.sv				+acc -sv

vlog environment.sv		+acc -sv
vlog test.sv			+acc -sv
vlog testbench.sv		+acc -sv


vsim -coverage -vopt work.testbench 

add wave -r /*
run -all

vcover report -html sv_fifo_coverage
coverage report -detail
