vlib work

vlog fifo_memory.sv
vlog TOP.sv
vlog r_pointer_epty.sv
vlog w_ptr_wfull.sv
vlog sync_r2w.sv
vlog syncw2r.sv
vlog testbench.sv

vsim work.async_fifo1_tb

run -all