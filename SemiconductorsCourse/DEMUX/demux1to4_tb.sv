module demux1to4_tb;

    logic       d;
    logic [1:0] sel;
    logic [3:0] y;

    demux1to4 dut (
        .d   (d),
        .sel (sel),
        .y   (y)
    );

    initial begin
        $monitor("Time=%0t | d=%b | sel=%b | y=%b (y3=%b y2=%b y1=%b y0=%b)",
                 $time, d, sel, y, y[3], y[2], y[1], y[0]);
    end

    initial begin
        d = 1'b1;

        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;

        d = 1'b0;

        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;

        $display("Simulation complete.");
        $finish;
    end

endmodule
