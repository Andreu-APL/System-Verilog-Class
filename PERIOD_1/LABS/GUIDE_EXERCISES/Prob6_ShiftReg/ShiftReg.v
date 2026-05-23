module ShiftReg(
    input CLK, // 50 MHz
    input [9:0] SW, // SW[7:0] Data
    input [1:0] KEY, // KEY[1] Load, KEY[0] Reset
    output [0:6] HEX0, HEX1, HEX2
);

    wire load = ~KEY[1]; // Active Low
    wire rst = ~KEY[0];
    wire [7:0] data_in = SW[7:0];
    
    wire clk_1hz;
    clk_divide #(.FREQ(1)) u_clk (
        .clk(CLK),
        .rst(rst),
        .clk_div(clk_1hz)
    );
    
    reg [7:0] shift_reg;
    
    always @(posedge clk_1hz or posedge rst or posedge load) begin
        if (rst) begin
            shift_reg <= 0;
        end else if (load) begin
            shift_reg <= data_in; // Async Load? Or Sync to 1Hz?
            // "Load value... when KEY[1] is pressed". Usually Async Load or Sync to fast clock.
            // But here logic is in slow clock domain.
            // Let's make load sync to slow clock edge? Or async set.
            // Better: Use fast clock for load detection, slow clock for shift.
            // But simplified: Async Load override.
            // Implementation: `posedge load` in sensitivity list implies async.
            shift_reg <= data_in;
        end else begin
            shift_reg <= {1'b0, shift_reg[7:1]}; // Shift Right
        end
    end
    
    // Display 0-255
    // Need BCD_4display (which handles up to 9999 or 1023).
    // BCD_4display inputs 10 bits usually.
    
    BCD_4display u_disp (
        .bcd_in({2'b00, shift_reg}),
        .D_un(HEX0),
        .D_de(HEX1),
        .D_ce(HEX2),
        .D_mi() // Unused
    );

endmodule
