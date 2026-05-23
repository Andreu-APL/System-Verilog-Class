module mux_tb();
reg [3:0] D;
reg [1:0] S;
wire out;

mux DUT(.D(D),.S(S),.out(out));

initial begin
    $display("Sim start");
    D = 4'b0101;
    S = 2'b00;
    #10;
    S = 2'b01;
    #10;
    S = 2'b10;
    #10;
    S = 2'b11;

$stop;
$finish;
end
initial begin
    $monitor("D = %b, S = %b, out = %b",D,S,out);
end

initial begin
    $dumpfile("mux.vcd");
    $dumpvars(0,mux_tb);
end

endmodule