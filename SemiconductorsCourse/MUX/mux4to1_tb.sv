module mux4to1_tb;

    logic [3:0] d;
    logic [1:0] sel;
    logic       y;

    mux4to1 dut (
        .d   (d),
        .sel (sel),
        .y   (y)
    );

    initial begin
        $monitor("Time=%0t | d=%b | sel=%b | y=%b", $time, d, sel, y);
    end

    initial begin
        d = 4'b1010;

        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;

        d = 4'b1100;
        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;

        $display("Simulation complete.");
        $finish;
    end

endmodule
