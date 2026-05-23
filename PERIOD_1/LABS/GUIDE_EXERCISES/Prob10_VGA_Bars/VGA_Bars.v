module VGA_Bars(
    input MAX10_CLK1_50,
    input [9:0] SW, // SW[2:0] Color (R,G,B? or Select?)
    // Guide: "Show a solid color that changes with switches SW[2:0]"
    // Let's assume SW[0]=R, SW[1]=G, SW[2]=B (1-bit color depth per channel for simplicity, or select from palette).
    // Let's do SW[2:0] selects color: 0=Black, 1=Blue, 2=Green, 3=Cyan, 4=Red, etc.
    output VGA_HS,
    output VGA_VS,
    output [3:0] VGA_R, VGA_G, VGA_B
);

    wire inDisplayArea;
    wire [9:0] CounterX;
    wire [9:0] CounterY;
    
    // Pixel Tick (25MHz)
    reg pixel_tick;
    always @(posedge MAX10_CLK1_50) pixel_tick <= ~pixel_tick;
    
    vga u_vga (
        .clk(MAX10_CLK1_50),
        .pixel_tick(pixel_tick),
        .vga_h_sync(VGA_HS),
        .vga_v_sync(VGA_VS),
        .inDisplayArea(inDisplayArea),
        .CounterX(CounterX),
        .CounterY(CounterY)
    );
    
    // Color Logic
    reg [11:0] rgb_out; // 4 bits per channel
    
    always @(*) begin
        if (inDisplayArea) begin
            case (SW[2:0])
                3'b000: rgb_out = 12'h000; // Black
                3'b001: rgb_out = 12'h00F; // Blue
                3'b010: rgb_out = 12'h0F0; // Green
                3'b011: rgb_out = 12'h0FF; // Cyan
                3'b100: rgb_out = 12'hF00; // Red
                3'b101: rgb_out = 12'hF0F; // Magenta
                3'b110: rgb_out = 12'hFF0; // Yellow
                3'b111: rgb_out = 12'hFFF; // White
            endcase
        end else begin
            rgb_out = 12'h000; // Black (Blanking)
        end
    end
    
    assign VGA_R = rgb_out[11:8];
    assign VGA_G = rgb_out[7:4];
    assign VGA_B = rgb_out[3:0];

endmodule
