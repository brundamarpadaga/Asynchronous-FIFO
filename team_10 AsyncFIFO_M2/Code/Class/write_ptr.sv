module write_ptr #(parameter ADDRSIZE = 9)(wclk, w_rst, winc,  rptr_sync,  waddr, wptr, wfull);

input bit wclk, w_rst, winc;
input logic [ADDRSIZE:0] rptr_sync;

output bit wfull;
output logic [ADDRSIZE:0] waddr, wptr;

logic wwfull;
logic [ADDRSIZE:0]waddr_next; 
logic [ADDRSIZE:0]wptr_next;

assign waddr_next= waddr + (winc & !wfull);
assign wptr_next= (waddr_next>>1)^waddr_next; 

always_ff@(posedge wclk or posedge w_rst)
begin
	if(w_rst)
		begin
		waddr<='0; 
		wptr<='0;
		end 
	else begin
		waddr<=waddr_next;
		wptr<=wptr_next;
	end
end

always_ff@(posedge wclk or posedge w_rst)
begin
if(w_rst)
	wfull<=0;
else
	wfull<=wwfull;
end
assign wwfull= (wptr_next=={~rptr_sync[ADDRSIZE:ADDRSIZE-1],rptr_sync[ADDRSIZE-2:0]});// wfull CONDITION
	
endmodule















 