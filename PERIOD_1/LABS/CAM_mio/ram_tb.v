module ram_tb();

    reg [1:0] addr;
    wire [15:0] data_out;

    ram #(
        .DATA_WIDTH(16),
        .ADDR_WIDTH(2)
    ) uut (
        .addr(addr),
        .data_out(data_out)
    );

    initial begin
        // Test case 1: Read from address 0
        addr = 2'b00;
        #10; // Wait for some time to observe the output

        // Test case 2: Read from address 1
        addr = 2'b01;
        #10;

        // Test case 3: Read from address 2
        addr = 2'b10;
        #10;

        // Test case 4: Read from address 3
        addr = 2'b11;
        #10;

        $finish; // End the simulation
    end

initial begin
    $dumpfile("ram_tb.vcd");
    $dumpvars(0,ram_tb);
end

endmodule