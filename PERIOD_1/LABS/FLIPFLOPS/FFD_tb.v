module FFD_tb ();

reg D;
reg CLK;
reg RST;
wire Q;

FFD DUT (.D(D),.CLK(CLK),.RST(RST),.Q(Q));

initial begin
    CLK = 0;
    //forever // 
    CLK = ~CLK;
end

initial begin
    RST = 1;
    D <= 0;
    #100
    RST = 0;
    D <= 1;
    #100
    D <= 0;
    #100
    D = 1;
    $stop
end

initial begin
    $monitor("D = %b,CLK = %b, RST = %b,Q = b",D,CLK,RST,Q);
end

initial begin
    $dumpfile("FFD_tb.vcd");
    $dumpvars(0,FFD_tb);
end


endmodule