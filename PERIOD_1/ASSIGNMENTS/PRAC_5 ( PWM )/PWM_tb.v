`timescale 1ns / 1ps

module PWM_tb;

    reg MAX10_CLK1_50;
    reg [1:0] KEY;
    reg [9:0] SW;

    wire [15:0] ARDUINO_IO;
    wire [7:0] HEX0;
    wire [7:0] HEX1;
    wire [7:0] HEX2;
    wire [7:0] HEX3;
    wire [7:0] HEX4;
    wire [7:0] HEX5;

    PWM_W uut (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .KEY(KEY),
        .SW(SW),
        .ARDUINO_IO(ARDUINO_IO),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    initial begin
        $dumpfile("PWM_tb.vcd");
        $dumpvars(0, PWM_tb);
    end

    initial begin
        MAX10_CLK1_50 = 0;
        forever #10 MAX10_CLK1_50 = ~MAX10_CLK1_50;
    end

    initial begin
        KEY = 2'b11; 
        SW = 10'b0;

        #100;
        KEY[0] = 0; 
        #100;
        KEY[0] = 1; 
        #100;

        $display("Testing 0 degrees...");
        SW = 10'b0000000001;
        #25000000; 

        // Test Case 2
        $display("Testing 90 degrees...");
        SW = 10'b0000000010;
        #25000000;

        // Test Case 3
        $display("Testing 180 degrees...");
        SW = 10'b0000000100;
        #25000000;
        
        $display("Test Complete");
        $stop;
    end
      
endmodule
