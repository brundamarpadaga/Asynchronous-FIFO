module wptr_full#(parameter ADDRSIZE = 9)
(
  input   winc, wclk, wrst_n,
  input   [ADDRSIZE :0] wq2_rptr,
  output reg  wfull,
  output  [ADDRSIZE-1:0] waddr,
  output reg [ADDRSIZE :0] wptr
);

   reg [ADDRSIZE:0] wbin;
  wire [ADDRSIZE:0] wgraynext, wbinnext;

  always_ff @(posedge wclk or negedge wrst_n)
    if (wrst_n)begin
      wbin <= '0;
	  wptr	<= '0;
	  end
    else begin
      wbin  <= wbinnext;
	  wptr  <= wgraynext;
	  end

  assign waddr = wbin[ADDRSIZE-1:0];
  assign wbinnext = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;

  assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

  always_ff @(posedge wclk or negedge wrst_n)
    if (wrst_n)
      wfull <= 1'b0;
    else
      wfull <= wfull_val;

endmodule