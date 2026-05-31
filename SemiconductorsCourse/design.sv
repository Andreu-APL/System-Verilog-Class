// Moore FSM: detects the bit sequence "101" on a serial input.
// Output is a function of state only (that's what makes it Moore).
// Overlapping is allowed, so "10101" fires twice.

module seq_detect (
    input  logic clk,
    input  logic rst_n,   // active low
    input  logic din,     // one bit per clock
    output logic found    // high for one cycle when "101" completes
);

    // S0: nothing yet
    // S1: saw "1"
    // S2: saw "10"
    // S3: saw "101"  -> assert output
    typedef enum logic [1:0] {S0, S1, S2, S3} state_t;
    state_t state, next;

    // state register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0;
        else
            state <= next;
    end

    // next-state logic
    always_comb begin
        next = state;
        case (state)
            S0: if (din) next = S1; else next = S0;
            S1: if (din) next = S1; else next = S2;   // another 1 keeps us at "1"
            S2: if (din) next = S3; else next = S0;   // a 0 resets the run
            S3: if (din) next = S1; else next = S2;   // overlap: trailing 1 starts a new run
        endcase
    end

    // Moore output: depends on state, not on din
    assign found = (state == S3);

endmodule
