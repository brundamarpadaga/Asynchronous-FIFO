module async_fifo
#(
  parameter FIFO_WIDTH = 8,
  parameter ADDR_WIDTH = 9
 )
(
  input   winc, wclk, wrst_n,//winc write enable signal
  input   rinc, rclk, rrst_n,//rinc read enable signal
  input   [FIFO_WIDTH-1:0] wdata,

  output  [FIFO_WIDTH-1:0] rdata,
  output  wfull,
  output  rempty
);

  wire [ADDR_WIDTH-1:0] waddr, raddr;
  wire [ADDR_WIDTH:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w sync_r2w (.*);
  sync_w2r sync_w2r (.*);
  fifomem #(FIFO_WIDTH, ADDR_WIDTH) fifomem (.*);
  rptr_empty #(ADDR_WIDTH) rptr_empty (.*);
  wptr_full #(ADDR_WIDTH) wptr_full (.*);

endmodule

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

// Read pointer to write clock synchronizer
module sync_r2w
#(
  parameter ADDR_WIDTH = 9
)
(
  input   wclk, wrst_n,
  input   [ADDR_WIDTH:0] rptr,
  output reg  [ADDR_WIDTH:0] wq2_rptr//readpointer with write side
);

  reg [ADDR_WIDTH:0] wq1_rptr;

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
    else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};

endmodule

module sync_w2r
#(
  parameter ADDR_WIDTH = 9
)
(
  input   rclk, rrst_n,
  input   [ADDR_WIDTH:0] wptr,
  output reg [ADDR_WIDTH:0] rq2_wptr
);

  reg [ADDR_WIDTH:0] rq1_wptr;

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rq2_wptr,rq1_wptr} <= 0;
    else
      {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};

endmodule

module wptr_full
#(
  parameter ADDR_WIDTH = 9
)
(
  input   winc, wclk, wrst_n,
  input   [ADDR_WIDTH :0] wq2_rptr,
  output reg  wfull,
  output  [ADDR_WIDTH-1:0] waddr,
  output reg [ADDR_WIDTH :0] wptr
);

   reg [ADDR_WIDTH:0] wbin;
  wire [ADDR_WIDTH:0] wgraynext, wbinnext;

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      {wbin, wptr} <= '0;
    else
      {wbin, wptr} <= {wbinnext, wgraynext};

  // Memory write-address pointer
  assign waddr = wbin[ADDR_WIDTH-1:0];
  assign wbinnext = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;

  assign wfull_val = (wgraynext=={~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1], wq2_rptr[ADDR_WIDTH-2:0]});

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      wfull <= 1'b0;
    else
      wfull <= wfull_val;

endmodule

module rptr_empty
#(
  parameter ADDR_WIDTH = 9
)
(
  input   rinc, rclk, rrst_n,
  input   [ADDR_WIDTH :0] rq2_wptr,
  output reg  rempty,
  output  [ADDR_WIDTH-1:0] raddr,
  output reg [ADDR_WIDTH :0] rptr
);

  reg [ADDR_WIDTH:0] rbin;
  wire [ADDR_WIDTH:0] rgraynext, rbinnext;

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rbin, rptr} <= '0;
    else
      {rbin, rptr} <= {rbinnext, rgraynext};

  // Memory read-address pointer (okay to use binary to address memory)
  assign raddr = rbin[ADDR_WIDTH-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;

  //---------------------------------------------------------------
  // FIFO empty when the next rptr == synchronized wptr or on reset
  //---------------------------------------------------------------
  assign rempty_val = (rgraynext == rq2_wptr);

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;

endmodule
