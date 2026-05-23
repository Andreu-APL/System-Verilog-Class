module fsm( 
	input CLOCK_50, 
	input [0:0] SW, 
	input [0:0] KEY, 
	output reg [4:0] LEDR
); 

reg[25:0] counter; //clock divider 
reg clk_div; 

always@(posedge CLOCK_50) 
	begin 
		counter<=counter+1;
		clk_div=counter[25];
	end 
	
parameter S0=0, S1=1, S2=2, S3=3; //estados, c/u tiene asignado un número 
/*
otra forma de expresar los estados
parameter S0= 4'b0001, Estado inicial
			 S1= 4'b0010, Secuancia 1 
			 S2= 4'b0100, Secuencia 10
			 S3= 4'b1000; Secuencia 101
			*/ 
			
reg[1:0] state, next; //en qué estado estamos y a cual deberiamos cambiar en la sig iteracion 
wire x= SW[0];
wire reset=~KEY[0]; 

//Current State 

//no se puede poner todo en un solo always, porque se ejecutan los estados de forma paralela 
//se tienen que separar 
always@(posedge clk_div or posedge reset) 
	begin 
		if(reset) 
			state <=50; 
		else 
			state <=next; 
	end 

//Next State 

always@(*)//el input es el state 
	begin 
		case(state) 
			S0: //0
				if(x==1) 
					next= S1; //poner igual para que sea unblocking statement 
				else 
					next= S0; 
			S1: //1
				if(x==0) 
					next= S2; 
				else 
					next= S1; 
			S2: //10
				if(x==1)
					next= S3;
				else 
					next= S0; 
			S3: //101 
				if(x==1) 
					next= S1; 
				else //1010
					next= S2; 
			default: 
				next= S0; //muy importante en caso de que la máquina vaya a un estado desconocido
		 endcase 
	end 

//Output Logic

always@(*) 
	begin
		LEDR= 4'b0000; //se apagan todos los LEDS, y ya dependiendo de cada caso, se van prendiendo c
						//correspondiendo de cada LED 
		
		case(state) 
			S0: LEDR[0]=1; 
			S1: LEDR[1]=1;
			S2: LEDR[2]=1; 
			S3: LEDR[3]=1;
		endcase 
	end 
endmodule 
			
//menor o igual, nonblocling assigment, podrá seguir implementando cosas en parelelo en la tarjeta 
//= bloquea la entrada hasta que no pase esa asignación