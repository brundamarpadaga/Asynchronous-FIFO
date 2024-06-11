class coverage extends uvm_test ;
`uvm_component_utils(coverage)// regisering the covergae class with the factory
uvm_analysis_imp #(fifo_seq_item, coverage) coverage_port;// craeting annalysis port for the coverage

real coverage_score1;
real coverage_score2;
real coverage_score3;
real total_coverage;
fifo_seq_item cov_pkt;
virtual intfc cov_if; // virtaul interface handle



//creating cover groups for write and read address
covergroup cov_mem with function sample(fifo_seq_item cov_pkt) ;
    a1: coverpoint cov_pkt.waddr { // Measure coverage
       bins waddr[]= {[0:511]};
     }
	 a2: coverpoint cov_pkt.raddr { // Measure coverage
     bins raddr[]= {[0:511]};
     }
     w_r_addr: cross a1,a2;
   endgroup

// craeting cover group for testing write operation
covergroup test_write with function sample(fifo_seq_item w_pkt) ;

c0:coverpoint w_pkt.w_rst{
             bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
c1:coverpoint w_pkt.rempty {
             bins  fifo_rempty_1 = {1};
			 bins fifo_rempty_0 = {0};
			 }
c2:coverpoint w_pkt.wfull {
             bins fifo_wfull_1 = {1};
			 bins fifo_wfull_0 = {0};
}
			 
c3 : coverpoint w_pkt.winc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

c4 : coverpoint w_pkt.wdata {
             bins wr_data = {[0:255]};
			  }

c10 : coverpoint w_pkt.rinc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
			 

endgroup

// creating cover group for testing read operation
covergroup test_read with function sample(fifo_seq_item r_pkt) ;
c5 : coverpoint r_pkt.rinc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c6: coverpoint r_pkt.r_rst {
             bins r_rst_high = {1};
			 bins r_rst_low = {0};
			 }			 

c7 : coverpoint r_pkt.rdata {
             bins rd_data = {[0:255]};
			  }
			  
c8:coverpoint r_pkt.rempty {
             bins  fifo_rempty_1 = {1};
			 bins fifo_rempty_0 = {0};
			 }
c9:coverpoint r_pkt.wfull {
             bins fifo_wfull_1 = {1};
			 bins fifo_wfull_0 = {0};
}
c11 : coverpoint r_pkt.winc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

endgroup

// creating a new constructor for coverage class and all the above created cover groups
function new (string name="coverage",uvm_component parent);
super.new(name,parent);
`uvm_info("COVERAGE CLASS", "Inside Constructor!", UVM_LOW)
cov_mem=new();
test_write=new();
test_read=new();
endfunction

//Buid Phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("COVERAGE CLASS", "Build Phase!", UVM_HIGH)
   
    coverage_port = new("coverage_port", this); 
endfunction
  
  // Write Function
function void write(fifo_seq_item t);
cov_mem.sample(t);
test_read.sample(t);
test_write.sample(t);

endfunction

// Extract Phase
function void extract_phase(uvm_phase phase);
   super.extract_phase(phase);
  coverage_score1=cov_mem.get_coverage();
coverage_score2=test_write.get_coverage();
coverage_score3=test_read.get_coverage();
endfunction

//Report Phase
function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("COVERAGE",$sformatf("Coverage=%0f%%",coverage_score1),UVM_MEDIUM);
	`uvm_info("COVERAGE",$sformatf("Coverage=%0f%%",coverage_score2),UVM_MEDIUM);
	`uvm_info("COVERAGE",$sformatf("Coverage=%0f%%",coverage_score3),UVM_MEDIUM);
endfunction

endclass