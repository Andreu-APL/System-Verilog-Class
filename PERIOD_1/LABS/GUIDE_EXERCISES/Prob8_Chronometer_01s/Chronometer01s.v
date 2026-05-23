module Chronometer01s(
    input CLK, // 50 MHz
    input [9:0] SW, // SW[0] Start/Stop
    input [1:0] KEY, // KEY[0] Reset
    output [0:6] HEX0, HEX1 // HEX0: 0.1s, HEX1: Seconds
);

    wire start = SW[0];
    wire rst = ~KEY[0];
    
    wire clk_10hz;
    clk_divide #(.FREQ(10)) u_clk (
        .clk(CLK),
        .rst(rst),
        .clk_div(clk_10hz)
    );
    
    reg [3:0] tenths;
    reg [3:0] seconds;
    
    always @(posedge clk_10hz or posedge rst) begin
        if (rst) begin
            tenths <= 0;
            seconds <= 0;
        end else if (start) begin
            if (tenths == 9) begin
                tenths <= 0;
                if (seconds == 9)
                    seconds <= 0;
                else
                    seconds <= seconds + 1;
            end else begin
                tenths <= tenths + 1;
            end
        end
    end
    
    BCD u_tenths (.BCD_in(tenths), .BCD_out(HEX0));
    BCD u_sec (.BCD_in(seconds), .BCD_out(HEX1));

endmodule
