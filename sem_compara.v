module sem_compara(
	// Las entradas de reloj
    input CLK, CLK_ENA,
	// Todas las entradas de control
	input RSTn, SEM_LOADn,
    // La entrada de la cuenta de segundos desde sem_clocks
	input [5:0] SEM_P,
	// Declaramos las salidas para todas las luces
	output reg Rcars,  // LEDR17: PIN_H15
	output reg Gcars,  // LEDG8 : PIN_F17
	output reg Rpedes, // LEDR0 : PIN_G19
	output reg Gpedes  // LEDG0 : PIN_E21
);

	// El cable interno que nos informa cuando ha terminado de contar,
	// es decir, cuando se ha llegado a 55 segundos, el valor máximo del
	// contador del semáforo.
	wire TC_CUENTA;
	// El cable interno para llevar la cuenta de los segundos, y actuar
	// en consecuencia.
	wire [5:0] CUENTA;
	
	// Declaramos el módulo sem_clocks
	sem_clocks CONTADOR(
	  .CLK(CLK),
	  .CLK_ENA(CLK_ENA),
	  .RSTn(RSTn),
	  .SEM_LOADn(SEM_LOADn),
	  .SEM_P(SEM_P),
	  .CUENTA(CUENTA),
	  .TC(TC_CUENTA)
	);
	
always @ (posedge CLK)
	begin
	    // 30 segundos
		if (CUENTA == 6'd30)
		  begin
		    // Enciende el "ámbar"
		    Rcars <= 1;
			 Gcars <= 1;
		  end
		// 35 segundos
		else if (CUENTA == 6'd35)
		  begin
		    // Apaga el "ámbar" y enciende rojo
		    Rcars <= 1;
			 Gcars <= 0;
			 
			// Encendemos el verde y apagamos el rojo
			Rpedes <= 0;
			Gpedes <= 1;
		  end
		// 55 segundos, reiniciamos el semáforo
		else if (TC_CUENTA)
		  begin
		    // Apaga el rojo y enciende el verde
		    Rcars <= 0;
			Gcars <= 1;
			 
			// Apagamos el verde y encendemos el rojo
			Rpedes <= 1;
			Gpedes <= 0;
		  end
	end

endmodule
