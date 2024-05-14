module fifomem
#(
  parameter FIFO_WIDTH = 8, // Memory data word width
  parameter ADDR_WIDTH = 9  // Number of mem address bits
)
(
  input   winc, wfull, wclk,
  input   [ADDR_WIDTH-1:0] waddr, raddr,
  input   [FIFO_WIDTH-1:0] wdata,
  output  [FIFO_WIDTH-1:0] rdata
);

  // RTL Verilog memory model
  localparam DEPTH = 1<<ADDR_WIDTH;//2*addsize

  logic [FIFO_WIDTH-1:0] mem [0:DEPTH-1];

  assign rdata = mem[raddr];

  always_ff @(posedge wclk)
    if (winc && !wfull)
      mem[waddr] <= wdata;

endmodule
