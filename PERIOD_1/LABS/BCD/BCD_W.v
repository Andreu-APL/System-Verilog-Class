module BCD_W(
    input [3:0] SW,
    output [0:6] HEX0
);

BCD WRAP(

    .bcd_in(SW),
    .bcd_out(HEX0)
);

endmodule