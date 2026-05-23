`timescale 1ns/1ps

module MIN_MAX_FINDER_TB;

    reg CLK;
    reg [9:0] SW;
    reg [1:0] KEY;
    wire [7:0] final_min;
    wire [7:0] final_max;
    wire done;

    // Instantiate UUT
    MIN_MAX_FINDER uut (
        .CLK(CLK),
        .SW(SW),
        .KEY(KEY),
        .final_min(final_min),
        .final_max(final_max),
        .done(done)
    );

    // Clock Generation
    initial CLK = 0;
    always #10 CLK = ~CLK; // 50 MHz

    initial begin
        // Reset
        SW = 0;
        KEY = 2'b11; // Released
        #100;
        KEY[1] = 0; // Reset
        #50;
        KEY[1] = 1;
        #50;

        $display("---------------------------------------------------");
        $display("          MIN_MAX_FINDER TESTBENCH                 ");
        $display("---------------------------------------------------");
        
        // Input Data
        $display("Step 1: Inputting Data...");
        
        // Value 1: 50
        write_data(50);
        // Value 2: 10
        write_data(10);
        // Value 3: 99 (Max)
        write_data(99);
        // Value 4: 5 (Min)
        write_data(5);
        
        // Fill rest with 30
        repeat(12) write_data(30);
        
        #100;
        
        // Start Find Mode
        $display("Step 2: Starting Find Mode...");
        SW[9] = 1; // Mode = Find
        
        // Wait for Done signal
        wait(done == 1);
        #50;
        
        $display("Step 3: Check Results");
        
        if (final_max === 99 && final_min === 5) begin
             $display("SUCCESS: Max=%d, Min=%d", final_max, final_min);
        end else begin
             $display("FAILURE: Max=%d (Exp 99), Min=%d (Exp 5)", final_max, final_min);
        end
        
        $display("---------------------------------------------------");
        $finish;
    end
    
    // Task to write data
    task write_data(input [7:0] val);
        begin
            SW[7:0] = val;
            #20;
            KEY[0] = 0; // Press Load
            #20;
            KEY[0] = 1; // Release Load
            #20;
        end
    endtask

endmodule
