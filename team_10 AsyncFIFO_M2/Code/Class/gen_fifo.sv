 
class generator;

	transaction trans, endtrans; 
	
	mailbox  gen2driv; 
	
	int count, size,temp_num=0;
	event ended;
	
	function new(mailbox  gen2driv, event ended);
		this.gen2driv = gen2driv;
        this.ended=ended;		
	endfunction

	task main();
	int i;
	endtrans =new();
	endtrans.temp_num=0;
	repeat(size) 
	begin
	
		
		for(int j=0;j<count;j++)
		begin 
			trans =new();
			if(j<=count/2)
				assert(trans.randomize() with {trans.winc==0;trans.rinc==1;});// randomizing the inputs
		
			if (j>count/2)
				assert(trans.randomize() with {trans.winc==1;trans.rinc==0;});

			gen2driv.put(trans); 
		
				
		i++;	
		end
	end
		endtrans.temp_num=1;
		gen2driv.put(endtrans);
	endtask
	


endclass 