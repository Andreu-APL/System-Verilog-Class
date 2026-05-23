module Multiplier(
    input [3:0] SW, // SW[1:0] A, SW[3:2] B
    output [0:6] HEX0
);

    wire [1:0] A = SW[1:0];
    wire [1:0] B = SW[3:2];
    
    wire [3:0] result = A * B;
    
    // Result max is 9, so fits in one BCD digit.
    // But if result > 9 (not possible here), BCD would be needed.
    // Using BCD module for consistency.
    
    BCD u_res (.BCD_in(result), .BCD_out(HEX0));

endmodule
