 
class driver;

    
	virtual intfc vir_inf;

	 
    transaction trans;

	
	mailbox gen2driv;
	
	function new(virtual intfc vir_inf, mailbox gen2driv);
		
		this.vir_inf = vir_inf;
	
		
		this.gen2driv = gen2driv;
	endfunction
	
	task reset; 
		wait(vir_inf.w_rst);
		$display("*******[@ Driver] write reset********");
		vir_inf.winc  <= 0 ;
		vir_inf.wdata <=0;
		vir_inf.wfull<=0;
		wait(!vir_inf.w_rst);
		$display("*******[@ Driver] write reset done********");
		
		wait(vir_inf.r_rst);
		$display("*******[@ Driver] read reset********");
		vir_inf.rinc  <= 0 ;
		vir_inf.wdata <=0;
		vir_inf.rempty<=0;
		wait(!vir_inf.r_rst);
		$display("*******[@ Driver] read reset done********");
    endtask
	
	int no_of_transaction, temp_num;
    task drive; 
	 forever 
	    begin
		trans=new();
		gen2driv.get(trans); 
		if(!trans.temp_num)
		begin	
			if(trans.winc & !vir_inf.wfull) 
			  begin
				vir_inf.winc <= trans.winc;
				vir_inf.rinc <= trans.rinc;
				vir_inf.wdata <= trans.wdata;
				@(posedge vir_inf.wclk);
				$display($time,"[@ Driver][Driver Transfer : %0d]------ winc = %0d,rinc=%0d, waddr = %d, wdata = %0d", no_of_transaction,trans.winc,trans.rinc, vir_inf.waddr, trans.wdata);
			  end
			  
			if(trans.rinc & !vir_inf.rempty)
			  begin
				vir_inf.rinc <= trans.rinc;
				vir_inf.winc <= trans.winc;
				vir_inf.wdata <= trans.wdata;
				@(posedge vir_inf.rclk);
				$display($time,"[@ Driver][Driver Transfer : %0d]------rinc = %0d,winc = %0d, raddr = %d",no_of_transaction, trans.rinc,trans.winc, vir_inf.raddr);
			  end
			no_of_transaction++; 
			trans.temp_num=1;	
		end
		else temp_num = trans.temp_num;
		end
	endtask
	 
endclass