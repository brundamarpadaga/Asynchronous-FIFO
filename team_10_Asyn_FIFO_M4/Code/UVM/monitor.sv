class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
virtual intfc vif; //virtual interafce handle
fifo_seq_item mon_pkt;// sequence item handle

uvm_analysis_port #(fifo_seq_item) monitor_port; // creating annalysis port for monitor

// creating a new constructor for monitor class
function new (string name="monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info("MONITOR", "Inside Constructor!",UVM_LOW)
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("MONITOR", "Inside Build Phase!",UVM_LOW)
	monitor_port = new("monitor_port", this);//creating a new constructor for monitor annalysis port
	if(!(uvm_config_db # (virtual intfc):: get (this, "*", "vif", vif))) //checking proper connection with interface
	begin
	`uvm_error (" DRIVER CLASS", "Failed to get vif from config DB!")
	end
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("MONITOR", "Inside Connect Phase!",UVM_LOW)
endfunction

//Run phase
task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("MONITOR", "Inside Run Phase!",UVM_LOW)
	
	forever begin
		mon_pkt = fifo_seq_item #(8,9)::type_id::create("mon_pkt");
		wait (!vif.w_rst && !vif.r_rst);
        //tranfering data when write enable is high
		if(vif.winc & !vif.rinc)
		begin
			@(posedge vif.wclk);
		
			mon_pkt.winc=vif.winc;
			mon_pkt.rinc=vif.rinc;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.wdata= vif.wdata;
			mon_pkt.rdata= vif.rdata;
			mon_pkt.wfull= vif.wfull;
			mon_pkt.rempty= vif.rempty;
			`uvm_info("MONITOR WRITE",$sformatf("Burtst Dtails:time=%0d,winc=%d,rinc=%d,wdata=%d,wfull=%0d,rempty=%0d, waddr=%d,",$time,vif.winc,vif.rinc,vif.wdata,vif.wfull,vif.rempty,vif.waddr),UVM_LOW) 
		end
		//tranfering data when read enable is high
		if(vif.rinc & !vif.winc)
		begin
		    @(posedge vif.rclk);
			mon_pkt.winc=vif.winc;
			mon_pkt.rinc=vif.rinc;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.wdata= vif.wdata;
			mon_pkt.rdata= vif.rdata;
			mon_pkt.wfull= vif.wfull;
			mon_pkt.rempty= vif.rempty;
			`uvm_info("MONITOR READ",$sformatf("Burtst Dtails:time=%0d,winc=%d,rinc=%d,rdata=%d,wfull=%0d,rempty=%0d, raddr=%d",$time,vif.winc,vif.rinc,vif.rdata,vif.wfull,vif.rempty,vif.raddr),UVM_LOW)
			
		end
		monitor_port.write(mon_pkt); // calling the write method from the scoreboard
	end
endtask

endclass