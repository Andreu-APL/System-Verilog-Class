module demux1to4 (
    input  logic       d,
    input  logic [1:0] sel,
    output logic [3:0] y
);

    always_comb begin
        y = 4'b0000;
        case (sel)
            2'b00: y[0] = d;
            2'b01: y[1] = d;
            2'b10: y[2] = d;
            2'b11: y[3] = d;
        endcase
    end

endmodule
