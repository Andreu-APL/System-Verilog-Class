module CounterUpDown(
    input CLK, // 50 MHz
    input [9:0] SW, // SW[0] Dir, SW[4:1] Limit
    input [1:0] KEY, // KEY[0] Reset
    output [0:6] HEX0
);

    wire rst = ~KEY[0];
    wire dir = SW[0]; // 0: Up, 1: Down
    wire [3:0] limit = SW[4:1];
    
    // Clock Divider (1Hz)
    wire clk_1hz;
    clk_divide #(.FREQ(1)) u_clk (
        .clk(CLK),
        .rst(rst),
        .clk_div(clk_1hz)
    );
    
    reg [3:0] count;
    
    always @(posedge clk_1hz or posedge rst) begin
        if (rst) begin
            count <= 0;
        end else begin
            if (dir == 0) begin // Up
                if (count >= limit)
                    count <= 0;
                else
                    count <= count + 1;
            end else begin // Down
                if (count == 0)
                    count <= limit;
                else
                    count <= count - 1;
            end
        end
    end
    
    BCD u_disp (.BCD_in(count), .BCD_out(HEX0));

endmodule
