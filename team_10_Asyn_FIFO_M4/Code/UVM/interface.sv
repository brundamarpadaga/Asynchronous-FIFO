interface intfc(input bit wclk, rclk, w_rst, r_rst);
parameter  DATASIZE=8, ADDRSIZE=9;
parameter wclk_width=4;
parameter rclk_width=10;
logic winc, rinc;
logic [ADDRSIZE:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;
bit wfull, rempty;
logic [DATASIZE-1:0] wdata,rdata;
logic  [DATASIZE-1:0] wdata_q[$],rdata_q;
		
endinterface
