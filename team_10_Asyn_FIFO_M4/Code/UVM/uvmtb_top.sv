`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "FIFO_seq_item.sv"
`include "sequence_fifo_wr.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "coverage_uvm.sv"
`include "env.sv"
`include "uvmtest.sv"

module uvmtb_top;


parameter DATASIZE=8;
parameter ADDRSIZE=9;


	bit rclk;
	bit wclk;
	bit w_rst, r_rst;
	
	// Instantiating the Top level DUT and interface
	intfc ifuvm(.wclk(wclk), .rclk(rclk), .w_rst(w_rst), .r_rst(r_rst));
	top #(.DATASIZE(DATASIZE), .ADDRSIZE(ADDRSIZE)) t1 (.inf(ifuvm));
	
	// connecting interface through uvm_config_db to other test bench components
	initial begin
		uvm_config_db #(virtual intfc):: set(null, "*", "vif", ifuvm);
	end
	
	
	initial begin
		run_test("uvmtest");
	end
	
	// clock generation
	always #4ns rclk=~rclk;
    always #2ns wclk=~wclk;
	
	
	//reset Generation
    initial begin
	    w_rst = 1;
		r_rst = 1;
		
		#15 w_rst = 0;
		#15 r_rst = 0;
    end
	
	
	initial begin
		#100000;
		$display("sorry ran out of clock cycles");
		$finish;
	end
	
	
endmodule