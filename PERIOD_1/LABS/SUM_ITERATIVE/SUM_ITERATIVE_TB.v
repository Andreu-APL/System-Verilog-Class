`timescale 1ns/1ps

module SUM_ITERATIVE_TB;

    reg CLK;
    reg [9:0] SW;
    reg [1:0] KEY;
    wire [9:0] LEDR;
    wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    SUM_ITERATIVE uut (
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
        $dumpfile("SUM_ITERATIVE_TB.vcd");
        $dumpvars(0, SUM_ITERATIVE_TB);

        // Reset
        SW = 0;
        KEY = 2'b10; // Reset
        #100;
        KEY = 2'b11; // Release
        #100;

        // Test 1: N = 4 (Sum = 0+1+2+3+4 = 10)
        SW = 4;
        #50;
        KEY[0] = 0; // Start
        #50;
        KEY[0] = 1;
        
        // Wait for calc (4 cycles)
        #200;
        
        // Check result manually in waveform or assume correctness if LEDR[0] high
        
        // Reset
        KEY[1] = 0;
        #50;
        KEY[1] = 1;
        
        // Test 2: N = 10 (Sum = 55)
        SW = 10;
        #50;
        KEY[0] = 0;
        #50;
        KEY[0] = 1;
        
        #500;
        
        $finish;
    end

endmodule
