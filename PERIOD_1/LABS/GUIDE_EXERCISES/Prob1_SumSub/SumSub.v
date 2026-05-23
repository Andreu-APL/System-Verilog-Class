module SumSub(
    input [9:0] SW, // SW[3:0] A, SW[7:4] B, SW[9] Op
    output [0:6] HEX0, HEX1
);

    wire [3:0] A = SW[3:0];
    wire [3:0] B = SW[7:4];
    wire op = SW[9]; // 0: Sum, 1: Sub
    
    reg [4:0] result; // 5 bits to hold sum up to 30 or negative?
    // Max sum: 15 + 15 = 30.
    // Max sub: 15 - 0 = 15. Min sub: 0 - 15 = -15.
    
    wire [4:0] abs_result;
    
    always @(*) begin
        if (op == 0) begin
            result = A + B;
        end else begin
            if (A >= B)
                result = A - B;
            else
                result = B - A; // Absolute difference
        end
    end
    
    // BCD conversion
    wire [3:0] tens = result / 10;
    wire [3:0] units = result % 10;
    
    BCD u_tens (.BCD_in(tens), .BCD_out(HEX1));
    BCD u_units (.BCD_in(units), .BCD_out(HEX0));

endmodule
