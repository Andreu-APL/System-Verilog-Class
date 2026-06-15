module top_module_tb();

reg clk;
reg rst;

top_module DUT(
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    #20;

    rst = 0;
    #80;

    $finish;
end

initial begin
    $dumpfile("top_module_tb.vcd");
    $dumpvars(0, top_module_tb);
end 

initial begin
    $monitor("PC=%h | INST=%h | ALU=%h | WD=%h | MEMWRITE=%b",
             DUT.pc,
             DUT.instruction,
             DUT.alu_result,
             DUT.rd2,
             DUT.mem_write);
end

endmodule