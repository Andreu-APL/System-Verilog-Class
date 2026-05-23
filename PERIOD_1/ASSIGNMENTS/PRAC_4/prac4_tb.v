module pract4_tb();
reg rst,clk,in;
wire out;

pract4 DUT(.rst(rst),.clk(clk),.in(in),.out(out));

initial begin
clk= 0;
rst = 0;
forever 
    #10 clk =~clk;
end


initial 
begin 
    $display("sim iniciada");
    
    in = 0;
    #30;
    rst = 1;
    #10;
    rst = 0;
    #10;
    in = 1;
    #20;
    in = 0;
    #20;
    in = 1;
    #20;
    in = 1;
    #20;
    
    repeat(50)
    begin
        in = $random%2;
        #20;
    end

    $display("sim finalizada");
    $stop;
    $finish;
end


initial begin
    $monitor("in=%b , out=%b",in,out);
end

initial begin
    $dumpfile("pract4_tb.vcd");
    $dumpvars(0,pract4_tb);
end

endmodule