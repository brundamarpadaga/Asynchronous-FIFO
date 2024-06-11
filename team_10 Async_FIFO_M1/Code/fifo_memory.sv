module fifomem#(parameter DATASIZE = 8,parameter ADDRSIZE = 9)
(
  input   winc, wfull, wclk,
  input   [ADDRSIZE-1:0] waddr, raddr,
  input   [DATASIZE-1:0] wdata,
  output  [DATASIZE-1:0] rdata
);


  localparam DEPTH = 1<<ADDRSIZE;//2*addsize

  logic [DATASIZE-1:0] mem [0:DEPTH-1];

  assign rdata = mem[raddr];

  always_ff @(posedge wclk)
    if (winc && !wfull)
      mem[waddr] <= wdata;

endmodule


