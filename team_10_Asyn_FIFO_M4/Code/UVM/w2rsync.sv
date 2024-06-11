module w2rsync #(parameter  ADDRSIZE=9)( rclk, r_rst,  wptr ,  wptr_sync);

input bit rclk,r_rst;
input [ADDRSIZE:0] wptr;
output logic [ADDRSIZE:0]  wptr_sync;

 logic [ADDRSIZE:0] q2;
  always_ff@(posedge rclk) begin
    if(r_rst) begin
      q2 <= 0;
      wptr_sync <= 0;//one cycle delay
    end
    else begin
      q2 <= wptr;
      wptr_sync <= q2;//two cycle delay
    end
  end
endmodule