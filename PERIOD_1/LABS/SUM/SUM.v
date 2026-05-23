module SUM(
    input CLK, // MAX10_CLK1_50
    input [9:0] SW, // SW[9] is mode, SW[8:0] is data
    input [1:0] KEY, // KEY[0] Enter, KEY[1] Reset
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    wire clk_div;
    wire [8:0] data_in = SW[8:0];
    wire mode = SW[9]; // 0: Input, 1: Sum
    reg [8:0] A, B;
    reg [1:0] state; // 0: Wait A, 1: Wait B, 2: Done

    // Debouncing/Slow Clock
    clk_divide #(.FREQ(100)) u_clk_div (
        .clk(CLK),
        .rst(~KEY[1]), // Active low reset -> Active high
        .clk_div(clk_div)
    );

    // Button edge detection
    reg key0_prev;
    wire key0_press = (key0_prev == 1 && KEY[0] == 0); // Falling edge (Active Low)

    always @(posedge clk_div or negedge KEY[1]) begin
        if (!KEY[1]) begin // Reset
            state <= 0;
            A <= 0;
            B <= 0;
            key0_prev <= 1;
        end else begin
            key0_prev <= KEY[0];
            
            if (mode == 0) begin // Input Mode
                if (key0_press) begin
                    case (state)
                        0: begin
                            A <= data_in;
                            state <= 1;
                        end
                        1: begin
                            B <= data_in;
                            state <= 2; 
                        end
                        2: begin
                             // Reset to state 0 to allow new inputs without hard reset
                             state <= 0; 
                             A <= data_in;
                        end
                    endcase
                end
            end
        end
    end

    // Display Logic
    reg [9:0] display_val;
    
    always @(*) begin
        if (mode == 1) begin
            display_val = A + B;
        end else begin
            // In input mode, show current switches
            // Or show A if waiting for B?
            // "User selects number A via switches... then the same for B"
            // Showing current SW is best feedback.
            display_val = {1'b0, data_in}; 
        end
    end

    BCD_4display u_disp (
        .bcd_in(display_val),
        .D_un(HEX0),
        .D_de(HEX1),
        .D_ce(HEX2),
        .D_mi(HEX3)
    );

    // Turn off unused displays
    assign HEX4 = 7'b1111111; 
    assign HEX5 = 7'b1111111;

endmodule
