`timescale 1ns/1ps

module CALCULATOR_TB;

    reg CLK;
    reg [9:0] SW;
    reg [1:0] KEY;
    wire [9:0] LEDR;
    wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    CALCULATOR uut (
        .CLK(CLK),
        .SW(SW),
        .KEY(KEY),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    initial CLK = 0;
    always #10 CLK = ~CLK; // 50 MHz

    initial begin
        $dumpfile("CALCULATOR_TB.vcd");
        $dumpvars(0, CALCULATOR_TB);

        SW = 0;
        KEY = 2'b11;

        // Reset
        SW[9] = 1;
        #100;
        SW[9] = 0;
        #100;

        // 1. Input A = 10
        SW[8:0] = 10;
        #50;
        KEY[0] = 0; // Press Next
        #20000000; // Wait debounce (20ms)
        KEY[0] = 1;
        #20000000;

        // 2. Input Op = ADD (SW[0])
        SW[8:0] = 0; // Clear data switches
        SW[0] = 1;
        #50;
        KEY[0] = 0; // Press Next
        #20000000;
        KEY[0] = 1;
        #20000000;

        // 3. Input B = 5
        SW[0] = 0;
        SW[8:0] = 5;
        #50;
        KEY[0] = 0; // Press Next (Execute 10 + 5 = 15)
        #20000000;
        KEY[0] = 1;
        #20000000;

        // 4. Input Op = SUB (SW[1])
        SW[8:0] = 0;
        SW[1] = 1;
        #50;
        KEY[0] = 0; // Press Next
        #20000000;
        KEY[0] = 1;
        #20000000;

        // 5. Input C = 3
        SW[1] = 0;
        SW[8:0] = 3;
        #50;
        KEY[0] = 0; // Press Next (Execute 15 - 3 = 12)
        #20000000;
        KEY[0] = 1;
        #20000000;

        // 6. Show Result
        KEY[1] = 0; // Press Show Result
        #20000000;
        KEY[1] = 1;
        #20000000;

        // Result should be 12 displayed
        #1000;

        $finish;
    end

endmodule
