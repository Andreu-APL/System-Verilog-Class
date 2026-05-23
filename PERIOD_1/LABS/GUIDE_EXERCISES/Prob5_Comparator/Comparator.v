module Comparator(
    input CLK, // 50 MHz
    input [9:0] SW, // SW[3:0] A, SW[7:4] B
    output [9:0] LEDR, // LEDR[9] A>B, LEDR[0] A<B
    output [0:6] HEX0
);

    wire [3:0] A = SW[3:0];
    wire [3:0] B = SW[7:4];
    
    assign LEDR[9] = (A > B);
    assign LEDR[0] = (A < B);
    assign LEDR[8:1] = 0;
    
    // Blinking logic for A=B
    wire clk_2hz;
    clk_divide #(.FREQ(2)) u_clk (
        .clk(CLK),
        .rst(0),
        .clk_div(clk_2hz)
    );
    
    wire [0:6] hex_out;
    BCD u_bcd (.BCD_in(A), .BCD_out(hex_out));
    
    // If A=B, blink (enable/disable display based on clk_2hz)
    // If A!=B, show A normally (always on? Guide says "Show A value... blinking if A=B". Implies A is always shown, just blinks if equal.)
    // Wait, "Show value of A in HEX0 blinking at 2Hz". If A!=B, does it show A? Or nothing?
    // "If A=B: Show A value... blinking".
    // Usually comparators show A or B. Let's assume we show A always, but blink if Equal.
    
    assign HEX0 = (A == B && clk_2hz) ? ~7'b0000000 : hex_out; // Off when clk high and equal

endmodule
