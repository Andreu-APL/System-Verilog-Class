module clk_divide_tb #(parameter  = 3; ) ();
    reg clk;
    reg rst;
    wire clk_div;

    clk_divide DUT(.clk(clk),.rst(rst),.clk_div(clk_div));

    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end

    initial begin
    #100 rst = 1;
    #1000 rst = 0;

    #100 $finish;
    end
endmodule