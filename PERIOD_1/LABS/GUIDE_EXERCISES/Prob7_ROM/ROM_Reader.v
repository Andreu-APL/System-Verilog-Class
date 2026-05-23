module ROM_Reader(
    input CLK, // 50 MHz
    input [1:0] KEY, // KEY[0] Next
    output [0:6] HEX0
);

    wire next_btn = ~KEY[0]; // Active Low
    
    // Debounce / Edge Detect
    // Assuming clean press or slow clock usage not critical for simple lab
    // But proper way:
    reg btn_prev;
    wire btn_pulse = (next_btn == 1 && btn_prev == 0);
    
    always @(posedge CLK) begin
        btn_prev <= next_btn;
    end
    
    reg [1:0] addr;
    reg [3:0] rom_data;
    
    // Memory Array
    reg [3:0] mem [0:3];
    
    initial begin
        $readmemh("Mem.hex", mem); // Ensure Mem.hex exists
    end
    
    always @(posedge CLK) begin
        if (btn_pulse) begin
            addr <= addr + 1;
        end
        rom_data <= mem[addr];
    end
    
    BCD u_disp (.BCD_in(rom_data), .BCD_out(HEX0));

endmodule
