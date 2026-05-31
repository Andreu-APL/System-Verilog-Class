`timescale 1ns/1ps

module tb;

    logic clk = 0;
    logic rst_n;
    logic din;
    logic found;

    seq_detect dut (.clk, .rst_n, .din, .found);

    // 10ns clock
    always #5 clk = ~clk;

    // feed one bit per rising edge
    task send(input logic b);
        din = b;
        @(posedge clk);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        din   = 0;
        rst_n = 0;
        @(posedge clk);
        rst_n = 1;

        // stream "1 1 0 1 0 1" -> "101" completes twice (overlap)
        send(1);
        send(1);
        send(0);
        send(1);  // found should pulse after this
        send(0);
        send(1);  // and again here

        // a clean miss
        send(0);
        send(0);

        repeat (2) @(posedge clk);
        $finish;
    end

    // print every time the detector fires
    always @(posedge clk)
        if (found)
            $display("[%0t] found 101", $time);

endmodule
