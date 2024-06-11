module read_ptr #(parameter ADDRSIZE=9)( rclk, r_rst, rinc,   wptr_sync,  raddr, rptr,  rempty);

input bit rclk,r_rst, rinc;
input logic [ADDRSIZE:0]  wptr_sync;
output bit rempty;
output logic [ADDRSIZE:0] raddr, rptr;

 logic rrempty;
 logic remptyr;
 logic readrempty;

logic [ADDRSIZE:0]raddr_next;
logic [ADDRSIZE:0]rptr_next;


assign raddr_next= raddr + (rinc & !rempty);
assign rptr_next=(raddr_next>>1)^raddr_next; 
assign rrempty= (wptr_sync == rptr_next); 
always_ff@(posedge rclk or posedge r_rst)
begin
	if(r_rst)
		begin
		raddr<=0; 
		rptr<=0;
		end 
	else begin
		raddr<=raddr_next;
		rptr<=rptr_next;
	end
end

always_ff@(posedge rclk or posedge r_rst)
begin
if(r_rst)
	rempty<=1;
else
	rempty<=rrempty;
	
end

property P_rreset;
	@(posedge rclk)
	disable iff(r_rst)
	r_rst |=> (raddr=='0 & rptr=='0);
endproperty
a_rreset: assert property(P_rreset)
else
	$error(" assertion failed in read reset");
	
property P_rempty;
	@(posedge rclk)
	disable iff(r_rst)
	r_rst |=> (rempty=='1);
endproperty
a_empty: assert property(P_rempty)
else
	$error(" assertion failed in empty condition");

endmodule












 