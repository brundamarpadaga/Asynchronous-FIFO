module wptr_full
#(
  parameter ADDR_WIDTH = 9
)
(
  input   winc, wclk, wrst_n,
  input   [ADDR_WIDTH :0] wq2_rptr,
  output reg  wfull,
  output  [ADDR_WIDTH-1:0] waddr,
  output reg [ADDR_WIDTH :0] wptr
);

   reg [ADDR_WIDTH:0] wbin;
  wire [ADDR_WIDTH:0] wgraynext, wbinnext;

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      {wbin, wptr} <= '0;
    else
      {wbin, wptr} <= {wbinnext, wgraynext};

  // Memory write-address pointer
  assign waddr = wbin[ADDR_WIDTH-1:0];
  assign wbinnext = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;

  assign wfull_val = (wgraynext=={~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1], wq2_rptr[ADDR_WIDTH-2:0]});

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      wfull <= 1'b0;
    else
      wfull <= wfull_val;

endmodule
