module Prim4 (
    input [3:0] S,
    output reg out
);


// manuealmente puse todos los casos en los que un numero es primo.
// solo puse hasta el 13 por que el numero max representado en 4B es 15.

always @(*)
begin 
    case (S)
    2: out = 1;
    3: out = 1;
    5: out = 1;
    7: out = 1;
    11: out = 1;
    13: out = 1;

    // el default para todos los casos excluidos no primos, por eso un 0
    default: out = 0;

    endcase
end


endmodule