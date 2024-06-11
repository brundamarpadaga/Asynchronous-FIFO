class transaction;

    parameter  data_width =8, ptr_width = 8;
	rand bit winc;
	rand bit rinc;
	randc bit [data_width-1:0] wdata;
	int temp_num,temp_num1;
	bit [data_width-1:0] rdata;
	bit rempty, wfull;
	bit [ptr_width:0] waddr;
	bit [ptr_width:0]raddr;
	
endclass
	
	

