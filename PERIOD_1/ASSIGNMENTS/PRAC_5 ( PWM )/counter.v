module counter(
    input clk,
    input rst,
    output reg [19:0] counter
);

always @(posedge clk or posedge rst) begin
    if (rst)
        counter <= 0;
    else begin
        // 5MHz clock = 0.2us period
        // 20ms period = 100,000 counts
        if (counter == 99999)
            counter <= 0;
        else
            counter <= counter + 1;
    end
end

endmodule
