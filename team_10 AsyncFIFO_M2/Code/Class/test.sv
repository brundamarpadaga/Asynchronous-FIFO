
`include "environment.sv"
program test(intfc vir_inf);
	environment env;
	initial
    begin	
		env = new(vir_inf); 
		env.gen.count =1024;//burst
		env.gen.size =20; // burst size
		env.run();
	end
 endprogram