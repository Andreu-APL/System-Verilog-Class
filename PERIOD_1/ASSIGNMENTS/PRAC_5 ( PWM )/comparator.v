module comparador(
    input clk,
    input rst,
    input [7:0] in, // 0, 90, 180
    output reg PWM_out
);

wire [19:0] count;
reg [19:0] threshold;

counter c1(
    .clk(clk),
    .rst(rst),
    .counter(count)
);

// 0 deg: 1ms = 5000 ticks
// 30 deg: 1.16ms = 5833 ticks
// 90 deg: 1.5ms = 7500 tisck
// 180 deg: 2ms = 10000 tiskcks

always @(*) begin
    case(in)
        8'd0:   threshold = 5000;
        8'd90:  threshold = 7500;
        8'd180: threshold = 10000;
        default: threshold = 5000;
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        PWM_out <= 0;
    end else begin
        if (count < threshold)
            PWM_out <= 1;
        else
            PWM_out <= 0;
    end
end

endmodule
