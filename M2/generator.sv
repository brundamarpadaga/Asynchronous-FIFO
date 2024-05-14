//`include "transaction.sv"
class generator;

  rand transaction tx;
  mailbox gen2driv;
  int tx_count;
  event gen2driv_done;

  function new(mailbox gen2driv, event gen2driv_done);
     $info("Time: %0t, ------ Inside Generator constructor -----", $time);
     this.gen2driv = gen2driv;
     this.gen2driv_done = gen2driv_done;
  endfunction

  task main();
      $display("----------- Generator Starts here -------------");
      repeat (tx_count) begin
	tx = new();
	assert (tx.randomize()) else $fatal("Tx Randomization failed");
	gen2driv.put(tx);
	$display("[GENERATOR] - Time: %0t, Inputs: winc= %0d, rinc= %0d, wdata= %0d", $time,tx.winc,tx.rinc,tx.wdata);
      end
      $display("----------- Generator ends here -------------");
      -> gen2driv_done;
  endtask

endclass