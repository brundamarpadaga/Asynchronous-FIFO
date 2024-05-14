import params::*;
interface intf(input logic wclk, rclk, wrst_n, rrst_n);
	logic winc;
  	logic rinc;
  	logic [FIFO_WIDTH-1:0] wdata;

  	logic [FIFO_WIDTH-1:0] rdata;
  	logic wfull;
  	logic rempty;
endinterface