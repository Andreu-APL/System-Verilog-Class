module BCD_4displays #(parameter N_in = 10, N_out = 7) (
    input [N_in-1:0] bcd_in,
    output [N_out-1:0] D_un, D_de, D_ce, D_mi
); 

wire [3:0] unidades,decenas,centenas,milares;

assign unidades = bcd_in % 10;
assign decenas = (bcd_in / 10) % 10;
assign centenas = (bcd_in / 100) % 10;
assign milares = (bcd_in / 1000) % 10;

BCD un (
    .bcd_in(unidades),
    .bcd_out(D_un)
);

BCD dec (
    .bcd_in(decenas),
    .bcd_out(D_de)
);

BCD cent (
    .bcd_in(centenas),
    .bcd_out(D_ce)
);

BCD mil (
    .bcd_in(milares),
    .bcd_out(D_mi)
);

endmodule