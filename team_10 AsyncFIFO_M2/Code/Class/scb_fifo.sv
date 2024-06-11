class scoreboard;


    mailbox mon2scb;
	

    int scb_transactions,temp_num;
	

    bit [7:0] data_queue[$];
	logic [7:0] check_data;
	int pass_count,fail_count;
	
    function new(mailbox mon2scb);
      
      this.mon2scb = mon2scb;
    endfunction
	
	
    task main;
	
    forever begin
	 transaction trans;
	  trans=new();
      mon2scb.get(trans); 
	  if(trans.temp_num1)
	  
	  begin
		if(trans.winc && !trans.wfull) 
		 begin
			data_queue.push_front(trans.wdata);
			$display($time,"[@ Scoreboard-PASS]");
	        pass_count++;
		 end
		if(trans.rinc && !trans.rempty)
		 begin
		
			check_data=trans.wdata;
			if(check_data !== trans.wdata)
			 begin
				$error("[@ Scoreboard-FAIL]" );
				fail_count++;
			 end
		    else 
			 begin
			  $display($time,"[@ scoreboard-PASS]");
			  pass_count++;
			 end
		 end
		 $display("--------------------------------------------------------------------------------");
      scb_transactions++;
	 end
	 else temp_num = trans.temp_num1;
    end
	$display("[@ SCOREBOARD] No.of Testes Passed = %d and No.of Tests failed=%0d",pass_count,fail_count);
  endtask
endclass