`timescale 1ns/1ps

module CAM_TB;

    reg CLK;
    reg [9:0] SW;
    reg [1:0] KEY;
    wire [9:0] LEDR;
    wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    CAM_Top uut (
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

    // Clock
    initial CLK = 0;
    always #10 CLK = ~CLK;

    initial begin
        $dumpfile("CAM_TB.vcd");
        $dumpvars(0, CAM_TB);
        
        // Initialize
        SW = 0;
        KEY = 2'b11; // Released
        
        // Reset
        #100;
        KEY[1] = 0; // Reset
        #20;
        KEY[1] = 1;
        #20;
        
        // 1. Write Data 0xA to Address 0x2
        SW[9] = 1; // Write Mode
        SW[7:4] = 4'h2; // Addr
        SW[3:0] = 4'hA; // Data
        #50;
        KEY[0] = 0; // Press
        #20;
        KEY[0] = 1; // Release
        #50;
        
        // 2. Write Data 0xB to Address 0x5
        SW[7:4] = 4'h5;
        SW[3:0] = 4'hB;
        #50;
        KEY[0] = 0;
        #20;
        KEY[0] = 1;
        #50;
        
        // 3. Search for 0xA (Should find at 0x2)
        SW[9] = 0; // Search Mode
        SW[3:0] = 4'hA;
        #100;
        
        // 4. Search for 0xB (Should find at 0x5)
        SW[3:0] = 4'hB;
        #100;
        
        // 5. Search for 0xC (Should not find)
        SW[3:0] = 4'hC;
        #100;
        
        $finish;
    end

endmodule
