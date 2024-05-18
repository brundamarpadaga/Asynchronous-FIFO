module r2wsync #(parameter ADDRSIZE=9)( wclk, w_rst, rptr,  rptr_sync);

input bit wclk, w_rst;
input logic [ADDRSIZE:0]  rptr;
output logic [ADDRSIZE:0]rptr_sync;

logic [ADDRSIZE:0] q1;
  always_ff@(posedge wclk) begin
    if(w_rst) begin
      q1 <= 0;
      rptr_sync <= 0;
    end
    else begin
      q1 <= rptr;
      rptr_sync <= q1;
    end
  end
endmodule