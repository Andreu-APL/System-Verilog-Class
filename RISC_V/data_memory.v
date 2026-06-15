module data_memory(
    input clk,
    input WE,
    input [31:0] A,
    input [31:0] WD,
    output [31:0] RD
);

reg [31:0] data_mem [0:255];

assign RD = data_mem[A[31:2]];

always @(posedge clk) begin
    if (WE) begin
        data_mem[A[31:2]] <= WD;
    end
end

endmodule