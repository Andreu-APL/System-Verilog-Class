module CRONO(
    input MAX10_CLK1_50,
    input [9:0] SW, // SW0 Start and Stop
    input [1:0] KEY, // KEY0 Reset
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4
);

wire start = SW[0];
wire rst = !KEY[0];

reg [9:0] ms_count; // 0 to 999
reg [5:0] s_count; // 0 to 59

reg [15:0] clk_cnt;
wire tick_1ms = (clk_cnt == 50000); // 50 MHZ / 1000 = 50K 

always @(posedge MAX10_CLK1_50 or posedge rst) 
begin
    if (rst) begin
        clk_cnt <= 0;
        ms_count <= 0;
        s_count <= 0;
    end else if (start)
    begin
        if (tick_1ms)
        begin
            clk_cnt <= 0;
            // una vuelta de ms y s
            if (ms_count == 999)
            begin
                ms_count <= 0;
                if (s_count == 59)
                begin
                    s_count <= 0;
                end
                else 
                begin
                    s_count <= s_count + 1;
                end
            end
            else
            begin 
                ms_count <= ms_count + 1;
            end
        end 
        else
        begin
            clk_cnt <= clk_cnt + 1;
        end
    end
end

wire [3:0] ms_a = ms_count % 10;
wire [3:0] ms_b = (ms_count / 10) % 10;
wire [3:0] ms_c = (ms_count / 100) %10;

wire [3:0] s_a = s_count % 10;
wire [3:0] s_b = (s_count / 10) % 10;

BCD a_ms_a  (.BCD_in(ms_a), .BCD_out(HEX0));
BCD b_ms_b  (.BCD_in(ms_b), .BCD_out(HEX1));
BCD c_ms_c  (.BCD_in(ms_c), .BCD_out(HEX2));

BCD a_s_a  (.BCD_in(s_a), .BCD_out(HEX3));
BCD b_s_b  (.BCD_in(s_b), .BCD_out(HEX4));

endmodule
