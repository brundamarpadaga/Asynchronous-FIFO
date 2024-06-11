module coverage #(parameter ptr_width = 8,depth = 256,data_width = 8) 
(intfc  rif_cov);

logic temp_r_en;
logic temp_w_en;
logic temp_clearw;
logic temp_clearr;
logic full_temp;
logic empty_temp;

always_ff @(posedge rif_cov.wclk)
     begin
     temp_clearw <= rif_cov.w_rst;
     temp_w_en <= rif_cov.winc;
	 full_temp<= rif_cov.wfull;
     end
always_ff @(posedge rif_cov.rclk)
     begin
     temp_clearr <= rif_cov.r_rst;
     temp_r_en <= rif_cov.rinc;
	 empty_temp<= rif_cov.rempty;
     end

covergroup test_write @(posedge rif_cov.wclk);

c0:coverpoint rif_cov.w_rst{
             bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
c1:coverpoint rif_cov.rempty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c2:coverpoint rif_cov.wfull {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
			 
c3 : coverpoint rif_cov.winc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

c4 : coverpoint rif_cov.wdata {
             bins wr_data = {[0:255]};
			  }

c10 : coverpoint rif_cov.rinc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }

endgroup

covergroup test_read @(rif_cov.rclk);
c5 : coverpoint rif_cov.rinc {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c6: coverpoint rif_cov.r_rst {
             bins r_rst_n_high = {1};
			 bins r_rst_n_low = {0};
			 }			 

c7 : coverpoint rif_cov.rdata {
             bins rd_data = {[0:255]};
			  }
			  
c8:coverpoint rif_cov.rempty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c9:coverpoint rif_cov.wfull {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
c11 : coverpoint rif_cov.winc {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

endgroup


test_write test_instw;
test_read  test_instr;

initial begin
  test_instw = new();
  test_instr = new();

 end

endmodule