module fifo_mem #(parameter DATASIZE = 8,parameter ADDRSIZE = 9)( wclk,rclk,r_rst,w_rst,winc,rinc,wfull,rempty, wdata,  waddr,raddr,  rdata);

input bit wclk,rclk,r_rst,w_rst,winc,rinc,wfull,rempty;
input logic [ADDRSIZE:0]  waddr, raddr;

input logic [DATASIZE-1:0] wdata;
output logic [DATASIZE-1:0]rdata;

localparam DEPTH = 1<<ADDRSIZE;

logic [DATASIZE-1:0] fifo [0: DEPTH-1];

always_ff@(posedge wclk)
begin
if(winc & !wfull)
begin
fifo[waddr[ADDRSIZE-1:0]]<=wdata; // WRITE OPERATION
end
end
assign rdata=fifo[raddr[ADDRSIZE-1:0]]; // READ OPERATION
endmodule
