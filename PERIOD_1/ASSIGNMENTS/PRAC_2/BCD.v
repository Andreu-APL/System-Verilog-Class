module BCD(
    input [3:0] bcd_in,
    output reg [0:6] bcd_out
);

always@(*)
begin
    case(bcd_in)
    4'b0000: bcd_out = ~7'b1111_110;
    4'b0001: bcd_out = ~7'b0110_000;
    4'b0010: bcd_out = ~7'b1101_101;
    4'b0011: bcd_out = ~7'b1111_001;
    4'b0100: bcd_out = ~7'b0110_011;
    4'b0101: bcd_out = ~7'b1011_011;
    4'b0110: bcd_out = ~7'b1011_111;
    4'b0111: bcd_out = ~7'b1110_000;
    4'b1000: bcd_out = ~7'b1111_111;
    4'b1001: bcd_out = ~7'b1111_011;

    default: bcd_out = 7'b0000_000;
    endcase

end
endmodule