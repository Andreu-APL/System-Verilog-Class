module ram #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 2
    )(
  
    input wire [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data_out

    );

    reg [DATA_WIDTH-1:0] MEMORY [0:(2**ADDR_WIDTH)-1];

    initial begin
        $readmemh("Mem.hex", MEMORY);
    end

    assign data_out = MEMORY[addr];

    endmodule