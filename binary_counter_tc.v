// Tarea 1. Laboratorio
module binary_counter_tc (CLK, CLK_ENA, RSTn, Q, LOADn, P , TC);
	parameter MODULE = 12500000; // 50MHz/4=0.25 segundos=4Hz
	parameter WIDTH  = 24; // Ya que tenemos que contar hasta 50M
	
	input 						CLK, CLK_ENA, RSTn, LOADn;
	input 		[WIDTH-1:0] P;
	output						TC;
	output reg 	[WIDTH-1:0] Q;

// CLK		: 	KEY[1]; 		RSTn 	:	KEY[0] 		(¡sincrono!)
// CLK_ENA	:	SW[16];		LOADn	:	SW[17];		P[3:0]:	SW[3:0];
//	Q[3:0]	:  LEDR[3:0];	TC		: 	LEDG[8];	
	
always @ (posedge CLK)
	begin
		if ( !RSTn )
				begin
							Q <= 0;
				end	
		else if ( !LOADn)
							Q <= P;
			else if ( CLK_ENA)
				if ( Q == MODULE-1)
					begin
							Q <= 0;
					end
				else
					begin							
							Q <= Q + 1;
					end				
	end
 
	assign TC = (Q ==(MODULE-1))? CLK_ENA: 0;
endmodule
