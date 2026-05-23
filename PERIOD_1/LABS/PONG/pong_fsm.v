module pong_fsm #(
    parameter SCREEN_W = 640,
    parameter SCREEN_H = 480,
    parameter PADDLE_X_L = 20,
    parameter PADDLE_X_R = 600,
    parameter BALL_SIZE = 10
)(
    input clk,
    input reset,
    input vsync,
    input [9:0] sw_input, // SW[9:0]
    output reg [9:0] ball_x,
    output reg [9:0] ball_y,
    output reg [9:0] paddle_l_y,
    output reg [9:0] paddle_r_y,
    output reg [9:0] paddle_w,
    output reg [9:0] paddle_h,
    output reg [3:0] score_l,
    output reg [3:0] score_r
);

    // Dynamic Parameters from Switches
    always @(*) begin
        paddle_h = sw_input[4] ? 100 : 60; // SW[4] controls Length
        paddle_w = sw_input[5] ? 20 : 10;  // SW[5] controls Thickness
    end

    // Internal State
    reg [9:0] ball_dx_dir; // 1 = Right, 0 = Left
    reg [9:0] ball_dy_dir; // 1 = Down, 0 = Up
    
    // VSync Edge Detection
    reg last_vsync;
    wire frame_tick = ~vsync && last_vsync; // Negative edge of VSync

    always @(posedge clk) begin
        if (reset) begin
            ball_x <= SCREEN_W/2;
            ball_y <= SCREEN_H/2;
            paddle_l_y <= SCREEN_H/2 - 30;
            paddle_r_y <= SCREEN_H/2 - 30;
            score_l <= 0;
            score_r <= 0;
            ball_dx_dir <= 1;
            ball_dy_dir <= 1;
            last_vsync <= 0;
        end else begin
            last_vsync <= vsync;
            
            if (frame_tick) begin
                // --- Paddle Control Logic ---
                // Left Paddle (SW1=Up, SW0=Down)
                if (sw_input[1] && paddle_l_y > 5)
                    paddle_l_y <= paddle_l_y - 4;
                else if (sw_input[0] && paddle_l_y < SCREEN_H - paddle_h - 5)
                    paddle_l_y <= paddle_l_y + 4;
                    
                // Right Paddle (SW9=Up, SW8=Down)
                if (sw_input[9] && paddle_r_y > 5)
                    paddle_r_y <= paddle_r_y - 4;
                else if (sw_input[8] && paddle_r_y < SCREEN_H - paddle_h - 5)
                    paddle_r_y <= paddle_r_y + 4;

                // --- Ball Movement X ---
                if (ball_dx_dir) begin // Moving Right
                    if (ball_x + BALL_SIZE >= SCREEN_W - 5) begin // Right Wall (Score for Left)
                        if (score_l < 9) score_l <= score_l + 1;
                        else score_l <= 0;
                        ball_x <= SCREEN_W/2;
                        ball_y <= SCREEN_H/2;
                        ball_dx_dir <= 0; // Serve to loser
                    end else if (ball_x + BALL_SIZE >= PADDLE_X_R && 
                               ball_x + BALL_SIZE <= PADDLE_X_R + paddle_w &&
                               ball_y + BALL_SIZE >= paddle_r_y && 
                               ball_y <= paddle_r_y + paddle_h) begin // Hit Right Paddle
                        ball_dx_dir <= 0;
                        ball_x <= ball_x - 4;
                    end else begin
                        ball_x <= ball_x + 2;
                    end
                end else begin // Moving Left
                    if (ball_x <= 5) begin // Left Wall (Score for Right)
                        if (score_r < 9) score_r <= score_r + 1;
                        else score_r <= 0;
                        ball_x <= SCREEN_W/2;
                        ball_y <= SCREEN_H/2;
                        ball_dx_dir <= 1; // Serve to loser
                    end else if (ball_x <= PADDLE_X_L + paddle_w && 
                               ball_x >= PADDLE_X_L &&
                               ball_y + BALL_SIZE >= paddle_l_y && 
                               ball_y <= paddle_l_y + paddle_h) begin // Hit Left Paddle
                        ball_dx_dir <= 1;
                        ball_x <= ball_x + 4;
                    end else begin
                        ball_x <= ball_x - 2;
                    end
                end
                
                // --- Ball Movement Y ---
                if (ball_dy_dir) begin // Moving Down
                    if (ball_y + BALL_SIZE >= SCREEN_H - 5) begin
                        ball_dy_dir <= 0;
                    end else begin
                        ball_y <= ball_y + 2;
                    end
                end else begin // Moving Up
                    if (ball_y <= 5) begin
                        ball_dy_dir <= 1;
                    end else begin
                        ball_y <= ball_y - 2;
                    end
                end
            end
        end
    end

endmodule
