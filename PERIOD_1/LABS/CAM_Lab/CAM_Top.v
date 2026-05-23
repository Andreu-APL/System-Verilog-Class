module CAM_Top(
    input CLK, // MAX10_CLK1_50
    input [9:0] SW,
    input [1:0] KEY,
    output [9:0] LEDR,
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    // Parameters
    parameter DATA_WIDTH = 4;
    parameter ADDR_WIDTH = 4;

    // Signals
    wire rst_n = KEY[1];
    wire mode_write = SW[9]; // 1 = Write, 0 = Search
    wire [DATA_WIDTH-1:0] data_in = SW[3:0];
    wire [ADDR_WIDTH-1:0] addr_in = SW[7:4];
    
    // Debounce KEY[0] for Write Enable
    reg key0_d1, key0_d2;
    wire key0_pressed = (key0_d2 == 1 && key0_d1 == 0); // Falling edge (Active Low: 1->0 is press, but usually we detect press as 1->0)
    // Wait, KEY is active low. 
    // Unpressed = 1. Pressed = 0.
    // Transition 1 -> 0 is Press.
    // d2=1 (old), d1=0 (new). Correct.
    
    always @(posedge CLK) begin
        key0_d1 <= KEY[0];
        key0_d2 <= key0_d1;
    end

    // CAM Instance
    wire match_found;
    wire [ADDR_WIDTH-1:0] match_addr;
    
    // Write Enable only in Write Mode + Key Press
    wire wr_en = mode_write && key0_pressed;

    CAM_Module #(DATA_WIDTH, ADDR_WIDTH) u_cam (
        .clk(CLK),
        .rst(rst_n),
        .wr_en(wr_en),
        .wr_addr(addr_in),
        .wr_data(data_in),
        .search_data(data_in), // In search mode, we search for data_in
        .match_found(match_found),
        .match_addr(match_addr)
    );

    // LEDs
    assign LEDR[9] = mode_write; // LED9 ON = Write Mode
    assign LEDR[0] = (!mode_write && match_found); // LED0 ON = Match Found (in Search Mode)
    assign LEDR[8:1] = 0;
    
    // HEX Displays
    
    // HEX0: Data Input
    HEX_Decoder h0 (
        .bin_in(data_in),
        .seg_out(HEX0)
    );
    
    // HEX1: Address Input (Show Blank when in Search Mode)
    wire [0:6] h1_out;
    HEX_Decoder h1 (
        .bin_in(addr_in),
        .seg_out(h1_out)
    );
    assign HEX1 = (mode_write) ? h1_out : ~7'b0000000;
    
    // HEX2: Match Address (Search) or Write Address (Write)
    wire [0:6] hex2_out_match;
    wire [0:6] hex2_out_addr;
    
    HEX_Decoder h2_match (
        .bin_in(match_addr),
        .seg_out(hex2_out_match)
    );
    
    HEX_Decoder h2_addr (
        .bin_in(addr_in),
        .seg_out(hex2_out_addr)
    );

    reg [0:6] hex2_final;
    
    always @(*) begin
        if (mode_write) begin
            hex2_final = hex2_out_addr; // Show Address Input
        end else begin
            if (match_found) 
                hex2_final = hex2_out_match; // Show Match Address
            else 
                hex2_final = ~7'b1001111; // "E" for Error/Empty (Active Low: 1001111 is E segments)
        end
    end
    
    assign HEX2 = hex2_final;
    
    // Turn off others (Active Low -> All 1s = OFF)
    assign HEX3 = ~7'b0000000; 
    assign HEX4 = ~7'b0000000;
    assign HEX5 = ~7'b0000000;

endmodule
