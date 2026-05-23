module Memory_RAM(
    input MAX10_CLK1_50,
    input [3:0] addr,
    output reg [7:0] data_out
);

    reg [7:0] mem [0:15];

    initial begin
        $readmemh("data.hex", mem);
    end

    always @(posedge MAX10_CLK1_50) begin
        data_out <= mem[addr];
    end

endmodule
