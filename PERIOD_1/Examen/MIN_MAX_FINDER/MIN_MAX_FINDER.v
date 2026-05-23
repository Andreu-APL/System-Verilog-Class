module MIN_MAX_FINDER(
    input MAX10_CLK1_50,
    input [9:0] SW, // SW0 0:Max, 1:Min
    input [1:0] KEY, // KEY0 Start and Reset
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    wire start_rst = ~KEY[0]; 
    wire show_min = SW[0]; 
    wire [7:0] mem_data_out;
    
    reg [7:0] min_val;
    reg [7:0] max_val;
    
    // FSM
    localparam S_IDLE = 0;
    localparam S_FIND = 1;
    localparam S_DONE = 2;
    
    reg [1:0] state;
    reg [4:0] i; // Loops count
    
    Memory_RAM u_mem (
        .clk(MAX10_CLK1_50),
        .addr(i[3:0]), 
        .data_out(mem_data_out)
    );
    
    always @(posedge MAX10_CLK1_50 or posedge start_rst) begin
        if (start_rst) begin
            state <= S_IDLE;
            i <= 0;
            min_val <= 255;
            max_val <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    state <= S_FIND;
                    i <= 0;
                    min_val <= 255;
                    max_val <= 0;
                end
                S_FIND: begin
                    if (i <= 16) begin
                        i <= i + 1;
                        if (i > 0) begin
                            if (mem_data_out >= max_val) max_val <= mem_data_out;
                            if (mem_data_out <= min_val) min_val <= mem_data_out;
                        end
                    end else begin
                        state <= S_DONE;
                    end
                end
                S_DONE: begin
                end
            endcase
        end
    end
    
    // MUX to decide what to show, MIN or MAX
    wire [7:0] val_to_show = (show_min) ? min_val : max_val;
    
    BCD u_tens (.BCD_in(val_to_show / 10), .BCD_out(HEX1));
    BCD u_units (.BCD_in(val_to_show % 10), .BCD_out(HEX0));
    
    assign HEX2 = ~7'b0000000;
    assign HEX3 = ~7'b0000000;
    assign HEX4 = ~7'b0000000;
    assign HEX5 = ~7'b0000000;

endmodule
