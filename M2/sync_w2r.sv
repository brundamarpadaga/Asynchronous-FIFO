module sync_w2r
#(
  parameter ADDR_WIDTH = 9
)
(
  input   rclk, rrst_n,
  input   [ADDR_WIDTH:0] wptr,
  output reg [ADDR_WIDTH:0] rq2_wptr
);

  reg [ADDR_WIDTH:0] rq1_wptr;

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rq2_wptr,rq1_wptr} <= 0;
    else
      {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};

endmodule
