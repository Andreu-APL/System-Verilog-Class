module alu_tb #(parameter N=32)();

reg [N-1:0] A, B;
reg [2:0] ALUcontrol;
wire [N-1:0] result;
wire zero;

sirvee dut(
    .A(A),
    .B(B),
    .Alucontrol(ALUcontrol),
    .result(result),
    .Zero(zero)
);

initial begin 

    repeat(80)
    begin
        A = $random % 100;
        B = $random % 100; 
        ALUcontrol = $random % 6; 
        #10;
    end 

end

initial begin  

    $monitor("%4t | %d | %d | %d | %d | %d",
             $time, A, B, ALUcontrol, result, zero);

end

initial begin 

    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);

end

endmodule