`include "interface.sv"
`include "test.sv"
import params::*;
module top;

   logic wclk, rclk;
   logic wrst_n, rrst_n;

   intf intf_top(wclk, rclk, wrst_n, rrst_n);
   test test_h(intf_top);
   async_fifo #(FIFO_WIDTH, ADDR_WIDTH) DUT(intf_top.winc, intf_top.wclk, intf_top.wrst_n, intf_top.rinc, 
					    intf_top.rclk, intf_top.rrst_n, intf_top.wdata, intf_top.rdata,
					    intf_top.wfull, intf_top.rempty);

  //clock generation blocks
  initial begin
    wclk = 1'b0;
    rclk = 1'b0;

    fork
      forever #1ns wclk = ~wclk;  //write frequency is 500MHz
      forever #1ns rclk = ~rclk;  //read frequency is 500MHz
    join
  end   

   initial begin
	wrst_n = '0; rrst_n = '0;
        #20 wrst_n = '1; rrst_n = '1;
   end 

endmodule