module ElectronicLock(
    input CLK, // 50 MHz
    input [9:0] SW, // SW[3:0] Num Input
    input [1:0] KEY, // KEY[1] Enter, KEY[0] Reset (Optional, guide doesn't specify reset but good practice)
    output [9:0] LEDR, // LEDR[9] Unlock
    output [0:6] HEX5 // Attempts Left
);

    wire enter_btn = ~KEY[1];
    wire [3:0] num_in = SW[3:0];
    
    // Pulse Detect
    reg btn_prev;
    wire enter_pulse = (enter_btn == 1 && btn_prev == 0);
    always @(posedge CLK) btn_prev <= enter_btn;
    
    // Correct Sequence: 1 -> 3 -> 2
    localparam PASS1 = 1;
    localparam PASS2 = 3;
    localparam PASS3 = 2;
    
    // States
    localparam S_IDLE = 0;
    localparam S_PASS1_OK = 1;
    localparam S_PASS2_OK = 2;
    localparam S_UNLOCK = 3;
    localparam S_FAIL = 4; // Temporary Fail State? Or just stay IDLE but decrement attempts.
    
    reg [2:0] state;
    reg [3:0] attempts;
    
    // Reset Logic (Internal or external?)
    // Guide: "If fail 3 times, system blocks".
    
    initial begin
        state = S_IDLE;
        attempts = 3;
    end
    
    always @(posedge CLK) begin
        if (attempts > 0) begin
            if (enter_pulse) begin
                case (state)
                    S_IDLE: begin
                        if (num_in == PASS1) state <= S_PASS1_OK;
                        else begin
                            state <= S_IDLE;
                            if (attempts > 0) attempts <= attempts - 1;
                        end
                    end
                    S_PASS1_OK: begin
                        if (num_in == PASS2) state <= S_PASS2_OK;
                        else begin
                            state <= S_IDLE;
                            if (attempts > 0) attempts <= attempts - 1;
                        end
                    end
                    S_PASS2_OK: begin
                        if (num_in == PASS3) state <= S_UNLOCK;
                        else begin
                            state <= S_IDLE;
                            if (attempts > 0) attempts <= attempts - 1;
                        end
                    end
                    S_UNLOCK: begin
                        // Stay unlocked? Or reset?
                        // Usually stays unlocked until reset.
                    end
                endcase
            end
        end
        // If attempts == 0, stay locked (state doesn't advance, effectively blocked if not in UNLOCK)
        // But if we were in UNLOCK, do we lock? 
        // Logic above: only decrement attempts on fail. If attempts hits 0, we can't enter new numbers.
    end
    
    assign LEDR[9] = (state == S_UNLOCK);
    BCD u_attempts (.BCD_in(attempts), .BCD_out(HEX5));

endmodule
