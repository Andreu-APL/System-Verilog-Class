module CAM_Module #(parameter DATA_WIDTH = 4, parameter ADDR_WIDTH = 4)(
    input clk,
    input rst,
    input wr_en,
    input [ADDR_WIDTH-1:0] wr_addr,
    input [DATA_WIDTH-1:0] wr_data,
    input [DATA_WIDTH-1:0] search_data,
    output reg match_found,
    output reg [ADDR_WIDTH-1:0] match_addr
);

    // 16 x 4 Memory
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
    integer i;

    // Write Logic (Synchronous)
    always @(posedge clk or negedge rst) begin // Active low reset assumed from top level context, fixed here
        if (!rst) begin
            for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
                mem[i] <= 0; // Clear memory on reset
            end
        end else if (wr_en) begin
            mem[wr_addr] <= wr_data;
        end
    end

    // Search Logic (Combinational - Priority Encoder style)
    // Finds the FIRST occurrence of search_data
    always @(*) begin
        match_found = 0;
        match_addr = 0;
        // Check all locations
        for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
            if (mem[i] == search_data) begin
                match_found = 1;
                match_addr = i[ADDR_WIDTH-1:0];
                // Since we want priority (e.g. lowest address first), we can break here?
                // Verilog for loops unroll in synthesis, so this priority structure works if we iterate 0 to N.
                // However, without a break/disable, the LAST match would win if we just assign.
                // To get FIRST match (lowest address), we should iterate backwards or use a flag.
                // Or simply:
                // i=0: match? -> addr=0
                // i=1: match? -> addr=1 (overwrites 0)
                // So this finds the HIGHEST address match.
                // Let's iterate downwards to find LOWEST address match?
                // Or restructure:
            end
        end
        
        // Let's do it properly for "Lowest Address Priority"
        match_found = 0;
        match_addr = 0;
        for (i = (1<<ADDR_WIDTH)-1; i >= 0; i = i - 1) begin
             if (mem[i] == search_data) begin
                match_found = 1;
                match_addr = i[ADDR_WIDTH-1:0];
             end
        end
        // Now if 0 matches, it overwrites whatever higher address matched. Correct.
    end

endmodule
