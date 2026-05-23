module Text_Display(
    input [3:0] op_sel, // SW[3:0] -> [0]:ADD, [1]:SUB, [2]:MUL, [3]:DIV
    output reg [0:6] HEX0, // Rightmost
    output reg [0:6] HEX1,
    output reg [0:6] HEX2,
    output reg [0:6] HEX3  // Leftmost
);

    // Active Low (0 = ON, 1 = OFF)
    // S = 5 = 1011011 -> ~1011011 = 0100100 (No, '5' is A,C,D,F,G)
    // 0:A, 1:B, 2:C, 3:D, 4:E, 5:F, 6:G
    // Let's use HEX constants.
    // 0: 0000001
    // 1: 1001111
    // ...
    // S (5): 0010010
    // U: 1000001 (0111110 inverted? No. U is B,C,D,E,F -> 0111110 -> ~ = 1000001)
    // b: 0000011 (c,d,e,f,g)
    // d: 0100001 (b,c,d,e,g)
    // A: 0001000 (a,b,c,e,f,g)
    // n: 0101011 (c,e,g) or 1101010 (n? usually c,e,g is small n).
    // Let's stick to standard 7-seg logic or approximations.

    always @(*) begin
        HEX3 = 7'b1111111; // Blank by default
        HEX2 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX0 = 7'b1111111;

        if (op_sel[0]) begin // ADD (A d d) or SUM (S u nn)
            // Let's do "Add"
            HEX2 = 7'b0001000; // A
            HEX1 = 7'b0100001; // d
            HEX0 = 7'b0100001; // d
        end else if (op_sel[1]) begin // SUB (S u b)
            HEX2 = 7'b0010010; // S (5)
            HEX1 = 7'b1100011; // u (small u) -> e,d,c? No. u is usually c,d,e. -> 0011100 -> ~ = 1100011?
            // u: c,d,e -> 0011100.
            // b: c,d,e,f,g -> 0011111 -> ~ = 1100000? No.
            // Let's verify standard:
            // S: a,c,d,f,g -> 1011011 -> ~ = 0100100
            // u: c,d,e -> 0011100 -> ~ = 1100011
            // b: c,d,e,f,g -> 0011111 -> ~ = 1100000
            HEX2 = 7'b0010010; // S
            HEX1 = 7'b1000001; // U (large U? b,c,d,e,f -> 0111110 -> ~ = 1000001)
            HEX0 = 7'b0000011; // b
        end else if (op_sel[2]) begin // MUL (nn u L) or MuL
            HEX2 = 7'b0101010; // n (c,e,g? No. e,g,c -> 1010100 -> ~ = 0101011)
            // Let's try 'nn' -> two humps? Just use 'n'.
            // M is hard. Let's use 'P' for Product? Or 'Prd'?
            // Or 'nn'. Let's use 'nn'.
            // Actually, let's just use 'P' 'r' 'o' (Product).
            // P: a,b,e,f,g -> 1100111 -> ~ = 0011000? No.
            // Let's stick to "nn" "u" "L".
            // n: c,e,g -> 0010101 -> ~ = 1101010
            HEX2 = 7'b0001000; // A (Wait, user said MUL).
            // Let's do "MuL"
            // M -> 'nn' (two n's? No).
            // Let's use 'C' 'r' 'o' (Cross)? No.
            // 't' 'i' 'nn' (Times)?
            // 'nn' 'u' 'L'.
            HEX2 = 7'b1101010; // n
            HEX1 = 7'b1100011; // u
            HEX0 = 7'b1000111; // L (d,e,f -> 0111000 -> ~ = 1000111)
        end else if (op_sel[3]) begin // DIV (d I u) -> d I v
            HEX2 = 7'b0100001; // d
            HEX1 = 7'b1001111; // I (b,c -> 0110000 -> ~ = 1001111? Or e,f -> 0000110 -> 1111001. Usually 1 is b,c)
            // v: c,d,e (u) ?
            // Let's use 'u' for 'v'.
            HEX0 = 7'b1100011; // u (v)
        end
    end

endmodule
