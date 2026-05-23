module counter (
    input clk,
    input rst,
    input Search_enable
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0;
        end else if (Search_enable) begin
            if (count == 4'd9) 
                count <= 4'b0;
            else 
                count <= count + 1;
        end
    end