import params::*;
class transaction;

  rand logic winc;
  rand logic rinc;
  rand logic [FIFO_WIDTH-1:0] wdata;

  logic [FIFO_WIDTH-1:0] rdata;
  logic wfull;
  logic rempty;

  function void post_randomize();
    //$display("Time: %0t, Inputs: winc= %0d, rinc= %0d, wdata= %0d", $time,winc,rinc,wdata);
  endfunction

  constraint write_for_1Burst_c { winc == 1;}

endclass