module sync_w2r#(parameter ADDRSIZE = 9)
(
  input   rclk, rrst_n,
  input   [ADDRSIZE:0] wptr,
  output reg [ADDRSIZE:0] rq2_wptr
);

  reg [ADDRSIZE:0] rq1_wptr;

  always_ff @(posedge rclk or negedge rrst_n)
    if (rrst_n)begin
      rq2_wptr <= '0;
	  rq1_wptr <= '0;
	  end
    else begin
      rq2_wptr <= wptr;
	  rq1_wptr <= wptr;
	  end
endmodule
