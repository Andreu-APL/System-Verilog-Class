module main(
	input up_down,
	input load,
	input [6:0] data_in,
	output [0:6] D_un,D_de,D_ce,D_mi
    input rst,clk,
    input  in,
    output reg out  
);

wire clock;
wire [7:0] counter;

count counter1(.clk(clock),.rst(rst),
	.up_down(up_down),
	.load(load),
	.data_in(data_in),
	 .counter(counter));

pract4 practica(.rst(rst),.clk(clk),.in(in),.out(out));

BCD_4display  u_4disp (
   .bcd_in(counter),.D_un(D_un),.D_de(D_de),.D_ce(D_ce),.D_mi(D_mi)
);

endmodule