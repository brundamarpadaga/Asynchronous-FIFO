//`include "transaction.sv"
class driver;

  int d_tx_count;
  virtual intf vif;

  mailbox gen2driv;

  function new(virtual intf vif, mailbox gen2driv);
	this.vif = vif;
	this.gen2driv = gen2driv;
  endfunction

  task reset();	
	$display("Time: %0t,--------- Inside Driver Reset task -------",$time);
	wait(!vif.wrst_n);
	vif.winc <= 0;
	vif.rinc <= 0;
	vif.wdata <= 0;
	wait(vif.wrst_n);
	$display("Time: %0t,--------- Driver Reset Ended -------",$time);
  endtask

  task main();
	$display("Time: %0t,--------- Inside Driver Main task -------",$time);
	forever begin
		transaction tx;
		gen2driv.get(tx);
		@(negedge vif.wclk);
		   vif.winc <= tx.winc;	   
		   vif.wdata <= tx.wdata;
		   vif.rinc <= tx.rinc;
                 @(negedge vif.wclk);
		
		d_tx_count++;
		$display("From [DRIVER] - Time: %0t,Inputs: winc= %0b, rinc= %0b, wdata = %0d",$time, vif.winc, vif.rinc, vif.wdata);
	end
	$display("Time: %0t,--------- Driver Main ended -------",$time);
  endtask

endclass