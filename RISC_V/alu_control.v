module alu_control( 
    input [1:0] alu_op, 
    input [2:0] funct3, 
    input funct7,
    output reg [2:0] alu_control
);

always @(*) begin
    case (alu_op)

        2'b00: begin
            alu_control = 3'b000; // ADD para lw/sw
        end

        2'b01: begin
            alu_control = 3'b001; // SUB para branch
        end

        2'b10: begin
            case (funct3)

                3'b000: begin
                    if (funct7 == 1'b0)
                        alu_control = 3'b000; // ADD
                    else
                        alu_control = 3'b001; // SUB
                end

                3'b111: begin
                    alu_control = 3'b010; // AND
                end

                3'b110: begin
                    alu_control = 3'b011; // OR
                end

                3'b010: begin
                    alu_control = 3'b101; // SLT
                end

                default: begin
                    alu_control = 3'b000;
                end

            endcase
        end

        default: begin
            alu_control = 3'b000;
        end

    endcase
end

endmodule