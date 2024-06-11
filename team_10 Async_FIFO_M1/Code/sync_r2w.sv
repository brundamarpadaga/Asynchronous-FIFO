module sync_r2w #(parameter ADDRSIZE = 9)
 (
  input   wclk, wrst_n,
  input   [ADDRSIZE:0] rptr,
  output reg  [ADDRSIZE:0] wq2_rptr
);

  reg [ADDRSIZE:0] wq1_rptr;

  always_ff @(posedge wclk or negedge wrst_n)
    if (wrst_n) begin
	wq2_rptr <= 0;
	wq1_rptr <= '0;
	end
    else begin
	wq2_rptr <= wq1_rptr;
	wq1_rptr <= rptr;
	end
endmodule