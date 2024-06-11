
`include "interface.sv"
`include "test.sv"

module testbench;

    parameter DATASIZE = 8;
	parameter ADDRSIZE = 9;

	bit rclk;
	bit wclk;
	bit w_rst, r_rst;
	

	always #4ns rclk=~rclk;
    always #2ns wclk=~wclk;
	
	
    initial begin
	    w_rst = 1;
		r_rst = 1;
		#50 w_rst = 0;
		#50 r_rst = 0;
    end
	
	intfc intf(.wclk(wclk), .rclk(rclk), .w_rst, .r_rst); 
	
	test testdesign(intf); 
	
	top  #( .DATASIZE(DATASIZE), .ADDRSIZE(ADDRSIZE))topdesign(  .inf(intf )); 


endmodule