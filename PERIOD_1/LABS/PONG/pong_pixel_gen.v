module pong_pixel_gen #(
    parameter SCREEN_W = 640,
    parameter SCREEN_H = 480,
    parameter PADDLE_X_L = 20,
    parameter PADDLE_X_R = 600,
    parameter BALL_SIZE = 10
)(
    input inDisplayArea,
    input [9:0] CounterX,
    input [9:0] CounterY,
    input [9:0] ball_x,
    input [9:0] ball_y,
    input [9:0] paddle_l_y,
    input [9:0] paddle_r_y,
    input [9:0] paddle_w,
    input [9:0] paddle_h,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
);

    wire draw_ball = (CounterX >= ball_x) && (CounterX < ball_x + BALL_SIZE) &&
                     (CounterY >= ball_y) && (CounterY < ball_y + BALL_SIZE);
                     
    wire draw_paddle_l = (CounterX >= PADDLE_X_L) && (CounterX < PADDLE_X_L + paddle_w) &&
                         (CounterY >= paddle_l_y) && (CounterY < paddle_l_y + paddle_h);
                         
    wire draw_paddle_r = (CounterX >= PADDLE_X_R) && (CounterX < PADDLE_X_R + paddle_w) &&
                         (CounterY >= paddle_r_y) && (CounterY < paddle_r_y + paddle_h);
    
    // Net (Dotted Line)
    wire draw_net = (CounterX >= SCREEN_W/2 - 2) && (CounterX < SCREEN_W/2 + 2) &&
                    (CounterY[4] == 1); // Dotted effect

    always @(*) begin
        if (!inDisplayArea) begin
            r = 0; g = 0; b = 0;
        end else begin
            if (draw_ball) begin
                r = 4'hF; g = 4'hF; b = 4'hF; // White
            end else if (draw_paddle_l) begin
                r = 4'hF; g = 4'hF; b = 4'hF; // White
            end else if (draw_paddle_r) begin
                r = 4'hF; g = 4'hF; b = 4'hF; // White
            end else if (draw_net) begin
                r = 4'h8; g = 4'h8; b = 4'h8; // Gray
            end else begin
                r = 4'h0; g = 4'h0; b = 4'h0; // Black Background
            end
        end
    end

endmodule
