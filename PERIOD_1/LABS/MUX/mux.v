module mux(
input [3:0] D,
input [1:0] S,
output reg out
);

always @(*)
begin
    case (S)
    0 : out = D[0];
    1 : out = D[1];

    endcase
end
endmodule