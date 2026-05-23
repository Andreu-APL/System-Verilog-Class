module counter_bcd_tb;

    reg clk;
    reg rst;
    wire [3:0] count;

    counter_bcd dut (.clk(clk),.rst(rst),.count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; 
        #100 rst = 0; 
        #200;
        
        rst = 1;
        #20 rst = 0;
        
        #100 $finish;
    end
    
    initial begin
        $monitor("Time=%0t | rst=%b | count=%d", $time, rst, count);
    end


initial begin
    $dumpfile("counter_bcd.vcd");
    $dumpvars(0,counter_bcd_tb);
end

endmodule