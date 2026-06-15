module alu( 
    input [31:0] a,
    input [31:0] b,
    input [2:0] alu_control,
    output reg [31:0] result,
    output zero
);

always @(*) begin
    case (alu_control)

        3'b000: begin
            result = a + b;      // ADD
        end

        3'b001: begin
            result = a - b;      // SUB
        end

        3'b010: begin
            result = a & b;      // AND
        end

        3'b011: begin
            result = a | b;      // OR
        end

        3'b101: begin
            result = (a < b) ? 32'd1 : 32'd0; // SLT
        end

        default: begin
            result = 32'd0;
        end

    endcase
end

assign zero = (result == 32'd0);

endmodule