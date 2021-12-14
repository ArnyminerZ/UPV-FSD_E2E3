module sem_clocks(CLK, CLK_ENA, RSTn, SEM_LOADn, SEM_P, CUENTA, TC);
   input CLK, CLK_ENA, RSTn, SEM_LOADn;
	// La entrada para empezar a contar segundos desde uno distinto de 0
	input [5:0] SEM_P;
	
	// Cable interno para conectar el contador del reloj de 50MHz,
	// y usarlo como uno de 4Hz.
	wire CLK_4;
	
	// La salida de cuenta de segundos para el comparador
	output [5:0] CUENTA;
	// La salida para reiniciar el semáforo cuando termine de contar
	output TC;

	// Instanciamos el contador para transformar el reloj de 50MHz
	// en uno de 4Hz.
	binary_counter_tc #(
	    // 50MHz/4=0.25 segundos=4Hz
	    .MODULE(12500000),
		 // Ya que tenemos que contar hasta 50M
		 .WIDTH(24)
		 
		 // Para dibujar el waveform, reducimos los valores
		 //.MODULE(3),
		 //.WIDTH(2)
	  )
	  DIVISOR(
	    .CLK(CLK),
		 .CLK_ENA(CLK_ENA),
		 .RSTn(RSTn),
		 // No lo conectamos ya que no nos interesa la salida de
		 // este contador
		 .Q(),
		 // No lo conectamos ya que siempre vamos a querer empezar
		 // a contar desde 0
		 .LOADn(1),
		 // No lo conectamos ya que queremos que el contador
		 // empiece a contar desde 0
		 .P(),
		 .TC(CLK_4)
	  );
	  
	binary_counter_tc #(
		 // Queremos contar hasta 55 segundos
	    .MODULE(55),
		 // 2^6=64 bits, para el módulo de 55
		 .WIDTH(6)
	  )
	  SEMAFOROS(
	    .CLK(CLK),
		 .CLK_ENA(CLK_4),
		 .RSTn(RSTn),
		 .Q(CUENTA),
		 .LOADn(SEM_LOADn),
		 // No conectado, ya que empezamos a contar desde 0
		 .P(SEM_P),
		 .TC(TC),
	  );

endmodule
