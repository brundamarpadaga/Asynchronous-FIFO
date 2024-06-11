module rptr_empty#(parameter ADDRSIZE = 9)
(
  input   rinc, rclk, rrst_n,
  input   [ADDRSIZE :0] rq2_wptr,
  output reg  rempty,
  output  [ADDRSIZE-1:0] raddr,
  output reg [ADDRSIZE :0] rptr
);

  reg [ADDRSIZE:0] rbin;
  wire [ADDRSIZE:0] rgraynext, rbinnext;


  always_ff @(posedge rclk or negedge rrst_n)
    if (rrst_n)begin
      rbin <= '0;
	  rptr <= '0;
	  end
    else begin
      rbin <= rbinnext;
	  rptr <= rgraynext;
	  end


  assign raddr = rbin[ADDRSIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;

  assign rempty_val = (rgraynext == rq2_wptr);

  always_ff @(posedge rclk or negedge rrst_n)
    if (rrst_n)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;

endmodule
