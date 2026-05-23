module CALCULATOR(
    input CLK, // MAX10_CLK1_50
    input [9:0] SW, // SW[9] is Reset, SW[8:0] is Data
    input [1:0] KEY, // KEY[0] Next, KEY[1] Show Result
    output [9:0] LEDR,
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    // States
    localparam S_INPUT_A = 0;
    localparam S_INPUT_OP = 1;
    localparam S_INPUT_B = 2;
    localparam S_SHOW_RESULT = 3;

    reg [1:0] state;
    reg [31:0] accumulator; // 32-bit to prevent overflow on multiply
    reg [3:0] saved_op; // Store Op code

    // Debounce / Slow Clock
    wire clk_div;
    clk_divide #(.FREQ(100)) u_clk (
        .clk(CLK),
        .rst(SW[9]), // SW[9] is Reset
        .clk_div(clk_div)
    );

    // Button Edge Detection
    reg key0_prev, key1_prev;
    wire key0_press = (key0_prev == 1 && KEY[0] == 0); // Falling Edge
    wire key1_press = (key1_prev == 1 && KEY[1] == 0); // Falling Edge

    always @(posedge clk_div or posedge SW[9]) begin
        if (SW[9]) begin
            state <= S_INPUT_A;
            accumulator <= 0;
            saved_op <= 0;
            key0_prev <= 1;
            key1_prev <= 1;
        end else begin
            key0_prev <= KEY[0];
            key1_prev <= KEY[1];

            case (state)
                S_INPUT_A: begin
                    // Wait for KEY0 to save A
                    if (key0_press) begin
                        accumulator <= {23'b0, SW[8:0]};
                        state <= S_INPUT_OP;
                    end
                end
                S_INPUT_OP: begin
                    // Wait for KEY0 to save Op
                    if (key0_press) begin
                        saved_op <= SW[3:0];
                        state <= S_INPUT_B;
                    end else if (key1_press) begin
                        state <= S_SHOW_RESULT;
                    end
                end
                S_INPUT_B: begin
                    // Wait for KEY0 to execute Op with B
                    if (key0_press) begin
                        case (saved_op) // Check Saved Op (not current SW)
                            4'b0001: accumulator <= accumulator + SW[8:0]; // ADD (SW[0])
                            4'b0010: accumulator <= accumulator - SW[8:0]; // SUB (SW[1])
                            4'b0100: accumulator <= accumulator * SW[8:0]; // MUL (SW[2])
                            4'b1000: begin // DIV (SW[3])
                                if (SW[8:0] != 0)
                                    accumulator <= accumulator / SW[8:0];
                                // Else keep accumulator (div by 0 protection)
                            end
                            default: accumulator <= accumulator; // No Op
                        endcase
                        state <= S_INPUT_OP; // Go back to ask for next Op
                    end else if (key1_press) begin
                        state <= S_SHOW_RESULT;
                    end
                end
                S_SHOW_RESULT: begin
                    // Stay here until Reset (SW[9])
                    // Or maybe KEY0 to restart?
                    if (key0_press) begin
                        state <= S_INPUT_A;
                        accumulator <= 0;
                    end
                end
            endcase
        end
    end

    // Display Logic
    reg [13:0] display_val; // Max 9999 for BCD_4display? BCD_4display input is N_in (default 10).
    // BCD_4display is 10 bits -> 1023 max.
    // If accumulator > 1023, it will wrap or show error.
    // Let's instantiate BCD_4display with larger N_in if possible, but BCD module is 4-bit.
    // BCD_4display logic:
    // assign unidades = bcd_in % 10;
    // assign decenas = (bcd_in / 10) % 10;
    // ...
    // This logic works for any integer size input as long as the division supports it.
    // So we can pass 32-bit accumulator to it, if we widen the input port.
    // But BCD_4display definition is: parameter N_in = 10.
    // We should instantiate it with N_in = 14 (up to 9999) or 32.

    wire [0:6] hex0_num, hex1_num, hex2_num, hex3_num;
    wire [0:6] hex0_txt, hex1_txt, hex2_txt, hex3_txt;
    wire [0:6] hex0_out, hex1_out, hex2_out, hex3_out;

    // Determine what to show
    always @(*) begin
        if (state == S_INPUT_A || state == S_INPUT_B)
            display_val = SW[8:0];
        else if (state == S_SHOW_RESULT)
            display_val = accumulator[13:0]; // Truncate to 14 bits for display
        else
            display_val = 0;
    end

    BCD_4display #(.N_in(14)) u_bcd_disp (
        .bcd_in(display_val),
        .D_un(hex0_num),
        .D_de(hex1_num),
        .D_ce(hex2_num),
        .D_mi(hex3_num)
    );

    // Text Display (OP Code)
    // In S_INPUT_OP, show text based on SW[3:0]
    Text_Display u_text_disp (
        .op_sel(SW[3:0]),
        .HEX0(hex0_txt),
        .HEX1(hex1_txt),
        .HEX2(hex2_txt),
        .HEX3(hex3_txt)
    );

    // Mux
    assign hex0_out = (state == S_INPUT_OP) ? hex0_txt : hex0_num;
    assign hex1_out = (state == S_INPUT_OP) ? hex1_txt : hex1_num;
    assign hex2_out = (state == S_INPUT_OP) ? hex2_txt : hex2_num;
    assign hex3_out = (state == S_INPUT_OP) ? hex3_txt : hex3_num;

    assign HEX0 = hex0_out;
    assign HEX1 = hex1_out;
    assign HEX2 = hex2_out;
    assign HEX3 = hex3_out;
    assign HEX4 = ~7'b0000000;
    assign HEX5 = ~7'b0000000;

    assign LEDR[0] = (state == S_INPUT_A);
    assign LEDR[1] = (state == S_INPUT_OP);
    assign LEDR[2] = (state == S_INPUT_B);
    assign LEDR[3] = (state == S_SHOW_RESULT);
    assign LEDR[9] = SW[9]; // Reset Indicator

endmodule
