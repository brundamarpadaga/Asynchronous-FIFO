module top #(parameter DATASIZE = 8,parameter ADDRSIZE = 9) (intfc inf );



w2rsync #(ADDRSIZE) w2rsync_inst(inf.rclk,  inf.r_rst,  inf.wptr ,  inf.wptr_sync );
r2wsync #(ADDRSIZE) r2wsync_inst(inf.wclk, inf.w_rst, inf.rptr,  inf.rptr_sync );


write_ptr #(ADDRSIZE) write_ptr_inst (inf.wclk, inf.w_rst, inf.winc,  inf.rptr_sync,  inf.waddr, inf.wptr, inf.wfull);


read_ptr #(ADDRSIZE) read_ptr_inst (inf.rclk, inf.r_rst, inf.rinc,   inf.wptr_sync,  inf.raddr, inf.rptr,  inf.rempty);


fifo_mem #(DATASIZE,ADDRSIZE) fifo_mem_inst (inf.wclk,inf.rclk,inf.r_rst,inf.w_rst,inf.winc,inf.rinc,inf.wfull,inf.rempty, inf.wdata,  inf.waddr,inf.raddr,  inf.rdata);

endmodule