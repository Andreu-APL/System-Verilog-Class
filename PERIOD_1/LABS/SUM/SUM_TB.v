`timescale 1ns/1ps

module SUM_TB;

    reg CLK;
    reg [9:0] SW;
    reg [1:0] KEY;
    wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instantiate SUM
    SUM uut (
        .CLK(CLK),
        .SW(SW),
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Clock generation
    initial CLK = 0;
    always #10 CLK = ~CLK; // 50 MHz = 20ns period -> toggle every 10ns

    initial begin
        $dumpfile("SUM_TB.vcd");
        $dumpvars(0, SUM_TB);

        // Initialize
        SW = 0;
        KEY = 2'b11; // Active low, so 11 is released

        // Reset
        #100;
        KEY[1] = 0; // Press Reset
        #100;
        KEY[1] = 1; // Release Reset
        #100;

        // Input A = 5
        SW[9] = 0; // Input Mode
        SW[8:0] = 9'd5;
        #100;
        // Press KEY0
        KEY[0] = 0;
        #20000000; // Wait for debounce/clk_divide (20ms)
        KEY[0] = 1;
        #20000000;

        // Input B = 7
        SW[8:0] = 9'd7;
        #100;
        // Press KEY0
        KEY[0] = 0;
        #20000000;
        KEY[0] = 1;
        #20000000;

        // Switch to Sum Mode
        SW[9] = 1;
        #100;

        // Display should be 12
        // Wait and observe
        #1000;

        $finish;
    end

endmodule
