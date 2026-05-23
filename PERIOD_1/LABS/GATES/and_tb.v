module and_tb();
reg a;
reg b;
wire out;

gates2 DUT(.a(a),.b(b),.out(out));

initial 
    begin
    $display("simulacion iniciada");
    a= 0;
    b= 0;
    #10;
    b= 1;
    #10;
    a= 1;
    #10;
    b= 0;
    #10;
    $display("simulacion finalizada");
    $stop;
    $finish;
end

initial begin
    $monitor("a = %b,b = %b,out = %b,",a,b,out);
end

endmodule