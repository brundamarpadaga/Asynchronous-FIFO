`include "trans_fifo.sv"
`include "gen_fifo.sv"
`include "driv_fifo.sv"
`include "mon_fifo.sv"
`include "scb_fifo.sv"

class environment;

	generator gen; //generator handle
	driver driv; //Driver handle
	monitor mon; // Monitor handle
	scoreboard scb; //scorebord handle
	
	mailbox g2d_mbx; // generator to driver
	mailbox m2s_mbx; // monitor to scoreboard
	   
    //event for synchronization between generator and test
    event gen_ended;
  
	virtual intfc vir_inf;

	function new(virtual intfc vir_inf);
	
		this.vir_inf = vir_inf;  //get the interface from test
		
		g2d_mbx = new(); //creating the mailbox for generator and driver
		m2s_mbx = new(); //creating the mailbox for scoreboard and monitor
		
		//creating generator and driver
		gen = new(g2d_mbx,gen_ended);
		driv = new(vir_inf,g2d_mbx);
		mon = new(vir_inf, m2s_mbx);
		scb = new(m2s_mbx);
	endfunction
	
	//preset task for driver reset
	task pre_test();
	 driv.reset();
	endtask
	
	task test();
	 fork
	    gen.main(); //calling main task from generator
		driv.drive(); //calling drive task from driver
		mon.main(); //calling main task from monitor
		scb.main(); //calling main task from scorebard
	 join_any
	endtask
	
	//task to set the flags required for finishing the simulation
	task post_test();
	 wait(scb.temp_num ==0);
	 wait(driv.temp_num==1);
	endtask
	
	
	task run;
		pre_test();
		test();
		post_test();
		$finish;
	endtask
	
endclass
	 



