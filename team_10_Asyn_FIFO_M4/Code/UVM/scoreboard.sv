
class scoreboard extends uvm_test;
	`uvm_component_utils(scoreboard)// registering the calss with the factory
	 
	 bit [7:0]trans_data[$];
	 fifo_seq_item trans[$];
	 uvm_analysis_imp #(fifo_seq_item,scoreboard) scoreboard_port; // creating annalysis port for scoreboard

	 //creating a new constructor for scoreboard class
	function new(string name= "scoreboard",uvm_component parent);
		super.new(name,parent);
		`uvm_info("SCOREBOARD", "Inside Constructor!",UVM_LOW)
	endfunction
	
	//Build Phase
	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
		`uvm_info("SCOREBOARD", "Build phase!",UVM_LOW)
		
		scoreboard_port = new("scoreboard_port",this);// creating new constructor for scoreboard analysis port
		
		endfunction
		
	//Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		`uvm_info("SCOREBOARD", "Connect Phase!",UVM_LOW)
	endfunction
	
	
	//Run Phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("SCOREBOARD", "Run Phase!",UVM_LOW)
	 forever 
	 begin

	 fifo_seq_item curr_trans;
	    wait(trans.size!=0);
		curr_trans=trans.pop_back();
		read(curr_trans);
	 end
	endtask
	 
	 
	 //write function for reference fifo queue
	 function void write(fifo_seq_item seqitem);
	 trans.push_front(seqitem);
	   if(seqitem.winc &!seqitem.wfull)
	   begin
		trans_data.push_front(seqitem.wdata);
		`uvm_info("Scoreboard write wdata",$sformatf("Burtst Dtails:winc=%d, wdata=%d, wfull=%0d",seqitem.winc, seqitem.wdata, seqitem.wfull),UVM_LOW) 
		end
	endfunction
	
	
	//Read method
	task read(fifo_seq_item read_trans);
	   bit [7:0] expected_data;
	   bit [7:0] actual;
	
	   if(read_trans.rinc &!read_trans.rempty)
	   begin
		actual = read_trans.rdata;
	    expected_data= trans_data.pop_back();
		 
	    `uvm_info("Scoreboard_getting read wdata",$sformatf("Burtst Dtails:rinc=%d, wdata=%d, wfull=%0d",read_trans.rinc, read_trans.wdata, read_trans.rempty),UVM_LOW)
		end
		//checking the output values from received from DUT nad the testbench(monitor)
		if(actual != expected_data) begin
			`uvm_error("Comparing read", $sformatf("transaction failed actual=%d, expected_data=%d", actual,expected_data)) 
		end
		
		else begin
			`uvm_info("Comparing read", $sformatf("transaction passed actual=%d, expected_data=%d", actual,expected_data), UVM_LOW) 
		end
		
	endtask	
		
endclass
	
	

	 
