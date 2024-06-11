import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_seq_item #(parameter  DATASIZE =8, ADDRSIZE = 9)extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item #(8,9))// registering the class to factory

	rand bit winc;
	rand bit rinc;
	rand bit w_rst;
	rand bit r_rst;
	rand bit [DATASIZE-1:0] wdata;
	bit [DATASIZE-1:0] rdata;
	bit rempty, wfull;
	bit [ADDRSIZE:0] waddr, raddr;
	
	constraint no_rst {w_rst == 0 && r_rst ==0;}//Constraint for reset
	
	function string convert2str();
	   return $sformatf ("winc =%0d, rinc =%0d,data_in =%0d",winc,rinc,wdata);
	endfunction
	
	// creating a new constructor for sequence item class
	function new (string name = "fifo_seq_item");
		super.new(name);
	endfunction
endclass
		
	