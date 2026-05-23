module SeqDetector(
    input CLK, // 50 MHz (Used for debouncing or just rely on KEY[1] as clock?)
    // Guide says "Input validated each time KEY[1] is pressed". So KEY[1] is the clock edge.
    // But KEY[1] needs debouncing if used as clock? Or we just use it directly (Schmitt trigger input on DE10-Lite usually good enough for simple labs, but proper design uses system clock).
    // Let's use system clock and edge detection on KEY[1].
    input [9:0] SW, // SW[0] Serial In
    input [1:0] KEY, // KEY[1] Clock/Validate, KEY[0] Reset
    output [9:0] LEDR, // LEDR[0] Detected
    output [0:6] HEX0 // Count
);

    wire clk = CLK;
    wire rst = ~KEY[0];
    wire in_bit = SW[0];
    wire step_btn = ~KEY[1]; // Active Low -> High when pressed
    
    // Edge Detection for Step Button
    reg btn_prev;
    wire step_pulse = (step_btn == 1 && btn_prev == 0);
    
    always @(posedge clk) begin
        btn_prev <= step_btn;
    end
    
    // FSM States
    // Sequence: 1 -> 0 -> 1 -> 1
    localparam S0 = 0; // Init
    localparam S1 = 1; // Got 1
    localparam S2 = 2; // Got 10
    localparam S3 = 3; // Got 101
    localparam S4 = 4; // Got 1011 (Detected)
    
    reg [2:0] state, next_state;
    
    // State Register
    always @(posedge clk or posedge rst) begin
        if (rst) 
            state <= S0;
        else if (step_pulse)
            state <= next_state;
    end
    
    // Next State Logic
    always @(*) begin
        case (state)
            S0: next_state = (in_bit) ? S1 : S0;
            S1: next_state = (in_bit) ? S1 : S2; // 1 -> 1 (Stay S1), 1 -> 0 (Go S2)
            S2: next_state = (in_bit) ? S3 : S0; // 10 -> 1 (Go S3), 10 -> 0 (Fail S0)
            S3: next_state = (in_bit) ? S4 : S2; // 101 -> 1 (Go S4), 101 -> 0 (Go S2: 10)
            S4: next_state = (in_bit) ? S1 : S2; // Overlap: 1011 -> 1 (Start 1 again), 1011 -> 0 (Start 10? No, 10110 -> 10).
            default: next_state = S0;
        endcase
    end
    
    // Output Logic
    assign LEDR[0] = (state == S4);
    
    // Counter Logic
    reg [3:0] detection_count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) 
            detection_count <= 0;
        else if (step_pulse && state == S3 && in_bit == 1) // Transition to S4
            if (detection_count < 9)
                detection_count <= detection_count + 1;
    end
    
    BCD u_count (.BCD_in(detection_count), .BCD_out(HEX0));
    
    // Debug LEDs
    assign LEDR[9:7] = state; 

endmodule
