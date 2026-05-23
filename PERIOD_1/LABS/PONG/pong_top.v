module pong_top(
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [9:0] SW,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5
);

    // --- Signal Declarations ---
    wire inDisplayArea;
    wire [9:0] CounterX, CounterY;
    wire hsync, vsync;
    
    // Game State Signals
    wire [9:0] ball_x, ball_y;
    wire [9:0] paddle_l_y, paddle_r_y;
    wire [9:0] paddle_w, paddle_h;
    wire [3:0] score_l, score_r;

    // --- Module Instantiations ---

    // 1. VGA Timing Generator
    reg pixel_tick = 0;
    always @(posedge MAX10_CLK1_50) pixel_tick <= ~pixel_tick;

    hvsync_generator vga_inst(
        .clk(MAX10_CLK1_50),
        .pixel_tick(pixel_tick),
        .vga_h_sync(hsync),
        .vga_v_sync(vsync),
        .inDisplayArea(inDisplayArea),
        .CounterX(CounterX),
        .CounterY(CounterY)
    );

    assign VGA_HS = hsync;
    assign VGA_VS = vsync;

    // 2. Game Logic FSM
    pong_fsm #(
        .SCREEN_W(640), .SCREEN_H(480), 
        .PADDLE_X_L(20), .PADDLE_X_R(600), .BALL_SIZE(10)
    ) game_logic (
        .clk(MAX10_CLK1_50),
        .reset(~KEY[0]),
        .vsync(vsync),
        .sw_input(SW),
        .ball_x(ball_x), .ball_y(ball_y),
        .paddle_l_y(paddle_l_y), .paddle_r_y(paddle_r_y),
        .paddle_w(paddle_w), .paddle_h(paddle_h),
        .score_l(score_l), .score_r(score_r)
    );

    // 3. Pixel Generation / Rendering
    pong_pixel_gen #(
        .SCREEN_W(640), .SCREEN_H(480),
        .PADDLE_X_L(20), .PADDLE_X_R(600), .BALL_SIZE(10)
    ) renderer (
        .inDisplayArea(inDisplayArea),
        .CounterX(CounterX), .CounterY(CounterY),
        .ball_x(ball_x), .ball_y(ball_y),
        .paddle_l_y(paddle_l_y), .paddle_r_y(paddle_r_y),
        .paddle_w(paddle_w), .paddle_h(paddle_h),
        .r(VGA_R), .g(VGA_G), .b(VGA_B)
    );

    // 4. Score Display
    seven_segment hex5_inst (.num(score_l), .seg(HEX5));
    seven_segment hex4_inst (.num(score_r), .seg(HEX4));
    
    // Turn off unused HEX displays
    assign HEX3 = 8'b11111111;
    assign HEX2 = 8'b11111111;
    assign HEX1 = 8'b11111111;
    assign HEX0 = 8'b11111111;

endmodule
