`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
class environment;

   generator gen;
   driver driv;
 
   mailbox gen2driv;
 
   event gen2driv_done;
 
   virtual intf vif;

   function new(virtual intf vif);
	$display("Time: %0t, -------- Environment started ---------- ", $time);
	this.vif = vif;
	gen2driv = new();
	gen = new(gen2driv, gen2driv_done);
	driv = new(vif, gen2driv);
   endfunction

   task pre_test();
	$display("Time: %0t, -------- Pre_Test started ---------- ", $time);
	driv.reset();
	$display("Time: %0t, -------- Pre_test ended ---------- ", $time);
   endtask

   task test();
	$display("Time: %0t, -------- Test started ---------- ", $time);
        fork
	gen.main();
	driv.main();
        join_any
	$display("Time: %0t, -------- Test ended ---------- ", $time);
   endtask

   task post_test();
	$display("Time: %0t, -------- Post_Test started ---------- ", $time);
	wait(gen2driv_done.triggered);
	wait(gen.tx_count == driv.d_tx_count);
	$display("Time: %0t, -------- Post_test ended ---------- ", $time);
   endtask

   task run();
	$display("Time: %0t, -------- run started ---------- ", $time);
	pre_test();
	test();
	post_test();
	$finish();
	$display("Time: %0t, -------- run ended ---------- ", $time);
   endtask

endclass