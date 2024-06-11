class monitor;

	
	virtual intfc vir_inf;
    

    mailbox mon2scb;
	transaction trans;
  
	function new(virtual intfc vir_inf, mailbox mon2scb);
		
		this.vir_inf = vir_inf;
		 
		this.mon2scb = mon2scb;
   endfunction
   int temp_num, mon_transfer;
   
 
	
   task main; 
    
	forever 
		begin
			trans = new(); 
			trans.temp_num1=0;
			wait(vir_inf.winc | vir_inf.rinc);
			
			if( (!vir_inf.rinc) & vir_inf.winc  ) 
			 begin
			    @(posedge vir_inf.wclk);
				trans.winc = vir_inf.winc;
				trans.rinc = vir_inf.rinc;
				trans.waddr = vir_inf.waddr;
				trans.raddr = vir_inf.raddr;
				trans.wdata = vir_inf.wdata;
				trans.wfull = vir_inf.wfull;
				trans.rempty = vir_inf.rempty;
				trans.rdata = vir_inf.rdata;
				$display($time,"[@ MONITOR][Write Transfer : %0d]----winc = %0d,rinc = %0d, wdata = %0d, rempty = %0d,wfull = %0d,waddr = %0d",mon_transfer, vir_inf.winc,vir_inf.rinc, vir_inf.wdata, vir_inf.rempty, vir_inf.wfull, vir_inf.waddr);
  
			 end
			if((!vir_inf.winc) & vir_inf.rinc )  
			 begin
			    @(posedge vir_inf.rclk);
			    trans.winc = vir_inf.winc;
				trans.rinc = vir_inf.rinc;
				trans.waddr = vir_inf.waddr;
				trans.raddr = vir_inf.raddr;
				trans.wdata = vir_inf.wdata;
				trans.wfull = vir_inf.wfull;
				trans.rempty = vir_inf.rempty;
				trans.rdata = vir_inf.rdata;
				$display($time,"[@ MONITOR][Read Transfer : %0d]----winc = %0d,rinc = %0d,rempty = %0d,wfull = %0d,rdata = %0d,raddr = %0d",mon_transfer, vir_inf.winc,vir_inf.rinc, vir_inf.rempty, vir_inf.wfull, vir_inf.rdata, vir_inf.raddr);
			 end
			mon2scb.put(trans);
		    trans.temp_num1=1;
			mon_transfer++;
		end
		
	endtask
endclass



