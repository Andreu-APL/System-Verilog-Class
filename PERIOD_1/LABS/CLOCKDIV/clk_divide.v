module clk_divide#(parameter FREQ = 1)(
    input clk, 
    input rst, // switch 0
    output reg clk_div, // led[0]
    output reg [31:0] count

    parameter CLK_FREQ = 50_000_000
    parameter constantnumber = CLK_FREQ / (2 * FREQ)
);

localparam  constantnum = 3;
    always @(posedge clk or posedge rst) begin
        if (rst == 1)
         count <= 0;
        else if (count == constantnum -1)
            count <= 0;
        else count<= count +1;
    end

     always @(posedge clk or posedge rst) begin
        if (rst == 1)
         clk_div <= 0;
        else if (count == constantnum -1)
            clk_div <= ~clk_div;
        else clk_div <= clk_div;
    end



endmodule