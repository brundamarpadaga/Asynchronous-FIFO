`include "environment.sv"
import params::*;
module test(intf fifo_intf);

    environment env;
    
    initial begin
	env = new(fifo_intf);
	env.gen.tx_count = BUR_CNT*BUR_LEN;
	env.run;
    end

endmodule