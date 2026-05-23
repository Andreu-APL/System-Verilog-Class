module SUM_ITERATIVE(
    input CLK, // 50 MHz
    input [9:0] SW, // SW[9:0] Input N (up to 1023)
    input [1:0] KEY, // KEY[0] Start, KEY[1] Reset
    output [9:0] LEDR,
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    wire start_btn = ~KEY[0]; // Active Low Button -> Start Pulse
    wire rst = ~KEY[1];   // Active Low Button -> Reset
    wire [9:0] N = SW;    // Input Number
    
    // Result Register
    // Max sum for N=1023 is (1023*1024)/2 = 523,776
    // Need 19 bits. Let's use 20.
    reg [19:0] sum;
    
    // Loop Counter
    reg [9:0] i;
    
    // State Machine
    localparam S_IDLE = 0;
    localparam S_CALC = 1;
    localparam S_DONE = 2;
    
    reg [1:0] state;
    
    always @(posedge CLK or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            sum <= 0;
            i <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    sum <= 0;
                    i <= 0;
                    if (start_btn) begin
                        state <= S_CALC;
                        i <= 1; // Start summing from 1
                    end
                end
                S_CALC: begin
                    if (i <= N) begin
                        sum <= sum + i;
                        i <= i + 1;
                    end else begin
                        state <= S_DONE;
                    end
                end
                S_DONE: begin
                    // Stay here until Reset
                    if (start_btn == 0) begin
                        // Wait for release? No, wait for reset.
                        // Or allow re-start if key released and pressed again?
                        // Let's stick to Reset required.
                    end
                end
            endcase
        end
    end
    
    // Display Logic (Using Division/Modulo for simplicity in Lab context)
    // Note: Division is resource intensive. For optimization, use "Double Dabble" algorithm.
    // But for DE10-Lite FPGA lab, direct division is synthesizable.
    
    wire [3:0] d_units = sum % 10;
    wire [3:0] d_tens  = (sum / 10) % 10;
    wire [3:0] d_hund  = (sum / 100) % 10;
    wire [3:0] d_thou  = (sum / 1000) % 10;
    wire [3:0] d_tth   = (sum / 10000) % 10;
    wire [3:0] d_hth   = (sum / 100000) % 10;
    
    BCD u0 (.BCD_in(d_units), .BCD_out(HEX0));
    BCD u1 (.BCD_in(d_tens),  .BCD_out(HEX1));
    BCD u2 (.BCD_in(d_hund),  .BCD_out(HEX2));
    BCD u3 (.BCD_in(d_thou),  .BCD_out(HEX3));
    BCD u4 (.BCD_in(d_tth),   .BCD_out(HEX4));
    BCD u5 (.BCD_in(d_hth),   .BCD_out(HEX5));
    
    // Status LEDs
    assign LEDR[0] = (state == S_DONE); // Calculation Finished
    assign LEDR[1] = (state == S_CALC); // Calculation in Progress
    assign LEDR[9:2] = 0;

endmodule
