module Prim4_tb();

reg [3:0] S;
wire out;
integer C; // Variable de control

Prim4 DUT(.S(S),.out(out));

initial 
    begin
    $display("simulacion iniciada");


    // utilizamos un ciclo for para automatizar la prueba de casos 
    for (C = 0; C < 15; C = C + 1) 
    begin
    S = C[3:0];
    #10;    
    end

    
    $display("simulacion finalizada");
    $stop;
    $finish;
    end

initial begin
    $monitor("S = %b,out = %b,",S,out);
end

initial begin
    $dumpfile("Prim4_tb.vcd");
    $dumpvars(0,Prim4_tb);
end

endmodule
