interface intfc(input bit wclk, rclk, w_rst, r_rst);

parameter DATASIZE = 8;parameter ADDRSIZE = 9; // parameters

parameter wclk_width=2; //Write clock width
parameter rclk_width=4; //read clock width
logic winc, rinc;
logic [ADDRSIZE:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;
bit wfull, rempty;
logic [DATASIZE-1:0] wdata,rdata;

modport driver ( input wclk,rclk, w_rst, r_rst);
modport monitor( input wclk,rclk, w_rst, r_rst);
modport coverage (input wclk,rclk, w_rst, r_rst, wdata,rdata,rinc,winc,wfull,rempty);
		
endinterface
