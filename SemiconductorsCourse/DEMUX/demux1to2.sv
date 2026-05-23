module demux1to2 (
    input  logic       d,
    input  logic       sel,
    output logic [1:0] y
);

    always_comb begin
        case (sel)
            1'b0: begin
                y[0] = d;
                y[1] = 1'b0;
            end
            1'b1: begin
                y[0] = 1'b0;
                y[1] = d;
            end
            default: y = 2'b00;
        endcase
    end

endmodule
